open Core
open Waspc

let ( let+ ) v f = Command.Param.map v ~f
let ( and+ ) = Command.Param.both
let ( let* ) v f = match v with Error e -> failwith e | Ok v -> f v

(* File processing for instrumentor.py *)
let patterns : (Re2.t * string) array =
  Array.map
    ~f:(fun (regex, template) -> (Re2.create_exn regex, template))
    [| ( "void reach_error\\(\\) \\{.*\\}"
       , "void reach_error() { __WASP_assert(0); }" )
    |]

let patch_with_regex (file_data : string) : string =
  Array.fold patterns ~init:file_data ~f:(fun data (regex, template) ->
    Re2.rewrite_exn regex ~template data )

let patch_gcc_ext (file_data : string) : string =
  String.concat_array ~sep:"\n"
    [| "#define __attribute__(x)"
     ; "#define __extension__"
     ; "#define __restrict"
     ; "#define __inline"
     ; file_data
    |]

let instrument_file (file : string) (_includes : string list) =
  Log.debug "instrumenting ...\n";
  match Sys_unix.file_exists file with
  | `No | `Unknown -> Error (sprintf "unable to read file \"%s\"@." file)
  | `Yes ->
    let data = In_channel.read_all file |> patch_gcc_ext |> patch_with_regex in
    Ok data

let compile_file (file : string) ~(includes : string list) =
  Log.debug "compiling ...\n";
  let cflags =
    String.concat ~sep:" "
      [ "-g"
      ; "-emit-llvm"
      ; "--target=wasm32"
      ; "-m32"
      ; String.concat ~sep:" " @@ List.map includes ~f:(fun inc -> "-I" ^ inc)
      ; "-c"
      ]
  in
  let ldflags =
    String.concat ~sep:" "
      [ "-z"
      ; "stack-size=1073741824"
      ; "--no-entry"
      ; "--export=__original_main"
      ]
  in
  let file_no_ext = Filename.chop_extension file in
  let file_bc = file_no_ext ^ ".bc" in
  let file_obj = file_no_ext ^ ".o" in
  let file_wasm = file_no_ext ^ ".wasm" in
  Sys_unix.command_exn (sprintf "clang %s -o %s %s" cflags file_bc file);
  Sys_unix.command_exn (sprintf "opt -O1 %s -o %s" file_bc file_bc);
  Sys_unix.command_exn
    (sprintf "llc -O1 -march=wasm32 -filetype=obj %s -o %s" file_bc file_obj);
  (* TODO: get libc.wasm from LD_PATH *)
  Sys_unix.command_exn
    (sprintf "wasm-ld %s libc.wasm -o %s %s" file_obj file_wasm ldflags)

let main debug output includes files () =
  Log.on_debug := debug;
  if not @@ Sys_unix.file_exists_exn output then Core_unix.mkdir output;
  List.iter files ~f:(fun file ->
    let* data = instrument_file file includes in
    let filename = Filename.concat output "instrumented.c" in
    Out_channel.write_all filename ~data;
    compile_file filename ~includes )

let params_spec =
  let open Command.Param in
  let open Command.Flag in
  let+ files = anon (sequence ("filename" %: Filename_unix.arg_type))
  and+ debug = flag "debug" no_arg ~doc:" debug"
  and+ output =
    flag "output" ~aliases:[ "o" ]
      (optional_with_default "wasp-out" string)
      ~doc:"string write results to dir"
  and+ includes =
    flag "include" ~aliases:[ "I" ] (listed string) ~doc:"list headers path"
  in
  main debug output includes files

let cli = Command.basic ~summary:"wasp-c" params_spec
let () = Command_unix.run ~version:"0.2" cli

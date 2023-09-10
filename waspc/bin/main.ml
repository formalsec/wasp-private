open Waspc

let ( let* ) r f = match r with Error e -> failwith e | Ok v -> f v

(* File processing for instrumentor.py *)
let patterns : (Re2.t * string) array =
  Array.map
    (fun (regex, template) -> (Re2.create_exn regex, template))
    [| ( "void reach_error\\(\\) \\{.*\\}"
       , "void reach_error() { __WASP_assert(0); }" )
    |]

let patch_with_regex (file_data : string) : string =
  Array.fold_left
    (fun data (regex, template) -> Re2.rewrite_exn regex ~template data)
    file_data patterns

let patch_gcc_ext (file_data : string) : string =
  String.concat "\n"
    [ "#define __attribute__(x)"
    ; "#define __extension__"
    ; "#define __restrict"
    ; "#define __inline"
    ; file_data
    ]

let instrument_file (file : string) (includes : string list) =
  Log.debug "instrumenting ...\n";
  match Sys.file_exists file with
  | false -> Error (Format.sprintf "unable to read file \"%s\"@." file)
  | true ->
    let data =
      In_channel.(with_open_text file input_all)
      |> patch_gcc_ext |> patch_with_regex
    in
    Py.initialize ();
    let data = Instrumentor.process_text data file includes in
    Py.finalize ();
    Ok data

let compile_file (file : string) ~(includes : string list) =
  Log.debug "compiling ...\n";
  let cflags =
    String.concat " "
      [ "-g"
      ; "-emit-llvm"
      ; "--target=wasm32"
      ; "-m32"
      ; String.concat " " @@ List.map (fun inc -> "-I" ^ inc) includes
      ; "-c"
      ]
  in
  let ldflags =
    String.concat " "
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
  let _ =
    Sys.command (Format.sprintf "clang %s -o %s %s" cflags file_bc file)
  in
  let _ = Sys.command (Format.sprintf "opt -O1 %s -o %s" file_bc file_bc) in
  let _ =
    Sys.command
      (Format.sprintf "llc -O1 -march=wasm32 -filetype=obj %s -o %s" file_bc
         file_obj )
  in
  (* TODO: get libc.wasm from LD_PATH *)
  ignore
  @@ Sys.command
       (Format.sprintf "wasm-ld %s libc.wasm -o %s %s" file_obj file_wasm
          ldflags )

let main debug output includes files =
  Log.on_debug := debug;
  if not @@ Sys.file_exists output then Unix.mkdir output 0o755;
  List.iter
    (fun file ->
      let* data = instrument_file file includes in
      let filename = Filename.concat output "instrumented.c" in
      Out_channel.(with_open_text filename (fun t -> output_string t data));
      compile_file filename ~includes )
    files

let debug =
  let doc = "debug mode" in
  Cmdliner.Arg.(value & flag & info [ "debug" ] ~doc)

let output =
  let doc = "write results to dir" in
  Cmdliner.Arg.(value & opt string "wasp-out" & info [ "output"; "o" ] ~doc)

let includes =
  let doc = "headers path" in
  Cmdliner.Arg.(value & opt_all string [] & info [ "I" ] ~doc)

let files =
  let doc = "source files" in
  Cmdliner.Arg.(value & pos 0 (list ~sep:' ' string) [] & info [] ~doc)

let cli =
  let open Cmdliner in
  let doc = "wasp-c" in
  let man = [ `S Manpage.s_bugs; `P "Email them to TODO" ] in
  let info = Cmd.info "waspc" ~doc ~man in
  Cmd.v info Term.(const main $ debug $ output $ includes $ files)

let () = exit @@ Cmdliner.Cmd.eval cli

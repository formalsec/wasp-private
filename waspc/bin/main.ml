open Waspc
open Bos

(* Just blowup for now, maybe bind later? *)
let ( let* ) r f = match r with Error (`Msg e) -> failwith e | Ok v -> f v

let patterns : (Re2.t * string) array =
  Array.map
    (fun (regex, template) -> (Re2.create_exn regex, template))
    [| ( "void\\s+reach_error\\(\\)\\s*\\{.*\\}"
       , "void reach_error() { __WASP_assert(0); }" )
       (* ugly: Hack to solve duplicate errors on compilation *)
     ; ("void\\s+(assert|assume)\\(", "void old_\\1(")
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
    ; "#include <wasp.h>"
    ; "#include <assert.h>"
    ; file_data
    ]

let instrument_file (file : Fpath.t) (includes : string list) =
  Log.debug "instrumenting ...@.";
  let* data = OS.File.read file in
  let data = patch_gcc_ext data |> patch_with_regex in
  try
    Py.initialize ();
    let data = Instrumentor.instrument data includes in
    Py.finalize ();
    data
  with Py.E (err_type, _) as _e ->
    Log.debug "      warning : exception \"%s\"@."
      (Py.Object.to_string err_type);
    data

let clang flags out_file file =
  Cmd.(v "clang" %% flags % "-o" % p out_file % p file)

let opt file = Cmd.(v "opt" % "-O1" % "-o" % p file % p file)

let llc bc obj =
  let flags = Cmd.of_list [ "-O1"; "-march=wasm32"; "-filetype=obj"; "-o" ] in
  Cmd.(v "llc" %% flags % p obj % p bc)

let ld flags out_file file =
  let* ld_path = OS.Env.req_var "LD_PATH" in
  let libc = Fpath.(v ld_path / "libc.wasm") in
  Cmd.(v "wasm-ld" %% flags % "-o" % p out_file % p libc % p file)

let wasm2wat file =
  Cmd.(v "wasm2wat" % p file % "-o" % p (Fpath.set_ext ".wat" file))

let compile_file (file : Fpath.t) ~(includes : string list) =
  Log.debug "compiling     ...@.";
  let cflags =
    let includes = Cmd.of_list ~slip:"-I" includes in
    let warnings =
      Cmd.of_list
        [ "-Wno-int-conversion"
        ; "-Wno-pointer-sign"
        ; "-Wno-string-plus-int"
        ; "-Wno-implicit-function-declaration"
        ; "-Wno-incompatible-library-redeclaration"
        ; "-Wno-incompatible-function-pointer-types"
        ; "-Wno-incompatible-pointer-types"
        ]
    in
    Cmd.(
      of_list [ "-g"; "-emit-llvm"; "--target=wasm32"; "-m32"; "-c" ]
      %% warnings %% includes )
  in
  let ldflags entry =
    Cmd.(
      of_list [ "-z"; "stack-size=1073741824"; "--no-entry" ]
      % ("--export=" ^ entry) )
  in
  let file_bc = Fpath.(file -+ ".bc") in
  let file_obj = Fpath.(file -+ ".o") in
  let file_wasm = Fpath.(file -+ ".wasm") in
  let* _ = OS.Cmd.run @@ clang cflags file_bc file in
  let* _ = OS.Cmd.run @@ opt file_bc in
  let* _ = OS.Cmd.run @@ llc file_bc file_obj in
  let* _ = OS.Cmd.run @@ ld (ldflags "__original_main") file_wasm file_obj in
  let* _ = OS.Cmd.run @@ wasm2wat file_wasm in
  ()

let main debug output includes files =
  Log.on_debug := debug;
  let output = Fpath.v output in
  let* _ = OS.Dir.create output in
  List.iter
    (fun file ->
      let* file = OS.File.must_exist (Fpath.v file) in
      let data = instrument_file file includes in
      let filename = Fpath.(output / "instrumented.c") in
      let* _ = OS.File.write filename data in
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

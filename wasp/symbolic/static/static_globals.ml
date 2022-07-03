open Types
open Symvalue
open Instance

type global = {mutable content : sym_expr; mut : mutability}
type global_map = (int32, global) Hashtbl.t
type t = global_map

exception Type
exception NotMutable

let alloc (GlobalType (t, mut)) v =
  if type_of v <> t then raise Type;
  {content = v; mut = mut}

let from_list (global_inst_list : global_inst list) : t =
  let tup_list = List.mapi (fun idx glob ->
    ((Int32.of_int idx), (
      let value = Global.load glob in
      let typ = Global.type_of glob in
      let expr = Value value in
      alloc typ expr
    ))
  ) global_inst_list in
  let seq = List.to_seq tup_list in
  (Hashtbl.of_seq seq)

let type_of glob =
  GlobalType (type_of glob.content, glob.mut)

let safe_store glob v =
  if glob.mut = Mutable then glob.content <- v

let globcpy (glob : global) : global =
  alloc (type_of glob) glob.content

(* let contents (globs : global list) : sym_expr list = *)
(*   let rec loop acc = function *)
(*     | []     -> acc *)
(*     | h :: t -> loop ((load h) :: acc) t *)
(*   in List.rev (loop [] globs) *)

let load (map: global_map) (x: int32): sym_expr =
  let g = Hashtbl.find map x in
  g.content

let store (map : global_map) (x : int32) (ex : sym_expr): unit =
  match Hashtbl.find_opt map x with
  | Some(g) -> begin
    if g.mut <> Mutable then raise NotMutable;
    if Symvalue.type_of ex <> Symvalue.type_of g.content then raise Type;
    g.content <- ex
  end
  | None ->
    (* TODO: fix mutability/initialization *)
    let g = { content = ex; mut = Mutable } in
    Hashtbl.replace map x g;

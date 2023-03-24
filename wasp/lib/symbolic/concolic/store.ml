open Common
open Encoding
open Encoding.Types
open Encoding.Expression

type name = string
type bind = name * Num.t

type store = {
  sym : Counter.t;
  ord : name BatDynArray.t;
  map : (name, Num.t) Hashtbl.t;
}

type t = store

let reset (s : t) : unit =
  Counter.clear s.sym;
  Hashtbl.clear s.map;
  BatDynArray.clear s.ord

let clear (s : t) : unit = Hashtbl.clear s.map

let init (s : t) (binds : bind list) : unit =
  List.iter (fun (k, v) -> Hashtbl.add s.map k v) binds

let create (binds : bind list) : t =
  let s =
    {
      sym = Counter.create ();
      ord = BatDynArray.create ();
      map = Hashtbl.create Interpreter.Flags.hashtbl_default_size;
    }
  in
  init s binds;
  s

let add (s : t) (x : name) (v : Num.t) : unit =
  BatDynArray.add s.ord x;
  Hashtbl.replace s.map x v

let find (s : t) (x : name) : Num.t = Hashtbl.find s.map x
let find_opt (s : t) (x : name) : Num.t option = Hashtbl.find_opt s.map x
let exists (s : t) (x : name) : bool = BatDynArray.mem x s.ord

let get (s : t) (x : name) (ty : num_type) (b : bool) : Num.t =
  let v =
    match find_opt s x with
    | Some v -> v
    | None -> (
        match ty with
        | I32Type -> I32 (Int32.of_int (Random.int (if b then 2 else 127)))
        | I64Type -> I64 (Int64.of_int (Random.int 127))
        | F32Type -> F32 (Int32.bits_of_float (Random.float 127.0))
        | F64Type -> F64 (Int64.bits_of_float (Random.float 127.0)))
  in
  add s x v;
  v

let next (s : t) (x : name) : name =
  let id = Counter.get_and_inc s.sym x in
  if id = 0 then x else x ^ "_" ^ string_of_int id

let is_empty (s : t) : bool = 0 = Hashtbl.length s.map

let update (s : t) (binds : bind list) : unit =
  List.iter (fun (x, v) -> Hashtbl.replace s.map x v) binds

let to_json (s : t) : string =
  let jsonify_bind (b : bind) : string =
    let n, v = b in
    "{" ^ "\"name\" : \"" ^ n ^ "\", " ^ "\"value\" : \"" ^ Num.string_of_num v
    ^ "\", " ^ "\"type\" : \""
    ^ Types.string_of_num_type (Types.type_of v)
    ^ "\"" ^ "}"
  in
  "["
  ^ String.concat ","
      (BatDynArray.fold_left
         (fun a x -> jsonify_bind (x, find s x) :: a)
         [] s.ord)
  ^ "]"

let strings_to_json string_env : string =
  let jsonify_bind b : string =
    let t, x, v = b in
    "{" ^ "\"name\" : \"" ^ x ^ "\", " ^ "\"value\" : \"" ^ v ^ "\", "
    ^ "\"type\" : \"" ^ t ^ "\"" ^ "}"
  in
  "[" ^ String.concat ", " (List.map jsonify_bind string_env) ^ "]"

let to_string (s : t) : string =
  BatDynArray.fold_left
    (fun a k ->
      let v = find s k in
      a ^ "(" ^ k ^ "->" ^ Num.string_of_num v ^ ")\n")
    "" s.ord

let get_key_types (s : t) : (string * num_type) list =
  Hashtbl.fold (fun k v acc -> (k, Types.type_of v) :: acc) s.map []

let to_expr (s : t) : expr list =
  Hashtbl.fold
    (fun k n acc ->
      let e =
        match n with
        | I32 _ -> Relop (I32 I32.Eq, Symbolic (I32Type, k), Num n)
        | I64 _ -> Relop (I64 I64.Eq, Symbolic (I64Type, k), Num n)
        | F32 _ -> Relop (F32 F32.Eq, Symbolic (F32Type, k), Num n)
        | F64 _ -> Relop (F64 F64.Eq, Symbolic (F64Type, k), Num n)
      in
      e :: acc)
    s.map []

let rec eval (env : t) (e : expr) : Num.t =
  match simplify e with
  | SymPtr (b, o) ->
      let b = I32 b in
      Eval_numeric.eval_binop (I32 I32.Add) b (eval env o)
  | Num n -> n
  | Binop (op, e1, e2) ->
      let v1 = eval env e1 and v2 = eval env e2 in
      Eval_numeric.eval_binop op v1 v2
  | Unop (op, e') ->
      let v = eval env e' in
      Eval_numeric.eval_unop op v
  | Relop (op, e1, e2) ->
      let v1 = eval env e1 and v2 = eval env e2 in
      Num.num_of_bool (Eval_numeric.eval_relop op v1 v2)
  | Cvtop (op, e') ->
      let v = eval env e' in
      Eval_numeric.eval_cvtop op v
  | Symbolic (ty, var) -> find env var
  | Extract (e', h, l) ->
      let v =
        match eval env e' with
        | I32 x | F32 x -> Int64.of_int32 x
        | I64 x | F64 x -> x
      in
      I64 (nland64 (Int64.shift_right v (l * 8)) (h - l))
  | Concat (e1, e2) -> eval env (simplify (e1 ++ e2))
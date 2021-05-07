open Z3
open Types
open Values
open Symvalue

let cfg = [
  ("model", "true");
  ("proof", "false");
  ("unsat_core", "false")
]

let ctx : context = mk_context cfg

let bv32_sort = BitVector.mk_sort ctx 32
let bv64_sort = BitVector.mk_sort ctx 64
let fp32_sort = FloatingPoint.mk_sort_single ctx
let fp64_sort = FloatingPoint.mk_sort_double ctx

let rne = FloatingPoint.RoundingMode.mk_rne ctx
let rtz = FloatingPoint.RoundingMode.mk_rtz ctx

let bv_false = BitVector.mk_numeral ctx "0" 32
let bv_true  = BitVector.mk_numeral ctx "1" 32

let get_sort (e : value_type) : Sort.sort =
  begin match e with
  | I32Type | F32Type -> bv32_sort
  | I64Type | F64Type -> bv64_sort
  end

let extend (e : Expr.expr) (target : int) : Expr.expr =
  let e' = FloatingPoint.(if is_fp e then mk_to_ieee_bv ctx e
                                     else e) in
  let curr = BitVector.get_size (Expr.get_sort e') in
  if  curr < target then BitVector.mk_zero_ext ctx (target - curr) e'
                    else e'

module Zi32 = 
struct
  open Si32

  let encode_value (i : int) : Expr.expr =
    Expr.mk_numeral_int ctx i bv32_sort

  let encode_unop (op : unop) (e : Expr.expr) : Expr.expr =
    failwith "Zi32: encode_unop: Construct not supported yet"

  let encode_binop (op : binop) (e1 : Expr.expr)
      (e2 : Expr.expr) : Expr.expr =
    let e1' = extend e1 32
    and e2' = extend e2 32
    and op' = begin match op with
      | I32Add  -> BitVector.mk_add  ctx
      | I32Sub  -> BitVector.mk_sub  ctx
      | I32Mul  -> BitVector.mk_mul  ctx
      | I32DivS -> BitVector.mk_sdiv ctx
      | I32DivU -> BitVector.mk_udiv ctx
      | I32And  -> BitVector.mk_and  ctx
      | I32Xor  -> BitVector.mk_xor  ctx
      | I32Or   -> BitVector.mk_or   ctx
      | I32Shl  -> BitVector.mk_shl  ctx
      | I32ShrS -> BitVector.mk_ashr ctx
      | I32ShrU -> BitVector.mk_lshr ctx
      | I32RemS -> BitVector.mk_srem ctx
      | I32RemU -> BitVector.mk_urem ctx
      end
    in op' e1' e2'

  let encode_relop (op : relop) (e1 : Expr.expr) 
      (e2 : Expr.expr) : Expr.expr = 
    let e1' = extend e1 32
    and e2' = extend e2 32
    and op' = begin match op with
      | I32Eq  -> Boolean.mk_eq ctx
      | I32Ne  -> (fun x1 x2 -> Boolean.mk_not ctx (Boolean.mk_eq ctx x1 x2))
      | I32LtU -> BitVector.mk_ult ctx
      | I32LtS -> BitVector.mk_slt ctx
      | I32LeU -> BitVector.mk_ule ctx
      | I32LeS -> BitVector.mk_sle ctx
      | I32GtU -> BitVector.mk_ugt ctx
      | I32GtS -> BitVector.mk_sgt ctx
      | I32GeU -> BitVector.mk_uge ctx
      | I32GeS -> BitVector.mk_sge ctx
      end
    in Boolean.mk_ite ctx (op' e1' e2') bv_true bv_false

  let encode_cvtop (op : cvtop) (e : Expr.expr) : Expr.expr =
    let op' = begin match op with
      | I32TruncSF32 -> (fun f -> FloatingPoint.mk_to_sbv ctx rtz f 32)
      | I32TruncUF32 -> (fun f -> FloatingPoint.mk_to_ubv ctx rtz f 32)
      | I32TruncSF64 -> (fun f -> FloatingPoint.mk_to_sbv ctx rtz f 32)
      | I32TruncUF64 -> (fun f -> FloatingPoint.mk_to_ubv ctx rtz f 32)
      | I32ReinterpretFloat -> FloatingPoint.mk_to_ieee_bv ctx 
      end
    in op' e
end


module Zi64 =
struct
  open Si64

  let encode_value (i : int) : Expr.expr =
    Expr.mk_numeral_int ctx i bv64_sort

  let encode_unop (op : unop) (e : Expr.expr) : Expr.expr =
    failwith "Zi64: encode_unop: Construct not supported yet"

  let encode_binop (op : binop) (e1 : Expr.expr)
      (e2 : Expr.expr) : Expr.expr =
    let e1' = extend e1 64
    and e2' = extend e2 64
    and op' = begin match op with
      | I64Add  -> BitVector.mk_add  ctx
      | I64Sub  -> BitVector.mk_sub  ctx
      | I64Mul  -> BitVector.mk_mul  ctx
      | I64DivS -> BitVector.mk_sdiv ctx
      | I64DivU -> BitVector.mk_udiv ctx
      | I64And  -> BitVector.mk_and  ctx
      | I64Xor  -> BitVector.mk_xor  ctx
      | I64Or   -> BitVector.mk_or   ctx
      | I64Shl  -> BitVector.mk_shl  ctx
      | I64ShrS -> BitVector.mk_ashr ctx
      | I64ShrU -> BitVector.mk_lshr ctx
      | I64RemS -> BitVector.mk_srem ctx
      | I64RemU -> BitVector.mk_urem ctx
      end
    in op' e1' e2'

  let encode_relop (op : relop) (e1 : Expr.expr)
      (e2 : Expr.expr) : Expr.expr =
    (* Extend to fix these: (I64Eq, (I64Ne, x, y), 1) *)
    let e1' = extend e1 64
    and e2' = extend e2 64
    and op' = begin match op with
      | I64Eq  -> Boolean.mk_eq ctx
      | I64Ne  -> (fun x1 x2 -> Boolean.mk_not ctx (Boolean.mk_eq ctx x1 x2))
      | I64LtU -> BitVector.mk_ult ctx
      | I64LtS -> BitVector.mk_slt ctx
      | I64LeU -> BitVector.mk_ule ctx
      | I64LeS -> BitVector.mk_sle ctx
      | I64GtU -> BitVector.mk_ugt ctx
      | I64GtS -> BitVector.mk_sgt ctx
      | I64GeU -> BitVector.mk_uge ctx
      | I64GeS -> BitVector.mk_sge ctx
      end
    in Boolean.mk_ite ctx (op' e1' e2') bv_true bv_false

  let encode_cvtop (op : cvtop) (e : Expr.expr) : Expr.expr =
    let op' = begin match op with
      | I64ExtendSI32 -> BitVector.mk_sign_ext ctx 32
      | I64ExtendUI32 -> BitVector.mk_zero_ext ctx 32
      (* rounding towards zero (aka truncation) *)
      | I64TruncSF32 -> (fun f -> FloatingPoint.mk_to_sbv ctx rtz f 64)
      | I64TruncUF32 -> (fun f -> FloatingPoint.mk_to_ubv ctx rtz f 64)
      | I64TruncSF64 -> (fun f -> FloatingPoint.mk_to_sbv ctx rtz f 64)
      | I64TruncUF64 -> (fun f -> FloatingPoint.mk_to_ubv ctx rtz f 64)
      | I64ReinterpretFloat -> FloatingPoint.mk_to_ieee_bv ctx 
      end
    in op' e
end

module Zf32 =
struct
  open Sf32

  let to_fp (e : Expr.expr) : Expr.expr =
    if BitVector.is_bv e then
      FloatingPoint.mk_to_fp_bv ctx e fp32_sort
    else e

  let encode_value (f : float) : Expr.expr =
    FloatingPoint.mk_numeral_f ctx f fp32_sort

  let encode_unop (op : unop) (e : Expr.expr) : Expr.expr =
    let op' =
      begin match op with
      | F32Neg -> FloatingPoint.mk_neg ctx
      end
    in op' (to_fp e)

  let encode_binop (op : binop) (e1 : Expr.expr)
      (e2 : Expr.expr) : Expr.expr =
    let e1' = to_fp e1
    and e2' = to_fp e2
    and op' = begin match op with
      | F32Add -> FloatingPoint.mk_add ctx rne
      | F32Sub -> FloatingPoint.mk_sub ctx rne
      | F32Mul -> FloatingPoint.mk_mul ctx rne
      | F32Div -> FloatingPoint.mk_div ctx rne
      end
    in op' e1' e2'

  let encode_relop (op : relop) (e1 : Expr.expr)
      (e2 : Expr.expr) : Expr.expr =
    let e1' = to_fp e1
    and e2' = to_fp e2
    and op' = begin match op with
      | F32Eq -> FloatingPoint.mk_eq  ctx
      | F32Ne -> (fun x1 x2 -> Boolean.mk_not ctx (FloatingPoint.mk_eq ctx x1 x2))
      | F32Lt -> FloatingPoint.mk_lt  ctx
      | F32Le -> FloatingPoint.mk_leq ctx
      | F32Gt -> FloatingPoint.mk_gt  ctx
      | F32Ge -> FloatingPoint.mk_geq ctx
      end
    in Boolean.mk_ite ctx (op' e1' e2') bv_true bv_false

  let encode_cvtop (op : cvtop) (e : Expr.expr) : Expr.expr =
    let op' = begin match op with
      | F32ConvertSI32 -> 
          (fun bv -> FloatingPoint.mk_to_fp_signed ctx rne bv fp32_sort)
      | F32ConvertUI32 ->
          (fun bv -> FloatingPoint.mk_to_fp_unsigned ctx rne bv fp32_sort)
      | F32ConvertSI64 ->
          (fun bv -> FloatingPoint.mk_to_fp_signed ctx rne bv fp32_sort)
      | F32ConvertUI64 ->
          (fun bv -> FloatingPoint.mk_to_fp_unsigned ctx rne bv fp32_sort)
      | F32ReinterpretInt -> 
          (fun bv -> FloatingPoint.mk_to_fp_bv ctx bv fp32_sort)
      end
    in op' e
end

module Zf64 =
struct
  open Sf64

  let to_fp (e : Expr.expr) : Expr.expr =
    if BitVector.is_bv e then begin
      FloatingPoint.mk_to_fp_bv ctx e fp64_sort
    end else e

  let encode_value (f : float) : Expr.expr =
    FloatingPoint.mk_numeral_f ctx f fp64_sort

  let encode_unop (op : unop) (e : Expr.expr) : Expr.expr =
    let op'  = begin match op with
      | F64Neg -> FloatingPoint.mk_neg ctx
      | F64Abs -> FloatingPoint.mk_abs ctx
      end
    in op' (to_fp e)

  let encode_binop (op : binop) (e1 : Expr.expr)
      (e2 : Expr.expr) : Expr.expr =
    let e1' = to_fp e1
    and e2' = to_fp e2
    and op' = begin match op with
      | F64Add -> FloatingPoint.mk_add ctx rne
      | F64Sub -> FloatingPoint.mk_sub ctx rne
      | F64Mul -> FloatingPoint.mk_mul ctx rne
      | F64Div -> FloatingPoint.mk_div ctx rne
      end
    in op' e1' e2'

  let encode_relop (op : relop) (e1 : Expr.expr)
      (e2 : Expr.expr) : Expr.expr =
    let e1' = to_fp e1
    and e2' = to_fp e2
    and op' = begin match op with
      | F64Eq -> FloatingPoint.mk_eq  ctx
      | F64Ne -> (fun x1 x2 -> Boolean.mk_not ctx (FloatingPoint.mk_eq ctx x1 x2))
      | F64Lt -> FloatingPoint.mk_lt  ctx
      | F64Le -> FloatingPoint.mk_leq ctx
      | F64Gt -> FloatingPoint.mk_gt  ctx
      | F64Ge -> FloatingPoint.mk_geq ctx
      end
    in Boolean.mk_ite ctx (op' e1' e2') bv_true bv_false

  let encode_cvtop (op : cvtop) (e : Expr.expr) : Expr.expr =
    let op' = begin match op with
      | F64ConvertSI32 -> 
          (fun bv -> FloatingPoint.mk_to_fp_signed ctx rne bv fp64_sort)
      | F64ConvertUI32 ->
          (fun bv -> FloatingPoint.mk_to_fp_unsigned ctx rne bv fp64_sort)
      | F64ConvertSI64 ->
          (fun bv -> FloatingPoint.mk_to_fp_signed ctx rne bv fp64_sort)
      | F64ConvertUI64 ->
          (fun bv -> FloatingPoint.mk_to_fp_unsigned ctx rne bv fp64_sort)
      | F64ReinterpretInt -> 
          (fun bv -> FloatingPoint.mk_to_fp_bv ctx bv fp64_sort)
      end
    in op' e

end

let encode_value (v : value) : Expr.expr =
  begin match v with
  | I32 i -> Zi32.encode_value (Int32.to_int i)
  | I64 i -> Zi64.encode_value (Int64.to_int i)
  | F32 f -> Zf32.encode_value (F32.to_float f)
  | F64 f -> Zf64.encode_value (F64.to_float f)
  end

let rec encode_sym_expr (e : sym_expr) : Expr.expr =
  begin match e with
  | Value v -> encode_value v
  | Ptr p   -> encode_value p
  | I32Unop  (op, e) ->
      let e' = encode_sym_expr e in
      Zi32.encode_unop op e'
  | I32Binop (op, e1, e2) ->
      let e1' = encode_sym_expr e1
      and e2' = encode_sym_expr e2 in
      Zi32.encode_binop op e1' e2'
  | I32Relop (op, e1, e2) ->
      let e1' = encode_sym_expr e1
      and e2' = encode_sym_expr e2 in
      Zi32.encode_relop op e1' e2'
  | I32Cvtop (op, e) ->
      let e' = encode_sym_expr e in
      Zi32.encode_cvtop op e'
  | I64Unop  (op, e) ->
      let e' = encode_sym_expr e in
      Zi64.encode_unop op e'
  | I64Binop (op, e1, e2) ->
      let e1' = encode_sym_expr e1
      and e2' = encode_sym_expr e2 in
      Zi64.encode_binop op e1' e2'
  | I64Relop (op, e1, e2) ->
      let e1' = encode_sym_expr e1
      and e2' = encode_sym_expr e2 in
      Zi64.encode_relop op e1' e2'
  | I64Cvtop (op, e) ->
      let e' = encode_sym_expr e in
      Zi64.encode_cvtop op e'
  | F32Unop (op, e) ->
      let e' = encode_sym_expr e in
      Zf32.encode_unop op e'
  | F32Binop (op, e1, e2) ->
      let e1' = encode_sym_expr e1
      and e2' = encode_sym_expr e2 in
      Zf32.encode_binop op e1' e2'
  | F32Relop (op, e1, e2) ->
      let e1' = encode_sym_expr e1
      and e2' = encode_sym_expr e2 in
      Zf32.encode_relop op e1' e2'
  | F32Cvtop (op, e) ->
      let e' = encode_sym_expr e in
      Zf32.encode_cvtop op e'
  | F64Unop (op, e) ->
      let e' = encode_sym_expr e in
      Zf64.encode_unop op e'
  | F64Binop (op, e1, e2) ->
      let e1' = encode_sym_expr e1
      and e2' = encode_sym_expr e2 in
      Zf64.encode_binop op e1' e2'
  | F64Relop (op, e1, e2) ->
      let e1' = encode_sym_expr e1
      and e2' = encode_sym_expr e2 in
      Zf64.encode_relop op e1' e2'
  | F64Cvtop (op, e) ->
      let e' = encode_sym_expr e in
      Zf64.encode_cvtop op e'
  | Symbolic (t, x) ->
      Expr.mk_const_s ctx x (get_sort (type_of_symbolic t))
  | Extract  (e, h, l) -> 
      let e' = encode_sym_expr e in
      (* UGLY HACK *)
      let e'' = 
        if FloatingPoint.is_fp e' then FloatingPoint.mk_to_ieee_bv ctx e' 
        else e'
      in
      BitVector.mk_extract ctx (h * 8 - 1) (l * 8) e''
  | Concat (e1, e2) -> 
      let e1' = encode_sym_expr e1
      and e2' = encode_sym_expr e2 in
      BitVector.mk_concat ctx e1' e2'
  | BoolOp (op, e1, e2) ->
      let e1' = encode_sym_expr e1
      and e2' = encode_sym_expr e2
      and op' = match op with
        | And -> BitVector.mk_and ctx
        | Or  -> BitVector.mk_or  ctx
      in op' e1' e2'
  end

let check_sat_core (pc : path_conditions) : Model.model option =
  assert (not (pc = []));
  let pc_as_bv = List.map encode_sym_expr pc in
  let pc' = List.map (fun c -> Boolean.mk_not ctx (Boolean.mk_eq ctx c bv_false)) pc_as_bv in
  let solver = Solver.mk_solver ctx None in
  List.iter (fun c -> Solver.add solver [c]) pc';
  (*
  Printf.printf "\n\nDEBUG ASSERTIONS:\n";
  List.iter (fun a -> Printf.printf "%s\n" (Expr.to_string a)) 
            (Solver.get_assertions solver);
  *)
  begin match Solver.check solver [] with
  | Solver.UNSATISFIABLE -> None
  | Solver.UNKNOWN       -> failwith ("unknown: " ^ (Solver.get_reason_unknown solver)) (* fail? *)
  | Solver.SATISFIABLE   -> Solver.get_model solver
  end

let lift_z3_model (model : Model.model) (sym_int32 : string list)
    (sym_int64 : string list) (sym_float32 : string list)
    (sym_float64 : string list) : (string * value) list = 

  let lift_z3_const (c : sym_expr) : int64 option =
    let recover_numeral (n : Expr.expr) : int64 option =
      if Expr.is_numeral n then begin
        let bytes_of_n = Bytes.of_string (Expr.to_string n) in
        Bytes.set bytes_of_n 0 '0';
        Some (Int64.of_string (Bytes.to_string bytes_of_n))
      end else None
    in
    let v = Model.get_const_interp_e model (encode_sym_expr c) in
    Option.map_default recover_numeral None v
  in
  let i32_asgn = List.fold_left (fun a x ->
    let n = lift_z3_const (Symbolic (SymInt32, x)) in
    let v = Option.map (fun y -> I32 (Int64.to_int32 y)) n in
    Option.map_default (fun y -> (x, y) :: a) (a) v
  ) [] sym_int32 in
  let i64_asgn = List.fold_left (fun a x ->
    let n = lift_z3_const (Symbolic (SymInt64, x)) in
    let v = Option.map (fun y -> I64 y) n in
    Option.map_default (fun y -> (x, y) :: a) (a) v
  ) [] sym_int64 in
  let f32_asgn = List.fold_left (fun a x ->
    let n = lift_z3_const (Symbolic (SymFloat32, x)) in
    let v = Option.map (fun y -> F32 (F32.of_bits (Int64.to_int32 y))) n in
    Option.map_default (fun y -> (x, y) :: a) (a) v
  ) [] sym_float32 in
  let f64_asgn = List.fold_left (fun a x ->
    let n = lift_z3_const (Symbolic (SymFloat64, x)) in
    let v = Option.map (fun y -> F64 (F64.of_bits y)) n in
    Option.map_default (fun y -> (x, y) :: a) (a) v
  ) [] sym_float64 in
  i32_asgn @ (i64_asgn @ (f32_asgn @ f64_asgn))

;; Stores and Loads symbolic variable
(module
  (type $0 (func))
  (type $1 (func (result i32)))
  
  (func $store_load_sym_mem (type $1) (result i32)
        (global.get 0)
        (i32.const 1024)
        (sym_int)
        (i32.store)
        (get_sym_int32 "x")
        (global.get 0)
        (i32.load)
        (i32.eq))
  (func $store_load_local (type $1) (result i32)
        (local i32)
        (i32.const 1026)
        (sym_int)
        (local.set 0)
        (get_sym_int32 "y")
        (local.get 0)
        (i32.eq))
  (func $main (type $0)
        (call $store_load_sym_mem)
        (sym_assert)
        (call $store_load_local)
        (sym_assert))
  (memory $0 1)
  (global $0 (mut i32) (i32.const 66592))
  (export "main" (func $main))
  (data $0 (i32.const 1024) "x\00y\00"))
(invoke "main")

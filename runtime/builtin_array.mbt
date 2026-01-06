///|
pub fn init_array_prototype(array_proto_val : JSValue) -> Unit {
  match array_proto_val {
    Object(obj) => {
      // push
      let push_fn = Native(fn(_ctx, this_val, args) {
        match this_val {
          Object(o) => {
            let mut len = match o["length"] {
              Number(n) => n
              _ => 0.0
            }
            for arg in args {
              o[len.to_string()] = arg
              len = len + 1.0
            }
            o["length"] = Number(len)
            Number(len)
          }
          _ => Number(0.0) // Should throw TypeError?
        }
      })
      let push_obj = JSFunction::new(name="push", body=push_fn)
      obj["push"] = JSValue::Function(push_obj)

      // pop
      let pop_fn = Native(fn(_ctx, this_val, _args) {
        match this_val {
          Object(o) => {
            let len = match o["length"] {
              Number(n) => n
              _ => 0.0
            }
            if len > 0.0 {
              let new_len = len - 1.0
              let val = o[new_len.to_string()]
              o.properties.remove(new_len.to_string())
              o["length"] = Number(new_len)
              val
            } else {
              o["length"] = Number(0.0)
              Undefined
            }
          }
          _ => Undefined
        }
      })
      let pop_obj = JSFunction::new(name="pop", body=pop_fn)
      obj["pop"] = JSValue::Function(pop_obj)
    }
    _ => ()
  }
}

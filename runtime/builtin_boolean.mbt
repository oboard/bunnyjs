///|
pub fn init_boolean_prototype(boolean_proto_val : JSValue) -> Unit {
  match boolean_proto_val {
    Object(obj) => {
      // valueOf
      let value_of_fn = Native(fn(_ctx, this_val, _args) {
        match this_val {
          Boolean(b) => JSValue::Boolean(b)
          Object(o) =>
            match o.properties.get("PrimitiveValue") {
              Some(Boolean(b)) => JSValue::Boolean(b)
              _ => JSValue::Boolean(false) // Should throw TypeError
            }
          _ => JSValue::Boolean(false) // Should throw TypeError
        }
      })
      let value_of_obj = JSFunction::{
        name: Some("valueOf"),
        params: [],
        body: value_of_fn,
        context: Context::new(),
        properties: @hashmap.new(),
        prototype: None,
      }
      obj.properties.set("valueOf", JSValue::Function(value_of_obj))

      // toString
      let to_string_fn = Native(fn(_ctx, this_val, _args) {
        let val = match this_val {
          Boolean(b) => b
          Object(o) =>
            match o.properties.get("PrimitiveValue") {
              Some(Boolean(b)) => b
              _ => false
            }
          _ => false
        }
        JSValue::String(val.to_string())
      })
      let to_string_obj = JSFunction::{
        name: Some("toString"),
        params: [],
        body: to_string_fn,
        context: Context::new(),
        properties: @hashmap.new(),
        prototype: None,
      }
      obj.properties.set("toString", JSValue::Function(to_string_obj))
    }
    _ => ()
  }
}

///|
pub fn create_boolean_constructor(proto : JSValue) -> JSValue {
  let ctor_fn = Native(fn(_ctx, this_val, args) {
    let val = if args.length() > 0 { args[0].is_truthy() } else { false }
    let is_constructor = match this_val {
      Object(o) =>
        match o.prototype {
          Some(p) =>
            match (p, proto) {
              (Object(a), Object(b)) =>
                physical_equal(a.properties, b.properties)
              _ => false
            }
          None => false
        }
      _ => false
    }
    if is_constructor {
      match this_val {
        Object(o) => o.properties.set("PrimitiveValue", JSValue::Boolean(val))
        _ => ()
      }
      JSValue::Boolean(val)
    } else {
      JSValue::Boolean(val)
    }
  })
  let ctor_obj = JSFunction::{
    name: Some("Boolean"),
    params: [],
    body: ctor_fn,
    context: Context::new(),
    properties: @hashmap.new(),
    prototype: None,
  }
  ctor_obj.properties.set("prototype", proto)
  JSValue::Function(ctor_obj)
}

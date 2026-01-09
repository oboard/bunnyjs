///|
pub fn create_error_prototype(object_proto : JSValue) -> JSValue {
  let proto_props = {
    "name": JSValue::String("Error"),
    "message": JSValue::String(""),
  }
  let proto = JSValue::Object({
    properties: proto_props,
    prototype: Some(object_proto),
  })

  // Error.prototype.toString
  let to_string_fn = Native(fn(_ctx, this_val, _args) {
    match this_val {
      Object({ properties, .. }) => {
        let name = match properties.get("name") {
          Some(JSValue::String(s)) => s
          _ => "Error"
        }
        let msg = match properties.get("message") {
          Some(JSValue::String(s)) => s
          _ => ""
        }
        if msg == "" {
          JSValue::String(name)
        } else {
          JSValue::String(name + ": " + msg)
        }
      }
      _ => JSValue::String("Error")
    }
  })
  proto_props.set(
    "toString",
    JSValue::Function(JSFunction::new(name="toString", body=to_string_fn)),
  )
  proto
}

///|
pub fn create_error_constructor(
  name : String,
  error_proto : JSValue,
  func_proto : JSValue,
) -> JSValue {
  let ctor_fn = Native(fn(_ctx, _this_val, args) {
    let message = if args is [JSValue::String(msg), ..] { msg } else { "" }
    let obj = JSObject::{
      properties: {
        "message": JSValue::String(message),
        "name": JSValue::String(name),
      },
      prototype: Some(error_proto),
    }
    JSValue::Object(obj)
  })
  let ctor = JSFunction::new(name~, body=ctor_fn, prototype=func_proto)
  ctor["prototype"] = error_proto
  let ctor_val = JSValue::Function(ctor)

  // Set constructor on prototype
  match error_proto {
    Object(o) => o.properties.set("constructor", ctor_val)
    _ => ()
  }
  ctor_val
}

///|
pub fn create_native_error_constructor(
  name : String,
  error_proto : JSValue, // Error.prototype
  func_proto : JSValue,
) -> JSValue {
  let proto_props = {
    "name": JSValue::String(name),
    "message": JSValue::String(""),
  }
  let proto = JSValue::Object({
    properties: proto_props,
    prototype: Some(error_proto),
  })
  create_error_constructor(name, proto, func_proto)
}

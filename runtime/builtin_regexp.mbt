///|
pub fn create_regexp_object(object_proto : JSValue) -> JSValue {
  let regexp_proto_props = @hashmap.new()
  let regexp_proto = JSValue::Object(JSObject::{
    properties: regexp_proto_props,
    prototype: Some(object_proto),
  })

  // RegExp Constructor
  let regexp_ctor_fn = Native(fn(_ctx, this_val, args) {
    let (pattern_view, pattern_str) = if args.length() > 0 {
      match args[0] {
        JSValue::String(s) => (s, s.to_string())
        _ => {
          let s = ""
          (s[:], s)
        }
      }
    } else {
      let s = ""
      (s[:], s)
    }

    // Note: Flags are ignored for now

    let (re, valid) = (@regexp.compile(pattern_view), true) catch {
      _ => (@regexp.compile(""[:]) catch { _ => panic() }, false)
    }
    if not(valid) {
      return JSValue::String("SyntaxError: Invalid regular expression")
    }
    let is_constructor_call = match this_val {
      Object(_obj) => true
      _ => false
    }
    if is_constructor_call {
      match this_val {
        Object(obj) => {
          obj.properties.set(
            "__internal_regexp__",
            JSValue::Internal(JSInternal::RegExp(re, pattern_str)),
          )
          this_val
        }
        _ => JSValue::Undefined
      }
    } else {
      // Function call - create new object
      let new_obj_props = @hashmap.new()
      let new_obj = JSValue::Object(JSObject::{
        properties: new_obj_props,
        prototype: Some(regexp_proto),
      })
      new_obj_props.set(
        "__internal_regexp__",
        JSValue::Internal(JSInternal::RegExp(re, pattern_str)),
      )
      new_obj
    }
  })
  let regexp_ctor = JSFunction::new(
    name="RegExp",
    body=regexp_ctor_fn,
    properties=@hashmap.new(),
    prototype=regexp_proto,
  )
  let regexp_ctor_val = JSValue::Function(regexp_ctor)
  regexp_proto_props.set("constructor", regexp_ctor_val)

  // RegExp.prototype.test(string)
  let test_fn = Native(fn(_ctx, this_val, args) {
    let str = if args.length() > 0 {
      match args[0] {
        JSValue::String(s) => s.to_string()
        _ => "undefined"
      }
    } else {
      "undefined"
    }
    match this_val {
      Object(obj) =>
        match obj.properties.get("__internal_regexp__") {
          Some(JSValue::Internal(JSInternal::RegExp(re, _))) => {
            // execute returns MatchResult? Checking if results is non-empty
            let res = re.execute(str)
            let matched = res.results().length() > 0
            JSValue::Boolean(matched)
          }
          _ => JSValue::Boolean(false)
        }
      _ => JSValue::Boolean(false)
    }
  })
  regexp_proto_props.set(
    "test",
    JSValue::Function(JSFunction::new(name="test", body=test_fn)),
  )

  // RegExp.prototype.toString()
  let to_string_fn = Native(fn(_ctx, this_val, _args) {
    match this_val {
      Object(obj) =>
        match obj.properties.get("__internal_regexp__") {
          Some(JSValue::Internal(JSInternal::RegExp(_, src))) =>
            JSValue::String("/" + src + "/")
          _ => JSValue::String("/(?:)/")
        }
      _ => JSValue::String("/(?:)/")
    }
  })
  regexp_proto_props.set(
    "toString",
    JSValue::Function(JSFunction::new(name="toString", body=to_string_fn)),
  )
  regexp_ctor_val
}

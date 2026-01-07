//|

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

    // Parse flags
    let flags_str = if args.length() > 1 {
      match args[1] {
        JSValue::String(s) => s.to_string()
        _ => ""
      }
    } else {
      ""
    }

    // Handle ignore case by prepending (?i) if supported or we rely on the engine
    // MoonBit's regexp currently doesn't support inline flags like (?i) or we don't have access to compile options.
    // So we just pass the pattern as is. Flags are stored in properties but not used for matching yet.
    let effective_pattern = pattern_str
    let (re, valid) = (@regexp.compile(effective_pattern[:]), true) catch {
      _ => (@regexp.compile(""[:]) catch { _ => panic() }, false)
    }
    if not(valid) {
      return JSValue::String("SyntaxError: Invalid regular expression")
    }
    let init_regexp_props = fn(obj : JSObject) {
      obj.properties.set("lastIndex", JSValue::Number(0.0))
      obj.properties.set("source", JSValue::String(pattern_view))
      obj.properties.set("global", JSValue::Boolean(flags_str.contains("g")))
      obj.properties.set(
        "ignoreCase",
        JSValue::Boolean(flags_str.contains("i")),
      )
      obj.properties.set("multiline", JSValue::Boolean(flags_str.contains("m")))
      obj.properties.set(
        "__internal_regexp__",
        JSValue::Internal(JSInternal::RegExp(re, pattern_str)),
      )
    }
    let is_constructor_call = match this_val {
      Object(_obj) => true
      _ => false
    }
    if is_constructor_call {
      match this_val {
        Object(obj) => {
          init_regexp_props(obj)
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
      let new_obj_inner = match new_obj {
        Object(o) => o
        _ => panic()
      }
      init_regexp_props(new_obj_inner)
      new_obj
    }
  })
  let regexp_ctor_props = @hashmap.new()
  regexp_ctor_props.set("prototype", regexp_proto)
  let regexp_ctor = JSFunction::new(
    name="RegExp",
    body=regexp_ctor_fn,
    properties=regexp_ctor_props,
    prototype=object_proto,
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
      Object(
        {
          properties: {
            "__internal_regexp__": JSValue::Internal(JSInternal::RegExp(re, _)),
            ..
          },
          ..,
        }
      ) => {
        // execute returns MatchResult? Checking if results is non-empty
        let res = re.execute(str)
        let matched = res.results().length() > 0
        JSValue::Boolean(matched)
      }
      _ => JSValue::Boolean(false)
    }
  })
  regexp_proto_props.set(
    "test",
    JSValue::Function(JSFunction::new(name="test", body=test_fn)),
  )

  // RegExp.prototype.exec(string)
  let exec_fn = Native(fn(_ctx, this_val, args) {
    let str = if args.length() > 0 {
      match args[0] {
        JSValue::String(s) => s.to_string()
        _ => "undefined"
      }
    } else {
      "undefined"
    }
    match this_val {
      Object(
        {
          properties: {
            "__internal_regexp__": JSValue::Internal(JSInternal::RegExp(re, _)),
            ..
          },
          ..,
        }
      ) => {
        let res = re.execute(str)
        if res.results().length() > 0 {
          // Construct result array
          // For simple exec, just return first match in an array-like object with index and input
          let match_content = res.results()[0]
          let match_str = match match_content {
            Some(s) => s.to_string()
            None => ""
          }
          // Calculate index using length of text before match
          let match_index = res.before().length()
          let result_array_props = @hashmap.new()
          result_array_props.set("0", JSValue::String(match_str))
          result_array_props.set(
            "index",
            JSValue::Number(match_index.to_double()),
          )
          result_array_props.set("input", JSValue::String(str))
          result_array_props.set("length", JSValue::Number(1.0))
          JSValue::Object(JSObject::{
            properties: result_array_props,
            prototype: Some(object_proto), // Array prototype ideally, but Object for now
          })
        } else {
          JSValue::Null
        }
      }
      _ => JSValue::Null
    }
  })
  regexp_proto_props.set(
    "exec",
    JSValue::Function(JSFunction::new(name="exec", body=exec_fn)),
  )

  // RegExp.prototype.toString()
  let to_string_fn = Native(fn(_ctx, this_val, _args) {
    match this_val {
      Object(
        {
          properties: {
            "__internal_regexp__": JSValue::Internal(JSInternal::RegExp(_, src)),
            ..
          },
          ..,
        }
      ) => JSValue::String("/" + src + "/")
      _ => JSValue::String("/(?:)/")
    }
  })
  regexp_proto_props.set(
    "toString",
    JSValue::Function(JSFunction::new(name="toString", body=to_string_fn)),
  )
  regexp_ctor_val
}

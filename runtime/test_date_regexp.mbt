///|
test "Date Constructor and Methods" {
  let obj_proto = JSValue::Object(JSObject::{
    properties: @hashmap.new(),
    prototype: None,
  })
  let date_ctor_val = create_date_object(obj_proto)
  let date_ctor = match date_ctor_val {
    Function(f) => f
    _ => abort("Date is not a function")
  }
  let ctx = Context::new()

  // Test Date() -> String
  let date_str = match date_ctor.body {
    Native(n) => n(ctx, JSValue::Undefined, [])
    _ => abort("Date body is not native")
  }
  match date_str {
    String(_) => ()
    _ => abort("Date() should return a string")
  }

  // Test new Date() -> Object
  // We need to simulate 'new' operator which creates object and calls constructor
  // But here we can just call constructor with 'this' as new object (simplified simulation)
  // Actually, create_date_object logic:
  // if is_constructor_call (this is Object) -> sets internal slot

  let new_date_obj_props = @hashmap.new()
  let new_date_obj = JSValue::Object(JSObject::{
    properties: new_date_obj_props,
    prototype: Some(date_ctor.prototype.unwrap()),
  })
  let _ = match date_ctor.body {
    Native(n) => n(ctx, new_date_obj, [])
    _ => abort("Date body is not native")
  }

  // Check internal slot
  match new_date_obj {
    Object(obj) =>
      match obj.properties.get("__internal_date__") {
        Some(Internal(Date(_))) => ()
        _ => abort("new Date() did not set internal date slot")
      }
    _ => abort("new Date() did not return object")
  }
}

///|
test "RegExp Constructor and Test" {
  let obj_proto = JSValue::Object(JSObject::{
    properties: @hashmap.new(),
    prototype: None,
  })
  let regexp_ctor_val = create_regexp_object(obj_proto)
  let regexp_ctor = match regexp_ctor_val {
    Function(f) => f
    _ => abort("RegExp is not a function")
  }
  let ctx = Context::new()

  // Test new RegExp("abc")
  let new_re_obj_props = @hashmap.new()
  let new_re_obj = JSValue::Object(JSObject::{
    properties: new_re_obj_props,
    prototype: Some(regexp_ctor.prototype.unwrap()),
  })
  let _ = match regexp_ctor.body {
    Native(n) => n(ctx, new_re_obj, [JSValue::String("abc")])
    _ => abort("RegExp body is not native")
  }

  // Check internal slot
  match new_re_obj {
    Object(obj) => {
      match obj.properties.get("__internal_regexp__") {
        Some(Internal(RegExp(_, pattern))) =>
          if pattern != "abc" {
            abort("RegExp pattern mismatch")
          }
        _ => abort("new RegExp() did not set internal regexp slot")
      }

      // Test .test() method
      // We need to find 'test' method on prototype
      // regexp_ctor.prototype is the prototype object
      let proto_val = regexp_ctor.prototype.unwrap()
      let test_method = match proto_val {
        Object(p) => p.properties.get("test").unwrap()
        _ => abort("RegExp.prototype is not object")
      }
      let test_fn = match test_method {
        Function(f) => f
        _ => abort("test is not function")
      }

      // Call test("abcdef") -> true
      let res_true = match test_fn.body {
        Native(n) => n(ctx, new_re_obj, [JSValue::String("abcdef")])
        _ => abort("test body not native")
      }
      match res_true {
        Boolean(true) => ()
        _ => abort("test('abcdef') should be true")
      }

      // Call test("xyz") -> false
      let res_false = match test_fn.body {
        Native(n) => n(ctx, new_re_obj, [JSValue::String("xyz")])
        _ => abort("test body not native")
      }
      match res_false {
        Boolean(false) => ()
        _ => abort("test('xyz') should be false")
      }
    }
    _ => abort("new RegExp() did not return object")
  }
}

///|
pub fn create_date_object(object_proto : JSValue) -> JSValue {
  let date_proto_props = @hashmap.new()
  let date_proto = JSValue::Object(JSObject::{
    properties: date_proto_props,
    prototype: Some(object_proto),
  })

  // Date Constructor
  let date_ctor_fn = Native(fn(_ctx, this_val, args) {
    let now_seconds = @env.now().reinterpret_as_int64()
    let zone = @time.utc_zone
    let is_constructor_call = match this_val {
      Object(_obj) => true
      _ => false
    }
    if is_constructor_call {
      let zdt_opt = if args.length() == 0 {
        Some(@time.ZonedDateTime::from_unix_second(now_seconds, zone~)) catch {
          _ => None
        }
      } else {
        let arg = args[0]
        match arg {
          Number(n) =>
            Some(
              @time.ZonedDateTime::from_unix_second(
                (n / 1000.0).to_int64(),
                zone~,
              ),
            ) catch {
              _ => None
            }
          String(_s) =>
            Some(@time.ZonedDateTime::from_unix_second(now_seconds, zone~)) catch {
              _ => None
            }
          _ =>
            Some(@time.ZonedDateTime::from_unix_second(now_seconds, zone~)) catch {
              _ => None
            }
        }
      }
      match this_val {
        Object(obj) => {
          match zdt_opt {
            Some(zdt) =>
              obj.properties.set(
                "__internal_date__",
                JSValue::Internal(JSInternal::Date(zdt)),
              )
            None => ()
          }
          this_val
        }
        _ => JSValue::Undefined
      }
    } else {
      // Function call
      JSValue::String(
        @time.ZonedDateTime::from_unix_second(now_seconds, zone~).to_string(),
      ) catch {
        _ => JSValue::String("Invalid Date")
      }
    }
  })
  let date_ctor = JSFunction::new(
    name="Date",
    body=date_ctor_fn,
    properties=@hashmap.new(),
    prototype=date_proto,
  )
  let date_ctor_val = JSValue::Function(date_ctor)
  date_proto_props.set("constructor", date_ctor_val)

  // Date.now()
  let now_fn = Native(fn(_ctx, _this, _args) {
    JSValue::Number(@env.now().to_double() * 1000.0)
  })
  date_ctor.properties.set(
    "now",
    JSValue::Function(JSFunction::new(name="now", body=now_fn)),
  )

  // Date.prototype.toString()
  let to_string_fn = Native(fn(_ctx, this_val, _args) {
    match this_val {
      Object(obj) =>
        match obj.properties.get("__internal_date__") {
          Some(JSValue::Internal(JSInternal::Date(zdt))) =>
            JSValue::String(zdt.to_string())
          _ => JSValue::String("Invalid Date")
        }
      _ => JSValue::String("Invalid Date")
    }
  })
  date_proto_props.set(
    "toString",
    JSValue::Function(JSFunction::new(name="toString", body=to_string_fn)),
  )

  // Date.prototype.getTime()
  let get_time_fn = Native(fn(_ctx, this_val, _args) {
    match this_val {
      Object(obj) =>
        match obj.properties.get("__internal_date__") {
          Some(JSValue::Internal(JSInternal::Date(zdt))) =>
            JSValue::Number(zdt.to_unix_second().to_double() * 1000.0)
          _ => JSValue::Number(@double.not_a_number)
        }
      _ => JSValue::Number(@double.not_a_number)
    }
  })
  date_proto_props.set(
    "getTime",
    JSValue::Function(JSFunction::new(name="getTime", body=get_time_fn)),
  )
  date_ctor_val
}

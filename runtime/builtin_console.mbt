///|
pub fn create_console_object(object_proto : JSValue) -> JSValue {
  Object({
    properties: {
      "log": Function(
        JSFunction::new(
          name="log",
          body=Native((_ctx, _this_val, args) => {
            println(args.map(_.to_string()).join(", "))
            Undefined
          }),
        ),
      ),
    },
    prototype: Some(object_proto),
  })
}

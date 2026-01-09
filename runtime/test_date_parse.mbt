///|
test "Date.parse" {
  let ctx = Context::create_global()
  let code =
    #| var d = new Date("2021-01-01T00:00:00");
    #| var t = Date.parse("2021-01-01T00:00:00");
    #| "" + d.valueOf() + "," + t
  inspect(ctx.eval(code), content="1609459200000,1609459200000")
}

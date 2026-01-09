///|
test "Error constructor" {
  let ctx = Context::create_global()
  let code =
    #| var e = new Error("msg");
    #| e.toString();
  inspect(ctx.eval(code), content="Error: msg")
}

///|
test "TypeError" {
  let ctx = Context::create_global()
  let code =
    #| var e = new TypeError("bad type");
    #| e.name + ": " + e.message;
  inspect(ctx.eval(code), content="TypeError: bad type")
}

///|
test "Throw Error" {
  let ctx = Context::create_global()
  let code =
    #| try {
    #|   throw new Error("boom");
    #| } catch (e) {
    #|   e.toString();
    #| }
  inspect(ctx.eval(code), content="Error: boom")
}

///|
test "Error instanceof" {
  let ctx = Context::create_global()
  let code =
    #| var e = new TypeError("test");
    #| "" + (e instanceof TypeError) + "," + (e instanceof Error) + "," + (e instanceof Object)
  inspect(ctx.eval(code), content="true,true,true")
}

///|
test "Error without new" {
  let ctx = Context::create_global()
  let code =
    #| var e = Error("msg");
    #| "" + (e instanceof Error) + ":" + e.message
  inspect(ctx.eval(code), content="true:msg")
}

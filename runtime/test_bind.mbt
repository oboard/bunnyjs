///|
test "Function.prototype.bind" {
  let ctx = Context::create_global()
  let code =
    #| function f(a, b) { return this.x + a + b; }
    #| var obj = { x: 1 };
    #| var bound = f.bind(obj, 2);
    #| bound(3);
  inspect(ctx.eval(code), content="6")
}

///|
test "Function.prototype.bind simple" {
  let ctx = Context::create_global()
  let code =
    #| var x = 10;
    #| var module = {
    #|   x: 42,
    #|   getX: function() {
    #|     return this.x;
    #|   }
    #| };
    #| var retrieveX = module.getX;
    #| var boundGetX = retrieveX.bind(module);
    #| boundGetX();
  inspect(ctx.eval(code), content="42")
}

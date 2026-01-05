///|
test "try_catch_basic" {
  let code =
    #| try {
    #|   throw "error";
    #| } catch (e) {
    #|   result = e;
    #| }
  let ctx = Context::create_global()
  ctx.eval(code) |> ignore
  assert_eq(ctx.resolve("result"), JSValue::String("error"))
}

///|
test "try_finally_basic" {
  let code =
    #| result = "initial";
    #| try {
    #|   // nothing
    #| } finally {
    #|   result = "finally";
    #| }
  let ctx = Context::create_global()
  ctx.eval(code) |> ignore
  assert_eq(ctx.resolve("result"), JSValue::String("finally"))
}

///|
test "try_catch_finally" {
  let code =
    #| try {
    #|   throw "error";
    #| } catch (e) {
    #|   caught = e;
    #| } finally {
    #|   finalized = true;
    #| }
  let ctx = Context::create_global()
  ctx.eval(code) |> ignore
  assert_eq(ctx.resolve("caught"), JSValue::String("error"))
  assert_eq(ctx.resolve("finalized"), JSValue::Boolean(true))
}

///|
test "nested_try_catch" {
  let code =
    #| try {
    #|   try {
    #|     throw "inner";
    #|   } catch (e) {
    #|     throw "outer";
    #|   }
    #| } catch (e) {
    #|   result = e;
    #| }
  let ctx = Context::create_global()
  ctx.eval(code) |> ignore
  assert_eq(ctx.resolve("result"), JSValue::String("outer"))
}

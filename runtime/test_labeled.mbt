///|
test "labeled_break_block" {
  let code =
    #| result = "start";
    #| label: {
    #|   result = "inside";
    #|   break label;
    #|   result = "unreachable";
    #| }
  let ctx = Context::create_global()
  ctx.eval(code) |> ignore
  assert_eq(ctx.resolve("result"), JSValue::String("inside"))
}

///|
test "labeled_break_loop" {
  let code =
    #| i = 0;
    #| outer: while (i < 5) {
    #|   j = 0;
    #|   while (j < 5) {
    #|     if (j == 2) break outer;
    #|     j = j + 1;
    #|   }
    #|   i = i + 1;
    #| }
  let ctx = Context::create_global()
  ctx.eval(code) |> ignore
  // i should be 0 because we broke out immediately in first iteration of inner loop
  assert_eq(ctx.resolve("i"), JSValue::Number(0.0))
  // j should be 2
  assert_eq(ctx.resolve("j"), JSValue::Number(2.0))
}

///|
test "labeled_continue_loop" {
  let code =
    #| i = 0;
    #| count = 0;
    #| outer: while (i < 3) {
    #|   i = i + 1;
    #|   j = 0;
    #|   while (j < 3) {
    #|     j = j + 1;
    #|     if (j == 2) continue outer;
    #|     count = count + 1;
    #|   }
    #| }
  let ctx = Context::create_global()
  ctx.eval(code) |> ignore
  // Outer loop runs 3 times.
  // Inner loop runs:
  // j=1 -> count++ (1)
  // j=2 -> continue outer
  // So count increments once per outer iteration.
  // Total count should be 3.
  assert_eq(ctx.resolve("count"), JSValue::Number(3.0))
}

///|
test "labeled_for_loop_continue" {
  let code =
    #| count = 0;
    #| outer: for (var i = 0; i < 3; i++) {
    #|   for (var j = 0; j < 3; j++) {
    #|     if (j == 1) continue outer;
    #|     count++;
    #|   }
    #| }
  let ctx = Context::create_global()
  ctx.eval(code) |> ignore
  // Outer 0:
  //   Inner 0: count++ (1)
  //   Inner 1: continue outer (i becomes 1)
  // Outer 1:
  //   Inner 0: count++ (2)
  //   Inner 1: continue outer (i becomes 2)
  // Outer 2:
  //   Inner 0: count++ (3)
  //   Inner 1: continue outer (i becomes 3, loop terminates)
  // Total count: 3
  assert_eq(ctx.resolve("count"), JSValue::Number(3.0))
}

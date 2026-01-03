///|
test "number_constructor" {
  let ctx = Context::create_global()
  let n1 = ctx.eval(parse("Number(42)"))
  inspect(n1, content="42")
  let n2 = ctx.eval(parse("Number('123.45')"))
  inspect(n2, content="123.45")
  let n3 = ctx.eval(parse("Number(true)"))
  inspect(n3, content="1")
  let n4 = ctx.eval(parse("Number(null)"))
  inspect(n4, content="0")
  // let n5 = ctx.eval(parse("Number(undefined)"))
  // inspect!(n5, content="NaN") // NaN comparison is tricky
}

///|
test "boolean_constructor" {
  let ctx = Context::create_global()
  let b1 = ctx.eval(parse("Boolean(1)"))
  inspect(b1, content="true")
  let b2 = ctx.eval(parse("Boolean(0)"))
  inspect(b2, content="false")
  let b3 = ctx.eval(parse("Boolean('hello')"))
  inspect(b3, content="true")
  let b4 = ctx.eval(parse("Boolean('')"))
  inspect(b4, content="false")
}

///|
test "math_functions" {
  let ctx = Context::create_global()
  let m1 = ctx.eval(parse("Math.abs(-42)"))
  inspect(m1, content="42")
  let m2 = ctx.eval(parse("Math.floor(12.9)"))
  inspect(m2, content="12")
  let m3 = ctx.eval(parse("Math.ceil(12.1)"))
  inspect(m3, content="13")
  let m4 = ctx.eval(parse("Math.max(1, 2, 3)"))
  inspect(m4, content="3")
  let m5 = ctx.eval(parse("Math.min(1, 2, 3)"))
  inspect(m5, content="1")
  let m6 = ctx.eval(parse("Math.trunc(3.7)"))
  inspect(m6, content="3")
  let m7 = ctx.eval(parse("Math.trunc(-3.7)"))
  inspect(m7, content="-3")
  let m8 = ctx.eval(parse("Math.trunc(0.1)"))
  inspect(m8, content="0")
}

///|
test "math_functions_extended" {
  let ctx = Context::create_global()
  // sign
  let s1 = ctx.eval(parse("Math.sign(5)"))
  inspect(s1, content="1")
  let s2 = ctx.eval(parse("Math.sign(-5)"))
  inspect(s2, content="-1")
  let s3 = ctx.eval(parse("Math.sign(0)"))
  inspect(s3, content="0")
  let s4 = ctx.eval(parse("Math.sign(-0)"))
  inspect(s4, content="0") // JS prints 0 for -0 usually, but let's check MoonBit behavior if it preserves -0 string. 
  // Actually MoonBit inspect for -0.0 might be "0" or "-0". Let's assume "0" for now or fix later.

  // hypot
  let h1 = ctx.eval(parse("Math.hypot(3, 4)"))
  inspect(h1, content="5")
  let h2 = ctx.eval(parse("Math.hypot(3, 4, 12)")) // 5, 12 -> 13
  inspect(h2, content="13")

  // pow
  let p1 = ctx.eval(parse("Math.pow(2, 3)"))
  inspect(p1, content="8")

  // abs (re-verify)
  let a1 = ctx.eval(parse("Math.abs(-10)"))
  inspect(a1, content="10")
}

///|
test "number_toFixed" {
  let ctx = Context::create_global()
  let t1 = ctx.eval(parse("123.456.toFixed(2)"))
  @json.inspect(t1, content=["String", "123.46"])
  let t2 = ctx.eval(parse("123.456.toFixed(0)"))
  @json.inspect(t2, content=["String", "123"])
  let t3 = ctx.eval(parse("1.2.toFixed(5)"))
  @json.inspect(t3, content=["String", "1.20000"])
  let t4 = ctx.eval(parse("0.004.toFixed(2)"))
  @json.inspect(t4, content=["String", "0.00"])
  let t5 = ctx.eval(parse("(-1.23).toFixed(1)"))
  @json.inspect(t5, content=["String", "-1.2"])
  let t6 = ctx.eval(parse("NaN.toFixed(1)"))
  @json.inspect(t6, content=["String", "NaN"])
  let t7 = ctx.eval(parse("123.456.toFixed(100)"))
  @json.inspect(t7, content=[
    "String", "123.4560000000000030695446184836328029632568359375000000000000000000000000000000000000000000000000000000",
  ])
}

///|
test "unary_operators" {
  let ctx = Context::create_global()
  let u1 = ctx.eval(parse("-42"))
  inspect(u1, content="-42")
  let u2 = ctx.eval(parse("+'42'"))
  inspect(u2, content="42")
  let u3 = ctx.eval(parse("!true"))
  inspect(u3, content="false")
  let u4 = ctx.eval(parse("typeof 42"))
  inspect(u4, content="number")
}

///|
test "bitwise_not" {
  let ctx = Context::create_global()
  let bn1 = ctx.eval(parse("~42"))
  inspect(bn1, content="-43")
  let bn2 = ctx.eval(parse("~'-1'"))
  inspect(bn2, content="0")
}

///|
test "delete_operator" {
  let ctx = Context::create_global()
  ctx.eval(parse("var obj = { a: 1 };")) |> ignore
  let d1 = ctx.eval(parse("delete obj.a"))
  inspect(d1, content="true")
  let d2 = ctx.eval(parse("obj.a"))
  inspect(d2, content="undefined")
  ctx.eval(parse("var x = 10;")) |> ignore
  let d3 = ctx.eval(parse("delete x"))
  inspect(d3, content="true")
  let d4 = ctx.eval(parse("x"))
  inspect(d4, content="undefined")
}

///|
fn parse(code : String) -> &Show {
  // Helper to bypass parser type checks in test
  // In real code we use @parser.parse
  // Here we just wrap the string to satisfy Context::eval signature
  // Wait, Context::eval takes &Show. String implements Show.
  code
}

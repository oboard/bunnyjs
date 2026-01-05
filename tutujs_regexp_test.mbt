///|
test "regexp constructor" {
  let ctx = @tutujs.Context::create_global()

  // Test new RegExp(pattern)
  let _ = ctx.eval("new RegExp('abc')")
  @json.inspect(ctx.eval("typeof re"), content=["String", "undefined"]) // 're' is not defined in eval context, just testing invocation
  @json.inspect(ctx.eval("new RegExp('abc') instanceof RegExp"), content=[
    "Boolean", true,
  ])
  @json.inspect(ctx.eval("typeof new RegExp('abc')"), content=[
    "String", "object",
  ])
}

///|
test "regexp test method" {
  let ctx = @tutujs.Context::create_global()

  // Simple match
  @json.inspect(ctx.eval("new RegExp('abc').test('abcdef')"), content=[
    "Boolean", true,
  ])

  // No match
  @json.inspect(ctx.eval("new RegExp('abc').test('xyz')"), content=[
    "Boolean", false,
  ])

  // Case sensitivity (default is sensitive)
  @json.inspect(ctx.eval("new RegExp('abc').test('ABC')"), content=[
    "Boolean", false,
  ])
}

///|
test "regexp exec method" {
  let ctx = @tutujs.Context::create_global()

  // exec match
  let res = ctx.eval("new RegExp('abc').exec('abcdef')")
  // Should return an object (array) with match details
  // For now, just checking it's an object and not null
  @json.inspect(
    match res {
      Object(_) => true
      _ => false
    },
    content=true,
  )

  // exec no match
  let res_null = ctx.eval("new RegExp('abc').exec('xyz')")
  @json.inspect(res_null, content="Null")
}

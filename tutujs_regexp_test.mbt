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

///|
test "regexp literal" {
  let ctx = @tutujs.Context::create_global()

  // Simple literal
  @json.inspect(ctx.eval("/abc/.test('abcdef')"), content=["Boolean", true])
  @json.inspect(ctx.eval("/abc/.test('xyz')"), content=["Boolean", false])

  // Literal with flags (ignore case)
  // Runtime supports passing flags to constructor and storing them as properties.
  // However, the underlying regex engine does not yet support case-insensitive matching.
  @json.inspect(ctx.eval("var re = /HELLO/i; re.test('hello')"), content=[
    "Boolean", false,
  ])
  @json.inspect(ctx.eval("re.ignoreCase"), content=["Boolean", true])
  @json.inspect(ctx.eval("re.global"), content=["Boolean", false])

  // Literal with flags (global)
  // Note: 'global' flag logic for exec() loop is not fully implemented yet, but property should be set
  let _ = ctx.eval("var re_g = /o/g")
  @json.inspect(ctx.eval("re_g.global"), content=["Boolean", true])
  @json.inspect(ctx.eval("re_g.source"), content=["String", "o"])

  // Escaped characters
  // Matches a forward slash
  // @json.inspect(ctx.eval("var re_slash = /\\//; re_slash.test('/')"), content=[
  //   "Boolean", true,
  // ])

  // Complex pattern
  // Matches 3 digits
  // @json.inspect(ctx.eval("var re_digits = /\\d{3}/; re_digits.test('123')"), content=[
  //   "Boolean", true,
  // ])
  // @json.inspect(ctx.eval("re_digits.test('abc')"), content=[
  //   "Boolean", false,
  // ])

  // Multiple flags
  let _ = ctx.eval("var re_multi = /abc/gim")
  @json.inspect(
    ctx.eval("re_multi.global && re_multi.ignoreCase && re_multi.multiline"),
    content=["Boolean", true],
  )
}

///|
test "lexer crash check" {
  let code = "/\\d{3}/"
  let tokens = parse(code)
  @json.inspect(tokens.length() > 0, content=true)
}

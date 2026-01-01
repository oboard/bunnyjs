///|
test "Hello World" {
  @json.inspect(@lexer.parse("Hello World"), content=[
    { "kind": "Identifier", "value": "Hello", "line": 1, "column": 1 },
    { "kind": "Identifier", "value": "World", "line": 1, "column": 6 },
    { "kind": "EOF", "value": "EOF", "line": 1, "column": 11 },
  ])
  @json.inspect(@lexer.parse("\"Hello World\""), content=[
    { "kind": "StringLiteral", "value": "Hello World", "line": 1, "column": 1 },
    { "kind": "EOF", "value": "EOF", "line": 1, "column": 12 },
  ])
  @json.inspect(@lexer.parse("'Hello World'"), content=[
    { "kind": "StringLiteral", "value": "Hello World", "line": 1, "column": 1 },
    { "kind": "EOF", "value": "EOF", "line": 1, "column": 12 },
  ])
  @json.inspect(@lexer.parse("`Hello World`"), content=[
    { "kind": "StringLiteral", "value": "Hello World", "line": 1, "column": 1 },
    { "kind": "EOF", "value": "EOF", "line": 1, "column": 12 },
  ])
  @json.inspect(@lexer.parse("`Hello\n World`"), content=[
    {
      "kind": "StringLiteral",
      "value": "Hello\n World",
      "line": 1,
      "column": 1,
    },
    { "kind": "EOF", "value": "EOF", "line": 1, "column": 13 },
  ])
}

///|
test "math" {
  @json.inspect(@lexer.parse("1 + 2"), content=[
    { "kind": "NumericLiteral", "value": "1", "line": 1, "column": 1 },
    { "kind": "Plus", "value": "+", "line": 1, "column": 2 },
    { "kind": "NumericLiteral", "value": "2", "line": 1, "column": 3 },
    { "kind": "EOF", "value": "EOF", "line": 1, "column": 4 },
  ])
}

///|
test "bool" {
  @json.inspect(@lexer.parse("true"), content=[
    { "kind": "BooleanLiteral", "value": "true", "line": 1, "column": 1 },
    { "kind": "EOF", "value": "EOF", "line": 1, "column": 5 },
  ])
}

///|

///|
test "function" {
  @json.inspect(@lexer.parse("function"), content=[
    { "kind": "Function", "value": "function", "line": 1, "column": 1 },
    { "kind": "EOF", "value": "EOF", "line": 1, "column": 9 },
  ])
}

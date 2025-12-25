///|
test "parse_string_literal" {
  let input = "let s = \"hello\";"
  @json.inspect(parse(input), content={
    "node_type": "Program",
    "body": [
      {
        "node_type": "VariableDeclaration",
        "loc": {
          "start": { "line": 1, "column": 1 },
          "end": { "line": 1, "column": 17 },
        },
        "body": [],
        "declarations": [
          {
            "node_type": "VariableDeclarator",
            "body": [],
            "declarations": [],
            "id": {
              "node_type": "Identifier",
              "loc": {
                "start": { "line": 1, "column": 5 },
                "end": { "line": 1, "column": 6 },
              },
              "body": [],
              "declarations": [],
              "params": [],
              "name": "s",
              "properties": [],
              "elements": [],
            },
            "init": {
              "node_type": "Literal",
              "loc": {
                "start": { "line": 1, "column": 9 },
                "end": { "line": 1, "column": 16 },
              },
              "body": [],
              "declarations": [],
              "params": [],
              "value": "hello",
              "raw": "\"hello\"",
              "properties": [],
              "elements": [],
            },
            "params": [],
            "properties": [],
            "elements": [],
          },
        ],
        "kind": "Let",
        "params": [],
        "properties": [],
        "elements": [],
      },
    ],
    "declarations": [],
    "params": [],
    "properties": [],
    "elements": [],
  })
}

///|
test "parse_single_quote_string" {
  let input = "let s = 'world';"
  @json.inspect(parse(input), content={
    "node_type": "Program",
    "body": [
      {
        "node_type": "VariableDeclaration",
        "loc": {
          "start": { "line": 1, "column": 1 },
          "end": { "line": 1, "column": 17 },
        },
        "body": [],
        "declarations": [
          {
            "node_type": "VariableDeclarator",
            "body": [],
            "declarations": [],
            "id": {
              "node_type": "Identifier",
              "loc": {
                "start": { "line": 1, "column": 5 },
                "end": { "line": 1, "column": 6 },
              },
              "body": [],
              "declarations": [],
              "params": [],
              "name": "s",
              "properties": [],
              "elements": [],
            },
            "init": {
              "node_type": "Literal",
              "loc": {
                "start": { "line": 1, "column": 9 },
                "end": { "line": 1, "column": 16 },
              },
              "body": [],
              "declarations": [],
              "params": [],
              "value": "world",
              "raw": "\"world\"",
              "properties": [],
              "elements": [],
            },
            "params": [],
            "properties": [],
            "elements": [],
          },
        ],
        "kind": "Let",
        "params": [],
        "properties": [],
        "elements": [],
      },
    ],
    "declarations": [],
    "params": [],
    "properties": [],
    "elements": [],
  })
}

///|
test "parse_member_expression" {
  let input = "console.log('hello');"
  @json.inspect(parse(input), content={
    "node_type": "Program",
    "body": [
      {
        "node_type": "ExpressionStatement",
        "loc": {
          "start": { "line": 1, "column": 1 },
          "end": { "line": 1, "column": 22 },
        },
        "body": [],
        "argument": {
          "node_type": "CallExpression",
          "body": [],
          "declarations": [],
          "params": [
            {
              "node_type": "Literal",
              "loc": {
                "start": { "line": 1, "column": 13 },
                "end": { "line": 1, "column": 20 },
              },
              "body": [],
              "declarations": [],
              "params": [],
              "value": "hello",
              "raw": "\"hello\"",
              "properties": [],
              "elements": [],
            },
          ],
          "callee": {
            "node_type": "MemberExpression",
            "body": [],
            "left": {
              "node_type": "Identifier",
              "loc": {
                "start": { "line": 1, "column": 1 },
                "end": { "line": 1, "column": 8 },
              },
              "body": [],
              "declarations": [],
              "params": [],
              "name": "console",
              "properties": [],
              "elements": [],
            },
            "right": {
              "node_type": "Identifier",
              "loc": {
                "start": { "line": 1, "column": 9 },
                "end": { "line": 1, "column": 12 },
              },
              "body": [],
              "declarations": [],
              "params": [],
              "name": "log",
              "properties": [],
              "elements": [],
            },
            "declarations": [],
            "params": [],
            "properties": [],
            "elements": [],
          },
          "properties": [],
          "elements": [],
        },
        "declarations": [],
        "params": [],
        "properties": [],
        "elements": [],
      },
    ],
    "declarations": [],
    "params": [],
    "properties": [],
    "elements": [],
  })
}

///|
test "tokenize and parse" {
  let code = "1 + 3 - 8"
  @json.inspect(code |> @lexer.parse |> @parser.parse, content={
    "sourceType": "Module",
    "body": [
      [
        "ExpressionStatement",
        {
          "expression": [
            "BinaryExpression",
            {
              "operator": "Minus",
              "left": [
                "BinaryExpression",
                {
                  "operator": "Plus",
                  "left": ["NumericLiteral", { "value": 1 }],
                  "right": ["NumericLiteral", { "value": 3 }],
                },
              ],
              "right": ["NumericLiteral", { "value": 8 }],
            },
          ],
        },
      ],
    ],
    "directives": [],
  })
}

///|
test "parse equality" {
  let code = "1 == 1"
  @json.inspect(code |> @lexer.parse |> @parser.parse, content={
    "sourceType": "Module",
    "body": [
      [
        "ExpressionStatement",
        {
          "expression": [
            "BinaryExpression",
            {
              "operator": "Equal",
              "left": ["NumericLiteral", { "value": 1 }],
              "right": ["NumericLiteral", { "value": 1 }],
            },
          ],
        },
      ],
    ],
    "directives": [],
  })
}

///|
test "parse strict equality" {
  let code = "1 === 1"
  @json.inspect(code |> @lexer.parse |> @parser.parse, content={
    "sourceType": "Module",
    "body": [
      [
        "ExpressionStatement",
        {
          "expression": [
            "BinaryExpression",
            {
              "operator": "StrictEqual",
              "left": ["NumericLiteral", { "value": 1 }],
              "right": ["NumericLiteral", { "value": 1 }],
            },
          ],
        },
      ],
    ],
    "directives": [],
  })
}

///|
test "tokenize and parse" {
  @json.inspect("1 * 3 + 8" |> @lexer.parse |> @parser.parse, content={
    "sourceType": "Module",
    "body": [
      [
        "ExpressionStatement",
        {
          "expression": [
            "BinaryExpression",
            {
              "operator": "Plus",
              "left": [
                "BinaryExpression",
                {
                  "operator": "Star",
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
  @json.inspect("1 / 3 * 8 - 8" |> @lexer.parse |> @parser.parse, content={
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
                  "operator": "Star",
                  "left": [
                    "BinaryExpression",
                    {
                      "operator": "Slash",
                      "left": ["NumericLiteral", { "value": 1 }],
                      "right": ["NumericLiteral", { "value": 3 }],
                    },
                  ],
                  "right": ["NumericLiteral", { "value": 8 }],
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
  @json.inspect("(1 === 1) == true" |> @lexer.parse |> @parser.parse, content={
    "sourceType": "Module",
    "body": [
      [
        "ExpressionStatement",
        {
          "expression": [
            "BinaryExpression",
            {
              "operator": "Equal",
              "left": [
                "BinaryExpression",
                {
                  "operator": "StrictEqual",
                  "left": ["NumericLiteral", { "value": 1 }],
                  "right": ["NumericLiteral", { "value": 1 }],
                },
              ],
              "right": ["BooleanLiteral", { "value": true }],
            },
          ],
        },
      ],
    ],
    "directives": [],
  })
}

///|
test "parser arithmetic" {
  let context = @bunnyjs.Context::new()
  @json.inspect(context.eval("1+1"), content={
    "sourceType": "Module",
    "body": [
      [
        "ExpressionStatement",
        {
          "expression": [
            "BinaryExpression",
            {
              "operator": "Plus",
              "left": ["NumericLiteral", { "value": 1 }],
              "right": ["NumericLiteral", { "value": 2 }],
            },
          ],
        },
      ],
    ],
    "directives": [],
  })
}

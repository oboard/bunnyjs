///|
test {
  @json.inspect(@parser.parse("console.log('Hello World')"), content={
    "node_type": "Program",
    "body": [
      {
        "node_type": "ExpressionStatement",
        "loc": {
          "start": { "line": 1, "column": 1 },
          "end": { "line": 1, "column": 27 },
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
                "end": { "line": 1, "column": 26 },
              },
              "body": [],
              "declarations": [],
              "params": [],
              "value": "Hello World",
              "raw": "\"Hello World\"",
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

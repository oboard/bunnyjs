///|
using @value {type JSValue}

///|
pub struct Context {
  global_scope : Map[String, @value.JSValue]
}

///|
pub fn Context::new() -> Context {
  { global_scope: Map::new() }
}

///|
pub fn Context::eval(self : Context, code : String) -> @value.JSValue {
  let ast = code |> @lexer.parse |> @parser.parse
  println(ast)
  self.evaluate(ast)
}

///|
fn Context::evaluate(self : Context, node : @parser.Program) -> @value.JSValue {
  match node.body {
    ...
  }
}

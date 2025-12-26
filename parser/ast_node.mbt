///|
pub enum ASTNode {
  Program(Program)
  Statement(Statement)
  Expression(Expression)
} derive(Show, Eq, ToJson, FromJson)

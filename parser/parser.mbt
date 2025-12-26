///|
using @tokens {type TokenKind}

///|
using @lexer {type LexToken}

///|
pub(all) struct Parser {
  tokens : Array[LexToken]
  mut pos : Int
}

///|
pub fn Parser::new(tokens : Array[LexToken]) -> Parser {
  { tokens, pos: 0 }
}

///|
pub fn parse(tokens : Array[LexToken]) -> Program {
  Parser::new(tokens).parse_program()
}

///|
pub fn Parser::parse(self : Parser) -> Program {
  self.parse_program()
}

///|
pub fn Parser::parse_program(self : Parser) -> Program {
  let body = []
  while self.peek().kind != TokenKind::EOF {
    let expr = self.parse_expression()
    body.push(
      Statement::ExpressionStatement({ expression: expr, directive: None }),
    )
  }
  { sourceType: Module, body, directives: [], interpreter: None }
}

///|
fn Parser::peek(self : Parser) -> LexToken {
  if self.pos < self.tokens.length() {
    self.tokens[self.pos]
  } else {
    self.tokens[self.tokens.length() - 1] // EOF
  }
}

///|
fn Parser::advance(self : Parser) -> Unit {
  if self.pos < self.tokens.length() {
    self.pos = self.pos + 1
  }
}

///|
fn Parser::consume(self : Parser, kind : TokenKind) -> Unit {
  if self.peek().kind == kind {
    self.advance()
  }
}

///|
fn Parser::parse_expression(self : Parser) -> Expression {
  self.parse_additive()
}

///|
fn Parser::parse_additive(self : Parser) -> Expression {
  let mut left = self.parse_multiplicative()
  while self.peek().kind == TokenKind::Plus ||
        self.peek().kind == TokenKind::Minus {
    let op_token = self.peek()
    self.advance()
    let right = self.parse_multiplicative()
    let operator = match op_token.kind {
      Plus => BinaryOperator::Plus
      Minus => BinaryOperator::Minus
      _ => BinaryOperator::Plus // Should not happen
    }
    left = Expression::BinaryExpression({ operator, left, right })
  }
  left
}

///|
fn Parser::parse_multiplicative(self : Parser) -> Expression {
  let mut left = self.parse_primary()
  while self.peek().kind == TokenKind::Star ||
        self.peek().kind == TokenKind::Slash {
    let op_token = self.peek()
    self.advance()
    let right = self.parse_primary()
    let operator = match op_token.kind {
      Star => BinaryOperator::Star
      Slash => BinaryOperator::Slash
      _ => BinaryOperator::Star // Should not happen
    }
    left = Expression::BinaryExpression({ operator, left, right })
  }
  left
}

///|
fn Parser::parse_primary(self : Parser) -> Expression {
  let token = self.peek()
  match token.kind {
    TokenKind::NumericLiteral => {
      self.advance()
      let val = @strconv.parse_double(token.value) catch { _ => 0.0 }
      Expression::NumericLiteral({ value: val })
    }
    TokenKind::LParen => {
      self.advance()
      let expr = self.parse_expression()
      self.consume(TokenKind::RParen)
      expr
    }
    _ => {
      self.advance()
      Expression::NumericLiteral({ value: 0.0 }) // Error handling placeholder
    }
  }
}

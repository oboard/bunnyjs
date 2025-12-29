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
  self.parse_equality()
}

///|
fn Parser::parse_equality(self : Parser) -> Expression {
  let mut left = self.parse_relational()
  while self.peek().kind == TokenKind::EqEq ||
        self.peek().kind == TokenKind::NotEq ||
        self.peek().kind == TokenKind::EqEqEq ||
        self.peek().kind == TokenKind::NotEqEq {
    let op_token = self.peek()
    self.advance()
    let right = self.parse_relational()
    let operator = match op_token.kind {
      TokenKind::EqEq => BinaryOperator::Equal
      TokenKind::NotEq => BinaryOperator::NotEqual
      TokenKind::EqEqEq => BinaryOperator::StrictEqual
      TokenKind::NotEqEq => BinaryOperator::StrictNotEqual
      _ => BinaryOperator::Equal // Should not happen
    }
    left = Expression::BinaryExpression({ operator, left, right })
  }
  left
}

///|
fn Parser::parse_relational(self : Parser) -> Expression {
  let mut left = self.parse_shift()
  while self.peek().kind == TokenKind::Lt ||
        self.peek().kind == TokenKind::Le ||
        self.peek().kind == TokenKind::Gt ||
        self.peek().kind == TokenKind::Ge ||
        self.peek().kind == TokenKind::In ||
        self.peek().kind == TokenKind::Instanceof {
    let op_token = self.peek()
    self.advance()
    let right = self.parse_shift()
    let operator = match op_token.kind {
      TokenKind::Lt => BinaryOperator::LessThan
      TokenKind::Le => BinaryOperator::LessThanOrEqual
      TokenKind::Gt => BinaryOperator::GreaterThan
      TokenKind::Ge => BinaryOperator::GreaterThanOrEqual
      TokenKind::In => BinaryOperator::In
      TokenKind::Instanceof => BinaryOperator::Instanceof
      _ => BinaryOperator::LessThan // Should not happen
    }
    left = Expression::BinaryExpression({ operator, left, right })
  }
  left
}

///|
fn Parser::parse_shift(self : Parser) -> Expression {
  let mut left = self.parse_additive()
  while self.peek().kind == TokenKind::LShift ||
        self.peek().kind == TokenKind::RShift ||
        self.peek().kind == TokenKind::URShift {
    let op_token = self.peek()
    self.advance()
    let right = self.parse_additive()
    let operator = match op_token.kind {
      TokenKind::LShift => BinaryOperator::LeftShift
      TokenKind::RShift => BinaryOperator::RightShift
      TokenKind::URShift => BinaryOperator::UnsignedRightShift
      _ => BinaryOperator::LeftShift // Should not happen
    }
    left = Expression::BinaryExpression({ operator, left, right })
  }
  left
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
      TokenKind::Plus => BinaryOperator::Plus
      TokenKind::Minus => BinaryOperator::Minus
      _ => BinaryOperator::Plus // Should not happen
    }
    left = Expression::BinaryExpression({ operator, left, right })
  }
  left
}

///|
fn Parser::parse_multiplicative(self : Parser) -> Expression {
  let mut left = self.parse_bitwise_and()
  while self.peek().kind == TokenKind::Star ||
        self.peek().kind == TokenKind::Slash ||
        self.peek().kind == TokenKind::Percent {
    let op_token = self.peek()
    self.advance()
    let right = self.parse_bitwise_and()
    let operator = match op_token.kind {
      TokenKind::Star => BinaryOperator::Star
      TokenKind::Slash => BinaryOperator::Slash
      TokenKind::Percent => BinaryOperator::Percent
      _ => BinaryOperator::Star // Should not happen
    }
    left = Expression::BinaryExpression({ operator, left, right })
  }
  left
}

///|
fn Parser::parse_bitwise_and(self : Parser) -> Expression {
  let mut left = self.parse_bitwise_xor()
  while self.peek().kind == TokenKind::BitAnd {
    // let op_token = self.peek()
    self.advance()
    let right = self.parse_bitwise_xor()
    let operator = BinaryOperator::BitwiseAnd
    left = Expression::BinaryExpression({ operator, left, right })
  }
  left
}

///|
fn Parser::parse_bitwise_xor(self : Parser) -> Expression {
  let mut left = self.parse_bitwise_or()
  while self.peek().kind == TokenKind::BitXor {
    // let op_token = self.peek()
    self.advance()
    let right = self.parse_bitwise_or()
    let operator = BinaryOperator::BitwiseXor
    left = Expression::BinaryExpression({ operator, left, right })
  }
  left
}

///|
fn Parser::parse_bitwise_or(self : Parser) -> Expression {
  let mut left = self.parse_unary()
  while self.peek().kind == TokenKind::BitOr {
    // let op_token = self.peek()
    self.advance()
    let right = self.parse_unary()
    let operator = BinaryOperator::BitwiseOr
    left = Expression::BinaryExpression({ operator, left, right })
  }
  left
}

///|
fn Parser::parse_unary(self : Parser) -> Expression {
  if self.peek().kind == TokenKind::Minus ||
    self.peek().kind == TokenKind::Plus ||
    self.peek().kind == TokenKind::BitNot ||
    self.peek().kind == TokenKind::Not {
    let op_token = self.peek()
    self.advance()
    let argument = self.parse_unary()
    let operator = match op_token.kind {
      TokenKind::Minus => UnaryOperator::Minus
      TokenKind::Plus => UnaryOperator::Plus
      TokenKind::BitNot => UnaryOperator::BitwiseNot
      TokenKind::Not => UnaryOperator::Not
      _ => UnaryOperator::Minus // Should not happen
    }
    Expression::UnaryExpression({ operator, prefix: true, argument })
  } else {
    self.parse_postfix()
  }
}

///|
fn Parser::parse_postfix(self : Parser) -> Expression {
  self.parse_primary()
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
    TokenKind::StringLiteral => {
      self.advance()
      Expression::StringLiteral({ value: token.value })
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

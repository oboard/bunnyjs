///|
fn is_regex_start(lexer : Lexer) -> Bool {
  match lexer.tokens.last() {
    None => true
    Some(token) =>
      match token.kind {
        @tokens.TokenKind::Identifier
        | @tokens.TokenKind::NumericLiteral
        | @tokens.TokenKind::StringLiteral
        | @tokens.TokenKind::BooleanLiteral
        | @tokens.TokenKind::NullLiteral
        | @tokens.TokenKind::RegularExpressionLiteral
        | @tokens.TokenKind::TemplateLiteral
        | @tokens.TokenKind::RParen
        | @tokens.TokenKind::RBrace
        | @tokens.TokenKind::RBracket
        | @tokens.TokenKind::This
        | @tokens.TokenKind::PlusPlus
        | @tokens.TokenKind::MinusMinus => false
        _ => true
      }
  }
}

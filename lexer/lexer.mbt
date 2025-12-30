///|
pub(all) struct LexToken {
  kind : @tokens.TokenKind
  value : StringView
  line : Int
  column : Int
} derive(Show, ToJson, Eq)

///|
pub(all) struct Lexer {
  input : String
  mut position : Int
  mut line : Int
  mut line_start : Int
  mut tokens : Array[LexToken]
}

///|
pub fn Lexer::new(input : String) -> Lexer {
  { input, position: 0, line: 1, line_start: 0, tokens: [] }
}

///|
fn Lexer::add_token(
  self : Lexer,
  kind : @tokens.TokenKind,
  value : StringView,
) -> Unit {
  let column = self.position - self.line_start + 1
  self.position += value.length()
  self.tokens.push({ kind, value, line: self.line, column })
}

///|
fn Lexer::tokenize(self : Lexer) -> Array[LexToken] {
  let input = self.input
  lex_tokens(input, self)
  self.tokens
}

///|
fn lex_tokens(input : StringView, lexer : Lexer) -> Unit {
  lexmatch input with longest {
    ("`" ("([^`\\\\]|\\\\.)*" as raw) "`", rest) => {
      lexer.add_token(@tokens.TokenKind::StringLiteral, raw)
      lex_tokens(rest, lexer)
    }

    // Whitespace
    ("[ \t\r]+", rest) => lex_tokens(rest, lexer)

    // Newlines
    ("\n", rest) => {
      lexer.line += 1
      lexer.line_start = lexer.position + 1
      lex_tokens(rest, lexer)
    }

    // Comments
    ("//[^\r\n]*", rest) => lex_tokens(rest, lexer)
    ("/\*[^*]*\*+([^/*][^*]*\*+)*/", rest) => lex_tokens(rest, lexer)

    // Boolean literals
    ("true|false" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::BooleanLiteral, raw)
      lex_tokens(rest, lexer)
    }

    // String literals
    ("\"" ("([^\\x22\\\\]|\\\\.)*" as raw) "\"", rest) => {
      lexer.add_token(@tokens.TokenKind::StringLiteral, raw)
      lex_tokens(rest, lexer)
    }
    ("'" ("([^'\\\\]|\\\\.)*" as raw) "'", rest) => {
      lexer.add_token(@tokens.TokenKind::StringLiteral, raw)
      lex_tokens(rest, lexer)
    }

    // Numeric literals
    ("0x[0-9a-fA-F](_|[0-9a-fA-F])*" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::NumericLiteral, raw)
      lex_tokens(rest, lexer)
    }
    ("0X[0-9a-fA-F](_|[0-9a-fA-F])*" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::NumericLiteral, raw)
      lex_tokens(rest, lexer)
    }
    ("0o[0-7](_|[0-7])*" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::NumericLiteral, raw)
      lex_tokens(rest, lexer)
    }
    ("0O[0-7](_|[0-7])*" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::NumericLiteral, raw)
      lex_tokens(rest, lexer)
    }
    ("0b[01](_|[01])*" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::NumericLiteral, raw)
      lex_tokens(rest, lexer)
    }
    ("0B[01](_|[01])*" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::NumericLiteral, raw)
      lex_tokens(rest, lexer)
    }
    // Decimal with dot, no exponent
    ("[0-9](_|[0-9])*\\.[0-9](_|[0-9])*" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::NumericLiteral, raw)
      lex_tokens(rest, lexer)
    }
    // Decimal with dot and exponent signed +
    ("[0-9](_|[0-9])*\\.[0-9](_|[0-9])*[eE]\\+[0-9](_|[0-9])*" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::NumericLiteral, raw)
      lex_tokens(rest, lexer)
    }
    // Decimal with dot and exponent signed -
    ("[0-9](_|[0-9])*\\.[0-9](_|[0-9])*[eE]-[0-9](_|[0-9])*" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::NumericLiteral, raw)
      lex_tokens(rest, lexer)
    }
    // Decimal with dot and exponent unsigned
    ("[0-9](_|[0-9])*\\.[0-9](_|[0-9])*[eE][0-9](_|[0-9])*" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::NumericLiteral, raw)
      lex_tokens(rest, lexer)
    }
    // Decimal without dot, with exponent signed +
    ("[0-9](_|[0-9])*[eE]\\+[0-9](_|[0-9])*" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::NumericLiteral, raw)
      lex_tokens(rest, lexer)
    }
    // Decimal without dot, with exponent signed -
    ("[0-9](_|[0-9])*[eE]-[0-9](_|[0-9])*" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::NumericLiteral, raw)
      lex_tokens(rest, lexer)
    }
    // Decimal without dot, with exponent unsigned
    ("[0-9](_|[0-9])*[eE][0-9](_|[0-9])*" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::NumericLiteral, raw)
      lex_tokens(rest, lexer)
    }
    // Dot starting, no exponent
    ("\\.[0-9](_|[0-9])*" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::NumericLiteral, raw)
      lex_tokens(rest, lexer)
    }
    // Dot starting, with exponent signed +
    ("\\.[0-9](_|[0-9])*[eE]\\+[0-9](_|[0-9])*" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::NumericLiteral, raw)
      lex_tokens(rest, lexer)
    }
    // Dot starting, with exponent signed -
    ("\\.[0-9](_|[0-9])*[eE]-[0-9](_|[0-9])*" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::NumericLiteral, raw)
      lex_tokens(rest, lexer)
    }
    // Dot starting, with exponent unsigned
    ("\\.[0-9](_|[0-9])*[eE][0-9](_|[0-9])*" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::NumericLiteral, raw)
      lex_tokens(rest, lexer)
    }
    // Plain integer
    ("[0-9](_|[0-9])*" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::NumericLiteral, raw)
      lex_tokens(rest, lexer)
    }

    // Identifiers
    ("[a-zA-Z_$][a-zA-Z0-9_$]*" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::Identifier, raw)
      lex_tokens(rest, lexer)
    }

    // EOF
    ("", _) => lexer.add_token(@tokens.TokenKind::EOF, "")
    ("[0-9]+" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::NumericLiteral, raw)
      lex_tokens(rest, lexer)
    }
    ("0[xX][0-9a-fA-F]+" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::NumericLiteral, raw)
      lex_tokens(rest, lexer)
    }
    ("0[oO][0-7]+" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::NumericLiteral, raw)
      lex_tokens(rest, lexer)
    }
    ("0[bB][01]+" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::NumericLiteral, raw)
      lex_tokens(rest, lexer)
    }

    // Keywords
    ("break", rest) => {
      lexer.add_token(@tokens.TokenKind::Break, "break")
      lex_tokens(rest, lexer)
    }
    ("case", rest) => {
      lexer.add_token(@tokens.TokenKind::Case, "case")
      lex_tokens(rest, lexer)
    }
    ("catch", rest) => {
      lexer.add_token(@tokens.TokenKind::Catch, "catch")
      lex_tokens(rest, lexer)
    }
    ("class", rest) => {
      lexer.add_token(@tokens.TokenKind::Class, "class")
      lex_tokens(rest, lexer)
    }
    ("const", rest) => {
      lexer.add_token(@tokens.TokenKind::Const, "const")
      lex_tokens(rest, lexer)
    }
    ("continue", rest) => {
      lexer.add_token(@tokens.TokenKind::Continue, "continue")
      lex_tokens(rest, lexer)
    }
    ("debugger", rest) => {
      lexer.add_token(@tokens.TokenKind::Debugger, "debugger")
      lex_tokens(rest, lexer)
    }
    ("default", rest) => {
      lexer.add_token(@tokens.TokenKind::Default, "default")
      lex_tokens(rest, lexer)
    }
    ("delete", rest) => {
      lexer.add_token(@tokens.TokenKind::Delete, "delete")
      lex_tokens(rest, lexer)
    }
    ("do", rest) => {
      lexer.add_token(@tokens.TokenKind::Do, "do")
      lex_tokens(rest, lexer)
    }
    ("else", rest) => {
      lexer.add_token(@tokens.TokenKind::Else, "else")
      lex_tokens(rest, lexer)
    }
    ("export", rest) => {
      lexer.add_token(@tokens.TokenKind::Export, "export")
      lex_tokens(rest, lexer)
    }
    ("extends", rest) => {
      lexer.add_token(@tokens.TokenKind::Extends, "extends")
      lex_tokens(rest, lexer)
    }
    ("finally", rest) => {
      lexer.add_token(@tokens.TokenKind::Finally, "finally")
      lex_tokens(rest, lexer)
    }
    ("for", rest) => {
      lexer.add_token(@tokens.TokenKind::For, "for")
      lex_tokens(rest, lexer)
    }
    ("function", rest) => {
      lexer.add_token(@tokens.TokenKind::Function, "function")
      lex_tokens(rest, lexer)
    }
    ("if", rest) => {
      lexer.add_token(@tokens.TokenKind::If, "if")
      lex_tokens(rest, lexer)
    }
    ("import", rest) => {
      lexer.add_token(@tokens.TokenKind::Import, "import")
      lex_tokens(rest, lexer)
    }
    ("in", rest) => {
      lexer.add_token(@tokens.TokenKind::In, "in")
      lex_tokens(rest, lexer)
    }
    ("instanceof", rest) => {
      lexer.add_token(@tokens.TokenKind::Instanceof, "instanceof")
      lex_tokens(rest, lexer)
    }
    ("new", rest) => {
      lexer.add_token(@tokens.TokenKind::New, "new")
      lex_tokens(rest, lexer)
    }
    ("return", rest) => {
      lexer.add_token(@tokens.TokenKind::Return, "return")
      lex_tokens(rest, lexer)
    }
    ("super", rest) => {
      lexer.add_token(@tokens.TokenKind::Super, "super")
      lex_tokens(rest, lexer)
    }
    ("switch", rest) => {
      lexer.add_token(@tokens.TokenKind::Switch, "switch")
      lex_tokens(rest, lexer)
    }
    ("this", rest) => {
      lexer.add_token(@tokens.TokenKind::This, "this")
      lex_tokens(rest, lexer)
    }
    ("throw", rest) => {
      lexer.add_token(@tokens.TokenKind::Throw, "throw")
      lex_tokens(rest, lexer)
    }
    ("try", rest) => {
      lexer.add_token(@tokens.TokenKind::Try, "try")
      lex_tokens(rest, lexer)
    }
    ("typeof", rest) => {
      lexer.add_token(@tokens.TokenKind::Typeof, "typeof")
      lex_tokens(rest, lexer)
    }
    ("var", rest) => {
      lexer.add_token(@tokens.TokenKind::Var, "var")
      lex_tokens(rest, lexer)
    }
    ("void", rest) => {
      lexer.add_token(@tokens.TokenKind::Void, "void")
      lex_tokens(rest, lexer)
    }
    ("while", rest) => {
      lexer.add_token(@tokens.TokenKind::While, "while")
      lex_tokens(rest, lexer)
    }
    ("with", rest) => {
      lexer.add_token(@tokens.TokenKind::With, "with")
      lex_tokens(rest, lexer)
    }
    ("yield", rest) => {
      lexer.add_token(@tokens.TokenKind::Yield, "yield")
      lex_tokens(rest, lexer)
    }
    ("enum", rest) => {
      lexer.add_token(@tokens.TokenKind::Enum, "enum")
      lex_tokens(rest, lexer)
    }
    ("implements", rest) => {
      lexer.add_token(@tokens.TokenKind::Implements, "implements")
      lex_tokens(rest, lexer)
    }
    ("interface", rest) => {
      lexer.add_token(@tokens.TokenKind::Interface, "interface")
      lex_tokens(rest, lexer)
    }
    ("let", rest) => {
      lexer.add_token(@tokens.TokenKind::Let, "let")
      lex_tokens(rest, lexer)
    }
    ("package", rest) => {
      lexer.add_token(@tokens.TokenKind::Package, "package")
      lex_tokens(rest, lexer)
    }
    ("private", rest) => {
      lexer.add_token(@tokens.TokenKind::Private, "private")
      lex_tokens(rest, lexer)
    }
    ("protected", rest) => {
      lexer.add_token(@tokens.TokenKind::Protected, "protected")
      lex_tokens(rest, lexer)
    }
    ("public", rest) => {
      lexer.add_token(@tokens.TokenKind::Public, "public")
      lex_tokens(rest, lexer)
    }
    ("static", rest) => {
      lexer.add_token(@tokens.TokenKind::Static, "static")
      lex_tokens(rest, lexer)
    }
    ("await", rest) => {
      lexer.add_token(@tokens.TokenKind::Await, "await")
      lex_tokens(rest, lexer)
    }
    ("async", rest) => {
      lexer.add_token(@tokens.TokenKind::Async, "async")
      lex_tokens(rest, lexer)
    }

    // Identifiers
    ("[a-zA-Z_$][a-zA-Z0-9_$]*" as raw, rest) => {
      lexer.add_token(@tokens.TokenKind::Identifier, raw)
      lex_tokens(rest, lexer)
    }

    // Operators
    ("\\.\\.\\.", rest) => {
      lexer.add_token(@tokens.TokenKind::Ellipsis, "...")
      lex_tokens(rest, lexer)
    }
    ("===", rest) => {
      lexer.add_token(@tokens.TokenKind::EqEqEq, "===")
      lex_tokens(rest, lexer)
    }
    ("!==", rest) => {
      lexer.add_token(@tokens.TokenKind::NotEqEq, "!==")
      lex_tokens(rest, lexer)
    }
    (">>>", rest) => {
      lexer.add_token(@tokens.TokenKind::URShift, ">>>")
      lex_tokens(rest, lexer)
    }
    (">>>=", rest) => {
      lexer.add_token(@tokens.TokenKind::URShiftEq, ">>>=")
      lex_tokens(rest, lexer)
    }
    ("<<=", rest) => {
      lexer.add_token(@tokens.TokenKind::LShiftEq, "<<=")
      lex_tokens(rest, lexer)
    }
    (">>=", rest) => {
      lexer.add_token(@tokens.TokenKind::RShiftEq, ">>=")
      lex_tokens(rest, lexer)
    }
    ("\\*\\*=", rest) => {
      lexer.add_token(@tokens.TokenKind::StarStarEqual, "**=")
      lex_tokens(rest, lexer)
    }
    ("\\*\\*", rest) => {
      lexer.add_token(@tokens.TokenKind::StarStar, "**")
      lex_tokens(rest, lexer)
    }
    (">>", rest) => {
      lexer.add_token(@tokens.TokenKind::RShift, ">>")
      lex_tokens(rest, lexer)
    }
    ("<<", rest) => {
      lexer.add_token(@tokens.TokenKind::LShift, "<<")
      lex_tokens(rest, lexer)
    }
    ("==", rest) => {
      lexer.add_token(@tokens.TokenKind::EqEq, "==")
      lex_tokens(rest, lexer)
    }
    ("!=", rest) => {
      lexer.add_token(@tokens.TokenKind::NotEq, "!=")
      lex_tokens(rest, lexer)
    }
    ("<=", rest) => {
      lexer.add_token(@tokens.TokenKind::Le, "<=")
      lex_tokens(rest, lexer)
    }
    (">=", rest) => {
      lexer.add_token(@tokens.TokenKind::Ge, ">=")
      lex_tokens(rest, lexer)
    }
    ("&&", rest) => {
      lexer.add_token(@tokens.TokenKind::And, "&&")
      lex_tokens(rest, lexer)
    }
    ("\\|\\|", rest) => {
      lexer.add_token(@tokens.TokenKind::Or, "||")
      lex_tokens(rest, lexer)
    }
    ("\\?\\?", rest) => {
      lexer.add_token(@tokens.TokenKind::QuestionQuestion, "??")
      lex_tokens(rest, lexer)
    }
    ("\\+\\+", rest) => {
      lexer.add_token(@tokens.TokenKind::PlusPlus, "++")
      lex_tokens(rest, lexer)
    }
    ("--", rest) => {
      lexer.add_token(@tokens.TokenKind::MinusMinus, "--")
      lex_tokens(rest, lexer)
    }
    ("=>", rest) => {
      lexer.add_token(@tokens.TokenKind::Arrow, "=>")
      lex_tokens(rest, lexer)
    }
    ("\\+=", rest) => {
      lexer.add_token(@tokens.TokenKind::PlusEq, "+=")
      lex_tokens(rest, lexer)
    }
    ("-=", rest) => {
      lexer.add_token(@tokens.TokenKind::MinusEq, "-=")
      lex_tokens(rest, lexer)
    }
    ("\*=", rest) => {
      lexer.add_token(@tokens.TokenKind::StarEq, "*=")
      lex_tokens(rest, lexer)
    }
    ("/=", rest) => {
      lexer.add_token(@tokens.TokenKind::SlashEq, "/=")
      lex_tokens(rest, lexer)
    }
    ("%=", rest) => {
      lexer.add_token(@tokens.TokenKind::PercentEq, "%=")
      lex_tokens(rest, lexer)
    }
    ("&=", rest) => {
      lexer.add_token(@tokens.TokenKind::BitAndEq, "&=")
      lex_tokens(rest, lexer)
    }
    ("\|=", rest) => {
      lexer.add_token(@tokens.TokenKind::BitOrEq, "|=")
      lex_tokens(rest, lexer)
    }
    ("\^=", rest) => {
      lexer.add_token(@tokens.TokenKind::BitXorEq, "^=")
      lex_tokens(rest, lexer)
    }

    // Single character operators
    ("[{]", rest) => {
      lexer.add_token(@tokens.TokenKind::LBrace, "{")
      lex_tokens(rest, lexer)
    }
    ("[}]", rest) => {
      lexer.add_token(@tokens.TokenKind::RBrace, "}")
      lex_tokens(rest, lexer)
    }
    ("\(", rest) => {
      lexer.add_token(@tokens.TokenKind::LParen, "(")
      lex_tokens(rest, lexer)
    }
    ("\)", rest) => {
      lexer.add_token(@tokens.TokenKind::RParen, ")")
      lex_tokens(rest, lexer)
    }
    ("\[", rest) => {
      lexer.add_token(@tokens.TokenKind::LBracket, "[")
      lex_tokens(rest, lexer)
    }
    ("\]", rest) => {
      lexer.add_token(@tokens.TokenKind::RBracket, "]")
      lex_tokens(rest, lexer)
    }
    ("\.", rest) => {
      lexer.add_token(@tokens.TokenKind::Dot, ".")
      lex_tokens(rest, lexer)
    }
    (";", rest) => {
      lexer.add_token(@tokens.TokenKind::Semi, ";")
      lex_tokens(rest, lexer)
    }
    (",", rest) => {
      lexer.add_token(@tokens.TokenKind::Comma, ",")
      lex_tokens(rest, lexer)
    }
    ("\?", rest) => {
      lexer.add_token(@tokens.TokenKind::Question, "?")
      lex_tokens(rest, lexer)
    }
    (":", rest) => {
      lexer.add_token(@tokens.TokenKind::Colon, ":")
      lex_tokens(rest, lexer)
    }
    ("=", rest) => {
      lexer.add_token(@tokens.TokenKind::Eq, "=")
      lex_tokens(rest, lexer)
    }
    ("\+", rest) => {
      lexer.add_token(@tokens.TokenKind::Plus, "+")
      lex_tokens(rest, lexer)
    }
    ("-", rest) => {
      lexer.add_token(@tokens.TokenKind::Minus, "-")
      lex_tokens(rest, lexer)
    }
    ("\*", rest) => {
      lexer.add_token(@tokens.TokenKind::Star, "*")
      lex_tokens(rest, lexer)
    }
    ("/", rest) => {
      lexer.add_token(@tokens.TokenKind::Slash, "/")
      lex_tokens(rest, lexer)
    }
    ("%", rest) => {
      lexer.add_token(@tokens.TokenKind::Percent, "%")
      lex_tokens(rest, lexer)
    }
    ("&", rest) => {
      lexer.add_token(@tokens.TokenKind::BitAnd, "&")
      lex_tokens(rest, lexer)
    }
    ("\|", rest) => {
      lexer.add_token(@tokens.TokenKind::BitOr, "|")
      lex_tokens(rest, lexer)
    }
    ("\^", rest) => {
      lexer.add_token(@tokens.TokenKind::BitXor, "^")
      lex_tokens(rest, lexer)
    }
    ("!", rest) => {
      lexer.add_token(@tokens.TokenKind::Not, "!")
      lex_tokens(rest, lexer)
    }
    ("~", rest) => {
      lexer.add_token(@tokens.TokenKind::BitNot, "~")
      lex_tokens(rest, lexer)
    }
    ("<", rest) => {
      lexer.add_token(@tokens.TokenKind::Lt, "<")
      lex_tokens(rest, lexer)
    }
    (">", rest) => {
      lexer.add_token(@tokens.TokenKind::Gt, ">")
      lex_tokens(rest, lexer)
    }

    // EOF
    ("$", _) => lexer.add_token(@tokens.TokenKind::EOF, "EOF")

    // Error case
    ("." as c, rest) => {
      lexer.add_token(@tokens.TokenKind::Illegal, c.to_string())
      lex_tokens(rest, lexer)
    }
    _ => panic()
  }
}

///|
pub fn parse(code : String) -> Array[LexToken] {
  let lexer = Lexer::new(code)
  lexer.tokenize()
}

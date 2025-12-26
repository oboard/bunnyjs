///|
pub(all) enum TokenKind {
  // Literals
  NumericLiteral
  StringLiteral
  BooleanLiteral
  NullLiteral
  RegExpLiteral

  // Identifiers
  Identifier

  // Keywords
  Break
  Case
  Catch
  Class
  Const
  Continue
  Debugger
  Default
  Delete
  Do
  Else
  Export
  Extends
  Finally
  For
  Function
  If
  Import
  In
  Instanceof
  New
  Return
  Super
  Switch
  This
  Throw
  Try
  Typeof
  Var
  Void
  While
  With
  Yield
  Enum
  Implements
  Interface
  Let
  Package
  Private
  Protected
  Public
  Static
  Await
  Async

  // Punctuators
  LBrace // {
  RBrace // }
  LParen // (
  RParen // )
  LBracket // [
  RBracket // ]
  Dot // .
  Ellipsis // ...
  Semi // ;
  Comma // ,
  Question // ?
  Colon // :
  Arrow // =>

  // Operators
  Eq // =
  Plus // +
  Minus // -
  Star // *
  Slash // /
  Percent // %
  StarStar // **
  PlusPlus // ++
  MinusMinus // --
  LShift // <<
  RShift // >>
  URShift // >>>
  BitAnd // &
  BitOr // |
  BitXor // ^
  Not // !
  BitNot // ~
  And // &&
  Or // ||
  QuestionQuestion // ??

  // Comparison
  EqEq // ==
  NotEq // !=
  EqEqEq // ===
  NotEqEq // !==
  Lt // <
  Le // <=
  Gt // >
  Ge // >=

  // Assignment
  PlusEq // +=
  MinusEq // -=
  StarEq // *=
  SlashEq // /=
  PercentEq // %=
  StarStarEq // **=
  LShiftEq // <<=
  RShiftEq // >>=
  URShiftEq // >>>=
  BitAndEq // &=
  BitOrEq // |=
  BitXorEq // ^=

  // Other
  EOF
  Illegal
} derive(Show, Eq)

///|
pub fn TokenKind::to_string(self : TokenKind) -> String {
  match self {
    NumericLiteral => "NumericLiteral"
    StringLiteral => "StringLiteral"
    BooleanLiteral => "BooleanLiteral"
    NullLiteral => "NullLiteral"
    RegExpLiteral => "RegExpLiteral"
    Identifier => "Identifier"
    Break => "break"
    Case => "case"
    Catch => "catch"
    Class => "class"
    Const => "const"
    Continue => "continue"
    Debugger => "debugger"
    Default => "default"
    Delete => "delete"
    Do => "do"
    Else => "else"
    Export => "export"
    Extends => "extends"
    Finally => "finally"
    For => "for"
    Function => "function"
    If => "if"
    Import => "import"
    In => "in"
    Instanceof => "instanceof"
    New => "new"
    Return => "return"
    Super => "super"
    Switch => "switch"
    This => "this"
    Throw => "throw"
    Try => "try"
    Typeof => "typeof"
    Var => "var"
    Void => "void"
    While => "while"
    With => "with"
    Yield => "yield"
    Enum => "enum"
    Implements => "implements"
    Interface => "interface"
    Let => "let"
    Package => "package"
    Private => "private"
    Protected => "protected"
    Public => "public"
    Static => "static"
    Await => "await"
    Async => "async"
    LBrace => "{"
    RBrace => "}"
    LParen => "("
    RParen => ")"
    LBracket => "["
    RBracket => "]"
    Dot => "."
    Ellipsis => "..."
    Semi => ";"
    Comma => ","
    Question => "?"
    Colon => ":"
    Arrow => "=>"
    Eq => "="
    Plus => "+"
    Minus => "-"
    Star => "*"
    Slash => "/"
    Percent => "%"
    StarStar => "**"
    PlusPlus => "++"
    MinusMinus => "--"
    LShift => "<<"
    RShift => ">>"
    URShift => ">>>"
    BitAnd => "&"
    BitOr => "|"
    BitXor => "^"
    Not => "!"
    BitNot => "~"
    And => "&&"
    Or => "||"
    QuestionQuestion => "??"
    EqEq => "=="
    NotEq => "!="
    EqEqEq => "==="
    NotEqEq => "!=="
    Lt => "<"
    Le => "<="
    Gt => ">"
    Ge => ">="
    PlusEq => "+="
    MinusEq => "-="
    StarEq => "*="
    SlashEq => "/="
    PercentEq => "%="
    StarStarEq => "**="
    LShiftEq => "<<="
    RShiftEq => ">>="
    URShiftEq => ">>>="
    BitAndEq => "&="
    BitOrEq => "|="
    BitXorEq => "^="
    EOF => "EOF"
    Illegal => "Illegal"
  }
}

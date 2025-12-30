///|
pub(all) enum JSValue {
  String(StringView)
  Number(Double)
  Boolean(Bool)
  BigInt(Int64)
  Symbol(String)
  Function(JSFunction)
  Object(JSObject)
  Null
  Undefined
} derive(Eq, ToJson, Compare, FromJson, Hash)

///|
pub impl Show for JSValue with output(self, logger) {
  match self {
    String(s) => logger.write_view(s)
    Number(n) => n.output(logger)
    Boolean(b) => b.output(logger)
    BigInt(i) => i.output(logger)
    Symbol(s) => logger.write_string("Symbol(" + s + ")")
    Function(f) => logger.write_string("Function: " + f.name)
    Object(_) => logger.write_string("[object Object]")
    Null => logger.write_string("null")
    Undefined => logger.write_string("undefined")
  }
}

///|
pub(all) struct JSFunction {
  name : String
  params : Array[String]
  body : @parser.ASTNode
} derive(Show, Eq, ToJson, FromJson)

///|
pub(all) struct JSObject {
  properties : Map[String, JSValue]
  prototype : JSValue? // Optional prototype? Or just JSValue
} derive(Show, Eq, ToJson, FromJson)

///|
pub impl Compare for JSObject with compare(_, _) -> Int {
  0
}

///|
pub impl Hash for JSObject with hash_combine(self, hasher) -> Unit {
  self.properties.each((k, v) => {
    hasher.combine(k)
    hasher.combine(v)
  })
}

///|
pub impl Compare for JSFunction with compare(_, _) -> Int {
  0
}

///|
pub impl Hash for JSFunction with hash_combine(self, hasher) -> Unit {
  hasher.combine(self.name)
  hasher.combine(self.body.to_json().stringify())
}

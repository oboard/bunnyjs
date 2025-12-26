///|
pub(all) enum JSValue {
  String(String)
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
  logger.write_string(
    match self {
      String(s) => s
      Number(n) => n.to_string()
      Boolean(b) => b.to_string()
      BigInt(i) => i.to_string()
      Symbol(s) => "Symbol(" + s + ")"
      Function(f) => "Function: " + f.name
      Object(_) => "[object Object]"
      Null => "null"
      Undefined => "undefined"
    },
  )
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

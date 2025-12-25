///|
pub(all) enum JSValue {
  String(String)
  Number(Double)
  Boolean(Bool)
  BigInt(BigInt)
  Symbol(JSValue)
  Function(JSFunction)
  Object(JSObject)
  Null
  Undefined
} derive(Show, ToJson, FromJson, Hash, Eq, Compare)

///|
pub(all) struct JSObject {
  mut properties : Map[String, JSValue]
  mut prototype : JSValue
  class_name : String
  mut extensible : Bool
} derive(Show, ToJson, FromJson, Eq)

///|
pub fn JSObject::new(class_name : String, prototype : JSValue) -> JSObject {
  { properties: Map::new(), prototype, class_name, extensible: true }
}

///|
pub struct JSFunction {
  name : String
  params : Array[String]
  body : String
} derive(Show, Eq, ToJson, Compare, FromJson, Hash)

///|
pub fn JSFunction::new(
  name : String,
  params : Array[String],
  body : String,
) -> JSFunction {
  { name, params, body }
}

///|
pub impl Hash for JSObject with hash(self) -> Int {
  self.class_name.hash()
}

///|
pub impl Hash for JSObject with hash_combine(self, hash) -> Unit {
  self.class_name.hash_combine(hash)
}

///|
pub impl Compare for JSObject with compare(_, _) -> Int {
  0
}

///|
pub(all) struct Context {
  scope : Map[String, JSValue]
  parent : Context?
} derive(Eq, ToJson, FromJson, Show)

///|
#as_free_fn(new)
pub fn Context::new(parent? : Context) -> Context {
  let scope = match parent {
    None =>
      {
        "NaN": Number(@double.not_a_number),
        "Infinity": Number(@double.infinity),
      }
    Some(_) => {}
  }
  { scope, parent }
}

///|
pub impl Compare for Context with compare(_, _) -> Int {
  0
}

///|
pub impl Hash for Context with hash_combine(self, hasher) -> Unit {
  hasher.combine(self.scope.length())
}

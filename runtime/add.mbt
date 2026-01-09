///|
pub impl Add for JSValue with add(self, other) -> JSValue {
  match (self, other) {
    (String(s1), _) => JSValue::String("\{s1}\{other.to_string()}")
    (_, String(s2)) => JSValue::String("\{self.to_string()}\{s2}")
    _ => {
      let n1 = self.to_number()
      let n2 = other.to_number()
      JSValue::Number(n1 + n2)
    }
  }
}

///|
pub impl Add for JSValue with add(self, other) -> JSValue {
  fn add_coercion(value : JSValue) -> JSValue {
    if value is Boolean(bool) {
      Number(if bool { 1.0 } else { 0.0 })
    } else {
      value
    }
  }

  let self = add_coercion(self)
  let other = add_coercion(other)
  if self == Number(@double.not_a_number) ||
    other == Number(@double.not_a_number) {
    Number(@double.not_a_number)
  } else {
    match (self, other) {
      (String(a), String(b)) => String(a + b)
      (Number(a), Number(b)) => Number(a + b)
      (String(a), Number(b)) => String("\{a}\{b}")
      (Number(a), String(b)) => String("\{a}\{b}")
      (_, _) => Number(@double.not_a_number)
    }
  }
}

///|
fn parse_regex_token(value : StringView) -> (String, Array[RegExpFlag]) {
  let s = value.to_string()
  let chars = s.to_array()
  let len = chars.length()
  let mut last_slash = -1
  for i = len - 1; i >= 0; i = i - 1 {
    if chars[i] == '/' {
      last_slash = i
      break
    }
  }
  if last_slash <= 0 {
    ("", [])
  } else {
    try {
      let pattern_view = s[1:last_slash]
      let flags_view = s[last_slash + 1:]
      let pattern = pattern_view.to_string()
      let flags = []
      for char in flags_view {
        match char {
          'g' => flags.push(RegExpFlag::G)
          'i' => flags.push(RegExpFlag::I)
          'm' => flags.push(RegExpFlag::M)
          's' => flags.push(RegExpFlag::S)
          'u' => flags.push(RegExpFlag::U)
          'y' => flags.push(RegExpFlag::Y)
          'v' => flags.push(RegExpFlag::V)
          _ => ()
        }
      }
      (pattern, flags)
    } catch {
      _ => ("", [])
    }
  }
}

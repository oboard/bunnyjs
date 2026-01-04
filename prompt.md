完成这三个 builtin @/runtime/ 

date 可以调用 @/time/ 这个库
regexp 就用///|
test {
  // Compile once, use everywhere
  let regexp = @regexp.compile("a(bc|de)f")
  guard regexp.match_("xxabcf") is Some(result)
  inspect(
    result.results(),
    content=(
      #|[Some("abcf"), Some("bc")]
    ),
  )

  // Write a simple split with regexp
  fn split(regexp : @regexp.Regexp, target : StringView) -> Array[StringView] {
    let result = []
    loop target {
      "" => ()
      str => {
        let res = regexp.execute(str)
        result.push(res.before())
        continue res.after()
      }
    }
    result
  }

  let re = @regexp.compile("_+")
  inspect(
    split(re, "1_2__3__4__5_____6"),
    content=(
      #|["1", "2", "3", "4", "5", "6"]
    ),
  )
}

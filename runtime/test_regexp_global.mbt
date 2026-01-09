///|
test "RegExp global lastIndex" {
  let ctx = Context::create_global()
  let code =
    #| var re = /a/g;
    #| var res1 = re.exec("aba");
    #| var idx1 = re.lastIndex;
    #| var res2 = re.exec("aba");
    #| var idx2 = re.lastIndex;
    #| "" + res1[0] + "@" + res1.index + " -> " + idx1 + " | " + res2[0] + "@" + res2.index + " -> " + idx2
  inspect(ctx.eval(code), content="a@0 -> 1 | a@2 -> 3")
}

///|
test "RegExp global test" {
  let ctx = Context::create_global()
  let code =
    #| var re = /a/g;
    #| var b1 = re.test("aba"); // true, lastIndex=1
    #| var b2 = re.test("aba"); // true, lastIndex=3
    #| var b3 = re.test("aba"); // false, lastIndex=0
    #| "" + b1 + "," + b2 + "," + b3
  inspect(ctx.eval(code), content="true,true,false")
}

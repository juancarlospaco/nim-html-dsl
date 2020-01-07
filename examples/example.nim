import html_dsl

when isMainModule:
  html page:
    head:
      title "Title"
      meta(name="foo", href="bar")
      link(href="href")
    body:
      p(text="Hello")
      p(text="World")
      `<!--`("wtf lol")
      a(text="WTF", src="a")
      divs:
        p("Example")

  echo render(page())

import html_dsl

const page = html:
  heads:
    title "Title"
    meta(name="foo", content="bar")
  bodys:
    p "Powered by Nim Metaprogramming"
    `<!--` "HTML Comment"
    a(text="Nim", href="https://nim-lang.org")
    divs:
      p "Example"

assert page is string
echo page

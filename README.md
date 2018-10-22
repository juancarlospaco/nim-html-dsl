# Nim-HTML-DSL

- [Nim](https://nim-lang.org) HTML DSL, [Domain Specific Language](https://en.wikipedia.org/wiki/Domain-specific_language) for HTML embedded on Nim lang code (Not a template engine).

![HTML DSL](https://raw.githubusercontent.com/juancarlospaco/nim-html-dsl/master/temp.png "HTML for Cats")


# Use

```nim
import html_dsl

html page:
  head:
    title("title")
  body:
    p("hello")
    p("world")
    dv:
      p "Example"

echo transpile(page())
```


# Design

- [Bulma CSS ready](https://bulma.io), [Spectre CSS ready](https://picturepan2.github.io/spectre/getting-started.html).
- HTML5, UTF-8, Responsive, all Tags supported.
- 255 Levels of indentation maximum.
- Minified when build for Release, else Pretty-Printed.
- No XHTML, dont be Valid XML but be HTML5.
- HTML Comments supported.
- Functional Programming, all functions are `func`.

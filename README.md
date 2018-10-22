# Nim-HTML-DSL

- [Nim](https://nim-lang.org) HTML DSL, [Domain Specific Language](https://en.wikipedia.org/wiki/Domain-specific_language) for HTML embedded on Nim lang code (Not a template engine).

![HTML DSL](https://raw.githubusercontent.com/juancarlospaco/nim-html-dsl/master/temp.png "HTML for Cats")


# Use

```nim
import html_dsl

html page:
  head:
    title("Title")
  body:
    p("Hello")
    p("World")
    dv:
      p "Example"

echo transpile(page())
```

<details>
  <summary>Click to see Output</summary>

Build for Development:

```html
<!DOCTYPE html>
  <html class='has-navbar-fixed-top' >
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Title</title>
  </head>
  <body class='has-navbar-fixed-top' >
    <p >Hello</p>
    <p >World</p>
    <div>
      <p>Example</p>
    </div>
  </body>
</html>
<!-- Nim 0.19.0 -->

```

Build for Release:

```html
<!DOCTYPE html><html class='has-navbar-fixed-top'><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Title</title></head><body class='has-navbar-fixed-top'><p>Hello</p><p>World</p><div><p>Example</p></div></body></html>
```

</details>


# Design

- [Bulma CSS ready](https://bulma.io), [Spectre CSS ready](https://picturepan2.github.io/spectre/getting-started.html).
- HTML5, UTF-8, Responsive, all Tags supported.
- 255 Levels of indentation maximum.
- Minified when build for Release, else Pretty-Printed.
- No XHTML, dont be Valid XML but be HTML5.
- HTML Comments supported.
- Functional Programming, all functions are `func`.

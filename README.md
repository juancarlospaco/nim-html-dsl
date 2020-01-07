# Nim-HTML-DSL

- [Nim](https://nim-lang.org) HTML DSL, [Domain Specific Language](https://en.wikipedia.org/wiki/Domain-specific_language) for HTML embedded on Nim lang code (Not a template engine).

![HTML DSL](https://raw.githubusercontent.com/juancarlospaco/nim-html-dsl/master/temp.png "HTML for Cats")


# Use

```nim
import html_dsl

const page = html:
  heads:
    title "Title"
    meta(name="foo", href="bar")
    link(href="href")
  bodys:
    p(text="Hello")
    p(text="World")
    `<!--`("wtf lol")
    a(text="WTF", src="a")
    divs:
      p("Example")
```

- `page` is `string`, can be assigned to `const` or `let`.

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

```

Build for Release:

```html
<!DOCTYPE html><html class='has-navbar-fixed-top'><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Title</title></head><body class='has-navbar-fixed-top'><p>Hello</p><p>World</p><div><p>Example</p></div></body></html>
```

</details>


# Design

- [Bulma CSS ready](https://bulma.io), [Spectre CSS ready](https://picturepan2.github.io/spectre/getting-started.html).
- HTML5, UTF-8, Responsive, all Tags supported.
- Minified when build for Release, Pretty-Printed when build for Development.
- [Functional Programming](https://en.wikipedia.org/wiki/Functional_programming), no side effects, all functions are `func`.
- 255 Levels of indentation maximum.
- HTML Comments are `<!--`.
- `<div>` is named `divs`, `<body>` is named `bodys`, `<head>` is named `heads`, to avoid possible name shadowing with other libs.


# FAQ

- Whats the Performance cost of using this?.

0. Zero. None. Everything is done at Compile-Time.

- Can be used with Jester?.

Yes.

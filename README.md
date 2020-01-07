# Nim-HTML-DSL

- [Nim](https://nim-lang.org) HTML DSL, [Domain Specific Language](https://en.wikipedia.org/wiki/Domain-specific_language) for HTML embedded on Nim lang code (Not a template engine).

![HTML DSL](https://raw.githubusercontent.com/juancarlospaco/nim-html-dsl/master/temp.png "HTML for Cats")


# Use

```nim
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
```

<details>
  <summary>Click to see Output</summary>

Build for Development:

```html
<!DOCTYPE html>
<html class='has-navbar-fixed-top'>
  <head>
    <meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"> <meta name="foo" content="bar" >
    <title>Title</title>
  </head>
  <body class='has-navbar-fixed-top'>
    <p > Powered by Nim Metaprogramming</p>

    <!--  HTML Comment  -->

    <a href="https://nim-lang.org" > Nim</a>
    <div >
      <p > Example</p>
      <p > Example</p>
    </div>
  </body>
</html>

```

Build for Release:

```html
<!DOCTYPE html><html class='has-navbar-fixed-top'><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="foo" content="bar" ><title>Title</title></head><body class='has-navbar-fixed-top'><p>Powered by Nim Metaprogramming</p><a href="https://nim-lang.org" >Nim</a><div><p>Example</p><p>Example</p></div></body></html>
```

</details>


# Design

- `42` Kilobytes *Hello World* file size, as fast as `const`, 1 file, ~300 Lines of Code.
- Works for JavaScript and NodeJS and NimScript.
- [Bulma CSS ready](https://bulma.io), [Spectre CSS ready](https://picturepan2.github.io/spectre/getting-started.html).
- Minified when build for Release, Pretty-Printed when build for Development.
- [Functional Programming](https://en.wikipedia.org/wiki/Functional_programming), no side-effects, all functions are `func`.
- `<div>` is named `divs`, `<body>` is named `bodys`, `<head>` is named `heads`, to avoid eventual name shadowing with other libs.
- HTML5, UTF-8, Responsive, all Tags supported, all Attributes supported.


# FAQ

- Whats the Performance cost of using this?.

0. Zero. None. Everything is done at Compile-Time.

- Can be used with Jester?.

Yes.

import unittest
import strutils

import html_dsl

func htmlhash(page: string): string =
  ## Removes whitespace, for equality checking
  ## Dumb? Genius? Someone cleverer than me could use `xmltree`
  page.replace(" ", "").replace("\n", "")

test "full example":
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

  const output = """
  <!DOCTYPE html>
  <html class='has-navbar-fixed-top'>
    <head>
      <meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
      <meta name="foo" content="bar" >
      <title>Title</title>
    </head>
    <body class='has-navbar-fixed-top'>
      <p >Powered by Nim Metaprogramming</p>
      <!--  HTML Comment  -->
      <a href="https://nim-lang.org" >Nim</a>
      <div >
        <p >Example</p>
      </div>
    </body>
  </html>
  """

  check page.htmlhash == output.htmlhash

test "divs":
  const page = html:
    heads:
      title "Title"
      meta(name="foo", content="bar")
    bodys:
      p "example"

  check page.count("example") == 1


test "title":
  const page = html:
    heads:
      title "Title"
    bodys:
      p "example"

  const pageAndMeta = html:
    heads:
      title "Title"
      meta(name="foo", content="bar")
    bodys:
      p "example"

  check page.count("Title") == 1
  check pageAndMeta.count("Title") == 1

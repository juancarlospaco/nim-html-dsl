## HTML-DSL
## ========
##
## - Nim HTML DSL, Domain Specific Language for HTML embedded on Nim lang code *(Not a template engine)*.
##
## .. image:: https://raw.githubusercontent.com/juancarlospaco/nim-html-dsl/master/temp.png
import macros except body
include tipos

const canHaveChildren = [
  nkAddress, nkArea, nkArticle, nkAside, nkAudio, nkB, nkBase, nkBdi, nkBdo,
  nkBig, nkBlockquote, nkButton, nkCanvas, nkCaption, nkCenter, nkCol,
  nkColgroup, nkData, nkDatalist, nkDd, nkDel, nkDetails, nkDfn, nkDialog,
  nkDiv, nkDl, nkDt, nkEm, nkEmbed, nkFieldset, nkFigure, nkFigcaption,
  nkFooter, nkForm, nkH1, nkH2, nkH3, nkH4, nkH5, nkH6, nkHeader, nkI, nkImg,
  nkIns, nkKbd, nkKeygen, nkLabel, nkLegend, nkLi, nkMain, nkMap, nkMark,
  nkMarquee, nkNav, nkObject, nkOl, nkOptgroup, nkOption, nkOutput, nkParam,
  nkPicture, nkPre, nkQ, nkRb, nkRp, nkRt, nkRtc, nkRuby, nkS, nkSamp,
  nkSection, nkSelect, nkSmall, nkSource, nkSpan, nkStrong, nkSub, nkSummary,
  nkSup, nkTable, nkTbody, nkTd, nkTemplate, nkTfoot, nkTh, nkThead, nkTr,
  nkTrack, nkTt, nkU, nkUl]  ## All Tags that can possibly have childrens.

var conta: int









func p*(x: varargs[string, `$`]): HtmlNode =
  result = HtmlNode(kind: nkP, text: (@x).join(" "))


func newDiv*(children: varargs[HtmlNode]): HtmlNode =
  result = HtmlNode(kind: nkDiv, children: @children)

macro dv*(inner: untyped): HtmlNode =
  assert inner.len >= 1, "Div Error: Wrong number of inner elements:" & $inner.len
  result = newCall("newDiv")
  if inner.len == 1:
    result.add(inner)
  inner.copyChildrenTo(result)

func newa*(href, val: string, rel="", id="", class=""): HtmlNode =
  result = HtmlNode(kind: nkA, href: href, text: val)
  result.id = id
  result.class = class
  result.rel = rel






func link*(href: string, hreflang="", crossorigin="", integrity="", media="", referrerpolicy="", sizes=""): HtmlNode =
  ## Create a new ``<link>`` tag Node with attributes. No children.
  HtmlNode(kind: nkLink, href: href, crossorigin: crossorigin, integrity: integrity,
           media: media, referrerpolicy: referrerpolicy, sizes: sizes, hreflang: hreflang)

proc meta*(name, content: string, httpequiv=""): HtmlNode =
  ## Create a new ``<meta>`` tag Node with name,content,httpequiv. No children.
  echo conta
  result = HtmlNode(kind: nkMeta, name: name, content: content, httpequiv: httpequiv)





func newHead*(title: HtmlNode, meta: varargs[HtmlNode], link: varargs[HtmlNode]): HtmlNode =
  ## Create a new ``<head>`` tag Node with meta, link and title tag nodes.
  HtmlNode(kind: nkHead, title: title, meta: @meta, link: @link)

macro head*(inner: untyped): HtmlNode =
  ## Macro to call ``newHead()`` with the childrens.
  assert inner.len >= 1, "Head Error: Wrong number of inner tags:" & $inner.len
  result = newCall("newHead")
  if inner.len == 1: result.add(inner)
  inner.copyChildrenTo(result)

func title*(titulo: string): HtmlNode =
  ## Create a new ``<title>`` tag Node with text string, title is Capitalized.
  HtmlNode(kind: nkTitle, text: titulo.strip.capitalizeAscii) # Only title arg

func newBody*(children: varargs[HtmlNode]): HtmlNode =
  ## Create a new ``<body>`` tag Node, containing all children tags.
  HtmlNode(kind: nkBody, children: @children) # Body have childrens.

macro body*(inner: untyped): HtmlNode =
  ## Macro to call ``newBody()`` with the childrens, if any.
  assert inner.len >= 1, "Body Error: Wrong number of inner tags:" & $inner.len
  result = newCall("newBody") # Result is a call to newBody()
  if inner.len == 1: result.add(inner) # if just 1 children just pass it as arg
  inner.copyChildrenTo(result) # if several children copy them all, AST level.

proc newHtml*(head, body: HtmlNode): HtmlNode =
  ## Create a new ``<html>`` tag Node, containing a ``<head>`` and ``<body>``.
  HtmlNode(kind: nkHtml, head: head, body: body) # Head & Body have childrens.

macro html*(name: untyped, inner: untyped) =
  ## Macro to create a new call to ``newHtml()``, passing Head and Body as arg.
  var rs = newCall("newHtml", inner[0], inner[1])  # Call newHtml(head, body)
  result = quote do: # inner is the whole content of the HTML DSL (head + body)
    proc `name`(): HtmlNode {.inline.} = `rs` # Do name() = newHtml(head, body)

template indent_if_needed(thingy, indentationLevel: untyped): untyped =
  ## Render Pretty-Printed with indentation when build for Release,else Minified
  when defined(release): thingy           # Release, Minified for Performance.
  else: indent(thingy, indentationLevel) # Development, use the Indentations.

proc render*(this: HtmlNode): string =
  ## Render HtmlNode with indentation return string.
  var indentationLevel: byte   # indent level, 0 ~ 255.
  case this.kind
  of nkHtml:                    # <html>
    result &= open_tag this
    inc indentationLevel
    result &= indent_if_needed(render(this.head), indentationLevel)
    result &= indent_if_needed(render(this.body), indentationLevel)
    dec indentationLevel
    result &= close_tag this
  of nkHead:                    # <head>
    result &= open_tag this
    inc indentationLevel
    if this.meta.len > 0:
      for meta_tag in this.meta:  # <meta ... >
        result &= indent_if_needed(render(meta_tag), indentationLevel)
    if this.link.len > 0:
      for link_tag in this.link:  # <link ... >
        result &= indent_if_needed(render(link_tag), indentationLevel)
    result &= indent_if_needed(open_tag(this.title), indentationLevel)
    dec indentationLevel
    result &= close_tag this
  of nkBody:                    # <body>
    result &= open_tag this
    inc indentationLevel
    if this.children.len > 0:
      for tag in this.children:
        if tag.kind in canHaveChildren:
          result &= indent_if_needed(render(tag), indentationLevel)
        else:
          result &= indent_if_needed(open_tag(tag), indentationLevel)
    dec indentationLevel
    result &= close_tag this
  else:
    result &= open_tag this
    inc indentationLevel
    if this.children.len > 0:
      for tag in this.children:
        if tag.kind in canHaveChildren:
          result &= indent_if_needed(render(tag), indentationLevel)
        else:
          result &= indent_if_needed(open_tag(tag), indentationLevel)
    dec indentationLevel
    result &= close_tag this

  # of nkAddress, nkArea, nkArticle, nkAside, nkAudio, nkB, nkBase, nkBdi, nkBdo,
  #    nkBig, nkBlockquote, nkButton, nkCanvas, nkCaption, nkCenter, nkCol,
  #    nkColgroup, nkData, nkDatalist, nkDd, nkDel, nkDetails, nkDfn, nkDialog,
  #    nkDiv, nkDl, nkDt, nkEm, nkEmbed, nkFieldset, nkFigure, nkFigcaption,
  #    nkFooter, nkForm, nkH1, nkH2, nkH3, nkH4, nkH5, nkH6, nkHeader, nkI, nkImg,
  #    nkIns, nkKbd, nkKeygen, nkLabel, nkLegend, nkLi, nkMain, nkMap, nkMark,
  #    nkMarquee, nkNav, nkObject, nkOl, nkOptgroup, nkOption, nkOutput, nkParam,
  #    nkPicture, nkPre, nkQ, nkRb, nkRp, nkRt, nkRtc, nkRuby, nkS, nkSamp,
  #    nkSection, nkSelect, nkSmall, nkSource, nkSpan, nkStrong, nkSub, nkSummary,
  #    nkSup, nkTable, nkTbody, nkTd, nkTemplate, nkTfoot, nkTh, nkThead, nkTr,
  #    nkTrack, nkTt, nkU, nkUl:  # All other tags
  #   result &= open_tag this
  #   inc indentationLevel
  #   if this.children.len > 0:
  #     for tag in this.children:
  #       if tag.kind in canHaveChildren:
  #         result &= indent_if_needed(render(tag), indentationLevel)
  #       else:
  #         result &= indent_if_needed(open_tag(tag), indentationLevel)
  #   dec indentationLevel
  #   result &= close_tag this
  # else:
  #   debugEcho "render() else: " & toUpperAscii($this.kind)


when isMainModule:
  html page:
    head:
      title "Title"
      meta("foo", "bar")
      link "href"
    body:
      p("Hello")
      p("World")
      dv:
        p("Example")

  echo render(page())


# , hreflang="hreflang", crossorigin="crossorigin", integrity="integrity", media="media", referrerpolicy="referrerpolicy", sizes="sizes"

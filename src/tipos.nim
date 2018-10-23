import strutils

const basic_head_tags =
  when defined(release):
    """<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">"""
  else:
    """<meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    """  ## Basic meta tags that all frameworks recommend nowadays.

type HtmlNodeKind* = enum  ## All HTML Tags, taken from Mozilla docs, +Comment.
  nkA, nkAbbr,  nkAddress, nkArea, nkArticle, nkAside, nkAudio, nkB, nkBase,
  nkBdi, nkBdo, nkBig, nkBlockquote, nkBody, nkBr, nkButton, nkCanvas,
  nkCaption, nkCenter, nkCite, nkCode, nkCol, nkColgroup, nkData, nkDatalist,
  nkDd, nkDel, nkDetails, nkDfn, nkDialog, nkDiv, nkDl, nkDt, nkEm, nkEmbed,
  nkFieldset, nkFigure, nkFigcaption, nkFooter, nkForm, nkH1, nkH2, nkH3, nkH4,
  nkH5, nkH6, nkHead, nkHeader, nkHtml, nkHr, nkI, nkIframe, nkImg, nkInput,
  nkIns, nkKbd, nkKeygen, nkLabel, nkLegend, nkLi, nkLink, nkMain, nkMap,
  nkMark, nkMarquee, nkMeta, nkMeter, nkNav, nkNoscript, nkObject, nkOl,
  nkOptgroup, nkOption, nkOutput, nkP, nkParam, nkPicture, nkPre, nkProgress,
  nkQ, nkRb, nkRp, nkRt, nkRtc, nkRuby, nkS, nkSamp, nkScript, nkSection,
  nkSelect, nkSlot, nkSmall, nkSource, nkSpan, nkStrong, nkStyle, nkSub,
  nkSummary, nkSup, nkTable, nkTbody, nkTd, nkTemplate, nkTextarea, nkTfoot,
  nkTh, nkThead, nkTime, nkTitle, nkTr, nkTrack, nkTt, nkU, nkUl, nkVar,
  nkVideo, nkWbr, nkComment

type HtmlNode* = ref object  ## HTML Tag Object type, all possible attributes.
  contenteditable: bool
  width: int
  height: int
  id: string
  class: string
  name: string
  accesskey: string
  dir: string
  src: string
  tabindex: string
  translate: string
  hidden: string
  lang: string
  role: string
  spellcheck: string
  onabort: string
  onblur: string
  oncancel: string
  oncanplay: string
  oncanplaythrough: string
  onchange: string
  onclick: string
  oncuechange: string
  ondblclick: string
  ondurationchange: string
  onemptied: string
  onended: string
  onerror: string
  onfocus: string
  oninput: string
  oninvalid: string
  onkeydown: string
  onkeypress: string
  onkeyup: string
  onload: string
  onloadeddata: string
  onloadedmetadata: string
  onloadstart: string
  onmousedown: string
  onmouseenter: string
  onmouseleave: string
  onmousemove: string
  onmouseout: string
  onmouseover: string
  onmouseup: string
  onmousewheel: string
  onpause: string
  onplay: string
  onplaying: string
  onprogress: string
  onratechange: string
  onreset: string
  onresize: string
  onscroll: string
  onseeked: string
  onseeking: string
  onselect: string
  onshow: string
  onstalled: string
  onsubmit: string
  onsuspend: string
  ontimeupdate: string
  ontoggle: string
  onvolumechange: string
  onwaiting: string
  disabled: string
  crossorigin: string
  hreflang: string
  form: string
  maxlength: string
  minlength: string
  placeholder: string
  readonly: string
  required: string
  coords: string
  download: string
  href: string
  rel: string
  shape: string
  target: string
  preload: string
  autoplay: string
  mediagroup: string
  loop: string
  muted: string
  controls: string
  poster: string
  onafterprint: string
  onbeforeprint: string
  onbeforeunload: string
  onhashchange: string
  onmessage: string
  onoffline: string
  ononline: string
  onpagehide: string
  onpageshow: string
  onpopstate: string
  onstorage: string
  onunload: string
  open: string
  action: string
  enctype: string
  novalidate: string
  srcdoc: string
  sandbox: string
  usemap: string
  ismap: string
  accept: string
  alt: string
  autocomplete: string
  autofocus: string
  checked: string
  dirname: string
  formaction: string
  formenctype: string
  formmethod: string
  formnovalidate: string
  formtarget: string
  inputmode: string
  list: string
  max: string
  min: string
  multiple: string
  pattern: string
  size: string
  step: string
  `type`: string
  value: string
  `for`: string
  `async`: string
  `defer`: string
  text: string
  val : string
  content: string
  behavior: string
  bgcolor: string
  direction: string
  hspace: string
  scrollamount: string
  scrolldelay: string
  truespeed: string
  vspace: string
  onbounce: string
  onfinish: string
  onstart: string
  optimum: string
  selected: string
  colspan: string
  rowspan: string
  headers: string
  cols: string
  rows : string
  wrap: string
  sons: seq[HtmlNode]
  case kind: HtmlNodeKind  # Some tags have unique attributes.
  of nkHtml:
    head: HtmlNode
    body: HtmlNode
  of nkHead:
    title: HtmlNode
    meta: seq[HtmlNode]
    link: seq[HtmlNode]
  else: discard

# func toJson*(this: HtmlNode): string =
#   result = "[\n    {\n"
#   result &= "    " & $this.kind  # FIXME: Make it work or remove it (?).
#   if this.sons.len.bool:
#     result &= ":\n        {\n"
#     for tag in this.sons:
#       result &= "\n" & $tag

func `$`*(this: HtmlNode): string =
  result = $this.kind & ": "  # Change to .repr()
  if this.sons.len.bool:
    for tag in this.sons:
      result &= "\n" & $tag

func attributter(tagy: HtmlNode): string =
  ## Render to string all attributtes for all HTML tags. Uses Branch Prediction.
  # TODO: Find the best way to Optimize this. Ugly code on purpose, for speed.
  var atributes = @[" "]
  if unlikely(tagy.width != 0):
    atributes.add "width=\"" & $tagy.width & "\" "
  if unlikely(tagy.height != 0):
    atributes.add "width='" & $tagy.height & "\" "
  if tagy.id.len.bool:
    atributes.add "id=\"" & tagy.id & "\" "
  if tagy.class.len.bool:
    atributes.add "class=\"" & tagy.class & "\" "
  if tagy.name.len.bool:
    atributes.add "name=\"" & tagy.name & "\" "
  if unlikely(tagy.accesskey.len.bool):
    atributes.add "accesskey=\"" & tagy.accesskey & "\" "
  if unlikely(tagy.dir.len.bool):
    atributes.add "dir=\"" & tagy.dir & "\" "
  if tagy.src.len.bool:
    atributes.add "src=\"" & tagy.src & "\" "
  if unlikely(tagy.tabindex.len.bool):
    atributes.add "tabindex=\"" & tagy.tabindex & "\" "
  if unlikely(tagy.translate.len.bool):
    atributes.add "translate=\"" & tagy.translate & "\" "
  if tagy.hidden.len.bool:
    atributes.add "hidden "
  if unlikely(tagy.lang.len.bool):
    atributes.add "lang=\"" & tagy.lang & "\" "
  if tagy.role.len.bool:
    atributes.add "role=\"" & tagy.role & "\" "
  if unlikely(tagy.spellcheck.len.bool):
    atributes.add "spellcheck "
  if tagy.onabort.len.bool:
    atributes.add "onabort=\"" & tagy.onabort & "\" "
  if tagy.onblur.len.bool:
    atributes.add "onblur=\"" & tagy.onblur & "\" "
  if tagy.oncancel.len.bool:
    atributes.add "oncancel=\"" & tagy.oncancel & "\" "
  if unlikely(tagy.oncanplay.len.bool):
    atributes.add "oncanplay=\"" & tagy.oncanplay & "\" "
  if unlikely(tagy.oncanplaythrough.len.bool):
    atributes.add "oncanplaythrough=\"" & tagy.oncanplaythrough & "\" "
  if tagy.onchange.len.bool:
    atributes.add "onchange=\"" & tagy.onchange & "\" "
  if tagy.onclick.len.bool:
    atributes.add "onclick=\"" & tagy.onclick & "\" "
  if unlikely(tagy.oncuechange.len.bool):
    atributes.add "oncuechange=\"" & tagy.oncuechange & "\" "
  if tagy.ondblclick.len.bool:
    atributes.add "ondblclick=\"" & tagy.ondblclick & "\" "
  if tagy.ondurationchange.len.bool:
    atributes.add "ondurationchange=\"" & tagy.ondurationchange & "\" "
  if unlikely(tagy.onemptied.len.bool):
    atributes.add "onemptied=\"" & tagy.onemptied & "\" "
  if tagy.onended.len.bool:
    atributes.add "onended=\"" & tagy.onended & "\" "
  if tagy.onerror.len.bool:
    atributes.add "onerror=\"" & tagy.onerror & "\" "
  if tagy.onfocus.len.bool:
    atributes.add "onfocus=\"" & tagy.onfocus & "\" "
  if tagy.oninput.len.bool:
    atributes.add "oninput=\"" & tagy.oninput & "\" "
  if tagy.oninvalid.len.bool:
    atributes.add "oninvalid=\"" & tagy.oninvalid & "\" "
  if tagy.onkeydown.len.bool:
    atributes.add "onkeydown=\"" & tagy.onkeydown & "\" "
  if tagy.onkeypress.len.bool:
    atributes.add "onkeypress=\"" & tagy.onkeypress & "\" "
  if tagy.onkeyup.len.bool:
    atributes.add "onkeyup=\"" & tagy.onkeyup & "\" "
  if tagy.onload.len.bool:
    atributes.add "onload=\"" & tagy.onload & "\" "
  if tagy.onloadeddata.len.bool:
    atributes.add "onloadeddata=\"" & tagy.onloadeddata & "\" "
  if unlikely(tagy.onloadedmetadata.len.bool):
    atributes.add "onloadedmetadata=\"" & tagy.onloadedmetadata & "\" "
  if tagy.onloadstart.len.bool:
    atributes.add "onloadstart=\"" & tagy.onloadstart & "\" "
  if tagy.onmousedown.len.bool:
    atributes.add "onmousedown=\"" & tagy.onmousedown & "\" "
  if tagy.onmouseenter.len.bool:
    atributes.add "onmouseenter=\"" & tagy.onmouseenter & "\" "
  if tagy.onmouseleave.len.bool:
    atributes.add "onmouseleave=\"" & tagy.onmouseleave & "\" "
  if tagy.onmousemove.len.bool:
    atributes.add "onmousemove=\"" & tagy.onmousemove & "\" "
  if tagy.onmouseout.len.bool:
    atributes.add "onmouseout=\"" & tagy.onmouseout & "\" "
  if tagy.onmouseover.len.bool:
    atributes.add "onmouseover=\"" & tagy.onmouseover & "\" "
  if tagy.onmouseup.len.bool:
    atributes.add "onmouseup=\"" & tagy.onmouseup & "\" "
  if tagy.onmousewheel.len.bool:
    atributes.add "onmousewheel=\"" & tagy.onmousewheel & "\" "
  if tagy.onpause.len.bool:
    atributes.add "onpause=\"" & tagy.onpause & "\" "
  if unlikely(tagy.onplay.len.bool):
    atributes.add "onplay=\"" & tagy.onplay & "\" "
  if unlikely(tagy.onplaying.len.bool):
    atributes.add "onplaying=\"" & tagy.onplaying & "\" "
  if tagy.onprogress.len.bool:
    atributes.add "onprogress=\"" & tagy.onprogress & "\" "
  if unlikely(tagy.onratechange.len.bool):
    atributes.add "onratechange=\"" & tagy.onratechange & "\" "
  if unlikely(tagy.onreset.len.bool):
    atributes.add "onreset=\"" & tagy.onreset & "\" "
  if tagy.onresize.len.bool:
    atributes.add "onresize=\"" & tagy.onresize & "\" "
  if tagy.onscroll.len.bool:
    atributes.add "onscroll=\"" & tagy.onscroll & "\" "
  if unlikely(tagy.onseeked.len.bool):
    atributes.add "onseeked=\"" & tagy.onseeked & "\" "
  if unlikely(tagy.onseeking.len.bool):
    atributes.add "onseeking=\"" & tagy.onseeking & "\" "
  if tagy.onselect.len.bool:
    atributes.add "onselect=\"" & tagy.onselect & "\" "
  if tagy.onshow.len.bool:
    atributes.add "onshow=\"" & tagy.onshow & "\" "
  if unlikely(tagy.onstalled.len.bool):
    atributes.add "onstalled=\"" & tagy.onstalled & "\" "
  if tagy.onsubmit.len.bool:
    atributes.add "onsubmit=\"" & tagy.onsubmit & "\" "
  if tagy.onsuspend.len.bool:
    atributes.add "onsuspend=\"" & tagy.onsuspend & "\" "
  if unlikely(tagy.ontimeupdate.len.bool):
    atributes.add "ontimeupdate=\"" & tagy.ontimeupdate & "\" "
  if tagy.ontoggle.len.bool:
    atributes.add "ontoggle=\"" & tagy.ontoggle & "\" "
  if unlikely(tagy.onvolumechange.len.bool):
    atributes.add "onvolumechange=\"" & tagy.onvolumechange & "\" "
  if tagy.onwaiting.len.bool:
    atributes.add "onwaiting=\"" & tagy.onwaiting & "\" "
  if unlikely(tagy.onafterprint.len.bool):
    atributes.add "onafterprint=\"" & tagy.onafterprint & "\" "
  if unlikely(tagy.onbeforeprint.len.bool):
    atributes.add "onbeforeprint=\"" & tagy.onbeforeprint & "\" "
  if tagy.onbeforeunload.len.bool:
    atributes.add "onbeforeunload=\"" & tagy.onbeforeunload & "\" "
  if unlikely(tagy.onhashchange.len.bool):
    atributes.add "onhashchange=\"" & tagy.onhashchange & "\" "
  if tagy.onmessage.len.bool:
    atributes.add "onmessage=\"" & tagy.onmessage & "\" "
  if tagy.onoffline.len.bool:
    atributes.add "onoffline=\"" & tagy.onoffline & "\" "
  if tagy.ononline.len.bool:
    atributes.add "ononline=\"" & tagy.ononline & "\" "
  if unlikely(tagy.onpagehide.len.bool):
    atributes.add "onpagehide=\"" & tagy.onpagehide & "\" "
  if unlikely(tagy.onpageshow.len.bool):
    atributes.add "onpageshow=\"" & tagy.onpageshow & "\" "
  if unlikely(tagy.onpopstate.len.bool):
    atributes.add "onpopstate=\"" & tagy.onpopstate & "\" "
  if unlikely(tagy.onstorage.len.bool):
    atributes.add "onstorage=\"" & tagy.onstorage & "\" "
  if tagy.onunload.len.bool:
    atributes.add "onunload=\"" & tagy.onunload & "\" "
  if unlikely(tagy.onbounce.len.bool):
    atributes.add "onbounce=\"" & tagy.onbounce & "\" "
  if tagy.onfinish.len.bool:
    atributes.add "onfinish=\"" & tagy.onfinish & "\" "
  if tagy.onstart.len.bool:
    atributes.add "onstart=\"" & tagy.onstart & "\" "
  if unlikely(tagy.disabled.len.bool):
    atributes.add "disabled "
  if tagy.crossorigin.len.bool:
    atributes.add "crossorigin=\"" & tagy.crossorigin & "\" "
  if unlikely(tagy.hreflang.len.bool):
    atributes.add "hreflang=\"" & tagy.hreflang & "\" "
  if tagy.form.len.bool:
    atributes.add "form=\"" & tagy.form & "\" "
  if tagy.maxlength.len.bool:
    atributes.add "maxlength=\"" & tagy.maxlength & "\" "
  if tagy.minlength.len.bool:
    atributes.add "minlength=\"" & tagy.minlength & "\" "
  if tagy.placeholder.len.bool:
    atributes.add "placeholder=\"" & tagy.placeholder & "\" "
  if tagy.readonly.len.bool:
    atributes.add "readonly "
  if tagy.required.len.bool:
    atributes.add "required "
  if unlikely(tagy.coords.len.bool):
    atributes.add "coords=\"" & tagy.coords & "\" "
  if unlikely(tagy.download.len.bool):
    atributes.add "download=\"" & tagy.download & "\" "
  if tagy.href.len.bool:
    atributes.add "href=\"" & tagy.href & "\" "
  if tagy.rel.len.bool:
    atributes.add "rel=\"" & tagy.rel & "\" "
  if unlikely(tagy.shape.len.bool):
    atributes.add "shape=\"" & tagy.shape & "\" "
  if tagy.target.len.bool:
    atributes.add "target=\"" & tagy.target & "\" "
  if tagy.preload.len.bool:
    atributes.add "preload=\"" & tagy.preload & "\" "
  if tagy.autoplay.len.bool:
    atributes.add "autoplay "
  if unlikely(tagy.mediagroup.len.bool):
    atributes.add "mediagroup=\"" & tagy.mediagroup & "\" "
  if unlikely(tagy.loop.len.bool):
    atributes.add "loop=\"" & tagy.loop & "\" "
  if unlikely(tagy.muted.len.bool):
    atributes.add "muted=\"" & tagy.muted & "\" "
  if unlikely(tagy.controls.len.bool):
    atributes.add "controls "
  if unlikely(tagy.poster.len.bool):
    atributes.add "poster=\"" & tagy.poster & "\" "
  if tagy.open.len.bool:
    atributes.add "open "
  if tagy.action.len.bool:
    atributes.add "action=\"" & tagy.action & "\" "
  if unlikely(tagy.enctype.len.bool):
    atributes.add "enctype=\"" & tagy.enctype & "\" "
  if unlikely(tagy.novalidate.len.bool):
    atributes.add "novalidate=\"" & tagy.novalidate & "\" "
  if unlikely(tagy.srcdoc.len.bool):
    atributes.add "srcdoc=\"" & tagy.srcdoc & "\" "
  if unlikely(tagy.sandbox.len.bool):
    atributes.add "sandbox=\"" & tagy.sandbox & "\" "
  if unlikely(tagy.usemap.len.bool):
    atributes.add "usemap=\"" & tagy.usemap & "\" "
  if unlikely(tagy.ismap.len.bool):
    atributes.add "ismap=\"" & tagy.ismap & "\" "
  if tagy.accept.len.bool:
    atributes.add "accept=\"" & tagy.accept & "\" "
  if tagy.alt.len.bool:
    atributes.add "alt=\"" & tagy.alt & "\" "
  if tagy.autocomplete.len.bool:
    atributes.add "autocomplete "
  if tagy.autofocus.len.bool:
    atributes.add "autofocus "
  if tagy.checked.len.bool:
    atributes.add "checked "
  if tagy.dirname.len.bool:
    atributes.add "dirname=\"" & tagy.dirname & "\" "
  if tagy.formaction.len.bool:
    atributes.add "formaction=\"" & tagy.formaction & "\" "
  if tagy.formenctype.len.bool:
    atributes.add "formenctype=\"" & tagy.formenctype & "\" "
  if tagy.formmethod.len.bool:
    atributes.add "formmethod=\"" & tagy.formmethod & "\" "
  if unlikely(tagy.formnovalidate.len.bool):
    atributes.add "formnovalidate=\"" & tagy.formnovalidate & "\" "
  if tagy.formtarget.len.bool:
    atributes.add "formtarget=\"" & tagy.formtarget & "\" "
  if tagy.inputmode.len.bool:
    atributes.add "inputmode=\"" & tagy.inputmode & "\" "
  if unlikely(tagy.list.len.bool):
    atributes.add "list=\"" & tagy.list & "\" "
  if unlikely(tagy.max.len.bool):
    atributes.add "max=\"" & tagy.max & "\" "
  if unlikely(tagy.min.len.bool):
    atributes.add "min=\"" & tagy.min & "\" "
  if unlikely(tagy.multiple.len.bool):
    atributes.add "multiple=\"" & tagy.multiple & "\" "
  if unlikely(tagy.pattern.len.bool):
    atributes.add "pattern=\"" & tagy.pattern & "\" "
  if tagy.size.len.bool:
    atributes.add "size=\"" & tagy.size & "\" "
  if tagy.step.len.bool:
    atributes.add "step=\"" & tagy.step & "\" "
  if tagy.`type`.len.bool:
    atributes.add "type=\"" & tagy.`type` & "\" "
  if tagy.value.len.bool:
    atributes.add "value=\"" & tagy.value & "\" "
  if tagy.`for`.len.bool:
    atributes.add "for=\"" & tagy.`for` & "\" "
  if tagy.`async`.len.bool:
    atributes.add "async "
  if tagy.`defer`.len.bool:
    atributes.add "defer "
  if unlikely(tagy.behavior.len.bool):
    atributes.add "behavior=\"" & tagy.behavior & "\" "
  if unlikely(tagy.bgcolor.len.bool):
    atributes.add "bgcolor=\"" & tagy.bgcolor & "\" "
  if unlikely(tagy.direction.len.bool):
    atributes.add "direction=\"" & tagy.direction & "\" "
  if unlikely(tagy.hspace.len.bool):
    atributes.add "hspace=\"" & tagy.hspace & "\" "
  if unlikely(tagy.scrollamount.len.bool):
    atributes.add "scrollamount=\"" & tagy.scrollamount & "\" "
  if unlikely(tagy.scrolldelay.len.bool):
    atributes.add "scrolldelay=\"" & tagy.scrolldelay & "\" "
  if unlikely(tagy.truespeed.len.bool):
    atributes.add "truespeed=\"" & tagy.truespeed & "\" "
  if unlikely(tagy.vspace.len.bool):
    atributes.add "vspace=\"" & tagy.vspace & "\" "
  if unlikely(tagy.optimum.len.bool):
    atributes.add "optimum=\"" & tagy.optimum & "\" "
  if tagy.selected.len.bool:
    atributes.add "selected "
  if tagy.colspan.len.bool:
    atributes.add "colspan=\"" & tagy.colspan & "\" "
  if tagy.rowspan.len.bool:
    atributes.add "rowspan=\"" & tagy.rowspan & "\" "
  if tagy.headers.len.bool:
    atributes.add "headers=\"" & tagy.headers & "\" "
  if tagy.cols.len.bool:
    atributes.add "cols=\"" & tagy.cols & "\" "
  if tagy.rows.len.bool:
    atributes.add "rows=\"" & tagy.rows & "\" "
  if tagy.wrap.len.bool:
    atributes.add "wrap=\"" & tagy.wrap & "\" "
  when not defined(release):  # No one uses contenteditable on Prod.
    if tagy.contenteditable:
      atributes.add """contenteditable="true" """
  result =
    when defined(release): atributes.join.strip(trailing=true)
    else:                  atributes.join

func render_tag(this: HtmlNode): string {.discardable.} =
  ## Render the HtmlNode to String,tag-by-tag,Bulma & Spectre support added here
  let atributos = attributter(this)
  case this.kind
  of nkhtml:
    result =
      when defined(release): "<!DOCTYPE html>" & "<html class='has-navbar-fixed-top'" & atributos & ">"
      else: "<!DOCTYPE html>\n  " & "<html class='has-navbar-fixed-top'" & atributos & ">\n"
  of nkhead:
    result =
      when defined(release): "<head>" & basic_head_tags
      else: "<head>\n  " & basic_head_tags
  of nktitle:
    result =
      when defined(release): "<title>" & this.val.strip.capitalizeAscii & "</title>"
      else: "<title>" & this.val & "</title>\n"
  of nkmeta:
    result =
      when defined(release): "<meta" & atributos & ">"
      else: "<meta" & atributos & ">\n"
  of nkbody:
    result =
      when defined(release): "<body class='has-navbar-fixed-top'" & atributos & ">"
      else: "<body class='has-navbar-fixed-top'" & atributos & ">\n"
  of nkArticle:
    result =
      when defined(release): "<article class='message'" & atributos & ">"
      else: "<article class='message'" & atributos & ">\n"
  of nkButton:
    result =
      when defined(release): "<button class='button is-light is-rounded btn tooltip'" & atributos & ">"
      else: "<button class='button is-light is-rounded btn tooltip'" & atributos & ">\n"
  of nkDetails:
    result =
      when defined(release): "<details class='message is-dark'" & atributos & ">"
      else: "<details class='message is-dark'" & atributos & ">\n"
  of nkDialog:
    result =
      when defined(release): "<dialog class='notification is-rounded modal'" & atributos & ">"
      else: "<dialog class='notification is-rounded modal'" & atributos & ">\n"
  of nkFooter:
    result =
      when defined(release): "<footer class='footer is-fullwidth'" & atributos & ">"
      else: "<footer class='footer is-fullwidth'" & atributos & ">\n"
  of nkH1:
    result =
      when defined(release): "<h1 class='title'" & atributos & ">"
      else: "<h1 class='title'" & atributos & ">\n"
  of nkImg:
    result =
      when defined(release): "<img class='image img-responsive'" & atributos & "\\>"
      else: "<img class='image img-responsive'" & atributos & "\\>\n"
  of nkLabel:
    result =
      when defined(release): "<label class='label form-label'" & atributos & ">"
      else: "<label class='label form-label'" & atributos & ">\n"
  of nkMeter:
    result =
      when defined(release): "<meter class='progress is-small bar-item' role='progressbar'" & atributos & ">"
      else: "<meter class='progress is-small bar-item' role='progressbar'" & atributos & ">\n"
  of nkComment:
    result =
      when defined(release): "<!-- " & this.text.strip
      else: "\n\n<!--  " & this.text
  else:
    var tagy = $this.kind
    tagy = tagy.replace("nk", "").toLowerAscii
    result =
      when defined(release): "<" & tagy & atributos & ">" & this.text & "</" & tagy & ">"
      else: "<" & tagy & atributos & ">" & this.text & "</" & tagy & ">\n"

func close_tag(this: HtmlNode): string {.discardable.} =
  ## Render the Closing tag of each HtmlNode to String, tag-by-tag.
  case this.kind
  of nkhtml:
    result =
      when defined(release): "</html>"
      else: "</html>\n<!-- Nim " & NimVersion & " -->\n"
  of nkComment:
    result =
      when defined(release): " -->"
      else: "  -->\n\n"
  else:
    var tagy = $this.kind
    tagy = tagy.replace("nk", "").toLowerAscii
    result =
      when defined(release): "</" & tagy & ">"
      else: "</" & tagy & ">\n"

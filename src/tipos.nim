import strutils

const basicHeadTags =
  when defined(release): """<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">"""
  else: """
    <meta charset="utf-8">
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
  src: string
  tabindex: string
  translate: string
  hidden: string
  httpequiv: string
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
  integrity: string
  media: string
  referrerpolicy: string
  sizes: string
  case kind: HtmlNodeKind  # Some tags have unique attributes.
  of nkHtml:
    head: HtmlNode
    body: HtmlNode
  of nkHead:
    title: HtmlNode
    meta: seq[HtmlNode]
    link: seq[HtmlNode]
  else:
    children: seq[HtmlNode]

# func toJson*(this: HtmlNode): string =
#   result = "[\n    {\n"
#   result &= "    " & $this.kind  # FIXME: Make it work or remove it (?).
#   if this.children.len > 0:
#     result &= ":\n        {\n"
#     for tag in this.children:
#       result &= "\n" & $tag

func `$`*(this: HtmlNode): string =
  ## Stringify an ``HtmlNode``.
  result = $this.kind & ": "
  if this.children.len > 0:
    for tag in this.children:
      result &= "\n" & $tag

func attributter(tagy: HtmlNode): string =
  ## Render to string all attributtes for all HTML tags. Uses Branch Prediction.
  # TODO: Find the best way to Optimize this. Ugly code on purpose, for speed.
  var atributes = @[" "]
  if unlikely(tagy.width != 0):
    atributes.add "width=\"" & $tagy.width & "\" "
  if unlikely(tagy.height != 0):
    atributes.add "width='" & $tagy.height & "\" "
  if tagy.id.len > 0:
    atributes.add "id=\"" & tagy.id & "\" "
  if tagy.class.len > 0:
    atributes.add "class=\"" & tagy.class & "\" "
  if tagy.name.len > 0:
    atributes.add "name=\"" & tagy.name & "\" "
  if unlikely(tagy.accesskey.len > 0):
    atributes.add "accesskey=\"" & tagy.accesskey & "\" "
  if tagy.src.len > 0:
    atributes.add "src=\"" & tagy.src & "\" "
  if unlikely(tagy.tabindex.len > 0):
    atributes.add "tabindex=\"" & tagy.tabindex & "\" "
  if unlikely(tagy.translate.len > 0):
    atributes.add "translate=\"" & tagy.translate & "\" "
  if tagy.hidden.len > 0:
    atributes.add "hidden "
  if unlikely(tagy.lang.len > 0):
    atributes.add "lang=\"" & tagy.lang & "\" "
  if tagy.role.len > 0:
    atributes.add "role=\"" & tagy.role & "\" "
  if unlikely(tagy.spellcheck.len > 0):
    atributes.add "spellcheck "
  if tagy.onabort.len > 0:
    atributes.add "onabort=\"" & tagy.onabort & "\" "
  if tagy.onblur.len > 0:
    atributes.add "onblur=\"" & tagy.onblur & "\" "
  if tagy.oncancel.len > 0:
    atributes.add "oncancel=\"" & tagy.oncancel & "\" "
  if unlikely(tagy.oncanplay.len > 0):
    atributes.add "oncanplay=\"" & tagy.oncanplay & "\" "
  if unlikely(tagy.oncanplaythrough.len > 0):
    atributes.add "oncanplaythrough=\"" & tagy.oncanplaythrough & "\" "
  if tagy.onchange.len > 0:
    atributes.add "onchange=\"" & tagy.onchange & "\" "
  if tagy.onclick.len > 0:
    atributes.add "onclick=\"" & tagy.onclick & "\" "
  if unlikely(tagy.oncuechange.len > 0):
    atributes.add "oncuechange=\"" & tagy.oncuechange & "\" "
  if tagy.ondblclick.len > 0:
    atributes.add "ondblclick=\"" & tagy.ondblclick & "\" "
  if tagy.ondurationchange.len > 0:
    atributes.add "ondurationchange=\"" & tagy.ondurationchange & "\" "
  if unlikely(tagy.onemptied.len > 0):
    atributes.add "onemptied=\"" & tagy.onemptied & "\" "
  if tagy.onended.len > 0:
    atributes.add "onended=\"" & tagy.onended & "\" "
  if tagy.onerror.len > 0:
    atributes.add "onerror=\"" & tagy.onerror & "\" "
  if tagy.onfocus.len > 0:
    atributes.add "onfocus=\"" & tagy.onfocus & "\" "
  if tagy.oninput.len > 0:
    atributes.add "oninput=\"" & tagy.oninput & "\" "
  if tagy.oninvalid.len > 0:
    atributes.add "oninvalid=\"" & tagy.oninvalid & "\" "
  if tagy.onkeydown.len > 0:
    atributes.add "onkeydown=\"" & tagy.onkeydown & "\" "
  if tagy.onkeypress.len > 0:
    atributes.add "onkeypress=\"" & tagy.onkeypress & "\" "
  if tagy.onkeyup.len > 0:
    atributes.add "onkeyup=\"" & tagy.onkeyup & "\" "
  if tagy.onload.len > 0:
    atributes.add "onload=\"" & tagy.onload & "\" "
  if tagy.onloadeddata.len > 0:
    atributes.add "onloadeddata=\"" & tagy.onloadeddata & "\" "
  if unlikely(tagy.onloadedmetadata.len > 0):
    atributes.add "onloadedmetadata=\"" & tagy.onloadedmetadata & "\" "
  if tagy.onloadstart.len > 0:
    atributes.add "onloadstart=\"" & tagy.onloadstart & "\" "
  if tagy.onmousedown.len > 0:
    atributes.add "onmousedown=\"" & tagy.onmousedown & "\" "
  if tagy.onmouseenter.len > 0:
    atributes.add "onmouseenter=\"" & tagy.onmouseenter & "\" "
  if tagy.onmouseleave.len > 0:
    atributes.add "onmouseleave=\"" & tagy.onmouseleave & "\" "
  if tagy.onmousemove.len > 0:
    atributes.add "onmousemove=\"" & tagy.onmousemove & "\" "
  if tagy.onmouseout.len > 0:
    atributes.add "onmouseout=\"" & tagy.onmouseout & "\" "
  if tagy.onmouseover.len > 0:
    atributes.add "onmouseover=\"" & tagy.onmouseover & "\" "
  if tagy.onmouseup.len > 0:
    atributes.add "onmouseup=\"" & tagy.onmouseup & "\" "
  if tagy.onmousewheel.len > 0:
    atributes.add "onmousewheel=\"" & tagy.onmousewheel & "\" "
  if tagy.onpause.len > 0:
    atributes.add "onpause=\"" & tagy.onpause & "\" "
  if unlikely(tagy.onplay.len > 0):
    atributes.add "onplay=\"" & tagy.onplay & "\" "
  if unlikely(tagy.onplaying.len > 0):
    atributes.add "onplaying=\"" & tagy.onplaying & "\" "
  if tagy.onprogress.len > 0:
    atributes.add "onprogress=\"" & tagy.onprogress & "\" "
  if unlikely(tagy.onratechange.len > 0):
    atributes.add "onratechange=\"" & tagy.onratechange & "\" "
  if unlikely(tagy.onreset.len > 0):
    atributes.add "onreset=\"" & tagy.onreset & "\" "
  if tagy.onresize.len > 0:
    atributes.add "onresize=\"" & tagy.onresize & "\" "
  if tagy.onscroll.len > 0:
    atributes.add "onscroll=\"" & tagy.onscroll & "\" "
  if unlikely(tagy.onseeked.len > 0):
    atributes.add "onseeked=\"" & tagy.onseeked & "\" "
  if unlikely(tagy.onseeking.len > 0):
    atributes.add "onseeking=\"" & tagy.onseeking & "\" "
  if tagy.onselect.len > 0:
    atributes.add "onselect=\"" & tagy.onselect & "\" "
  if tagy.onshow.len > 0:
    atributes.add "onshow=\"" & tagy.onshow & "\" "
  if unlikely(tagy.onstalled.len > 0):
    atributes.add "onstalled=\"" & tagy.onstalled & "\" "
  if tagy.onsubmit.len > 0:
    atributes.add "onsubmit=\"" & tagy.onsubmit & "\" "
  if tagy.onsuspend.len > 0:
    atributes.add "onsuspend=\"" & tagy.onsuspend & "\" "
  if unlikely(tagy.ontimeupdate.len > 0):
    atributes.add "ontimeupdate=\"" & tagy.ontimeupdate & "\" "
  if tagy.ontoggle.len > 0:
    atributes.add "ontoggle=\"" & tagy.ontoggle & "\" "
  if unlikely(tagy.onvolumechange.len > 0):
    atributes.add "onvolumechange=\"" & tagy.onvolumechange & "\" "
  if tagy.onwaiting.len > 0:
    atributes.add "onwaiting=\"" & tagy.onwaiting & "\" "
  if unlikely(tagy.onafterprint.len > 0):
    atributes.add "onafterprint=\"" & tagy.onafterprint & "\" "
  if unlikely(tagy.onbeforeprint.len > 0):
    atributes.add "onbeforeprint=\"" & tagy.onbeforeprint & "\" "
  if tagy.onbeforeunload.len > 0:
    atributes.add "onbeforeunload=\"" & tagy.onbeforeunload & "\" "
  if unlikely(tagy.onhashchange.len > 0):
    atributes.add "onhashchange=\"" & tagy.onhashchange & "\" "
  if tagy.onmessage.len > 0:
    atributes.add "onmessage=\"" & tagy.onmessage & "\" "
  if tagy.onoffline.len > 0:
    atributes.add "onoffline=\"" & tagy.onoffline & "\" "
  if tagy.ononline.len > 0:
    atributes.add "ononline=\"" & tagy.ononline & "\" "
  if unlikely(tagy.onpagehide.len > 0):
    atributes.add "onpagehide=\"" & tagy.onpagehide & "\" "
  if unlikely(tagy.onpageshow.len > 0):
    atributes.add "onpageshow=\"" & tagy.onpageshow & "\" "
  if unlikely(tagy.onpopstate.len > 0):
    atributes.add "onpopstate=\"" & tagy.onpopstate & "\" "
  if unlikely(tagy.onstorage.len > 0):
    atributes.add "onstorage=\"" & tagy.onstorage & "\" "
  if tagy.onunload.len > 0:
    atributes.add "onunload=\"" & tagy.onunload & "\" "
  if unlikely(tagy.onbounce.len > 0):
    atributes.add "onbounce=\"" & tagy.onbounce & "\" "
  if tagy.onfinish.len > 0:
    atributes.add "onfinish=\"" & tagy.onfinish & "\" "
  if tagy.onstart.len > 0:
    atributes.add "onstart=\"" & tagy.onstart & "\" "
  if unlikely(tagy.disabled.len > 0):
    atributes.add "disabled "
  if tagy.crossorigin.len > 0:
    atributes.add "crossorigin=\"" & tagy.crossorigin & "\" "
  if unlikely(tagy.hreflang.len > 0):
    atributes.add "hreflang=\"" & tagy.hreflang & "\" "
  if tagy.form.len > 0:
    atributes.add "form=\"" & tagy.form & "\" "
  if tagy.maxlength.len > 0:
    atributes.add "maxlength=\"" & tagy.maxlength & "\" "
  if tagy.minlength.len > 0:
    atributes.add "minlength=\"" & tagy.minlength & "\" "
  if tagy.placeholder.len > 0:
    atributes.add "placeholder=\"" & tagy.placeholder & "\" "
  if tagy.readonly.len > 0:
    atributes.add "readonly "
  if tagy.required.len > 0:
    atributes.add "required "
  if unlikely(tagy.coords.len > 0):
    atributes.add "coords=\"" & tagy.coords & "\" "
  if unlikely(tagy.download.len > 0):
    atributes.add "download=\"" & tagy.download & "\" "
  if tagy.href.len > 0:
    atributes.add "href=\"" & tagy.href & "\" "
  if tagy.rel.len > 0:
    atributes.add "rel=\"" & tagy.rel & "\" "
  if unlikely(tagy.shape.len > 0):
    atributes.add "shape=\"" & tagy.shape & "\" "
  if tagy.target.len > 0:
    atributes.add "target=\"" & tagy.target & "\" "
  if tagy.preload.len > 0:
    atributes.add "preload=\"" & tagy.preload & "\" "
  if tagy.autoplay.len > 0:
    atributes.add "autoplay "
  if unlikely(tagy.mediagroup.len > 0):
    atributes.add "mediagroup=\"" & tagy.mediagroup & "\" "
  if unlikely(tagy.loop.len > 0):
    atributes.add "loop=\"" & tagy.loop & "\" "
  if unlikely(tagy.muted.len > 0):
    atributes.add "muted=\"" & tagy.muted & "\" "
  if unlikely(tagy.controls.len > 0):
    atributes.add "controls "
  if unlikely(tagy.poster.len > 0):
    atributes.add "poster=\"" & tagy.poster & "\" "
  if tagy.open.len > 0:
    atributes.add "open "
  if tagy.action.len > 0:
    atributes.add "action=\"" & tagy.action & "\" "
  if unlikely(tagy.enctype.len > 0):
    atributes.add "enctype=\"" & tagy.enctype & "\" "
  if unlikely(tagy.novalidate.len > 0):
    atributes.add "novalidate=\"" & tagy.novalidate & "\" "
  if unlikely(tagy.srcdoc.len > 0):
    atributes.add "srcdoc=\"" & tagy.srcdoc & "\" "
  if unlikely(tagy.sandbox.len > 0):
    atributes.add "sandbox=\"" & tagy.sandbox & "\" "
  if unlikely(tagy.usemap.len > 0):
    atributes.add "usemap=\"" & tagy.usemap & "\" "
  if unlikely(tagy.ismap.len > 0):
    atributes.add "ismap=\"" & tagy.ismap & "\" "
  if tagy.accept.len > 0:
    atributes.add "accept=\"" & tagy.accept & "\" "
  if tagy.alt.len > 0:
    atributes.add "alt=\"" & tagy.alt & "\" "
  if tagy.autocomplete.len > 0:
    atributes.add "autocomplete "
  if tagy.autofocus.len > 0:
    atributes.add "autofocus "
  if tagy.checked.len > 0:
    atributes.add "checked "
  if tagy.dirname.len > 0:
    atributes.add "dirname=\"" & tagy.dirname & "\" "
  if tagy.formaction.len > 0:
    atributes.add "formaction=\"" & tagy.formaction & "\" "
  if tagy.formenctype.len > 0:
    atributes.add "formenctype=\"" & tagy.formenctype & "\" "
  if tagy.formmethod.len > 0:
    atributes.add "formmethod=\"" & tagy.formmethod & "\" "
  if unlikely(tagy.formnovalidate.len > 0):
    atributes.add "formnovalidate=\"" & tagy.formnovalidate & "\" "
  if tagy.formtarget.len > 0:
    atributes.add "formtarget=\"" & tagy.formtarget & "\" "
  if tagy.inputmode.len > 0:
    atributes.add "inputmode=\"" & tagy.inputmode & "\" "
  if unlikely(tagy.list.len > 0):
    atributes.add "list=\"" & tagy.list & "\" "
  if unlikely(tagy.max.len > 0):
    atributes.add "max=\"" & tagy.max & "\" "
  if unlikely(tagy.min.len > 0):
    atributes.add "min=\"" & tagy.min & "\" "
  if unlikely(tagy.multiple.len > 0):
    atributes.add "multiple=\"" & tagy.multiple & "\" "
  if unlikely(tagy.pattern.len > 0):
    atributes.add "pattern=\"" & tagy.pattern & "\" "
  if tagy.size.len > 0:
    atributes.add "size=\"" & tagy.size & "\" "
  if tagy.step.len > 0:
    atributes.add "step=\"" & tagy.step & "\" "
  if tagy.`type`.len > 0:
    atributes.add "type=\"" & tagy.`type` & "\" "
  if tagy.value.len > 0:
    atributes.add "value=\"" & tagy.value & "\" "
  if tagy.`for`.len > 0:
    atributes.add "for=\"" & tagy.`for` & "\" "
  if tagy.`async`.len > 0:
    atributes.add "async "
  if tagy.`defer`.len > 0:
    atributes.add "defer "
  if unlikely(tagy.behavior.len > 0):
    atributes.add "behavior=\"" & tagy.behavior & "\" "
  if unlikely(tagy.bgcolor.len > 0):
    atributes.add "bgcolor=\"" & tagy.bgcolor & "\" "
  if unlikely(tagy.direction.len > 0):
    atributes.add "direction=\"" & tagy.direction & "\" "
  if unlikely(tagy.hspace.len > 0):
    atributes.add "hspace=\"" & tagy.hspace & "\" "
  if unlikely(tagy.scrollamount.len > 0):
    atributes.add "scrollamount=\"" & tagy.scrollamount & "\" "
  if unlikely(tagy.scrolldelay.len > 0):
    atributes.add "scrolldelay=\"" & tagy.scrolldelay & "\" "
  if unlikely(tagy.truespeed.len > 0):
    atributes.add "truespeed=\"" & tagy.truespeed & "\" "
  if unlikely(tagy.vspace.len > 0):
    atributes.add "vspace=\"" & tagy.vspace & "\" "
  if unlikely(tagy.optimum.len > 0):
    atributes.add "optimum=\"" & tagy.optimum & "\" "
  if tagy.selected.len > 0:
    atributes.add "selected "
  if tagy.colspan.len > 0:
    atributes.add "colspan=\"" & tagy.colspan & "\" "
  if tagy.rowspan.len > 0:
    atributes.add "rowspan=\"" & tagy.rowspan & "\" "
  if tagy.headers.len > 0:
    atributes.add "headers=\"" & tagy.headers & "\" "
  if tagy.cols.len > 0:
    atributes.add "cols=\"" & tagy.cols & "\" "
  if tagy.rows.len > 0:
    atributes.add "rows=\"" & tagy.rows & "\" "
  if tagy.wrap.len > 0:
    atributes.add "wrap=\"" & tagy.wrap & "\" "
  if tagy.httpequiv.len > 0:
    atributes.add "http-equiv=\"" & tagy.httpequiv & "\" "
  if tagy.content.len > 0:
    atributes.add "content=\"" & tagy.content & "\" "
  if tagy.integrity.len > 0:
    atributes.add "integrity=\"" & tagy.integrity & "\" "
  if tagy.media.len > 0:
    atributes.add "media=\"" & tagy.media & "\" "
  if tagy.referrerpolicy.len > 0:
    atributes.add "referrerpolicy=\"" & tagy.referrerpolicy & "\" "
  if tagy.sizes.len > 0:
    atributes.add "sizes=\"" & tagy.sizes & "\" "
  when not defined(release):  # No one uses contenteditable on Prod.
    if tagy.contenteditable:
      atributes.add """contenteditable="true" """
  result = atributes.join.strip(leading=false)

func open_tag(this: HtmlNode): string {.discardable.} =
  ## Render the HtmlNode to String,tag-by-tag,Bulma & Spectre support added here
  var atributos: string
  if this.kind notin [nkHtml, nkHead, nkTitle, nkBody, nkComment]:
    atributos = attributter(this)
  case this.kind
  of nkHtml:
    result =
      when defined(release): "<!DOCTYPE html><html class='has-navbar-fixed-top'>"
      else: "<!DOCTYPE html>\n  <html class='has-navbar-fixed-top'>\n"
  of nkHead:
    result =
      when defined(release): "<head>" & basicHeadTags
      else: "<head>\n  " & basicHeadTags
  of nkTitle:
    result =
      when defined(release): "<title>" & this.text & "</title>"
      else: "<title>" & this.text & "</title>\n"
  of nkMeta:
    result =
      when defined(release): "<meta" & atributos & ">"
      else: "<meta" & atributos & ">\n"
  of nkLink:
    result =
      when defined(release): "<link" & atributos & ">"
      else: "<link" & atributos & ">\n"
  of nkBody:
    result =
      when defined(release): "<body class='has-navbar-fixed-top'>"
      else: "<body class='has-navbar-fixed-top'>\n"
  of nkArticle:
    result =
      when defined(release): "<article class='message'" & atributos & ">"
      else: "<article class='message'" & atributos & ">\n"
  of nkButton:
    result = "<button class='button is-light is-rounded btn tooltip'" & atributos & ">" & this.text
  of nkDetails:
    result =
      when defined(release): "<details class='message is-dark'" & atributos & ">"
      else: "<details class='message is-dark'" & atributos & ">\n"
  of nkSummary:
    result = "<summary class='message-header is-dark'" & atributos & ">" & this.text
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
      when defined(release): "<img class='image img-responsive'" & atributos & ">"
      else: "<img class='image img-responsive'" & atributos & ">\n"
  of nkLabel:
    result =
      when defined(release): "<label class='label form-label'" & atributos & ">"
      else: "<label class='label form-label'" & atributos & ">\n"
  of nkMeter:
    result =
      when defined(release): "<meter class='progress is-small bar-item' role='progressbar'" & atributos & ">"
      else: "<meter class='progress is-small bar-item' role='progressbar'" & atributos & ">\n"
  of nkProgress:
    result =
      when defined(release): "<progress class='progress is-small bar-item' role='progressbar'" & atributos & ">"
      else: "<progress class='progress is-small bar-item' role='progressbar'" & atributos & ">\n"
  of nkSection:
    result =
      when defined(release): "<section class='section'" & atributos & ">"
      else: "<section class='section'" & atributos & ">\n"
  of nkSelect:
    result =
      when defined(release): "<select class='select is-primary is-rounded is-small form-select'" & atributos & ">"
      else: "<select class='select is-primary is-rounded is-small form-select'" & atributos & ">\n"
  of nkTable:
    result =
      when defined(release): "<table class='table is-bordered is-striped is-hoverable table-striped table-hover'" & atributos & ">"
      else: "<table class='table is-bordered is-striped is-hoverable table-striped table-hover'" & atributos & ">\n"
  of nkFigure:
    result =
      when defined(release): "<figure class='figure figure-caption text-center'" & atributos & ">" & this.text
      else: "<figure class='figure figure-caption text-center'" & atributos & ">\n" & this.text
  of nkPre:
    result =
      when defined(release): "<pre class='code'" & atributos & ">" & this.text
      else: "<pre class='code'" & atributos & ">\n" & this.text
  of nkVideo:
    result =
      when defined(release): "<video class='video-responsive'" & atributos & ">"
      else: "<video class='video-responsive'" & atributos & ">\n"
  of nkCenter:
    result =
      when defined(release): "<center class='is-centered'" & atributos & ">" & this.text
      else: "<center class='is-centered'" & atributos & ">\n" & this.text
  of nkInput:
    result =
      when defined(release): "<input class='input is-primary form-input' dir=\"auto\" " & atributos & ">"
      else: "<input class='input is-primary form-input' dir=\"auto\" " & atributos & ">\n"
  of nkTextarea:
    result =
      when defined(release): "<textarea class='textarea is-primary form-input' dir=\"auto\" " & atributos & ">"
      else: "<textarea class='textarea is-primary form-input' dir=\"auto\" " & atributos & ">\n"
  of nkNav:
    result =
      when defined(release): "<nav class='navbar is-fixed-top is-light' role=\"navigation\"" & atributos & ">"
      else: "<nav class='navbar is-fixed-top is-light' role=\"navigation\"" & atributos & ">\n"
  of nkHr:
    result = "<hr>"
  of nkBr:
    result = "<br>"
  of nkComment:
    result =
      when defined(release): "<!-- " & this.text.strip & " -->"
      else: "\n\n<!--  " & this.text & "  -->\n\n"
  else:
    debugEcho "open_tag() else: " & $this.kind
    var tagy = $this.kind
    tagy = tagy[2 ..< len(tagy)].toLowerAscii # remove "nk" from string
    result =
      when defined(release): "<" & tagy & atributos & ">" & this.text
      else: "<" & tagy & atributos & ">" & this.text

func close_tag(this: HtmlNode): string {.inline, discardable.} =
  ## Render the Closing tag of each HtmlNode to String, tag-by-tag.
  case this.kind
  of nkHtml:    result = when defined(release): "</html>" else: "</html>\n<!-- Nim " & NimVersion & " -->\n"
  of nkComment: result = when defined(release): " -->" else: "  -->\n\n"
  of nkTitle, nkMeta, nkLink, nkImg, nkInput, nkBr, nkHr: result = ""  # These tags dont need Closing Tag.
  else:
    var tagy = $this.kind
    tagy = tagy[2 ..< len(tagy)].toLowerAscii
    result = when defined(release): "</" & tagy & ">" else: "</" & tagy & ">\n"

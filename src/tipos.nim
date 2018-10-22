import strutils, strformat

const
  basic_head_tags =
    when defined(release):
      """<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">"""
    else:
      """<meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      """  ## Basic meta tags that all frameworks recommend nowadays.

type HtmlNodeKind* = enum  ## All HTML Tags, taken from Mozilla docs, including Comment.
  nkA,
  nkAbbr,
  nkAddress,
  nkArea,
  nkArticle,
  nkAside,
  nkAudio,
  nkB,
  nkBase,
  nkBdi,
  nkBdo,
  nkBig,
  nkBlockquote,
  nkBody,
  nkBr,
  nkButton,
  nkCanvas,
  nkCaption,
  nkCenter,
  nkCite,
  nkCode,
  nkCol,
  nkColgroup,
  nkData,
  nkDatalist,
  nkDd,
  nkDel,
  nkDetails,
  nkDfn,
  nkDialog,
  nkDiv,
  nkDl,
  nkDt,
  nkEm,
  nkEmbed,
  nkFieldset,
  nkFigure,
  nkFigcaption,
  nkFooter,
  nkForm,
  nkH1,
  nkH2,
  nkH3,
  nkH4,
  nkH5,
  nkH6,
  nkHead,
  nkHeader,
  nkHtml,
  nkHr,
  nkI,
  nkIframe,
  nkImg,
  nkInput,
  nkIns,
  nkKbd,
  nkKeygen,
  nkLabel,
  nkLegend,
  nkLi,
  nkLink,
  nkMain,
  nkMap,
  nkMark,
  nkMarquee,
  nkMeta,
  nkMeter,
  nkNav,
  nkNoscript,
  nkObject,
  nkOl,
  nkOptgroup,
  nkOption,
  nkOutput,
  nkP,
  nkParam,
  nkPicture,
  nkPre,
  nkProgress,
  nkQ,
  nkRb,
  nkRp,
  nkRt,
  nkRtc,
  nkRuby,
  nkS,
  nkSamp,
  nkScript,
  nkSection,
  nkSelect,
  nkSlot,
  nkSmall,
  nkSource,
  nkSpan,
  nkStrong,
  nkStyle,
  nkSub,
  nkSummary,
  nkSup,
  nkTable,
  nkTbody,
  nkTd,
  nkTemplate,
  nkTextarea,
  nkTfoot,
  nkTh,
  nkThead,
  nkTime,
  nkTitle,
  nkTr,
  nkTrack,
  nkTt,
  nkU,
  nkUl,
  nkVar,
  nkVideo,
  nkWbr,
  nkComment

type HtmlNode* = ref object  ## Base HTML Tag Object type.
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
  else:
    discard


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
  # TODO: Find the best way to Optimize this.
  var atributes = @[" "]
  if unlikely(tagy.contenteditable != false):
    atributes.add """contenteditable="true" """
  if unlikely(tagy.width != 0):
    atributes.add fmt"""width="{tagy.width}" """
  if unlikely(tagy.height != 0):
    atributes.add fmt"""width="{tagy.height}" """
  if tagy.id != "":
    atributes.add fmt"""id="{tagy.id}" """
  if tagy.class != "":
    atributes.add fmt"""class="{tagy.class}" """
  if tagy.name != "":
    atributes.add fmt"""name="{tagy.name}" """
  if unlikely(tagy.accesskey != ""):
    atributes.add fmt"""accesskey="{tagy.accesskey}" """
  if unlikely(tagy.dir != ""):
    atributes.add fmt"""dir="{tagy.dir}" """
  if tagy.src != "":
    atributes.add fmt"""src="{tagy.src}" """
  if unlikely(tagy.tabindex != ""):
    atributes.add fmt"""tabindex="{tagy.tabindex}" """
  if unlikely(tagy.translate != ""):
    atributes.add fmt"""translate="{tagy.translate}" """
  if tagy.hidden != "":
    atributes.add "hidden "
  if unlikely(tagy.lang != ""):
    atributes.add fmt"""lang="{tagy.lang}" """
  if tagy.role != "":
    atributes.add fmt"""role="{tagy.role}" """
  if unlikely(tagy.spellcheck != ""):
    atributes.add "spellcheck "
  if tagy.onabort != "":
    atributes.add fmt"""onabort="{tagy.onabort}" """
  if tagy.onblur != "":
    atributes.add fmt"""onblur="{tagy.onblur}" """
  if tagy.oncancel != "":
    atributes.add fmt"""oncancel="{tagy.oncancel}" """
  if unlikely(tagy.oncanplay != ""):
    atributes.add fmt"""oncanplay="{tagy.oncanplay}" """
  if unlikely(tagy.oncanplaythrough != ""):
    atributes.add fmt"""oncanplaythrough="{tagy.oncanplaythrough}" """
  if tagy.onchange != "":
    atributes.add fmt"""onchange="{tagy.onchange}" """
  if tagy.onclick != "":
    atributes.add fmt"""onclick="{tagy.onclick}" """
  if unlikely(tagy.oncuechange != ""):
    atributes.add fmt"""oncuechange="{tagy.oncuechange}" """
  if tagy.ondblclick != "":
    atributes.add fmt"""ondblclick="{tagy.ondblclick}" """
  if tagy.ondurationchange != "":
    atributes.add fmt"""ondurationchange="{tagy.ondurationchange}" """
  if unlikely(tagy.onemptied != ""):
    atributes.add fmt"""onemptied="{tagy.onemptied}" """
  if tagy.onended != "":
    atributes.add fmt"""onended="{tagy.onended}" """
  if tagy.onerror != "":
    atributes.add fmt"""onerror="{tagy.onerror}" """
  if tagy.onfocus != "":
    atributes.add fmt"""onfocus="{tagy.onfocus}" """
  if tagy.oninput != "":
    atributes.add fmt"""oninput="{tagy.oninput}" """
  if tagy.oninvalid != "":
    atributes.add fmt"""oninvalid="{tagy.oninvalid}" """
  if tagy.onkeydown != "":
    atributes.add fmt"""onkeydown="{tagy.onkeydown}" """
  if tagy.onkeypress != "":
    atributes.add fmt"""onkeypress="{tagy.onkeypress}" """
  if tagy.onkeyup != "":
    atributes.add fmt"""onkeyup="{tagy.onkeyup}" """
  if tagy.onload != "":
    atributes.add fmt"""onload="{tagy.onload}" """
  if tagy.onloadeddata != "":
    atributes.add fmt"""onloadeddata="{tagy.onloadeddata}" """
  if unlikely(tagy.onloadedmetadata != ""):
    atributes.add fmt"""onloadedmetadata="{tagy.onloadedmetadata}" """
  if tagy.onloadstart != "":
    atributes.add fmt"""onloadstart="{tagy.onloadstart}" """
  if tagy.onmousedown != "":
    atributes.add fmt"""onmousedown="{tagy.onmousedown}" """
  if tagy.onmouseenter != "":
    atributes.add fmt"""onmouseenter="{tagy.onmouseenter}" """
  if tagy.onmouseleave != "":
    atributes.add fmt"""onmouseleave="{tagy.onmouseleave}" """
  if tagy.onmousemove != "":
    atributes.add fmt"""onmousemove="{tagy.onmousemove}" """
  if tagy.onmouseout != "":
    atributes.add fmt"""onmouseout="{tagy.onmouseout}" """
  if tagy.onmouseover != "":
    atributes.add fmt"""onmouseover="{tagy.onmouseover}" """
  if tagy.onmouseup != "":
    atributes.add fmt"""onmouseup="{tagy.onmouseup}" """
  if tagy.onmousewheel != "":
    atributes.add fmt"""onmousewheel="{tagy.onmousewheel}" """
  if tagy.onpause != "":
    atributes.add fmt"""onpause="{tagy.onpause}" """
  if unlikely(tagy.onplay != ""):
    atributes.add fmt"""onplay="{tagy.onplay}" """
  if unlikely(tagy.onplaying != ""):
    atributes.add fmt"""onplaying="{tagy.onplaying}" """
  if tagy.onprogress != "":
    atributes.add fmt"""onprogress="{tagy.onprogress}" """
  if unlikely(tagy.onratechange != ""):
    atributes.add fmt"""onratechange="{tagy.onratechange}" """
  if unlikely(tagy.onreset != ""):
    atributes.add fmt"""onreset="{tagy.onreset}" """
  if tagy.onresize != "":
    atributes.add fmt"""onresize="{tagy.onresize}" """
  if tagy.onscroll != "":
    atributes.add fmt"""onscroll="{tagy.onscroll}" """
  if unlikely(tagy.onseeked != ""):
    atributes.add fmt"""onseeked="{tagy.onseeked}" """
  if unlikely(tagy.onseeking != ""):
    atributes.add fmt"""onseeking="{tagy.onseeking}" """
  if tagy.onselect != "":
    atributes.add fmt"""onselect="{tagy.onselect}" """
  if tagy.onshow != "":
    atributes.add fmt"""onshow="{tagy.onshow}" """
  if unlikely(tagy.onstalled != ""):
    atributes.add fmt"""onstalled="{tagy.onstalled}" """
  if tagy.onsubmit != "":
    atributes.add fmt"""onsubmit="{tagy.onsubmit}" """
  if tagy.onsuspend != "":
    atributes.add fmt"""onsuspend="{tagy.onsuspend}" """
  if unlikely(tagy.ontimeupdate != ""):
    atributes.add fmt"""ontimeupdate="{tagy.ontimeupdate}" """
  if tagy.ontoggle != "":
    atributes.add fmt"""ontoggle="{tagy.ontoggle}" """
  if unlikely(tagy.onvolumechange != ""):
    atributes.add fmt"""onvolumechange="{tagy.onvolumechange}" """
  if tagy.onwaiting != "":
    atributes.add fmt"""onwaiting="{tagy.onwaiting}" """
  if unlikely(tagy.onafterprint != ""):
    atributes.add fmt"""onafterprint="{tagy.onafterprint}" """
  if unlikely(tagy.onbeforeprint != ""):
    atributes.add fmt"""onbeforeprint="{tagy.onbeforeprint}" """
  if tagy.onbeforeunload != "":
    atributes.add fmt"""onbeforeunload="{tagy.onbeforeunload}" """
  if unlikely(tagy.onhashchange != ""):
    atributes.add fmt"""onhashchange="{tagy.onhashchange}" """
  if tagy.onmessage != "":
    atributes.add fmt"""onmessage="{tagy.onmessage}" """
  if tagy.onoffline != "":
    atributes.add fmt"""onoffline="{tagy.onoffline}" """
  if tagy.ononline != "":
    atributes.add fmt"""ononline="{tagy.ononline}" """
  if unlikely(tagy.onpagehide != ""):
    atributes.add fmt"""onpagehide="{tagy.onpagehide}" """
  if unlikely(tagy.onpageshow != ""):
    atributes.add fmt"""onpageshow="{tagy.onpageshow}" """
  if unlikely(tagy.onpopstate != ""):
    atributes.add fmt"""onpopstate="{tagy.onpopstate}" """
  if unlikely(tagy.onstorage != ""):
    atributes.add fmt"""onstorage="{tagy.onstorage}" """
  if tagy.onunload != "":
    atributes.add fmt"""onunload="{tagy.onunload}" """
  if unlikely(tagy.onbounce != ""):
    atributes.add fmt"""onbounce="{tagy.onbounce}" """
  if tagy.onfinish != "":
    atributes.add fmt"""onfinish="{tagy.onfinish}" """
  if tagy.onstart != "":
    atributes.add fmt"""onstart="{tagy.onstart}" """
  if unlikely(tagy.disabled != ""):
    atributes.add "disabled "
  if tagy.crossorigin != "":
    atributes.add fmt"""crossorigin="{tagy.crossorigin}" """
  if unlikely(tagy.hreflang != ""):
    atributes.add fmt"""hreflang="{tagy.hreflang}" """
  if tagy.form != "":
    atributes.add fmt"""form="{tagy.form}" """
  if tagy.maxlength != "":
    atributes.add fmt"""maxlength="{tagy.maxlength}" """
  if tagy.minlength != "":
    atributes.add fmt"""minlength="{tagy.minlength}" """
  if tagy.placeholder != "":
    atributes.add fmt"""placeholder="{tagy.placeholder}" """
  if tagy.readonly != "":
    atributes.add "readonly "
  if tagy.required != "":
    atributes.add "required "
  if unlikely(tagy.coords != ""):
    atributes.add fmt"""coords="{tagy.coords}" """
  if unlikely(tagy.download != ""):
    atributes.add fmt"""download="{tagy.download}" """
  if tagy.href != "":
    atributes.add fmt"""href="{tagy.href}" """
  if tagy.rel != "":
    atributes.add fmt"""rel="{tagy.rel}" """
  if unlikely(tagy.shape != ""):
    atributes.add fmt"""shape="{tagy.shape}" """
  if tagy.target != "":
    atributes.add fmt"""target="{tagy.target}" """
  if tagy.preload != "":
    atributes.add fmt"""preload="{tagy.preload}" """
  if tagy.autoplay != "":
    atributes.add "autoplay "
  if unlikely(tagy.mediagroup != ""):
    atributes.add fmt"""mediagroup="{tagy.mediagroup}" """
  if unlikely(tagy.loop != ""):
    atributes.add fmt"""loop="{tagy.loop}" """
  if unlikely(tagy.muted != ""):
    atributes.add fmt"""muted="{tagy.muted}" """
  if unlikely(tagy.controls != ""):
    atributes.add "controls "
  if unlikely(tagy.poster != ""):
    atributes.add fmt"""poster="{tagy.poster}" """
  if tagy.open != "":
    atributes.add "open "
  if tagy.action != "":
    atributes.add fmt"""action="{tagy.action}" """
  if unlikely(tagy.enctype != ""):
    atributes.add fmt"""enctype="{tagy.enctype}" """
  if unlikely(tagy.novalidate != ""):
    atributes.add fmt"""novalidate="{tagy.novalidate}" """
  if unlikely(tagy.srcdoc != ""):
    atributes.add fmt"""srcdoc="{tagy.srcdoc}" """
  if unlikely(tagy.sandbox != ""):
    atributes.add fmt"""sandbox="{tagy.sandbox}" """
  if unlikely(tagy.usemap != ""):
    atributes.add fmt"""usemap="{tagy.usemap}" """
  if unlikely(tagy.ismap != ""):
    atributes.add fmt"""ismap="{tagy.ismap}" """
  if tagy.accept != "":
    atributes.add fmt"""accept="{tagy.accept}" """
  if tagy.alt != "":
    atributes.add fmt"""alt="{tagy.alt}" """
  if tagy.autocomplete != "":
    atributes.add "autocomplete "
  if tagy.autofocus != "":
    atributes.add "autofocus "
  if tagy.checked != "":
    atributes.add "checked "
  if tagy.dirname != "":
    atributes.add fmt"""dirname="{tagy.dirname}" """
  if tagy.formaction != "":
    atributes.add fmt"""formaction="{tagy.formaction}" """
  if tagy.formenctype != "":
    atributes.add fmt"""formenctype="{tagy.formenctype}" """
  if tagy.formmethod != "":
    atributes.add fmt"""formmethod="{tagy.formmethod}" """
  if unlikely(tagy.formnovalidate != ""):
    atributes.add fmt"""formnovalidate="{tagy.formnovalidate}" """
  if tagy.formtarget != "":
    atributes.add fmt"""formtarget="{tagy.formtarget}" """
  if tagy.inputmode != "":
    atributes.add fmt"""inputmode="{tagy.inputmode}" """
  if unlikely(tagy.list != ""):
    atributes.add fmt"""list="{tagy.list}" """
  if unlikely(tagy.max != ""):
    atributes.add fmt"""max="{tagy.max}" """
  if unlikely(tagy.min != ""):
    atributes.add fmt"""min="{tagy.min}" """
  if unlikely(tagy.multiple != ""):
    atributes.add fmt"""multiple="{tagy.multiple}" """
  if unlikely(tagy.pattern != ""):
    atributes.add fmt"""pattern="{tagy.pattern}" """
  if tagy.size != "":
    atributes.add fmt"""size="{tagy.size}" """
  if tagy.step != "":
    atributes.add fmt"""step="{tagy.step}" """
  if tagy.`type` != "":
    atributes.add fmt"""type="{tagy.`type`}" """
  if tagy.value != "":
    atributes.add fmt"""value="{tagy.value}" """
  if tagy.`for` != "":
    atributes.add fmt"""for="{tagy.`for`}" """
  if tagy.`async` != "":
    atributes.add "async "
  if tagy.`defer` != "":
    atributes.add "defer "
  if unlikely(tagy.behavior != ""):
    atributes.add fmt"""behavior="{tagy.behavior}" """
  if unlikely(tagy.bgcolor != ""):
    atributes.add fmt"""bgcolor="{tagy.bgcolor}" """
  if unlikely(tagy.direction != ""):
    atributes.add fmt"""direction="{tagy.direction}" """
  if unlikely(tagy.hspace != ""):
    atributes.add fmt"""hspace="{tagy.hspace}" """
  if unlikely(tagy.scrollamount != ""):
    atributes.add fmt"""scrollamount="{tagy.scrollamount}" """
  if unlikely(tagy.scrolldelay != ""):
    atributes.add fmt"""scrolldelay="{tagy.scrolldelay}" """
  if unlikely(tagy.truespeed != ""):
    atributes.add fmt"""truespeed="{tagy.truespeed}" """
  if unlikely(tagy.vspace != ""):
    atributes.add fmt"""vspace="{tagy.vspace}" """
  if unlikely(tagy.optimum != ""):
    atributes.add fmt"""optimum="{tagy.optimum}" """
  if tagy.selected != "":
    atributes.add "selected "
  if tagy.colspan != "":
    atributes.add fmt"""colspan="{tagy.colspan}" """
  if tagy.rowspan != "":
    atributes.add fmt"""rowspan="{tagy.rowspan}" """
  if tagy.headers != "":
    atributes.add fmt"""headers="{tagy.headers}" """
  if tagy.cols != "":
    atributes.add fmt"""cols="{tagy.cols}" """
  if tagy.rows != "":
    atributes.add fmt"""rows="{tagy.rows}" """
  if tagy.wrap != "":
    atributes.add fmt"""wrap="{tagy.wrap}" """
  result =
    when defined(release): atributes.join.strip(trailing=true)
    else:                  atributes.join

func render(this: HtmlNode): string {.discardable.} =
  ## Render the HtmlNode to String,tag-by-tag,Bulma & Spectre support added here
  let atributos = attributter(this)
  case this.kind:
  of nkhtml:
    result =
      when defined(release): "<!DOCTYPE html>" & fmt"<html class='has-navbar-fixed-top'{atributos}>"
      else: "<!DOCTYPE html>\n  " & fmt"<html class='has-navbar-fixed-top'{atributos}>" & "\n"
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
      when defined(release): fmt"<meta{atributos}>"
      else: fmt"<meta {atributos}>" & "\n"
  of nkbody:
    result =
      when defined(release): fmt"<body class='has-navbar-fixed-top'{atributos}>"
      else: fmt"<body class='has-navbar-fixed-top'{atributos}>" & "\n"
  of nkArticle:
    result =
      when defined(release): fmt"<article class='message'{atributos}>"
      else: fmt"<article class='message'{atributos}>" & "\n"
  of nkButton:
    result =
      when defined(release): fmt"<button class='button is-light is-rounded btn tooltip'{atributos}>"
      else: fmt"<button class='button is-light is-rounded btn tooltip'{atributos}>" & "\n"
  of nkDetails:
    result =
      when defined(release): fmt"<details class='message is-dark'{atributos}>"
      else: fmt"<details class='message is-dark'{atributos}>" & "\n"
  of nkDialog:
    result =
      when defined(release): fmt"<dialog class='notification is-rounded modal'{atributos}>"
      else: fmt"<dialog class='notification is-rounded modal'{atributos}>" & "\n"
  of nkFooter:
    result =
      when defined(release): fmt"<footer class='footer is-fullwidth'{atributos}>"
      else: fmt"<footer class='footer is-fullwidth'{atributos}>" & "\n"
  of nkH1:
    result =
      when defined(release): fmt"<h1 class='title'{atributos}>"
      else: fmt"<h1 class='title'{atributos}>" & "\n"
  of nkImg:
    result =
      when defined(release): fmt"<img class='image img-responsive'{atributos}\>"
      else: fmt"<img class='image img-responsive'{atributos}\>" & "\n"
  of nkLabel:
    result =
      when defined(release): fmt"<label class='label form-label'{atributos}>"
      else: fmt"<label class='label form-label'{atributos}>" & "\n"
  of nkMeter:
    result =
      when defined(release): fmt"<meter class='progress is-small bar-item' role='progressbar'{atributos}>"
      else: fmt"<meter class='progress is-small bar-item' role='progressbar'{atributos}>" & "\n"
  of nkComment:
    result =
      when defined(release): "<!-- " & this.text.strip
      else: "\n\n<!--  " & this.text
  else:
    var tagy = $this.kind
    tagy = tagy.replace("nk", "").toLowerAscii
    result =
      when defined(release): fmt"<{tagy}{atributos}>{this.text}</{tagy}>"
      else: fmt"<{tagy}{atributos}>{this.text}</{tagy}>" & "\n"

func close(this: HtmlNode): string {.discardable.} =
  ## Render the Closing tag of each HtmlNode to String, tag-by-tag.
  case this.kind:
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

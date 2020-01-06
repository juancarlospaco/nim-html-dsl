import strutils

const basicHeadTags =
  when defined(release): """<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">"""
  else: """
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
  """  ## Basic meta tags that all frameworks recommend nowadays.

type HtmlNodeKind = enum  ## All HTML Tags, taken from Mozilla docs, +Comment.
  nkA = "a", nkAbbr = "abbr",  nkAddress = "address", nkArea = "area",
  nkArticle = "article", nkAside = "aside", nkAudio = "audio", nkB = "b",
  nkBase = "base", nkBdi = "bdi", nkBdo = "bdo", nkBig = "big",
  nkBlockquote = "blockquote", nkBody = "body", nkBr = "br",
  nkButton = "button", nkCanvas = "canvas", nkCaption = "caption",
  nkCenter = "center", nkCite = "cite", nkCode = "code", nkCol = "col",
  nkColgroup = "colgroup", nkData = "data", nkDatalist = "datalist",
  nkDd = "dd", nkDel = "del", nkDetails = "details", nkDfn = "dfn",
  nkDialog = "dialog", nkDiv = "div", nkDl = "dl", nkDt = "dt", nkEm = "em",
  nkEmbed = "embed", nkFieldset = "fieldset", nkFigure = "figure",
  nkFigcaption = "figcaption", nkFooter = "footer", nkForm = "form",
  nkH1 = "h1", nkH2 = "h2", nkH3 = "h3", nkH4 = "h4", nkH5 = "h5", nkH6 = "h6",
  nkHead = "head", nkHeader = "header", nkHtml = "html", nkHr = "hr",
  nkI = "i", nkIframe = "iframe", nkImg = "img", nkInput = "input",
  nkIns = "ins", nkKbd = "kbd", nkKeygen = "leygen", nkLabel = "label",
  nkLegend = "legend", nkLi = "li", nkLink = "link", nkMain = "main",
  nkMap = "map", nkMark = "mark", nkMarquee = "marquee", nkMeta = "meta",
  nkMeter = "meter", nkNav = "nav", nkNoscript = "noscript",
  nkObject = "object", nkOl = "ol", nkOptgroup = "optgroup",
  nkOption = "option", nkOutput = "output", nkP = "p", nkParam = "param",
  nkPicture = "picture", nkPre = "pre", nkProgress = "progress", nkQ = "q",
  nkRb = "rb", nkRp = "rp", nkRt = "rt", nkRtc = "rtc", nkRuby = "ruby",
  nkS = "s", nkSamp = "samp", nkScript = "script", nkSection = "section",
  nkSelect = "select", nkSlot = "slot", nkSmall = "small", nkSource = "source",
  nkSpan = "span", nkStrong = "strong", nkStyle = "style", nkSub = "sub",
  nkSummary = "summary", nkSup = "sup", nkTable = "table", nkTbody = "tbody",
  nkTd = "td", nkTemplate = "template", nkTextarea = "textarea",
  nkTfoot = "tfoot", nkTh = "th", nkThead = "thead", nkTime = "time",
  nkTitle = "title", nkTr = "tr", nkTrack = "track", nkTt = "tt", nkU = "u",
  nkUl = "ul", nkVar = "var", nkVideo = "video", nkWbr = "wbr", nkComment

type HtmlNode = ref object  ## HTML Tag Object type, all possible attributes.
  contenteditable: bool
  width, height: Natural
  id, class, name, accesskey, src, tabindex, translate, hidden, httpequiv, lang, role, spellcheck: string
  onabort, onblur, oncancel, oncanplay, oncanplaythrough, onchange, onclick, oncuechange, ondblclick: string
  ondurationchange, onemptied, onended, onerror, onfocus, oninput, oninvalid, onkeydown, onkeypress: string
  onkeyup, onload, onloadeddata, onloadedmetadata, onloadstart, onmousedown, onmouseenter, onmouseleave: string
  onmousemove, onmouseout, onmouseover, onmouseup, onmousewheel, onpause, onplay, onplaying, onprogress: string
  onratechange, onreset, onresize, onscroll, onseeked, onseeking, onselect, onshow, onstalled, onsubmit: string
  onsuspend, ontimeupdate, ontoggle, onvolumechange, onwaiting, disabled, crossorigin, hreflang, form: string
  maxlength, minlength, placeholder, readonly, required, coords, download, href, rel, shape, target: string
  preload, autoplay, mediagroup, loop, muted, controls, poster, onafterprint, onbeforeprint, onbeforeunload: string
  onhashchange, onmessage, onoffline, ononline, onpagehide, onpageshow, onpopstate, onstorage, onunload: string
  open, action, enctype, novalidate, srcdoc, sandbox, usemap, ismap, accept, alt, autocomplete, autofocus: string
  checked, dirname, formaction, formenctype, formmethod, formnovalidate, formtarget, inputmode, list: string
  max, min, multiple, pattern, size, step, value, text, val, content, behavior, bgcolor, direction, hspace: string
  scrollamount, scrolldelay, truespeed, vspace, onbounce, onfinish, onstart, optimum, selected, colspan: string
  rowspan, headers, cols, rows, wrap, integrity, media, referrerpolicy, sizes : string
  `type`, `for`, `async`, `defer`: string
  case kind: HtmlNodeKind  # Some tags have unique attributes.
  of nkHtml: head, body: HtmlNode
  of nkHead:
    title: HtmlNode
    meta, link: seq[HtmlNode]
  else: children: seq[HtmlNode]

func `$`*(this: HtmlNode): string =
  ## Stringify an ``HtmlNode``.
  result = $this.kind & ": "
  if this.children.len > 0:
    for tag in this.children: result &= "\n" & $tag

func attributter(t: HtmlNode): string =
  ## Render to string all attributtes for all HTML tags. Uses Branch Prediction.
  var x = @[" "]
  if t.hidden.len > 0:              x.add "hidden "
  if t.spellcheck.len > 0:          x.add "spellcheck "
  if unlikely(t.disabled.len > 0):  x.add "disabled "
  if t.readonly.len > 0:            x.add "readonly "
  if t.required.len > 0:            x.add "required "
  if t.autoplay.len > 0:            x.add "autoplay "
  if unlikely(t.controls.len > 0):  x.add "controls "
  if t.autocomplete.len > 0:        x.add "autocomplete "
  if t.autofocus.len > 0:           x.add "autofocus "
  if t.checked.len > 0:             x.add "checked "
  if t.open.len > 0:                x.add "open "
  if t.`async`.len > 0:             x.add "async "
  if t.`defer`.len > 0:             x.add "defer "
  if t.selected.len > 0:            x.add "selected "
  if unlikely(t.width != 0):        x.add "width=\""            & $t.width           & "\" "
  if unlikely(t.height != 0):       x.add "width='"             & $t.height          & "\" "
  if t.id.len > 0:                  x.add "id=\""               & t.id               & "\" "
  if t.class.len > 0:               x.add "class=\""            & t.class            & "\" "
  if t.name.len > 0:                x.add "name=\""             & t.name             & "\" "
  if unlikely(t.accesskey.len > 0): x.add "accesskey=\""        & t.accesskey        & "\" "
  if t.src.len > 0:                 x.add "src=\""              & t.src              & "\" "
  if unlikely(t.tabindex.len > 0):  x.add "tabindex=\""         & t.tabindex         & "\" "
  if unlikely(t.translate.len > 0): x.add "translate=\""        & t.translate        & "\" "
  if unlikely(t.lang.len > 0):      x.add "lang=\""             & t.lang             & "\" "
  if t.role.len > 0:                x.add "role=\""             & t.role             & "\" "
  if t.onabort.len > 0:             x.add "onabort=\""          & t.onabort          & "\" "
  if t.onblur.len > 0:              x.add "onblur=\""           & t.onblur           & "\" "
  if t.oncancel.len > 0:            x.add "oncancel=\""         & t.oncancel         & "\" "
  if unlikely(t.oncanplay.len > 0): x.add "oncanplay=\""        & t.oncanplay        & "\" "
  if t.oncanplaythrough.len > 0:    x.add "oncanplaythrough=\"" & t.oncanplaythrough & "\" "
  if t.onchange.len > 0:            x.add "onchange=\""         & t.onchange         & "\" "
  if t.onclick.len > 0:             x.add "onclick=\""          & t.onclick          & "\" "
  if t.oncuechange.len > 0:         x.add "oncuechange=\""      & t.oncuechange      & "\" "
  if t.ondblclick.len > 0:          x.add "ondblclick=\""       & t.ondblclick       & "\" "
  if t.ondurationchange.len > 0:    x.add "ondurationchange=\"" & t.ondurationchange & "\" "
  if unlikely(t.onemptied.len > 0): x.add "onemptied=\""        & t.onemptied        & "\" "
  if t.onended.len > 0:             x.add "onended=\""          & t.onended          & "\" "
  if t.onerror.len > 0:             x.add "onerror=\""          & t.onerror          & "\" "
  if t.onfocus.len > 0:             x.add "onfocus=\""          & t.onfocus          & "\" "
  if t.oninput.len > 0:             x.add "oninput=\""          & t.oninput          & "\" "
  if t.oninvalid.len > 0:           x.add "oninvalid=\""        & t.oninvalid        & "\" "
  if t.onkeydown.len > 0:           x.add "onkeydown=\""        & t.onkeydown        & "\" "
  if t.onkeypress.len > 0:          x.add "onkeypress=\""       & t.onkeypress       & "\" "
  if t.onkeyup.len > 0:             x.add "onkeyup=\""          & t.onkeyup          & "\" "
  if t.onload.len > 0:              x.add "onload=\""           & t.onload           & "\" "
  if t.onloadeddata.len > 0:        x.add "onloadeddata=\""     & t.onloadeddata     & "\" "
  if t.onloadedmetadata.len > 0:    x.add "onloadedmetadata=\"" & t.onloadedmetadata & "\" "
  if t.onloadstart.len > 0:         x.add "onloadstart=\""      & t.onloadstart      & "\" "
  if t.onmousedown.len > 0:         x.add "onmousedown=\""      & t.onmousedown      & "\" "
  if t.onmouseenter.len > 0:        x.add "onmouseenter=\""     & t.onmouseenter     & "\" "
  if t.onmouseleave.len > 0:        x.add "onmouseleave=\""     & t.onmouseleave     & "\" "
  if t.onmousemove.len > 0:         x.add "onmousemove=\""      & t.onmousemove      & "\" "
  if t.onmouseout.len > 0:          x.add "onmouseout=\""       & t.onmouseout       & "\" "
  if t.onmouseover.len > 0:         x.add "onmouseover=\""      & t.onmouseover      & "\" "
  if t.onmouseup.len > 0:           x.add "onmouseup=\""        & t.onmouseup        & "\" "
  if t.onmousewheel.len > 0:        x.add "onmousewheel=\""     & t.onmousewheel     & "\" "
  if t.onpause.len > 0:             x.add "onpause=\""          & t.onpause          & "\" "
  if unlikely(t.onplay.len > 0):    x.add "onplay=\""           & t.onplay           & "\" "
  if unlikely(t.onplaying.len > 0): x.add "onplaying=\""        & t.onplaying        & "\" "
  if t.onprogress.len > 0:          x.add "onprogress=\""       & t.onprogress       & "\" "
  if t.onratechange.len > 0:        x.add "onratechange=\""     & t.onratechange     & "\" "
  if unlikely(t.onreset.len > 0):   x.add "onreset=\""          & t.onreset          & "\" "
  if t.onresize.len > 0:            x.add "onresize=\""         & t.onresize         & "\" "
  if t.onscroll.len > 0:            x.add "onscroll=\""         & t.onscroll         & "\" "
  if unlikely(t.onseeked.len > 0):  x.add "onseeked=\""         & t.onseeked         & "\" "
  if unlikely(t.onseeking.len > 0): x.add "onseeking=\""        & t.onseeking        & "\" "
  if t.onselect.len > 0:            x.add "onselect=\""         & t.onselect         & "\" "
  if t.onshow.len > 0:              x.add "onshow=\""           & t.onshow           & "\" "
  if unlikely(t.onstalled.len > 0): x.add "onstalled=\""        & t.onstalled        & "\" "
  if t.onsubmit.len > 0:            x.add "onsubmit=\""         & t.onsubmit         & "\" "
  if t.onsuspend.len > 0:           x.add "onsuspend=\""        & t.onsuspend        & "\" "
  if t.ontimeupdate.len > 0:        x.add "ontimeupdate=\""     & t.ontimeupdate     & "\" "
  if t.ontoggle.len > 0:            x.add "ontoggle=\""         & t.ontoggle         & "\" "
  if t.onvolumechange.len > 0:      x.add "onvolumechange=\""   & t.onvolumechange   & "\" "
  if t.onwaiting.len > 0:           x.add "onwaiting=\""        & t.onwaiting        & "\" "
  if t.onafterprint.len > 0:        x.add "onafterprint=\""     & t.onafterprint     & "\" "
  if t.onbeforeprint.len > 0:       x.add "onbeforeprint=\""    & t.onbeforeprint    & "\" "
  if t.onbeforeunload.len > 0:      x.add "onbeforeunload=\""   & t.onbeforeunload   & "\" "
  if t.onhashchange.len > 0:        x.add "onhashchange=\""     & t.onhashchange     & "\" "
  if t.onmessage.len > 0:           x.add "onmessage=\""        & t.onmessage        & "\" "
  if t.onoffline.len > 0:           x.add "onoffline=\""        & t.onoffline        & "\" "
  if t.ononline.len > 0:            x.add "ononline=\""         & t.ononline         & "\" "
  if t.onpagehide.len > 0:          x.add "onpagehide=\""       & t.onpagehide       & "\" "
  if t.onpageshow.len > 0:          x.add "onpageshow=\""       & t.onpageshow       & "\" "
  if t.onpopstate.len > 0:          x.add "onpopstate=\""       & t.onpopstate       & "\" "
  if unlikely(t.onstorage.len > 0): x.add "onstorage=\""        & t.onstorage        & "\" "
  if t.onunload.len > 0:            x.add "onunload=\""         & t.onunload         & "\" "
  if unlikely(t.onbounce.len > 0):  x.add "onbounce=\""         & t.onbounce         & "\" "
  if t.onfinish.len > 0:            x.add "onfinish=\""         & t.onfinish         & "\" "
  if t.onstart.len > 0:             x.add "onstart=\""          & t.onstart          & "\" "
  if t.crossorigin.len > 0:         x.add "crossorigin=\""      & t.crossorigin      & "\" "
  if unlikely(t.hreflang.len > 0):  x.add "hreflang=\""         & t.hreflang         & "\" "
  if t.form.len > 0:                x.add "form=\""             & t.form             & "\" "
  if t.maxlength.len > 0:           x.add "maxlength=\""        & t.maxlength        & "\" "
  if t.minlength.len > 0:           x.add "minlength=\""        & t.minlength        & "\" "
  if t.placeholder.len > 0:         x.add "placeholder=\""      & t.placeholder      & "\" "
  if unlikely(t.coords.len > 0):    x.add "coords=\""           & t.coords           & "\" "
  if unlikely(t.download.len > 0):  x.add "download=\""         & t.download         & "\" "
  if t.href.len > 0:                x.add "href=\""             & t.href             & "\" "
  if t.rel.len > 0:                 x.add "rel=\""              & t.rel              & "\" "
  if unlikely(t.shape.len > 0):     x.add "shape=\""            & t.shape            & "\" "
  if t.target.len > 0:              x.add "target=\""           & t.target           & "\" "
  if t.preload.len > 0:             x.add "preload=\""          & t.preload          & "\" "
  if t.mediagroup.len > 0:          x.add "mediagroup=\""       & t.mediagroup       & "\" "
  if unlikely(t.loop.len > 0):      x.add "loop=\""             & t.loop             & "\" "
  if unlikely(t.muted.len > 0):     x.add "muted=\""            & t.muted            & "\" "
  if unlikely(t.poster.len > 0):    x.add "poster=\""           & t.poster           & "\" "
  if t.action.len > 0:              x.add "action=\""           & t.action           & "\" "
  if unlikely(t.enctype.len > 0):   x.add "enctype=\""          & t.enctype          & "\" "
  if t.novalidate.len > 0:          x.add "novalidate=\""       & t.novalidate       & "\" "
  if unlikely(t.srcdoc.len > 0):    x.add "srcdoc=\""           & t.srcdoc           & "\" "
  if unlikely(t.sandbox.len > 0):   x.add "sandbox=\""          & t.sandbox          & "\" "
  if unlikely(t.usemap.len > 0):    x.add "usemap=\""           & t.usemap           & "\" "
  if unlikely(t.ismap.len > 0):     x.add "ismap=\""            & t.ismap            & "\" "
  if t.accept.len > 0:              x.add "accept=\""           & t.accept           & "\" "
  if t.alt.len > 0:                 x.add "alt=\""              & t.alt              & "\" "
  if t.dirname.len > 0:             x.add "dirname=\""          & t.dirname          & "\" "
  if t.formaction.len > 0:          x.add "formaction=\""       & t.formaction       & "\" "
  if t.formenctype.len > 0:         x.add "formenctype=\""      & t.formenctype      & "\" "
  if t.formmethod.len > 0:          x.add "formmethod=\""       & t.formmethod       & "\" "
  if t.formnovalidate.len > 0:      x.add "formnovalidate=\""   & t.formnovalidate   & "\" "
  if t.formtarget.len > 0:          x.add "formtarget=\""       & t.formtarget       & "\" "
  if t.inputmode.len > 0:           x.add "inputmode=\""        & t.inputmode        & "\" "
  if unlikely(t.list.len > 0):      x.add "list=\""             & t.list             & "\" "
  if unlikely(t.max.len > 0):       x.add "max=\""              & t.max              & "\" "
  if unlikely(t.min.len > 0):       x.add "min=\""              & t.min              & "\" "
  if unlikely(t.multiple.len > 0):  x.add "multiple=\""         & t.multiple         & "\" "
  if unlikely(t.pattern.len > 0):   x.add "pattern=\""          & t.pattern          & "\" "
  if t.size.len > 0:                x.add "size=\""             & t.size             & "\" "
  if t.step.len > 0:                x.add "step=\""             & t.step             & "\" "
  if t.`type`.len > 0:              x.add "type=\""             & t.`type`           & "\" "
  if t.value.len > 0:               x.add "value=\""            & t.value            & "\" "
  if t.`for`.len > 0:               x.add "for=\""              & t.`for`            & "\" "
  if unlikely(t.behavior.len > 0):  x.add "behavior=\""         & t.behavior         & "\" "
  if unlikely(t.bgcolor.len > 0):   x.add "bgcolor=\""          & t.bgcolor          & "\" "
  if unlikely(t.direction.len > 0): x.add "direction=\""        & t.direction        & "\" "
  if unlikely(t.hspace.len > 0):    x.add "hspace=\""           & t.hspace           & "\" "
  if t.scrollamount.len > 0:        x.add "scrollamount=\""     & t.scrollamount     & "\" "
  if t.scrolldelay.len > 0:         x.add "scrolldelay=\""      & t.scrolldelay      & "\" "
  if unlikely(t.truespeed.len > 0): x.add "truespeed=\""        & t.truespeed        & "\" "
  if unlikely(t.vspace.len > 0):    x.add "vspace=\""           & t.vspace           & "\" "
  if unlikely(t.optimum.len > 0):   x.add "optimum=\""          & t.optimum          & "\" "
  if t.colspan.len > 0:             x.add "colspan=\""          & t.colspan          & "\" "
  if t.rowspan.len > 0:             x.add "rowspan=\""          & t.rowspan          & "\" "
  if t.headers.len > 0:             x.add "headers=\""          & t.headers          & "\" "
  if t.cols.len > 0:                x.add "cols=\""             & t.cols             & "\" "
  if t.rows.len > 0:                x.add "rows=\""             & t.rows             & "\" "
  if t.wrap.len > 0:                x.add "wrap=\""             & t.wrap             & "\" "
  if t.httpequiv.len > 0:           x.add "http-equiv=\""       & t.httpequiv        & "\" "
  if t.content.len > 0:             x.add "content=\""          & t.content          & "\" "
  if t.integrity.len > 0:           x.add "integrity=\""        & t.integrity        & "\" "
  if t.media.len > 0:               x.add "media=\""            & t.media            & "\" "
  if t.referrerpolicy.len > 0:      x.add "referrerpolicy=\""   & t.referrerpolicy   & "\" "
  if t.sizes.len > 0:               x.add "sizes=\""            & t.sizes            & "\" "
  when not defined(release):  # No one uses contenteditable on Prod.
    if unlikely(t.contenteditable): x.add """contenteditable="true" """
  result = x.join.strip(leading=false)

func openTag(this: HtmlNode): string {.discardable.} =
  ## Render the HtmlNode to String,tag-by-tag,Bulma & Spectre support added here
  let atributos = if this.kind notin [nkHtml, nkHead, nkTitle, nkBody, nkComment]: attributter(this) else: ""
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
    result = when defined(release): "" else: "\n\n<!--  " & this.text & "  -->\n\n"
  else:
    debugEcho "openTag() else: " & $this.kind
    result = "<" & $this.kind & atributos & ">" & this.text

func closeTag(this: HtmlNode): string {.inline, discardable.} =
  ## Render the Closing tag of each HtmlNode to String, tag-by-tag.
  case this.kind
  of nkHtml:    result = when defined(release): "</html>" else: "</html>\n<!-- Nim " & NimVersion & " -->\n"
  of nkComment: result = when defined(release): "" else: "  -->\n\n"
  of nkTitle, nkMeta, nkLink, nkImg, nkInput, nkBr, nkHr: result = ""  # These tags dont need Closing Tag.
  else: result = when defined(release): "</" & $this.kind & ">" else: "</" & $this.kind & ">\n"

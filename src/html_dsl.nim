import macros except body
import strutils

type
  HtmlNodeKind = enum  ## All HTML Tags, taken from Mozilla docs, +Comment.
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
    nkIns = "ins", nkKbd = "kbd", nkKeygen = "keygen", nkLabel = "label",
    nkLegend = "legend", nkLi = "li", nkLink = "link", nkMain = "main",
    nkMap = "map", nkMark = "mark", nkMarquee = "marquee", nkMeta = "meta",
    nkMeter = "meter", nkNav = "nav", nkNoscript = "noscript",
    nkOl = "ol", nkOptgroup = "optgroup", nkOption = "option",
    nkOutput = "output", nkP = "p", nkParam = "param", nkPicture = "picture",
    nkPre = "pre", nkProgress = "progress", nkQ = "q", nkRb = "rb", nkRp = "rp",
    nkRt = "rt", nkRtc = "rtc", nkRuby = "ruby", nkS = "s", nkSamp = "samp",
    nkScript = "script", nkSection = "section", nkSelect = "select",
    nkSlot = "slot", nkSmall = "small", nkSource = "source", nkSpan = "span",
    nkStrong = "strong", nkStyle = "style", nkSub = "sub", nkSummary = "summary",
    nkSup = "sup", nkTable = "table", nkTbody = "tbody", nkTd = "td",
    nkTextarea = "textarea", nkTfoot = "tfoot", nkTh = "th", nkThead = "thead",
    nkTime = "time", nkTitle = "title", nkTr = "tr", nkTrack = "track",
    nkTt = "tt", nkU = "u", nkUl = "ul", nkVideo = "video", nkWbr = "wbr", nkComment
  HtmlNode = ref object  ## HTML Tag Object type, all possible attributes.
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
    rowspan, headers, cols, rows, wrap, integrity, media, referrerpolicy, sizes, `type`, `for`, `async`, `defer`: string
    case kind: HtmlNodeKind  # Some tags have unique attributes.
    of nkHtml: head, body: HtmlNode
    of nkHead:
      title: HtmlNode
      meta, link: seq[HtmlNode]
    else: children: seq[HtmlNode]

const
  basicHeadTags = """<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">"""
  procTemplate = """func $1*(text = "", val = "", contenteditable = false, width = 0, height = 0,
  id = "", class = "", name = "", accesskey = "", src = "", tabindex = "",
  translate = "", hidden = "", httpequiv = "", lang = "", role = "",
  spellcheck = "", onabort = "", onblur = "", oncancel = "", oncanplay = "",
  oncanplaythrough = "", onchange = "", onclick = "", oncuechange = "",
  ondblclick = "", ondurationchange = "", onemptied = "", onended = "",
  onerror = "", onfocus = "", oninput = "", oninvalid = "", onkeydown = "",
  onkeypress = "", onkeyup = "", onload = "", onloadeddata = "",
  onloadedmetadata = "", onloadstart = "", onmousedown = "",
  onmouseenter = "", onmouseleave = "", onmousemove = "", onmouseout = "",
  onmouseover = "", onmouseup = "", onmousewheel = "", onpause = "",
  onplay = "", onplaying = "", onprogress = "", onratechange = "",
  onreset = "", onresize = "", onscroll = "", onseeked = "", onseeking = "",
  onselect = "", onshow = "", onstalled = "", onsubmit = "", onsuspend = "",
  ontimeupdate = "", ontoggle = "", onvolumechange = "", onwaiting = "",
  disabled = "", crossorigin = "", hreflang = "", form = "", maxlength = "",
  minlength = "", placeholder = "", readonly = "", required = "",
  coords = "", download = "", href = "", rel = "", shape = "", target = "",
  preload = "", autoplay = "", mediagroup = "", loop = "", muted = "",
  controls = "", poster = "", onafterprint = "", onbeforeprint = "",
  onbeforeunload = "", onhashchange = "", onmessage = "", onoffline = "",
  ononline = "", onpagehide = "", onpageshow = "", onpopstate = "",
  onstorage = "", onunload = "", open = "", action = "", enctype = "",
  novalidate = "", srcdoc = "", sandbox = "", usemap = "", ismap = "",
  accept = "", alt = "", autocomplete = "", autofocus = "", checked = "",
  dirname = "", formaction = "", formenctype = "", formmethod = "",
  formnovalidate = "", formtarget = "", inputmode = "", list = "", max = "",
  min = "", multiple = "", pattern = "", size = "", step = "", value = "",
  content = "", behavior = "", bgcolor = "", direction = "", hspace = "",
  scrollamount = "", scrolldelay = "", truespeed = "", vspace = "", onbounce = "",
  onfinish = "", onstart = "", optimum = "", selected = "", colspan = "",
  rowspan = "", headers = "", cols = "", rows = "", wrap = "", integrity = "",
  media = "", referrerpolicy = "", sizes = "", `type` = "", `for` = "", `async` = "",
  `defer` = "", children: varargs[HtmlNode]): HtmlNode {.inline.} = HtmlNode(kind: nk_$1,
  text: text, val: val, contenteditable: contenteditable, width: width, height: height,
  id: id, class: class, name: name, accesskey: accesskey, src: src, tabindex: tabindex,
  translate: translate, hidden: hidden, httpequiv: httpequiv, lang: lang, role: role,
  spellcheck: spellcheck, onabort: onabort, onblur: onblur, oncancel: oncancel, oncanplay: oncanplay,
  oncanplaythrough: oncanplaythrough, onchange: onchange, onclick: onclick, oncuechange: oncuechange,
  ondblclick: ondblclick, ondurationchange: ondurationchange, onemptied: onemptied, onended: onended,
  onerror: onerror, onfocus: onfocus, oninput: oninput, oninvalid: oninvalid, onkeydown: onkeydown,
  onkeypress: onkeypress, onkeyup: onkeyup, onload: onload, onloadeddata: onloadeddata,
  onloadedmetadata: onloadedmetadata, onloadstart: onloadstart, onmousedown: onmousedown,
  onmouseenter: onmouseenter, onmouseleave: onmouseleave, onmousemove: onmousemove, onmouseout: onmouseout,
  onmouseover: onmouseover, onmouseup: onmouseup, onmousewheel: onmousewheel, onpause: onpause,
  onplay: onplay, onplaying: onplaying, onprogress: onprogress, onratechange: onratechange,
  onreset: onreset, onresize: onresize, onscroll: onscroll, onseeked: onseeked, onseeking: onseeking,
  onselect: onselect, onshow: onshow, onstalled: onstalled, onsubmit: onsubmit, onsuspend: onsuspend,
  ontimeupdate: ontimeupdate, ontoggle: ontoggle, onvolumechange: onvolumechange, onwaiting: onwaiting,
  disabled: disabled, crossorigin: crossorigin, hreflang: hreflang, form: form, maxlength: maxlength,
  minlength: minlength, placeholder: placeholder, readonly: readonly, required: required,
  coords: coords, download: download, href: href, rel: rel, shape: shape, target: target,
  preload: preload, autoplay: autoplay, mediagroup: mediagroup, loop: loop, muted: muted,
  controls: controls, poster: poster, onafterprint: onafterprint, onbeforeprint: onbeforeprint,
  onbeforeunload: onbeforeunload, onhashchange: onhashchange, onmessage: onmessage, onoffline: onoffline,
  ononline: ononline, onpagehide: onpagehide, onpageshow: onpageshow, onpopstate: onpopstate,
  onstorage: onstorage, onunload: onunload, open: open, action: action, enctype: enctype,
  novalidate: novalidate, srcdoc: srcdoc, sandbox: sandbox, usemap: usemap, ismap: ismap,
  accept: accept, alt: alt, autocomplete: autocomplete, autofocus: autofocus, checked: checked,
  dirname: dirname, formaction: formaction, formenctype: formenctype, formmethod: formmethod,
  formnovalidate: formnovalidate, formtarget: formtarget, inputmode: inputmode, list: list, max: max,
  min: min, multiple: multiple, pattern: pattern, size: size, step: step, value: value,
  content: content, behavior: behavior, bgcolor: bgcolor, direction: direction,
  hspace: hspace, scrollamount: scrollamount, scrolldelay: scrolldelay,
  truespeed: truespeed, vspace: vspace, onbounce: onbounce, onfinish: onfinish,
  onstart: onstart, optimum: optimum, selected: selected, colspan: colspan,
  rowspan: rowspan, headers: headers, cols: cols, rows: rows, wrap: wrap,
  integrity: integrity, media: media, referrerpolicy: referrerpolicy, sizes: sizes,
  `type`: `type`, `for`: `for`, `async`: `async`, `defer`: `defer`, children: @children) """

func setAttributes(t: HtmlNode): string =
  result = " "
  if t.hidden.len > 0:              result.add "hidden " # Just adds HTML attributes for tags.
  if t.spellcheck.len > 0:          result.add "spellcheck "
  if unlikely(t.disabled.len > 0):  result.add "disabled "
  if t.readonly.len > 0:            result.add "readonly "
  if t.required.len > 0:            result.add "required "
  if t.autoplay.len > 0:            result.add "autoplay "
  if unlikely(t.controls.len > 0):  result.add "controls "
  if t.autocomplete.len > 0:        result.add "autocomplete "
  if t.autofocus.len > 0:           result.add "autofocus "
  if t.checked.len > 0:             result.add "checked "
  if t.open.len > 0:                result.add "open "
  if t.`async`.len > 0:             result.add "async "
  if t.`defer`.len > 0:             result.add "defer "
  if t.selected.len > 0:            result.add "selected "
  if unlikely(t.width != 0):        result.add "width=\""            & $t.width           & "\" "
  if unlikely(t.height != 0):       result.add "width='"             & $t.height          & "\" "
  if t.id.len > 0:                  result.add "id=\""               & t.id               & "\" "
  if t.class.len > 0:               result.add "class=\""            & t.class            & "\" "
  if t.name.len > 0:                result.add "name=\""             & t.name             & "\" "
  if unlikely(t.accesskey.len > 0): result.add "accesskey=\""        & t.accesskey        & "\" "
  if t.src.len > 0:                 result.add "src=\""              & t.src              & "\" "
  if unlikely(t.tabindex.len > 0):  result.add "tabindex=\""         & t.tabindex         & "\" "
  if unlikely(t.translate.len > 0): result.add "translate=\""        & t.translate        & "\" "
  if unlikely(t.lang.len > 0):      result.add "lang=\""             & t.lang             & "\" "
  if t.role.len > 0:                result.add "role=\""             & t.role             & "\" "
  if t.onabort.len > 0:             result.add "onabort=\""          & t.onabort          & "\" "
  if t.onblur.len > 0:              result.add "onblur=\""           & t.onblur           & "\" "
  if t.oncancel.len > 0:            result.add "oncancel=\""         & t.oncancel         & "\" "
  if unlikely(t.oncanplay.len > 0): result.add "oncanplay=\""        & t.oncanplay        & "\" "
  if t.oncanplaythrough.len > 0:    result.add "oncanplaythrough=\"" & t.oncanplaythrough & "\" "
  if t.onchange.len > 0:            result.add "onchange=\""         & t.onchange         & "\" "
  if t.onclick.len > 0:             result.add "onclick=\""          & t.onclick          & "\" "
  if t.oncuechange.len > 0:         result.add "oncuechange=\""      & t.oncuechange      & "\" "
  if t.ondblclick.len > 0:          result.add "ondblclick=\""       & t.ondblclick       & "\" "
  if t.ondurationchange.len > 0:    result.add "ondurationchange=\"" & t.ondurationchange & "\" "
  if unlikely(t.onemptied.len > 0): result.add "onemptied=\""        & t.onemptied        & "\" "
  if t.onended.len > 0:             result.add "onended=\""          & t.onended          & "\" "
  if t.onerror.len > 0:             result.add "onerror=\""          & t.onerror          & "\" "
  if t.onfocus.len > 0:             result.add "onfocus=\""          & t.onfocus          & "\" "
  if t.oninput.len > 0:             result.add "oninput=\""          & t.oninput          & "\" "
  if t.oninvalid.len > 0:           result.add "oninvalid=\""        & t.oninvalid        & "\" "
  if t.onkeydown.len > 0:           result.add "onkeydown=\""        & t.onkeydown        & "\" "
  if t.onkeypress.len > 0:          result.add "onkeypress=\""       & t.onkeypress       & "\" "
  if t.onkeyup.len > 0:             result.add "onkeyup=\""          & t.onkeyup          & "\" "
  if t.onload.len > 0:              result.add "onload=\""           & t.onload           & "\" "
  if t.onloadeddata.len > 0:        result.add "onloadeddata=\""     & t.onloadeddata     & "\" "
  if t.onloadedmetadata.len > 0:    result.add "onloadedmetadata=\"" & t.onloadedmetadata & "\" "
  if t.onloadstart.len > 0:         result.add "onloadstart=\""      & t.onloadstart      & "\" "
  if t.onmousedown.len > 0:         result.add "onmousedown=\""      & t.onmousedown      & "\" "
  if t.onmouseenter.len > 0:        result.add "onmouseenter=\""     & t.onmouseenter     & "\" "
  if t.onmouseleave.len > 0:        result.add "onmouseleave=\""     & t.onmouseleave     & "\" "
  if t.onmousemove.len > 0:         result.add "onmousemove=\""      & t.onmousemove      & "\" "
  if t.onmouseout.len > 0:          result.add "onmouseout=\""       & t.onmouseout       & "\" "
  if t.onmouseover.len > 0:         result.add "onmouseover=\""      & t.onmouseover      & "\" "
  if t.onmouseup.len > 0:           result.add "onmouseup=\""        & t.onmouseup        & "\" "
  if t.onmousewheel.len > 0:        result.add "onmousewheel=\""     & t.onmousewheel     & "\" "
  if t.onpause.len > 0:             result.add "onpause=\""          & t.onpause          & "\" "
  if unlikely(t.onplay.len > 0):    result.add "onplay=\""           & t.onplay           & "\" "
  if unlikely(t.onplaying.len > 0): result.add "onplaying=\""        & t.onplaying        & "\" "
  if t.onprogress.len > 0:          result.add "onprogress=\""       & t.onprogress       & "\" "
  if t.onratechange.len > 0:        result.add "onratechange=\""     & t.onratechange     & "\" "
  if unlikely(t.onreset.len > 0):   result.add "onreset=\""          & t.onreset          & "\" "
  if t.onresize.len > 0:            result.add "onresize=\""         & t.onresize         & "\" "
  if t.onscroll.len > 0:            result.add "onscroll=\""         & t.onscroll         & "\" "
  if unlikely(t.onseeked.len > 0):  result.add "onseeked=\""         & t.onseeked         & "\" "
  if unlikely(t.onseeking.len > 0): result.add "onseeking=\""        & t.onseeking        & "\" "
  if t.onselect.len > 0:            result.add "onselect=\""         & t.onselect         & "\" "
  if t.onshow.len > 0:              result.add "onshow=\""           & t.onshow           & "\" "
  if unlikely(t.onstalled.len > 0): result.add "onstalled=\""        & t.onstalled        & "\" "
  if t.onsubmit.len > 0:            result.add "onsubmit=\""         & t.onsubmit         & "\" "
  if t.onsuspend.len > 0:           result.add "onsuspend=\""        & t.onsuspend        & "\" "
  if t.ontimeupdate.len > 0:        result.add "ontimeupdate=\""     & t.ontimeupdate     & "\" "
  if t.ontoggle.len > 0:            result.add "ontoggle=\""         & t.ontoggle         & "\" "
  if t.onvolumechange.len > 0:      result.add "onvolumechange=\""   & t.onvolumechange   & "\" "
  if t.onwaiting.len > 0:           result.add "onwaiting=\""        & t.onwaiting        & "\" "
  if t.onafterprint.len > 0:        result.add "onafterprint=\""     & t.onafterprint     & "\" "
  if t.onbeforeprint.len > 0:       result.add "onbeforeprint=\""    & t.onbeforeprint    & "\" "
  if t.onbeforeunload.len > 0:      result.add "onbeforeunload=\""   & t.onbeforeunload   & "\" "
  if t.onhashchange.len > 0:        result.add "onhashchange=\""     & t.onhashchange     & "\" "
  if t.onmessage.len > 0:           result.add "onmessage=\""        & t.onmessage        & "\" "
  if t.onoffline.len > 0:           result.add "onoffline=\""        & t.onoffline        & "\" "
  if t.ononline.len > 0:            result.add "ononline=\""         & t.ononline         & "\" "
  if t.onpagehide.len > 0:          result.add "onpagehide=\""       & t.onpagehide       & "\" "
  if t.onpageshow.len > 0:          result.add "onpageshow=\""       & t.onpageshow       & "\" "
  if t.onpopstate.len > 0:          result.add "onpopstate=\""       & t.onpopstate       & "\" "
  if unlikely(t.onstorage.len > 0): result.add "onstorage=\""        & t.onstorage        & "\" "
  if t.onunload.len > 0:            result.add "onunload=\""         & t.onunload         & "\" "
  if unlikely(t.onbounce.len > 0):  result.add "onbounce=\""         & t.onbounce         & "\" "
  if t.onfinish.len > 0:            result.add "onfinish=\""         & t.onfinish         & "\" "
  if t.onstart.len > 0:             result.add "onstart=\""          & t.onstart          & "\" "
  if t.crossorigin.len > 0:         result.add "crossorigin=\""      & t.crossorigin      & "\" "
  if unlikely(t.hreflang.len > 0):  result.add "hreflang=\""         & t.hreflang         & "\" "
  if t.form.len > 0:                result.add "form=\""             & t.form             & "\" "
  if t.maxlength.len > 0:           result.add "maxlength=\""        & t.maxlength        & "\" "
  if t.minlength.len > 0:           result.add "minlength=\""        & t.minlength        & "\" "
  if t.placeholder.len > 0:         result.add "placeholder=\""      & t.placeholder      & "\" "
  if unlikely(t.coords.len > 0):    result.add "coords=\""           & t.coords           & "\" "
  if unlikely(t.download.len > 0):  result.add "download=\""         & t.download         & "\" "
  if t.href.len > 0:                result.add "href=\""             & t.href             & "\" "
  if t.rel.len > 0:                 result.add "rel=\""              & t.rel              & "\" "
  if unlikely(t.shape.len > 0):     result.add "shape=\""            & t.shape            & "\" "
  if t.target.len > 0:              result.add "target=\""           & t.target           & "\" "
  if t.preload.len > 0:             result.add "preload=\""          & t.preload          & "\" "
  if t.mediagroup.len > 0:          result.add "mediagroup=\""       & t.mediagroup       & "\" "
  if unlikely(t.loop.len > 0):      result.add "loop=\""             & t.loop             & "\" "
  if unlikely(t.muted.len > 0):     result.add "muted=\""            & t.muted            & "\" "
  if unlikely(t.poster.len > 0):    result.add "poster=\""           & t.poster           & "\" "
  if t.action.len > 0:              result.add "action=\""           & t.action           & "\" "
  if unlikely(t.enctype.len > 0):   result.add "enctype=\""          & t.enctype          & "\" "
  if t.novalidate.len > 0:          result.add "novalidate=\""       & t.novalidate       & "\" "
  if unlikely(t.srcdoc.len > 0):    result.add "srcdoc=\""           & t.srcdoc           & "\" "
  if unlikely(t.sandbox.len > 0):   result.add "sandbox=\""          & t.sandbox          & "\" "
  if unlikely(t.usemap.len > 0):    result.add "usemap=\""           & t.usemap           & "\" "
  if unlikely(t.ismap.len > 0):     result.add "ismap=\""            & t.ismap            & "\" "
  if t.accept.len > 0:              result.add "accept=\""           & t.accept           & "\" "
  if t.alt.len > 0:                 result.add "alt=\""              & t.alt              & "\" "
  if t.dirname.len > 0:             result.add "dirname=\""          & t.dirname          & "\" "
  if t.formaction.len > 0:          result.add "formaction=\""       & t.formaction       & "\" "
  if t.formenctype.len > 0:         result.add "formenctype=\""      & t.formenctype      & "\" "
  if t.formmethod.len > 0:          result.add "formmethod=\""       & t.formmethod       & "\" "
  if t.formnovalidate.len > 0:      result.add "formnovalidate=\""   & t.formnovalidate   & "\" "
  if t.formtarget.len > 0:          result.add "formtarget=\""       & t.formtarget       & "\" "
  if t.inputmode.len > 0:           result.add "inputmode=\""        & t.inputmode        & "\" "
  if unlikely(t.list.len > 0):      result.add "list=\""             & t.list             & "\" "
  if unlikely(t.max.len > 0):       result.add "max=\""              & t.max              & "\" "
  if unlikely(t.min.len > 0):       result.add "min=\""              & t.min              & "\" "
  if unlikely(t.multiple.len > 0):  result.add "multiple=\""         & t.multiple         & "\" "
  if unlikely(t.pattern.len > 0):   result.add "pattern=\""          & t.pattern          & "\" "
  if t.size.len > 0:                result.add "size=\""             & t.size             & "\" "
  if t.step.len > 0:                result.add "step=\""             & t.step             & "\" "
  if t.`type`.len > 0:              result.add "type=\""             & t.`type`           & "\" "
  if t.value.len > 0:               result.add "value=\""            & t.value            & "\" "
  if t.`for`.len > 0:               result.add "for=\""              & t.`for`            & "\" "
  if unlikely(t.behavior.len > 0):  result.add "behavior=\""         & t.behavior         & "\" "
  if unlikely(t.bgcolor.len > 0):   result.add "bgcolor=\""          & t.bgcolor          & "\" "
  if unlikely(t.direction.len > 0): result.add "direction=\""        & t.direction        & "\" "
  if unlikely(t.hspace.len > 0):    result.add "hspace=\""           & t.hspace           & "\" "
  if t.scrollamount.len > 0:        result.add "scrollamount=\""     & t.scrollamount     & "\" "
  if t.scrolldelay.len > 0:         result.add "scrolldelay=\""      & t.scrolldelay      & "\" "
  if unlikely(t.truespeed.len > 0): result.add "truespeed=\""        & t.truespeed        & "\" "
  if unlikely(t.vspace.len > 0):    result.add "vspace=\""           & t.vspace           & "\" "
  if unlikely(t.optimum.len > 0):   result.add "optimum=\""          & t.optimum          & "\" "
  if t.colspan.len > 0:             result.add "colspan=\""          & t.colspan          & "\" "
  if t.rowspan.len > 0:             result.add "rowspan=\""          & t.rowspan          & "\" "
  if t.headers.len > 0:             result.add "headers=\""          & t.headers          & "\" "
  if t.cols.len > 0:                result.add "cols=\""             & t.cols             & "\" "
  if t.rows.len > 0:                result.add "rows=\""             & t.rows             & "\" "
  if t.wrap.len > 0:                result.add "wrap=\""             & t.wrap             & "\" "
  if t.httpequiv.len > 0:           result.add "http-equiv=\""       & t.httpequiv        & "\" "
  if t.content.len > 0:             result.add "content=\""          & t.content          & "\" "
  if t.integrity.len > 0:           result.add "integrity=\""        & t.integrity        & "\" "
  if t.media.len > 0:               result.add "media=\""            & t.media            & "\" "
  if t.referrerpolicy.len > 0:      result.add "referrerpolicy=\""   & t.referrerpolicy   & "\" "
  if t.sizes.len > 0:               result.add "sizes=\""            & t.sizes            & "\" "
  if unlikely(t.contenteditable):   result.add """contenteditable="true" """

func openTag(this: HtmlNode): string =
  const n = when defined(release): ">" else: ">\n" # Render the HtmlNode to String,tag-by-tag,Bulma & Spectre support added here
  result = case this.kind
    of nkHtml:     static("<!DOCTYPE html" & n & "<html class='has-navbar-fixed-top'" & n)
    of nkHead:     static("<head" & n) & basicHeadTags
    of nkTitle:    "<title>" & this.text & static("</title" & n)
    of nkMeta:     "<meta" & setAttributes(this) & n
    of nkLink:     "<link" & setAttributes(this) & n
    of nkBody:     static("<body class='has-navbar-fixed-top'" & n)
    of nkArticle:  "<article class='message'" & setAttributes(this) & n
    of nkButton:   "<button class='button is-light is-rounded btn tooltip'" & setAttributes(this) & n & this.text
    of nkDetails:  "<details class='message is-dark'" & setAttributes(this) & n
    of nkSummary:  "<summary class='message-header is-dark'" & setAttributes(this) & n & this.text
    of nkDialog:   "<dialog class='notification is-rounded modal'" & setAttributes(this) & n
    of nkFooter:   "<footer class='footer is-fullwidth'" & setAttributes(this) & n
    of nkH1:       "<h1 class='title'" & setAttributes(this) & n
    of nkImg:      "<img class='image img-responsive'" & setAttributes(this) & n
    of nkLabel:    "<label class='label form-label'" & setAttributes(this) & n
    of nkMeter:    "<meter class='progress is-small bar-item' role='progressbar'" & setAttributes(this) & n
    of nkProgress: "<progress class='progress is-small bar-item' role='progressbar'" & setAttributes(this) & n
    of nkSection:  "<section class='section'" & setAttributes(this) & n
    of nkSelect:   "<select class='select is-primary is-rounded is-small form-select'" & setAttributes(this) & n
    of nkTable:    "<table class='table is-bordered is-striped is-hoverable table-striped table-hover'" & setAttributes(this) & n
    of nkFigure:   "<figure class='figure figure-caption text-center'" & setAttributes(this) & n & this.text
    of nkPre:      "<pre class='code'" & setAttributes(this) & n & this.text
    of nkVideo:    "<video class='video-responsive'" & setAttributes(this) & n
    of nkCenter:   "<center class='is-centered'" & setAttributes(this) & n & this.text
    of nkInput:    "<input class='input is-primary form-input' dir='auto' " & setAttributes(this) & n
    of nkTextarea: "<textarea class='textarea is-primary form-input' dir='auto' " & setAttributes(this) & n
    of nkNav:      "<nav class='navbar is-fixed-top is-light' role='navigation'" & setAttributes(this) & n
    of nkHr:       static("<hr" & n)
    of nkBr:       static("<br" & n)
    of nkComment:  indent(when defined(release): "" else: "\n\n<!--  " & this.text & "  -->\n\n", 2)
    else: "<" & $this.kind & setAttributes(this) & n & this.text

func closeTag(this: HtmlNode): string {.inline.} =
  if this.kind notin [nkTitle, nkMeta, nkLink, nkImg, nkInput, nkBr, nkHr, nkComment]:
    result = "</" & $this.kind & static(when defined(release): ">" else: ">\n")

macro autogenAllTheProcs() =
  var allTheProcs: string
  for item in HtmlNodeKind: # nkComment, nkBody, nkHead, nkDiv, nkHtml are special case.
    if item in [nkComment, nkBody, nkHead, nkDiv, nkHtml]: continue else: allTheProcs.add procTemplate.format($item) & "\n"
  parseStmt allTheProcs # This generates a truckload of code.

autogenAllTheProcs()

template indentIfNeeded(thingy, indentationLevel: untyped): untyped =
  when defined(release): thingy else: indent(thingy, indentationLevel)

func render*(this: HtmlNode): string =
  var indentationLevel: byte   # indent level, 0 ~ 255.
  result &= openTag this
  inc indentationLevel
  case this.kind
  of nkHtml:                    # <html>
    result &= indentIfNeeded(render(this.head), indentationLevel)
    result &= indentIfNeeded(render(this.body), indentationLevel)
  of nkHead:                    # <head>
    if this.meta.len > 0:
      for meta_tag in this.meta: result &= indentIfNeeded(render(meta_tag), indentationLevel)  # <meta ... >
    if this.link.len > 0:
      for link_tag in this.link: result &= indentIfNeeded(render(link_tag), indentationLevel) # <link ... >
    result &= indentIfNeeded(openTag(this.title), indentationLevel)
  of nkBody:                    # <body>
    if this.children.len > 0:
      for tag in this.children: result &= indentIfNeeded(render(tag), indentationLevel)
  else:
    if this.children.len > 0:
      for tag in this.children: result &= indentIfNeeded(render(tag), indentationLevel)
  dec indentationLevel
  result &= closeTag this

func `<!--`*(text: string): HtmlNode {.inline.} = HtmlNode(kind: nkComment, text: text) # HTML Comment
func newDiv*(children: varargs[HtmlNode]): HtmlNode {.inline.} = HtmlNode(kind: nkDiv, children: @children)

macro divs*(inner: untyped): HtmlNode =
  assert inner.len >= 1, "Div Error: Wrong number of inner elements:" & $inner.len # <div> is named "divs"
  result = newCall("newDiv")
  if inner.len == 1: result.add inner
  inner.copyChildrenTo(result)

func newHead*(title: HtmlNode, meta: varargs[HtmlNode], link: varargs[HtmlNode]): HtmlNode {.inline.} = HtmlNode(kind: nkHead, title: title, meta: @meta, link: @link) ## Create a new ``<head>`` tag Node with meta, link and title tag nodes.

macro heads*(inner: untyped): HtmlNode =
  result = newCall("newHead")
  if inner.len == 1: result.add inner
  inner.copyChildrenTo(result)

func newBody*(children: varargs[HtmlNode]): HtmlNode {.inline.} = HtmlNode(kind: nkBody, children: @children) ## Create a new ``<body>`` tag Node, containing all children tags.

macro bodys*(inner: untyped): HtmlNode =
  result = newCall("newBody") # Result is a call to newBody()
  if inner.len == 1: result.add inner # if just 1 children just pass it as arg
  inner.copyChildrenTo(result) # if several children copy them all, AST level.

func newHtml*(head, body: HtmlNode): HtmlNode {.inline.} = HtmlNode(kind: nkHtml, head: head, body: body)
macro html*(inner: untyped): string = newCall("render", newCall("newHtml", inner[0], inner[1]))

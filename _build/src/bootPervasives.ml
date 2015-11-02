exception Element_not_found
 
let ( >>= )   = Lwt.bind
let _s        = Js.string
let s_        = Js.to_string
let alert x   = Dom_html.window ## alert (_s x)
let log x     = Firebug.console ## log(x)

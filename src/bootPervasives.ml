exception Element_not_found
 
let ( >>= )   = Lwt.bind
let _s        = Js.string
let s_        = Js.to_string
let alert x   = Dom_html.window ## alert (_s x)
let log x     = Firebug.console ## log(x)

let id x = x 

let ( % ) f g x = f (g x)
let ( %> ) f g x = g (f x)

let ( $ ) f x = f x 

let flip f x y = f y x

let tap f x =
  let _ = f x in x

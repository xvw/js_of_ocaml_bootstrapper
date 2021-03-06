open BootPervasives

let wakeup w x _ = let _ = Lwt.wakeup w () in x
let wrap f = (fun x -> Lwt.return (f x))
let run promise f elt = promise elt >>= (wrap f)
                                        
let raw_onload elt () =
  let thread, wakener = Lwt.wait () in
  let _ = elt ## onload <-
      Dom.handler (wakeup wakener Js._true)
  in thread
    
let dom_onload () = raw_onload (Dom_html.window) ()
let img_onload i  = raw_onload i ()

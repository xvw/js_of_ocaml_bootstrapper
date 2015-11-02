open BootPervasives

include Lwt_js_events
let bind = async_loop
let (>-) elt (event, f) =
  let _ =
    bind event elt
      (fun a b ->
         let _ = f a b in
         Lwt.return_unit
      ) in elt
    
let rec delayed_loop ?(delay=1.0) f =
  let _ = f () in
  Lwt_js.sleep delay
  >>= (fun _ -> delayed_loop ~delay f)

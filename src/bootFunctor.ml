open BootPervasives

module type APPLICATION = sig
  val initialize : unit -> unit
end

module type APPLICATION_CONTEXT = sig
  val context : [> `Css of string | `Js of string] list
  include APPLICATION
end


module Application(F : APPLICATION) = struct
  let _ = BootPromise.(run dom_onload F.initialize ())
end

module Application_with(F : APPLICATION_CONTEXT) = struct
  let f = fun () ->
    let _ = List.iter (fun l -> BootHtml.load_library l) F.context in
    F.initialize ()
  let _ = BootPromise.(run dom_onload f ())
end

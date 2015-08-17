(*  * Small bootstrapper for Js_of_ocaml Projects
 * ~ provide a simple library for common uses   *)

exception Element_not_found
 
let ( >>= )   = Lwt.bind
let _s        = Js.string
let s_        = Js.to_string
let alert x   = Dom_html.window ## alert (_s x)

module Option =
struct
  
  let safe x = try Some x with _ -> None
    
  let unit_map f = function
    | Some e -> f e
    | None -> ()

end

module Promise =
struct

  let wakeup w x _ = let _ = Lwt.wakeup w () in x
  let wrap f = (fun () -> Lwt.return (f ()))
  let run promise f = promise () >>= (wrap f)

  let onload () =
    let thread, wakener = Lwt.wait () in
    let _ = Dom_html.window ## onload <-
        Dom.handler (wakeup wakener Js._true)
    in thread
    
end

module Event =
struct

  include Lwt_js_events
  let bind = async_loop
  let (>-) elt (event, f) =
    let _ =
      bind event elt
        (fun a b ->
           let _ = f a b in
           Lwt.return_unit
        ) in elt
  
end

module Get =
struct

  let fail () = raise Element_not_found
  let unopt x = Js.Opt.get x fail

  let byId id =
    Dom_html.document ## getElementById (_s id)
    |> unopt

  let find container selector =
    container ## querySelector (_s selector)
    |> unopt

  let select container selector =
    container ## querySelectorAll (_s selector)
    |> Dom.list_of_nodeList

  let byId_opt id = Option.safe (byId id)
  let find_opt container selector =
    Option.safe (find container selector)

  module Attribute =
  struct
    
    let get elt attr =
      let s_attr = _s attr in
      if (elt ## hasAttribute (s_attr)) == Js._true
      then
        Some (
          elt ## getAttribute (s_attr)
          |> unopt
          |> s_
        )
      else None
        
  end

    
end

module Class =
struct

  let add_one elt klass = elt ## classList ## add (_s klass)
  let add elt classes = List.iter (add_one elt)
  
end

module Create =
struct

  let element ?(id = None) ?(classes = []) ?(into = None) f =
    let elt = f Dom_html.document in
    let _   = Class.add elt classes in
    let _   = Option.unit_map (fun x -> elt ## id <- (_s x)) id in
    let _   = Option.unit_map (fun x -> Dom.appendChild x elt) into
    in elt

  let text ?(into = None) value =
    let elt = Dom_html.document ## createTextNode (_s value) in
    let _   = Option.unit_map (fun x -> Dom.appendChild x elt) into
    in elt
  
end

module Input =
struct

  let from_element x =
    Dom_html.CoerceTo.input x
    |> Get.unopt

  let getById_opt x =
    match Get.byId_opt x with
    | None -> None
    | Some x -> Some (from_element x)
  
  let getById x =
    Get.byId x
    |> from_element

  let valueOf x =
    (from_element x) ## value
    |> s_

  let isChecked x =
    (from_element x) ## checked
    |> Js.to_bool

  let create ?(id = None) ?(classes = []) ?(into = None) _type value =
    let f   = Dom_html.createInput ~_type:(_s _type) in
    let elt = Create.element ~id ~classes ~into f in
    let _   = elt ## value <- (_s value)
    in elt
  
end


module type APPLICATION = sig
  val initialize : unit -> unit
end

module Application(F : APPLICATION) = struct
  let _ = Promise.(run onload F.initialize)
end

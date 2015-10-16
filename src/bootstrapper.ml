(*  * Small bootstrapper for Js_of_ocaml Projects
 * ~ provide a simple library for common uses   *)

exception Element_not_found
 
let ( >>= )   = Lwt.bind
let _s        = Js.string
let s_        = Js.to_string
let alert x   = Dom_html.window ## alert (_s x)
let log x     = Firebug.console ## log(x)

module Option =
struct
  
  let safe f x = try Some (f x) with _ -> None
    
  let unit_map f = function
    | Some e -> f e
    | None -> ()
      
  let some x = Some x
  let none = None
  
  let default value = function
    | None -> value
    | Some x -> x
      
  let map f = function
    | None -> None
    | Some x -> Some (f x)
                  
  let apply = function
    | None -> (fun x -> x)
    | Some f -> f
      
  let is_some = function
    | Some _ -> true
    | _ -> false
      
  let is_none = function
    | None -> true
    | _ -> false
      
end

module Promise =
struct

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

  let rec delayed_loop ?(delay=1.0) f =
    let _ = f () in
    Lwt_js.sleep delay
    >>= (fun _ -> delayed_loop ~delay f)
        
end

module Interval =
struct

  let set ?(delay=0.1) f =
    Event.delayed_loop ~delay:delay f

  let set_until ?(delay=0.1) pred f =
    let cpt = ref 0 in
    let _ = while pred(!cpt) do
        let _ = Lwt_js.sleep delay >>= (fun _ -> Lwt.return (f ())) in
        cpt := !cpt + 1
      done
    in Lwt.return_unit
    
  let set_for ?(delay=0.1) x f =
    set_until ~delay:delay (fun i -> i < x) f
         
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

  let byId_opt id = Option.safe byId id
  let find_opt container selector =
    Option.safe (fun x -> find x selector) container

  let all () =
    Dom_html.document ## getElementsByTagName (_s "*")
    |> Dom.list_of_nodeList
    
end

module Attribute =
struct

  let get elt attr =
    let s_attr = _s attr in
    if (elt ## hasAttribute (s_attr)) == Js._true
    then
      Some (
        elt ## getAttribute (s_attr)
        |> Get.unopt
        |> s_
      )
    else None


  let set elt attr value =
    let s_attr = _s attr
    and s_value = _s value in
    elt ## setAttribute(s_attr, s_value) 

  module Data =
  struct
    
    let get elt data =
      let attr = "data-"^data in
      get elt attr

    let set elt data value =
      let attr = "data-"^data in
      set elt attr value
        
  end
    
end

module Class =
struct

  let add_one elt klass = elt ## classList ## add (_s klass)
  let add elt classes = List.iter (add_one elt) classes
  let remove_one elt klass =  elt ## classList ## remove (_s klass)
  let remove elt classes = List.iter (remove_one elt) classes
  
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


let load_library lnk = 
  let h = Get.find Dom_html.document "head" in
  match lnk with 
  | `Css link ->
    let l = Create.element ~into:(Some h) Dom_html.createLink in
    let _ = Attribute.set l "rel" "stylesheet" in
    let _ = Attribute.set l "type" "text/css" in
    Attribute.set l "href" link 
  | `Js link ->
    let l = Create.element ~into:(Some h) Dom_html.createScript in
    let _ = Attribute.set l "type" "text/javascript" in
    Attribute.set l "src" link



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

module Ajax = struct

  let load file =
    let open XmlHttpRequest in
    get file >>= (fun frame ->
        let code = frame.code
        and message = frame.content in 
        if code = 0 || code = 200
        then Lwt.return (Some message)
        else Lwt.return None
      ) 
  
end

module EHtml = struct

  (* Extension of HTML *)

  let mouse_trigger_of_string = function
    | "click" -> Event.click
    | "dblclick" -> Event.dblclick
    | "mousedown" -> Event.mousedown
    | "mouseup" -> Event.mouseup
    | "mouseover" -> Event.mouseover
    | "mousemove" -> Event.mousemove
    | "mouseout" -> Event.mouseout
    | _ -> Event.click

  let dataInclude elt =
    match Attribute.Data.get elt "include" with
    | None -> Lwt.return_unit
    | Some file ->
      Ajax.load file >>= (
        function 
        | None -> Lwt.return_unit
        | Some textNode ->
          let _ = elt ## innerHTML <- _s textNode in
          Lwt.return_unit
      )

  let mouse_event_bind h elt =
    match Attribute.Data.(get elt "callback", get elt "trigger") with
    | Some cb, Some tr ->
      let open Event in
      let _ =
        try
          let cl = List.assoc cb h in
          elt >- (mouse_trigger_of_string tr, fun e _ -> cl (e##target))
          |> ignore
        with _ -> ()
      in 
      Lwt.return_unit
    | _ -> Lwt.return_unit
             
  let refresh_dom h =
    List.iter begin
      fun elt ->
        let _ = dataInclude elt in
        let _ = mouse_event_bind h elt in 
        ()
    end (Get.all ())
    |> Lwt.return
  
end


module type APPLICATION = sig
  val initialize : unit -> unit
end


module type EHTML_APPLICATION = sig
  val registered_callback : (string * ('a -> unit)) list
  val initialize : unit -> unit
end

module Application(F : APPLICATION) = struct
  let _ = Promise.(run dom_onload F.initialize ())
end

module EHtml_Application(F : EHTML_APPLICATION) = struct
  include EHtml
  let initialize () =
    let _ = refresh_dom F.registered_callback in
    let _ = F.initialize () in Lwt.wakeup
  let _ = Promise.(run dom_onload initialize ())
end


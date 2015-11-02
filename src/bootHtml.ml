open BootPervasives

let fail () = raise Element_not_found
let unopt x = Js.Opt.get x fail

let get_by_id id =
  Dom_html.document ## getElementById (_s id)
  |> unopt
  
let find_node container selector =
  container ## querySelector (_s selector)
  |> unopt
  
let select_nodes container selector =
  container ## querySelectorAll (_s selector)
  |> Dom.list_of_nodeList
       
let get_by_id_opt id = BootOption.safe get_by_id id
let find_node_opt container selector =
  BootOption.safe (fun x -> find_node x selector) container
    
let all_nodes () =
  Dom_html.document ## getElementsByTagName (_s "*")
  |> Dom.list_of_nodeList
  

let get_attribute elt attr =
  let s_attr = _s attr in
  if (elt ## hasAttribute (s_attr)) == Js._true
  then
    Some (
      elt ## getAttribute (s_attr)
      |> unopt
      |> s_
    )
  else None
    

let set_attribute elt attr value =
  let s_attr = _s attr
  and s_value = _s value in
  elt ## setAttribute(s_attr, s_value) 
    

let get_data elt data =
  let attr = "data-"^data in
  get_attribute elt attr
    
let set_data elt data value =
  let attr = "data-"^data in
  set_attribute elt attr value
    
let add_class elt klass = elt ## classList ## add (_s klass)
let add_classes elt classes = List.iter (add_class elt) classes
let remove_class elt klass =  elt ## classList ## remove (_s klass)
let remove_classes elt classes = List.iter (remove_class elt) classes
    

let element ?(id = None) ?(classes = []) ?(into = None) f =
  let elt = f Dom_html.document in
  let _   = Class.add_classes elt classes in
  let _   = BootOption.unit_map (fun x -> elt ## id <- (_s x)) id in
  let _   = BootOption.unit_map (fun x -> Dom.appendChild x elt) into
  in elt
    
let text ?(into = None) value =
  let elt = Dom_html.document ## createTextNode (_s value) in
  let _   = BootOption.unit_map (fun x -> Dom.appendChild x elt) into
  in elt


let input_from_element x =
  Dom_html.CoerceTo.input x
  |> unopt
       
let input_get_by_id_opt x =
  match get_by_id_opt x with
  | None -> None
  | Some x -> Some (from_element x)
                
let input_get_by_id x =
  get_by_id x
  |> input_from_element
  
let input_value x =
  (input_from_element x) ## value
  |> s_
  
let input_is_checked x =
  (input_from_element x) ## checked
  |> Js.to_bool
       
let input_create ?(id = None) ?(classes = []) ?(into = None) _type value =
  let f   = Dom_html.createInput ~_type:(_s _type) in
  let elt = element ~id ~classes ~into f in
  let _   = elt ## value <- (_s value)
  in elt

(** {2 Retreive nodes of the Dom} *)

(** All function for retreiving element from the DOM *)

(** @raise Element_not_found if no element are found*)
val fail : unit -> 'a

(** Try to extract a potential unset value
    @raise Element_not_found if the retreiving is failed
*)
val unopt : 'a Js.Opt.t -> 'a

(** try to retreive a Dom element by his ID 
    @raise Element_not_found if the element doesn't exist
*)
val get_by_id : string -> Dom_html.element Js.t

(** try to retreive a Dom element using a QuerySelector
    @raise Element_not_found if the element doesn't exist
*)
val find_node : Dom_html.element Js.t -> string -> Dom_html.element Js.t

(** Retreive a Dom elements list using a QuerySelector
*)
val select_nodes : Dom_html.element Js.t -> string -> Dom_html.element Js.t list

(** Same as [get_by_id] but wrap the result with an option instead of an 
    exception
*)
val get_by_id_opt : string -> Dom_html.element Js.t option

(** Same as [find_node] but wrap the result with an option instead of an 
    exception
*)
val find_node_opt : Dom_html.element Js.t -> string -> Dom_html.element Js.t option

(** Retreive all Dom elements as a list *)
val all_node : unit -> Dom_html.element Js.t list 

(** {2 About attributes} *)
    
(** Try to get an argument of an element : 
      [get_attribute div "id"] (returns Some (id value))
*)
val get_attribute : Dom_html.element Js.t -> string -> string option
    
(** 
     set a value to an attribute 
     (an creates the attribute if it doesn't exists).
     [set_attribute div "id" "new_id"] change the id of [div]
*)
val set_attribute : Dom_html.element Js.t -> string -> string -> unit 


(** Try to get a data-argument of an element : 
        [get_data div "id"] (returns Some (data-id value))
*)
val get_data : Dom_html.element Js.t -> string -> string option
    
(** 
       set a value to a data-argument 
       (an creates the attribute if it doesn't exists).
       [set_data div "id" "new_id"] change the data-id of [div]
*)
val set_data : Dom_html.element Js.t -> string -> string -> unit 
    
(** {2 CSS classes} *)

(** [add_class elt css_class] add [css_class] to [elt] *)
val add_class : Dom_html.element Js.t -> string -> unit
    
(** [add_classes elt css_class_list] add each [css_class] to [elt] *)
val add_classes : Dom_html.element Js.t -> string list -> unit
  
(** Remove a css class of the gived Elt *)
val remove_class : Dom_html.element Js.t -> string -> unit
  
(** Remove all css classes of the gived Elt *)
val remove_classes : Dom_html.element Js.t -> string list -> unit 

(** {2 Create elements} *)

(** Create an HTML element using Dom_html function*)
val element :
  ?id:string option ->
  ?classes:string list ->
  ?into:((Dom_html.element Js.t) option) ->
  (Dom_html.document Js.t -> Dom_html.element Js.t) ->
  Dom_html.element Js.t
    
(** Create a simple text node (maybe into another element *)
val text : ?into:((Dom_html.element Js.t) option) -> string -> Dom.text Js.t

(** {2 Inputs} *)
    
(** Convert an abstract Dom element to a concrete Input *)
val input_from_element : Dom_html.element Js.t -> Dom_html.inputElement Js.t
    
(** try to retreive an Input by his ID 
      @raise Element_not_found if the element doesn't exist
*)
val input_get_by_id : string -> Dom_html.inputElement Js.t
    
(** Same as [Input.getById] but wrap the result with an option instead of an 
      exception
*)
val input_get_by_id_opt : string -> Dom_html.inputElement Js.t option
    
(** Retreive the value of an input*)
val input_value : Dom_html.inputElement Js.t -> string
  
(** returns true if the input is checked, else false *)
val input_is_checked : Dom_html.inputElement Js.t -> bool
  
(** [Input.create input_type value] creates an input *)
val input_create :
  ?id:string option ->
  ?classes:string list ->
  ?into:Dom_html.element Js.t option ->
  string -> string -> Dom_html.inputElement Js.t
    

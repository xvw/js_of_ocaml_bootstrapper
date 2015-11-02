(** This module is the pervasives module of the framework *)
  
module Event :
sig

  (** Easy access for Event API *)

  (** Include Lwt_js_events 
      @see <http://ocsigen.org/js_of_ocaml/api/Lwt_js_events> Official doc*)
  include module type of Lwt_js_events

  (** link an element to an event and a callback.
      [Event.(element >- (click, fun _ _ -> alert "TT")] for example, 
      when this code is called, at each click on the event, the alert
      "TT" will be launched
  *)
  val (>-) :
    'a ->
    (?use_capture:bool -> 'a -> 'b Lwt.t) * ('b -> unit Lwt.t -> 'c) ->
    'a

  (** [Event.delayed_loop ~delay:2.0 f] execute [f] each 2 second *)
  val delayed_loop : ?delay:float -> (unit -> 'a) -> 'b Lwt.t 
   
  
end

module Interval :
sig

  (** Provide LWT's interval*)
  
  (** [Interval.set ~delay:2.0 f] execute [f] each 2 second *)
  val set : ?delay:float -> (unit -> 'a) -> unit Lwt.t

  (** [Interval.set_until ~delay:2.0 predicat f] execute [f] each 2 second 
      until pred(i) (where i is the counter) returns true
  *)
  val set_until : ?delay:float -> (int -> bool) -> (unit -> 'a) -> unit Lwt.t

  (** [Interval.set_for ~delay:2.0 10 f] execute [f] 10 each 2 second 
  *)
  val set_for : ?delay:float -> int -> (unit -> 'a) -> unit Lwt.t
      
end

module Get :
sig

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
  val byId : string -> Dom_html.element Js.t

  (** try to retreive a Dom element using a QuerySelector
      @raise Element_not_found if the element doesn't exist
  *)
  val find : Dom_html.element Js.t -> string -> Dom_html.element Js.t

  (** Retreive a Dom elements list using a QuerySelector
  *)
  val select : Dom_html.element Js.t -> string -> Dom_html.element Js.t list

  (** Same as [Get.byId] but wrap the result with an option instead of an 
      exception
  *)
  val byId_opt : string -> Dom_html.element Js.t option

  (** Same as [Get.find] but wrap the result with an option instead of an 
      exception
  *)
  val find_opt : Dom_html.element Js.t -> string -> Dom_html.element Js.t option

  (** Retreive all Dom elements as a list *)
  val all : unit -> Dom_html.element Js.t list 
  
end

module Attribute :
sig

  (** Easy access to Dom's element's attributes *)

  (** Try to get an argument of an element : 
      [Attribute.get div "id"] (returns Some (id value))
  *)
  val get : Dom_html.element Js.t -> string -> string option

  (** 
     set a value to an attribute 
     (an creates the attribute if it doesn't exists).
     [Attribute.set div "id" "new_id"] change the id of [div]
  *)
  val set : Dom_html.element Js.t -> string -> string -> unit 

  module Data :
  sig

    (** Shortcut for Data Attributes (data-attr).
        for example in [<div data-truc="test">], [data-truc]
        is a Data Attribute (and accessible via [get elt "truc"])
    *)

    
    (** Try to get a data-argument of an element : 
        [Attribute.Data.get div "id"] (returns Some (data-id value))
    *)
    val get : Dom_html.element Js.t -> string -> string option

    (** 
       set a value to a data-argument 
       (an creates the attribute if it doesn't exists).
       [Attribute.Data.set div "id" "new_id"] change the data-id of [div]
    *)
    val set : Dom_html.element Js.t -> string -> string -> unit 
    
  end
  
end

module Class :
sig

  (** Easy access for using class as a String list *)

  (** [Class.add_one elt css_class] add [css_class] to [elt] *)
  val add_one : Dom_html.element Js.t -> string -> unit
    
  (** [Class.add elt css_class_list] add each [css_class] to [elt] *)
  val add : Dom_html.element Js.t -> string list -> unit

  (** Remove a css class of the gived Elt *)
  val remove_one : Dom_html.element Js.t -> string -> unit

  (** Remove all css classes of the gived Elt *)
  val remove : Dom_html.element Js.t -> string list -> unit 
 
  
end


module Create :
sig

  (** Easy access for elt creation *)

  (** Create an HTML element using Dom_html function*)
  val element :
    ?id:string option ->
    ?classes:string list ->
    ?into:((Dom_html.element Js.t) option) ->
    (Dom_html.document Js.t -> Dom_html.element Js.t) ->
    Dom_html.element Js.t

  (** Create a simple text node (maybe into another element *)
  val text : ?into:((Dom_html.element Js.t) option) -> string -> Dom.text Js.t

end


module Input :
sig

  (** Shortcuts for inputs *)

  (** Convert an abstract Dom element to a concrete Input *)
  val from_element : Dom_html.element Js.t -> Dom_html.inputElement Js.t


    (** try to retreive an Input by his ID 
      @raise Element_not_found if the element doesn't exist
  *)
  val getById : string -> Dom_html.inputElement Js.t

  (** Same as [Input.getById] but wrap the result with an option instead of an 
      exception
  *)
  val getById_opt : string -> Dom_html.inputElement Js.t option

  (** Retreive the value of an input*)
  val valueOf : Dom_html.inputElement Js.t -> string

  (** returns true if the input is checked, else false *)
  val isChecked : Dom_html.inputElement Js.t -> bool

  (** [Input.create input_type value] creates an input *)
  val create :
    ?id:string option ->
    ?classes:string list ->
    ?into:Dom_html.element Js.t option ->
    string -> string -> Dom_html.inputElement Js.t
  
end


module Ajax :
sig

  (** Ajax functions *)

  (** Try to load an external file *)
  val load : string -> string option Lwt.t

end

(** {2 Functors for templating } *)

(** The interface for application building *)
module type APPLICATION = sig

  (** initialize is the entry point of an application *)
  val initialize : unit -> unit
end

(** The interface for an application using external composants *)
module type APPLICATION_CONTEXT = sig

  (** List of external assets *)
  val context : [> `Css of string | `Js of string] list
  
  (** initialize is the entry point of an application *)
  val initialize : unit -> unit
    
end


(** The interface for application building using EHTML*)
module type EHTML_APPLICATION = sig

  (** An Hashtbl for callback registration *)
  val registered_callback : (string * ('a -> unit)) list
  
  (** initialize is the entry point of an application *)
  val initialize : unit -> unit
end


(** Make a simple application *)
module Application :
  functor (F : APPLICATION) -> sig end 
(** 
   Example for instanciate an application
   {[
     module App =
       Bootstrapper.Application(
       struct
         
         open Bootstrapper
             
         let initialize () =
           allert "hello world"
              
       end
  )
   ]}
*)

(** Make an application using EHtml*)
module EHtml_Application :
  functor (F : EHTML_APPLICATION) -> sig end 

(** Make an application using an external context *)
module Application_with :
  functor (F : APPLICATION_CONTEXT) -> sig end

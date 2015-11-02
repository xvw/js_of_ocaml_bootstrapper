(** This module is the pervasives module of the framework *)




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

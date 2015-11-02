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

(** Make an application using an external context *)
module Application_with :
  functor (F : APPLICATION_CONTEXT) -> sig end

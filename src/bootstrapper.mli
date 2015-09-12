(** This module is the pervasives module of the framework *)

(** {2 Exceptions} *)

(** this exception is launched when an element is not founded *)
exception Element_not_found

(** {2 General function } *)

(** Lwt binder *)
val ( >>= ) : 'a Lwt.t -> ('a -> 'b Lwt.t) -> 'b Lwt.t

(** Convert a OCaml's string into a JavaScript's string *)
val _s : string -> Js.js_string Js.t

(** Convert a JavaScript's string into a OCaml's string *)
val s_ : Js.js_string Js.t -> string

(** Perform a JavaScript alert *)
val alert : string -> unit

(** Print data int the console *)
val log : 'a -> unit
  
(** {2 Inner modules} *)

module Option :
sig

  (** This module offer some optionnal combinators *)

  (** [Option.safe f x] try to execute [f x], if the result 
      don't raise any exception, the result is [Some (f x)] else [None] *)
  val safe : ('a -> 'b) -> 'a -> 'b option

  (** Map a side effect on an option *)
  val unit_map : ('a -> unit) -> 'a option -> unit

  (* this part of the code is litterally plagied from OML *)
                                                
  val some : 'a -> 'a option
  (** [some x] returns [Some x] *)

  val none : 'a option
  (** [none] returns [None] *)
      
  val default : 'a -> 'a option -> 'a
  (** return the wrapped value or the first arguments (if the gived 
      option is None )
  *)

  
  val map : ('a -> 'b) -> 'a option -> 'b option
  (** [map f opt] returns [Some (f x)] if opt = Some x, None if opt = None *)

  val apply : ('a -> 'a) option -> 'a -> 'a
  (** [apply None x] returns [x] and [apply (Some f) x] returns [f x] *)

  val is_some : 'a option -> bool
  (** [is_some opt] returns true if opt is Some(x), otherwise false *)
    
  val is_none : 'a option -> bool
  (** [is_none opt] returns true if opt is None, otherwise false *)
  
end

module Promise :
sig

  (** This module is a purpose of presaved pomise *)

  (** Execute a promise *)
  val run : (unit -> unit Lwt.t) -> (unit -> 'a) -> 'a Lwt.t

  (** Presaved promise : wait for Dom's loading *)
  val onload : unit -> unit Lwt.t

end

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
  val delayed_loop :
    ?delay:float -> (unit -> 'a) -> 'b Lwt.t 
   
  
end

module Get :
sig

  (** All function for retreiving element from the DOM *)
  
end

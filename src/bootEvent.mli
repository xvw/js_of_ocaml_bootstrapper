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

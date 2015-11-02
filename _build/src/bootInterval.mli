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

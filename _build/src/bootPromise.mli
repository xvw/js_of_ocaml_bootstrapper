(** This module is a purpose of presaved pomise *)

(** Execute a promise *)
val run : ('a -> 'b Lwt.t) -> ('b -> 'c) -> 'a -> 'c Lwt.t
    
(** Presaved promise : wait for Dom's loading *)
val dom_onload : unit -> unit Lwt.t

(** Presaved promise : wait for Dom's loading *)
val img_onload : Dom_html.imageElement Js.t -> unit Lwt.t

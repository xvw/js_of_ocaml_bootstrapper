(** This module provide a common API *)

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

(** Identity function *)
val id : 'a -> 'a

(** Function composition *)
val ( % ) : ('a -> 'b) -> ('c -> 'a) -> 'c -> 'b

(** Function composition when the second function is executed first*)
val ( %> ) : ('a -> 'b) -> ('b -> 'c) -> 'a -> 'c

(** Application operator. This operator is redundant, since ordinary
    application (f x) means the same as (f $ x). However, $ has low,
    right-associative binding precedence, so it sometimes allows parentheses
*)
val ( $ ) : ('a -> 'b) -> 'a -> 'b 

(** Reverted application for two parameters in a function *)
val flip : ('a -> 'b -> 'c) -> 'b -> 'a -> 'c

(** Function application with side-effect, return the gived argument *)
val tap : ('a -> 'b) -> 'a -> 'a

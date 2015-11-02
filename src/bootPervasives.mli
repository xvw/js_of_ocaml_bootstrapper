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

(** Dynamic library loader *)
val load_library : [< `Css of string | `Js of string] -> unit


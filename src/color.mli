(** This module provide a simple api for color manipulation *)

(** {2 Types} *)

type t = {
  red : int
; green : int
; blue : int 
}


(** {2 Presaved color} *)

val red   : t
val green : t
val blue  : t
val white : t
val black : t

(** {2 Color's function} *)

val make : int -> int -> int -> t
(** [Color.make r g b] create a color *)

val to_string : t -> string
(** [Color.to_string color] transform [color] into an HTML's string *)

(** [Color.of_rgb_string s] transform [s] as "rgb(r,g,b)" into a color *)
val of_rgb_string : string -> t

(** [Color.of_hexa_string s] transform [s] as "#RGB" into a color *)
val of_hexa_string : string -> t

(** [Color.of_string s] unsafe coersion *)
val of_string : string -> t

val to_js : t -> Js.js_string Js.t
(** Create a color usable by a JavaScript function *)

(** This module provide a simple api for color manipulation *)

(** {2 Presaved color} *)

val red   : Js.js_string Js.t
val green : Js.js_string Js.t
val blue  : Js.js_string Js.t
val white : Js.js_string Js.t
val black : Js.js_string Js.t

(** {2 Color's function} *)

val make : string -> Js.js_string Js.t
(** Create a color usable by a JavaScript function *)

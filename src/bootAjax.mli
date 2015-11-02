(** Ajax functions *)

(** Try to load an external file *)
val load : string -> string option Lwt.t

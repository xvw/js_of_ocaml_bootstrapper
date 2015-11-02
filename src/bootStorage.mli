(** 
   Provide a Webstorage convinient binding. 
   Webstorage provide a key-value storage system, for storing 
   string. 

   The HTML5 webstorage offer two way : Session (binded to a session) 
   and Local, (binded to an user)
*)

(** Raised if the Webstorages are not allowed *)
exception Not_allowed


(** API for session storage (key value) *)
module Session :
sig

  (** [Session.get key] retreive (in an option) the value at the [key] *)
  val get : string -> string option

  (** [Session.set key value] save [value] at [key] as a key  *)
  val set : string -> string -> unit

  (** [Session.remove key] remove the value at the [key] *)
  val remove : string -> unit

  (** [Session.clear ()] clear the storage *)
  val clear : unit -> unit

  (** Get a key with is position *)
  val key : int -> string option

  (** [Session.length ()] give the total of stored object *) 
  val length : unit -> int

  (** [Session.to_hashtbl ()] retreive all stored data as an Hashtbl *) 
  val to_hashtbl : unit -> (string, string) Hashtbl.t

end


(** API for local storage (key value) *)
module Local :
sig

  (** [Local.get key] retreive (in an option) the value at the [key] *)
  val get : string -> string option

  (** [Local.set key value] save [value] at [key] as a key  *)
  val set : string -> string -> unit

  (** [Local.remove key] remove the value at the [key] *)
  val remove : string -> unit

  (** [Local.clear ()] clear the storage *)
  val clear : unit -> unit

  (** Get a key with is position *)
  val key : int -> string option

  (** [Local.length ()] give the total of stored object *) 
  val length : unit -> int

  (** [Session.to_hashtbl ()] retreive all stored data as an Hashtbl *) 
  val to_hashtbl : unit -> (string, string) Hashtbl.t

end

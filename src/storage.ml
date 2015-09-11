(* Provide a convinient API for Webstorage *)

open Bootstrapper

(* Exception if Webstorage not allowed *)
exception Not_allowed

(* Minimal interface for implementing Storage *)
module type STORAGE_HANDLER =
sig
  val handler : Dom_html.storage Js.t Js.optdef
end

(* General API *)
module type STORAGE =
sig
  val get : string -> string option
  val set : string -> string -> unit
  val remove : string -> unit
  val clear : unit -> unit
  val key : int -> string option
  val length : unit -> int

end

(* Generalize API *)
module Make_storage (F : STORAGE_HANDLER) : STORAGE = 
struct

  let handler =
    Js.Optdef.case
      F.handler
      (fun () -> raise Not_allowed)
      (fun x -> x)
      
  let length () = handler ## length

  let wrap f k =
    let r =
      try Some (Get.unopt(f k))
      with _ -> None
    in Option.map s_ r

  let get key = wrap (fun x -> handler ## getItem(_s x)) key
  let key index = wrap (fun x -> handler ## key(x)) index
  let set key value = handler ## setItem(_s key, _s value)
      
  let remove key = handler ## removeItem (_s key)
  let clear () = handler ## clear()

end

(* Session storage *)
module Session =
  Make_storage(struct
    let handler = Dom_html.window ## sessionStorage
  end)

(* Local storage *)
module Local =
  Make_storage(struct
    let handler = Dom_html.window ## localStorage
  end)

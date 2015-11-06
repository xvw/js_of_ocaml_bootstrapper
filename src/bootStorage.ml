(* Provide a convinient API for Webstorage *)

open BootPervasives

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
  val to_hashtbl : unit -> (string, string) Hashtbl.t
  val map : (string -> string -> string) -> unit
  val fold : ('a -> string -> string -> 'a) -> 'a -> 'a
  val filter : (string -> string -> bool) -> (string, string) Hashtbl.t
  val iter : (string -> string -> unit) -> unit
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
      try Some (BootHtml.unopt(f k))
      with _ -> None
    in BootOption.map s_ r

  let get key = wrap (fun x -> handler ## getItem(_s x)) key
  let key index = wrap (fun x -> handler ## key(x)) index
  let set key value = handler ## setItem(_s key, _s value)
      
  let remove key = handler ## removeItem (_s key)
  let clear () = handler ## clear()

  let raw_get key = match get key with
    | Some r -> r
    | _ -> raise Not_allowed

  let to_hashtbl () =
    let len = length () in
    let h = Hashtbl.create len in
    for i = 0 to (len - 1) do
      let k = match key i with
        | Some r -> r
        | _ -> raise Not_allowed
      in
      match get k with
      | Some e -> Hashtbl.add h k e
      | _ -> raise Not_allowed
    done;
    h

  let map f =
    let len = length () in
    for i = 0 to (len - 1) do
      match key i with
      | Some r -> set r (f r (raw_get r))
      | _ -> raise Not_allowed
    done

  let iter f =
    let len = length () in
    for i = 0 to (len - 1) do
      match key i with
      | Some r -> (f r (raw_get r))
      | _ -> raise Not_allowed
    done

  let fold f acc =
    let len = length () in
    let rec aux acc = function
      | i when i = len -> acc
      | i ->
        begin match key i with
          | Some r -> aux (f acc r (raw_get r)) (i + 1)
          | _ -> raise Not_allowed
        end
    in aux acc 0

  let filter p =
    let len = length () in
    let h = Hashtbl.create len in
    for i = 0 to (len - 1) do
      let k = match key i with
        | Some r -> r
        | _ -> raise Not_allowed
      in
      match get k with
      | Some e ->
        if p k e then Hashtbl.add h k e
      | _ -> raise Not_allowed
    done;
    h
      

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

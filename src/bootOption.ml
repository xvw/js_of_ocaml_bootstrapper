open BootPervasives

let safe f x = try Some (f x) with _ -> None
    
let unit_map f = function
  | Some e -> f e
  | None -> ()
              
let some x = Some x
let none = None
  
let default value = function
  | None -> value
  | Some x -> x

let map f = function
  | None -> None
  | Some x -> Some (f x)

let apply = function
  | None -> id
  | Some f -> f

let is_some = function
  | Some _ -> true
  | _ -> false

let is_none = function
  | None -> true
  | _ -> false



module Bind : BootInterfaces.Monad.BIND with type 'a t = 'a option =
struct
  type 'a t = 'a option
  let return x = some x
  let bind m f = match m with
    | Some x -> f x
    | None -> None
end

module Plus : BootInterfaces.Monad.PLUS with type 'a t = 'a option =
struct
  type 'a t = 'a option
  let mempty = None
  let mplus a b =
    match (a, b) with
    | None, x -> x
    | x, None -> x
    | x, _ -> x
end

module Basic_monad = BootMonad.Make.WithBind(Bind)
include BootMonad.Make.Plus (Basic_monad) (Plus)

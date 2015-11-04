(* A Simple todo-list using local storage *)

open Bootstrapper

type task = {
  title : int
; label : string
; state : bool
} deriving (Yojson)

module Sample =
  Application (
  struct
    
    let initialize () =
      let app = Html.get_by_id "app" in
      let _ = Html.text ~into:(Some app) "Hello World"
      in ()
        
  end
  )

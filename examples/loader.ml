(* Sample *)
module App =
  Bootstrapper.Application(
  struct

    open Bootstrapper
        
    let initialize () =
      let _ = load_library (`Css "loader.css") in
      let _ = load_library (`Js "loaderex.js")
      in ()
                  
  end
  )


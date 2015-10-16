(* Sample *)
module App =
  Bootstrapper.Application_with(
  struct

    open Bootstrapper

    let context = [
      `Css "loader.css";
      `Js "loaderex.js"
    ]
    
    let initialize () =
      alert "done"
                  
  end
  )


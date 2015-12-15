open Bootstrapper
    
module Sample =
  Application (
  struct
    
    let initialize () =
      let _ = alert "Hello World"
      in ()
         
  end
  )

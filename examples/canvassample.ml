(* Sample *)
module App =
  Bootstrapper.Application(
  struct

    open Bootstrapper
        
    let initialize () =
      let app = Get.byId "application" in
      let _ = Canvas.create_in app 600 400 in
      let _ = Canvas.(fill_rect (plain_color Color.red) empty (_rect 1 1 10 10))
      in ()
                  
  end
  )



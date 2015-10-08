(* Sample *)
module App =
  Bootstrapper.Application(
  struct

    open Bootstrapper
        
    let initialize () =
      let app = Get.byId "application" in
      let _ = Canvas.create_in app 600 400 in
      let p = Canvas.(linear_gradient (point 0 0) (point 600 400) [0.0, Color.red; 1., Color.green]) in
      let _ = Canvas.(fill_rect p empty (_rect 0 0 600 400)) in
      ()
                  
  end
  )



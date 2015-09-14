(* Sample *)
module App =
  Bootstrapper.Application(
  struct

    open Bootstrapper
        
    let initialize () =
      let app = Get.byId "application" in
      let _ = Canvas.create_in app 600 400 in
      let _ =
        Canvas.(
          fill_all
            (
              linear_gradient
                (point 75 100)
                (point 5 90)
                [
                  (0., Color.red);
                  (1., Color.white);
                ]
            )
        )
      in ()
                  
  end
  )



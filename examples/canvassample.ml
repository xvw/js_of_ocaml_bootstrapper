(* Sample *)
module App =
  Bootstrapper.Application(
  struct

    open Bootstrapper
        
    let initialize () =
      let app = Get.byId "application" in
      let _ = Canvas.create_in app 600 400 in
      let img =
        Canvas.image
          ~path:(Some
                   "http://cdn.codesamplez.com/wp-content/uploads/2013/04/Lambda.png")
          ~onload:(fun i ->
              Canvas.(draw_image_with_size i (_rect 10 10 200 100))
            ) ()

      in ()
                  
  end
  )



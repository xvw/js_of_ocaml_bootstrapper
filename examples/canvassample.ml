(* Sample *)
module App =
  Bootstrapper.Application(
  struct

    open Bootstrapper
        
    let initialize () =
      let app = Get.byId "application" in
      let img = Canvas.image ~path:(Some "https://avatars2.githubusercontent.com/u/6772534?v=3&s=460") () in
      let _ = Canvas.create_in app 600 400 in
      let _ = Canvas.draw_image img (Canvas.point 10 10)
      in ()
                  
  end
  )



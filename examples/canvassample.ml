(* Sample *)
module App =
  Bootstrapper.Application(
  struct

    open Bootstrapper
        
    let initialize () =
      let app = Get.byId "application" in
      let open Canvas in
      let _ = create_in app 600 400 in
      let _ =
        draw_text
          ~font:(font 30 "Helvetica")
          empty (plain_color Color.red)
          "Hello World" (10., 45.)
      in 
      ()
                  
  end
  )



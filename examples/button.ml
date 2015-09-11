(* Sample *)
module App =
  Bootstrapper.Application(
  struct

    open Bootstrapper
        
    let initialize () =
        
      let app = Get.byId "application" in
      let btn =
        Input.create
          ~into:(Some app)
          "button"
          "Click me !"
      in
      let _ =
        let open Event in 
        btn >- (
          click,
          fun _ _ ->
            let sp = Create.element ~into:(Some app) Dom_html.createDiv
            in Create.text ~into:(Some sp) "Hello World"
        )
      in ()
         
  end
  )



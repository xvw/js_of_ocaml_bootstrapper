(* Sample *)
module App =
  Bootstrapper.Application(
  struct

    open Bootstrapper
        
    let initialize () =
        
      let app = Get.byId "application" in
      let h1  =
        Create.element
          ~into:(Some app)
          Dom_html.createH1 in
      let txt =
        Create.text
          ~into:(Some h1)
          "Hello World"
      in ()
                  
  end
  )


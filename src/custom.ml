(* Sample *)
module App =
  Bootstrapper.Application(
  struct

    open Bootstrapper
        
    let initialize () =
        
      let app = Get.byId "application" in
      Canvas.createIn app 640 480;
      Canvas.fillAll "#1A2530"
      
  end
  )

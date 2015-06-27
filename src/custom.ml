(* Sample *)
module App =
  Bootstrapper.Application(
  struct

    open Bootstrapper

    let initialize () =
      let open Event in
      let app = Get.byId "application" in
      let btn = Input.create ~into:(Some app) "button" "Click" in 
      let _   =
        btn >- (click, (fun _ _ -> alert "Hello World !"))
      in ()
      
  end
  )

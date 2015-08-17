(* Sample *)
module App =
  Bootstrapper.EHtml_Application(
  struct

    open Bootstrapper

    let initialize () =
      let open Event in
      let app = Get.byId "application" in
      let btn = Input.create ~into:(Some app) "button" "Click" in
      let _   =
        btn >- (click, (fun _ _ ->
            Firebug.console ## log (Get.find app "#title")
          ))
      in ()
      
  end
  )

(* Sample *)
module App =
  Bootstrapper.EHtml_Application(
  struct

    open Bootstrapper

    let initialize () =
      let open Event in
      let app = Get.byId "application" in
      let title = Get.select Dom_html.document "#title" in
      let _ = alert (string_of_int (List.length title)) in
      let btn = Input.create ~into:(Some app) "button" "Click" in 
      let _   =
        btn >- (click, (fun _ _ -> alert "Hello World !"))
      in ()
      
  end
  )

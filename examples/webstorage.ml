(* Sample *)
module App =
  Bootstrapper.Application(
  struct

    open Bootstrapper
        
    let initialize () =
          
      let say_hello container nickname =
        Create.text ~into:container ("Hello "^nickname)
      in

      
      let create_form container =
        let c = Create.element ~into:container Dom_html.createDiv in
        let t = Input.create ~into:(Some c) "text" "Your nickname" in
        let i = Input.create ~into:(Some c) "button" "Save it !" in
        Event.(
          i >-
          (click, fun _ _ ->
              let new_name = Input.valueOf (t) in
              let _ = Storage.Session.set "nick" new_name in
              say_hello container new_name
          )
        )
      in 
      
      let app = Some (Get.byId "application") in
      let _ =
        match (Storage.Session.get "nick")  with
        | None -> create_form app |> ignore
        | Some x -> say_hello app x |> ignore
      in ()
  end
  )


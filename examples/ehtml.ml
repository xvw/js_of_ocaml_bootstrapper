(* Sample *)
module App =
  Bootstrapper.EHtml_Application(
  struct

    open Bootstrapper

    let registered_callback = [
      "testA", (fun _ -> alert "test");
      "testB", (fun _ -> alert "test2");
      "log", (fun x -> log x);
    ]
        
    let initialize () = ()
                  
  end
  )


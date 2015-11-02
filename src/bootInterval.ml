open BootPervasives

let set ?(delay=0.1) f =
  BootEvent.delayed_loop ~delay f
    
let set_until ?(delay=0.1) pred f =
  let cpt = ref 0 in
  let _ = while pred(!cpt) do
      let _ = Lwt_js.sleep delay >>= (fun _ -> Lwt.return (f ())) in
      cpt := !cpt + 1
    done
  in Lwt.return_unit
       
let set_for ?(delay=0.1) x f =
  set_until ~delay (fun i -> i < x) f

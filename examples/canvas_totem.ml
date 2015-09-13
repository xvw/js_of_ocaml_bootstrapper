module App =
  Bootstrapper.Application(
  struct

    open Bootstrapper

    let width, height = 180, 300
    let s_width, s_height = 5, 5

    (* Sad boilerplate for array *)
    let array_rev arr =
      let open Array in
      let xs = copy arr in let n = length xs in
      let j = ref (n-1) in
      let _ =
        for i = 0 to n/2-1 do
          let c = xs.(i) in
          let _ = xs.(i) <- xs.(!j) in
          let _ = xs.(!j) <- c in decr j
        done
      in xs
      
    let coeff_x, coeff_y = width/s_width, height/s_height
    let matrix =
      let _ = Random.self_init () in
      Array.init coeff_y
        (fun i ->
           let arr =
             Array.init (coeff_x/2)
               (fun j ->
                  (Random.int 10 >= 6 (* && j > (coeff_x/5) *)),
                  (float_of_int (j*s_width)),
                  (float_of_int (i*s_height))
               ) in
           let sec =
             Array.mapi (fun ri (b, x, y) ->
                 let zz = float_of_int ((coeff_x/2)*s_width) in
                 (b, zz +. (float_of_int (ri * s_width)), y)
               ) (array_rev arr)
           in Array.append arr sec
        )
        
    let initialize () =
      let app = Get.byId "application" in
      let _ = Canvas.create_in app width height in
      let _ = Canvas.fill_all "#FFF"
      in
      Array.iter
        (fun line ->
           Array.iter
             (fun (flag, x, y) ->
                Canvas.fill_rect
                  (if flag then Some "#223377" else None)
                  None
                  x y
                  (float_of_int s_width)
                  (float_of_int s_height)
             ) line
        )
        matrix
                  
  end
  )


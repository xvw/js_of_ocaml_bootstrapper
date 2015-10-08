(* A simple game of life *)
(* Sample *)
module App =
  Bootstrapper.Application(
  struct

    let width = 200
    let height = 150 

    open Dom_html
    open Bootstrapper

    let grid_style =
      "display:flex;"
      ^ "flex-direction: column;"
      ^ "position: absolute;"
      ^ "top:0; left:0; right:0; bottom: 0;"

    let line_style =
      "display:flex;"
      ^ "width:100%;"
      ^ "flex-direction:row;"
      ^ "flex: 1;"

    let cell_style rest =
      "width: 100%; height: 100%;"
      ^ rest
      
    let alive_style = cell_style "background-color:green;"
    let dead_style = cell_style "background-color: white"

    let create_cell line =
      let c = Create.element ~into:(Some line) createDiv in
      let _ = Attribute.Data.set c "state" "dead" in
      let _ = Attribute.set c "style" dead_style in
      c
    
    let create_line app  =
      let d = Create.element ~into:(Some app) createDiv in
      let _ = Attribute.set d "style" line_style in
      d
        
    let rec set_state cell = function
      | `Alive ->
        let _ = Attribute.Data.set cell "state" "alive" in
        Attribute.set cell "style" alive_style
      | `Dead ->
        let _ = Attribute.Data.set cell "state" "dead" in
        Attribute.set cell "style" dead_style
      | `Revert ->
        match Attribute.Data.get cell "state"  with
        | Some "alive" -> set_state cell `Dead
        | Some "dead" -> set_state cell `Alive
        | _ -> set_state cell `Dead

    let is_alive cell =
      match Attribute.Data.get cell "state" with
      | Some "alive" -> true
      | _ -> false

    let hood i j =
      List.filter
        (fun (y, x) -> x > 0 && x < width && y > 0 && y < height)
        [
          (i-1, j-1);(i-1, j);(i-1, j+1);
          (i, j-1);  (i, j+1);
          (i+1, j-1);(i+1, j);(i+1, j+1);
        ]

    let alive_neig grid i j =
      List.filter
        (fun (i, j) -> is_alive (grid.(i).(j)))
        (hood i j)
      |> List.length

    let random_state () =
      if Random.bool ()
      then `Alive
      else `Dead
         
    let make_grid app =
      let _ = Random.self_init () in
      let _ = Attribute.set app "style" grid_style in
      Array.init height (fun i ->
          let line = create_line app in
          Array.init width (fun j ->
              let r = create_cell line in
              let _ = set_state r (random_state ())  in r
            )
            
        )

    let iter_next_state grid =
      Array.init height
        (fun i ->
           Array.init width  (fun j ->
               let aln = alive_neig grid i j in
               if is_alive grid.(i).(j) then
                 begin 
                   if aln = 2 || aln = 3 then `Alive
                   else `Dead
                 end 
               else begin 
                 if aln = 3 then `Alive
                 else `Dead
               end 
             )
        )

    let next_state grid =
      let c = iter_next_state grid in
      Array.iteri
        (fun i l ->
           Array.iteri (fun j k ->
               set_state grid.(i).(j) k
             ) l
        ) c
        
        
    let initialize () =
      let app  = Get.byId "application" in
      let grid = make_grid app in
      let _ = Event.delayed_loop (fun () -> next_state grid)
      in () 
                  
  end
  )



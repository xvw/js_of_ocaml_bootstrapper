(* Canvas Helper 
   work in progress
*)
open Bootstrapper

exception Already_created
exception Not_created


(* Canvas reference *)
let get = ref None

(* Create a Canvas *)
let create width height =
  match !get with
  | Some _ -> raise Already_created
  | None ->
    let canvas = Dom_html.(createCanvas document) in
    let _ = (canvas ## width <- width)
    and _ = (canvas ## height <- height)
    in get := (Some (canvas))

(* Wrap canvas operation *)
let wrap f =
  match !get with
  | None -> raise Not_created
  | Some x -> f x

(* Append canvas into an element *)
let append elt =
  wrap (fun canvas -> Dom.appendChild elt canvas ) 
  

(* Create canvas inside an element *)
let create_in elt width height =
  let _ = create width height in
  append elt

let wrap_2d f =
  wrap (fun canvas ->
      f canvas (canvas ## getContext(Dom_html._2d_))
    )

module Internal =
struct

  let pi = 3.14159265358979323846

  let cap_style s =
    let style = match s with 
      | `Round -> "round"
      | `Square -> "square"
      | `Butt -> "butt"
    in _s style

  let join_style s =
    let style = match s with
      | `Bevel -> "bevel"
      | `Square -> "square"
      | `Mitter -> "mitter"
    in _s style

  let stroke ctx c =
    let _ = ctx ## strokeStyle <- (Color.to_js c) in
    ctx ## stroke ()
      
  let fill ctx c =
    let _ = ctx ## fillStyle <- (Color.to_js c) in
    ctx ## fill ()

  let wrap_option f ctx = function
    | Some x -> f ctx x
    | None   -> ()
      
end

let draw fc sc fs =
  wrap_2d (fun canvas ctx ->
      let _ = ctx ## beginPath () in
      let _ = List.iter (fun f -> f ()) fs in
      let _ = Internal.(wrap_option fill ctx fc) in
      Internal.(wrap_option stroke ctx sc)
    )


let line_join style =
  wrap_2d (fun canvas ctx ->
      ctx ## lineJoin <- (Internal.join_style style)
    )

let line_cap style =
  wrap_2d (fun canvas ctx ->
      ctx ## lineCap <- (Internal.cap_style style)
    )


let clear_rect x y width height =
  wrap_2d (fun canvas ctx ->
      ctx ## clearRect(x, y, width, height)
    )
      
let fill_rect fill_color stroke_color x y width height =
  wrap_2d (fun canvas ctx ->
      let _ = match fill_color with
        | Some color ->
          let _ = ctx ## fillStyle <- (Color.to_js color) in
          ctx ## fillRect(x, y, width, height)
        | None -> ()
      in
      match stroke_color with
      | Some color ->
        let _ = ctx ## strokeStyle <- (Color.to_js color) in
        ctx ## strokeRect(x, y, width, height)
      | None -> ()
    )

let fill_square fc sc x y w = fill_rect fc sc x y w w 

let clear_all () =
  wrap (fun canvas ->
      let w = float_of_int (canvas ## width)
      and h = float_of_int (canvas ## height)
      in clear_rect 0. 0. w h
    )

let fill_all color_str =
  wrap (fun canvas ->
      let w = float_of_int (canvas ## width)
      and h = float_of_int (canvas ## height)
      in fill_rect (Some color_str) None  0. 0. w h
    )


let shape ?(closed=false) points  =
  wrap_2d (fun canvas ctx ->
      match points with
      | (x,y) :: point_list -> 
        let _ = ctx ## moveTo (x,y) in
        let _ = List.iter (fun (x,y) -> ctx ## lineTo (x,y)) point_list in
        if closed then ctx ## closePath () 
      | _ -> ()
    )

let fill_shape ?(closed=false) fill_color stroke_color points  =
  draw fill_color stroke_color [fun () -> shape ~closed points]

let fill_closed_shape = fill_shape ~closed:true

let fill_triangle fc sc pa pb pc =
  fill_shape ~closed:true fc sc [pa; pb; pc] 


let arc ?(clockwise=true)  x y radius sa ea =
  wrap_2d (fun canvas ctx ->
      let anticlockwise = if clockwise then Js._false else Js._true in
      ctx ## arc (x, y, radius, sa, ea, anticlockwise)
    )

let fill_arc ?(clockwise=true) fc sc x y radius sa ea =
  draw fc sc [fun () -> arc x y radius sa ea]
  
let fill_circle fc sc x y radius =
  fill_arc fc sc x y radius 0. (Internal.pi *. 2.)


let quadratic_curve x y x2 y2 =
  wrap_2d (fun canvas ctx -> ctx ## quadraticCurveTo(x, y, x2, y2))


let fill_quadratic_curve fc sc x y x2 y2 =
  draw fc sc [fun () -> quadratic_curve x y x2 y2]


let bezier_curve x y x2 y2 x3 y3 =
  wrap_2d (fun canvas ctx -> ctx ## bezierCurveTo(x, y, x2, y2, x3, y3))


let fill_bezier_curve fc sc x y x2 y2 x3 y3 =
  draw fc sc [fun () -> bezier_curve x y x2 y2 x3 y3]

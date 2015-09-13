(** This module provide some function for canvas manipulation.
    Like HTML5 (actual) specification you can just have one 
    canvas per page. 
    When a canvas is created, you don't have to relay his reference. 
    The module look if the canvas is already created and return it 
    (and raise an exception : [Not_created] if the canvas isn't 
    initialized. 

    You could use [Color] for building colors.
*)

(** {2 Exceptions } *)

exception Already_created
exception Not_created

(** {2 Canvas creation } *)

(** 
   This library provide a unified way to make stroked or filled 
   shape. The stroking/filling parameter depend on the fill/stroke_color 
   option.
*)


(** [Canvas.create width height] creates a canvas *)
val create : int -> int -> unit

(** [Canvas.append elt] append the created canvas into [elt] *)
val append : Dom_html.element Js.t -> unit

(** Create and append a Canvas (junction between [create] and [append] *)
val create_in : Dom_html.element Js.t -> int -> int -> unit

(** {2 Canvas drawing style } *)


(** [Canvas.line_cap style] define the cap style of the strokes *)
val line_cap : [< `Round | `Square | `Butt ] -> unit 

(** [Canvas.line_join style] define the join style of the strokes *)
val line_join : [< `Bevel | `Square | `Mitter ] -> unit 

(** {2 Canvas Drawing} *)

(** Draw a sequence *)
val draw : Color.t option -> Color.t option -> (unit -> unit) list -> unit

(** [shape points] draw point on the canvas*)
val shape : ?closed:bool -> (float * float) list -> unit

(** [arc ~clockwise:true x y radius start_angle end_angle] draw an arc *)
val arc :
  ?clockwise:bool ->
  float -> float ->
  float -> float -> float ->
  unit


(** 
   [Canvas.quadratic_curve x1 y1 x2 y2]
   Draw a quatratic curve from [(x1, y1)] to [(x2, y2)]
*)
val quadratic_curve :
  float -> float ->
  float -> float ->
  unit

(** 
   [Canvas.bezier_curve x1 y1 x2 y2 x3 y3]
   Draw a bezier curve from [(x1, y1)] to [(x3, y3)] using [(x2, y2)] as 
   curve high.
*)
val bezier_curve :
  float -> float ->
  float -> float ->
  float -> float ->
  unit


(** {2 Canvas shape} *)

(** [Canvas.clear_rect x y width h] clear the defined rect *)
val clear_rect : float -> float -> float -> float -> unit

(** Clear all surface of the canvas *)
val clear_all : unit -> unit

(** [Canvas.clear_rect fill_color stroke_color x y width h] colorized the
    defined rect filled with [fill_color] and stoked with [stroke_color] 
*)
val fill_rect :
  Color.t option ->
  Color.t option ->
  float -> float -> float -> float -> unit

(** [Canvas.fill_square fill_color stroke_color x y size] draw a square 
    on the canvas
*)
val fill_square : 
  Color.t option ->
  Color.t option ->
  float -> float -> float -> unit

(** [Canvas.fill_triangle fill_color stroke_color (x,y) (x2,y2) (x3,y3)]
    draw a rectangle
*)
val fill_triangle :
  Color.t option ->
  Color.t option ->
  (float * float) -> (float * float) -> (float * float) ->
  unit

(** [Canvas.fill_all color] fill all the surface with [color]*)
val fill_all : Color.t -> unit

(** [Canvas.shape ~closed:false fill_color stroke_color points_list] 
    will draw a shape on the Canvas (if ~closed:true, the shape will 
    be closed)
*)
val fill_shape :
  ?closed:bool ->
  Color.t option ->
  Color.t option ->
  (float * float) list
  -> unit

(** [Canvas.closed_shape fill_color stroke_color points_list]
    will be created a closed shape on the canvas
*)
val fill_closed_shape :
  Color.t option ->
  Color.t option ->
  (float * float) list ->
  unit

(** [Canvas.fill_circle fill_color stroke_color x y radius] Draw 
    a circle on the canvas *)
val fill_circle :
  Color.t option ->
  Color.t option ->
  float -> float -> float -> unit

(** 
   [Canvas.fill_arc ~clockwise:true 
   fill_color stroke_color x y radius, start_angle end_angle]
   Draw an arc on the canvas
*)
val fill_arc :
  ?clockwise:bool ->
  Color.t option ->
  Color.t option ->
  float -> float -> float -> float -> float ->
  unit

(** 
   [Canvas.fill_quadratic_curve fill_color stroke_color x1 y1 x2 y2]
   Draw a quatratic curve from [(x1, y1)] to [(x2, y2)]
*)
val fill_quadratic_curve :
  Color.t option ->
  Color.t option ->
  float -> float ->
  float -> float ->
  unit

(** 
   [Canvas.fill_bezier_curve fill_color stroke_color x1 y1 x2 y2 x3 y3]
   Draw a bezier curve from [(x1, y1)] to [(x3, y3)] using [(x2, y2)] as 
   curve high.
*)
val fill_bezier_curve :
  Color.t option ->
  Color.t option ->
  float -> float ->
  float -> float ->
  float -> float ->
  unit

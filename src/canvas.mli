(** This module provide some function for canvas manipulation.
    Like HTML5 (actual) specification you can just have one 
    canvas per page. 
    When a canvas is created, you don't have to relay his reference. 
    The module look if the canvas is already created and return it 
    (and raise an exception : [Not_created] if the canvas isn't 
    initialized. 

    You could'nt use [Color] for building color as a String, colors 
    are already wrapped into a Js context.
*)

(** {2 Exceptions } *)

exception Already_created
exception Not_created

(** {2 Canvas creation } *)

(** [Canvas.create width height] creates a canvas *)
val create : int -> int -> unit

(** [Canvas.append elt] append the created canvas into [elt] *)
val append : Dom_html.element Js.t -> unit

(** Create and append a Canvas (junction between [create] and [append] *)
val create_in : Dom_html.element Js.t -> int -> int -> unit

(** {2 Canvas drawing} *)

(** [Canvas.clearRect x y width h] clear the defined rect *)
val clear_rect : float -> float -> float -> float -> unit

(** Clear all surface of the canvas *)
val clear_all : unit -> unit

(** [Canvas.clearRect fill_color stroke_color x y width h] colorized the defined
    rect filled with [fill_color] and stoked with [stroke_color] 
*)
val fill_rect :
  string option ->
  string option ->
  float -> float -> float -> float -> unit

(** [Canvas.fill_all color] fill all the surface with [color]*)
val fill_all : string -> unit

(** [Canvas.shape ~closed:false fill_color stroke_color points_list] 
    will draw a shape on the Canvas (if ~closed:true, the shape will 
    be closed)
*)
val shape :
  ?closed:bool ->
  string option ->
  string option ->
  (float * float) list
  -> unit

(** [Canvas.closed_shape fill_color stroke_color points_list]
    will be created a closed shape on the canvas
*)
val closed_shape :
  string option ->
  string option ->
  (float * float) list ->
  unit

(** [Canvas.line_cap style] define the cap style of the strokes *)
val line_cap : [< `Round | `Square | `Butt ] -> unit 

(** [Canvas.line_join style] define the join style of the strokes *)
val line_join : [< `Bevel | `Square | `Mitter ] -> unit 

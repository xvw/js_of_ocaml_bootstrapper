

(** 
   Option in OCaml are like Maybe from Haskell. A value could exist [Some x] or 
   not, [None]. This library provides some function for using Option.
*)

include BootInterfaces.Monad.PLUS_INTERFACE with type 'a t = 'a option


(** {2 Common functions} *)
                                               
val some : 'a -> 'a option
(** [some x] returns [Some x] *)

val none : 'a option
(** [none] returns [None] *)

val default : 'a -> 'a option -> 'a
(** return the wrapped value or the first arguments (if the gived 
    option is None )
*)

(** {2 Applications } *)


(** [Option.safe f x] try to execute [f x], if the result 
      don't raise any exception, the result is [Some (f x)] else [None] *)
val safe : ('a -> 'b) -> 'a -> 'b option
    
(** Map a side effect on an option *)
val unit_map : ('a -> unit) -> 'a option -> unit
  
val map : ('a -> 'b) -> 'a option -> 'b option
(** [map f opt] returns [Some (f x)] if opt = Some x, None if opt = None *)

val apply : ('a -> 'a) option -> 'a -> 'a
(** [apply None x] returns [x] and [apply (Some f) x] returns [f x] *)

(** {2 Option verification} *)

val is_some : 'a option -> bool
(** [is_some opt] returns true if opt is Some(x), otherwise false *)

val is_none : 'a option -> bool
(** [is_none opt] returns true if opt is None, otherwise false *)

(** {2 Monadic functions} *)
                                               
(** Place a value in a minimal monadic context *)
val return : 'a -> 'a option

(** The join function is the conventional monad join operator. 
    It is used to remove one level of monadic structure, projecting its
    bound argument into the outer level.*)
val join : 'a option option -> 'a option

(** Sequentially compose two actions, passing any value produced by the
    first as an argument to the second.*)
val bind : 'a option -> ('a -> 'b option) -> 'b option

(** Sequential application  *)
val fmap : ('a -> 'b) -> 'a option -> 'b option

(** void value discards or ignores the result of evaluation, such as the
    return value of an IO action. *)
val void : 'a option -> unit option

(** Promote a function to a monad. *)
val liftM : ('a -> 'b) -> 'a option -> 'b option

(** Promote a function to a monad, scanning the monadic arguments from left
    to right *)
val liftM2 : ('a -> 'b -> 'c) -> 'a option -> 'b option -> 'c option


(** Represent the neutral element *)
val mempty : 'a option
    
(** Monoïd combination *)
val mplus : 'a option -> 'a option -> 'a option

val keep_if : ('a -> bool) -> 'a -> 'a option
(** [ list >>= keep_if predicat ] returns an option containing the values who's 
    respecting the gived predicat. *)



(** {4 Infix operators} *)


(** Infix operator for mplus *)
val ( <+> ) : 'a option -> 'a option -> 'a option

(** Sequential application. *)
val ( <*> ) : ('a -> 'b) option -> 'a option -> 'b option

(** infix alias of fmap *)
val ( <$> ) : ('a -> 'b) -> 'a option -> 'b option

(** infix alias of fmap *)
val ( >|= ) : 'a option -> ('a -> 'b) -> 'b option


(** Replace all locations in the input with the same value. *)
val ( <$ ) : 'a -> 'b option -> 'a option

(** Sequence actions, discarding the value of the first argument. *)
val ( *> ) : 'a option -> 'b option -> 'b option

(** Sequence actions, discarding the value of the second argument. *)
val ( <* ) : 'a option -> 'b option -> 'a option

(** A variant of <*> with the arguments reversed. *)
val ( <**> ) : 'a option -> ('a -> 'b) option -> 'b option

(** Sequentially compose two actions, passing any value produced by the
    first as an argument to the second.*)
val ( >>= ) : 'a option -> ('a -> 'b option) -> 'b option

(** Right-to-left Kleisli composition of monads. (>=>), with the arguments
    flipped *)
val ( <=< ) : ('b -> 'c option) -> ('a -> 'b option) -> 'a -> 'c option

(** Left-to-right Kleisli composition of monads. *)    
val ( >=> ) : ('a -> 'b option) -> ('b -> 'c option) -> 'a -> 'c option

(** Flipped version of >>= *)
val ( =<< ) : ('a -> 'b option) -> 'a option -> 'b option

(** Sequentially compose two actions, discarding any value produced by the
    first, like sequencing operators (such as the semicolon) in imperative
     languages. *)
val ( >> ) : 'a option -> 'b option -> 'b option


(** This module provides all interfaces using for the functors. *)

open BootPervasives

(** This submodules is a namespace for monadic's interfaces *)
module Monad =
struct

  (** 
     Monadics operation could be generated with two ways : using
     an interface with a parametrized type, return and bind. Or 
     using an interface with a parametrized type, return, join 
     and fmap.

     A lot of those function's description come from the Haskell documentation
  *)

  (*
   * This module avoid functor's (from Haskell)  behaviours, 
   * beacause, in my own use case i don't use it ! 
   *)


  (** The common API for creating a Monad *)
  module type COMMON =
  sig
    type 'a t
        
    (** Place a value in a minimal monadic context *)
    val return : 'a -> 'a t
        
  end
  
  (** Describe the minimal interface for making a monad with bind 
      function. This module could be used by OmlMonad.Make.WithBind
      to generate a BASIC_INTERFACE Module, for example.
  *)
  module type BIND =
  sig
    include COMMON
        
    (** Sequentially compose two actions, passing any value produced by the
        first as an argument to the second.*)
    val bind : 'a t -> ('a -> 'b t) -> 'b t
        
  end

  (** Describe the minimal interface for making a monad with 
      join function. This module could be used by OmlMonad.Make.WithJoin
      to generate a BASIC_INTERFACE Module, for example.
  *)
  module type JOIN =
  sig
    include COMMON
        
    (** The join function is the conventional monad join operator. 
        It is used to remove one level of monadic structure, projecting its
        bound argument into the outer level.*)
    val join : ('a t) t -> 'a t

    (** Sequential application  *)
    val fmap : ('a -> 'b) -> 'a t -> 'b t
  end

  (** Describe a conjunction between join and bin.
      This module could be used by OmlMonad.Make.Base
      to generate a BASIC_INTERFACE Module, for example.
  *)
  module type BASIC_INTERFACE =
  sig
    include COMMON
        
    (** The join function is the conventional monad join operator. 
        It is used to remove one level of monadic structure, projecting its
        bound argument into the outer level.*)
    val join : ('a t) t -> 'a t

    (** Sequentially compose two actions, passing any value produced by the
        first as an argument to the second.*)
    val bind : 'a t -> ('a -> 'b t) -> 'b t
        
    (** Sequential application *)
    val fmap : ('a -> 'b) -> 'a t -> 'b t
        
  end
  
  (** Provide the signatures of all infix operators (linked to a Monad) *)
  module type INFIX =
  sig
    type 'a t
        
    (* Functor's operators *)

    (** Sequential application. *)
    val ( <*> ) : ('a -> 'b) t -> 'a t -> 'b t

    (** infix alias of fmap *)
    val ( <$> ) : ('a -> 'b) -> 'a t -> 'b t

    (** Replace all locations in the input with the same value. *)
    val ( <$  ) : 'a -> 'b t -> 'a t

    (** Sequence actions, discarding the value of the first argument. *)
    val ( *>  ) : 'a t -> 'b t -> 'b t

    (** Sequence actions, discarding the value of the second argument. *)
    val ( <*  ) : 'a t -> 'b t -> 'a t

    (** A variant of <*> with the arguments reversed. *)    
    val ( <**>) : 'a t -> ('a -> 'b) t -> 'b t
        
    (* Monadic opetaros *)
        
    (** Sequentially compose two actions, passing any value produced by the
        first as an argument to the second.*)
    val ( >>= ) : 'a t -> ('a -> 'b t) -> 'b t

    (** infix alias of fmap *)
    val ( >|= ) : 'a t -> ('a -> 'b) ->  'b t

    (** Right-to-left Kleisli composition of monads. (>=>), with the arguments
        flipped *)
    val ( <=< ) : ('b -> 'c t) -> ('a -> 'b t) -> 'a -> 'c t
        
    (** Left-to-right Kleisli composition of monads. *)    
	  val ( >=> ) : ('a -> 'b t) -> ('b -> 'c t) -> 'a -> 'c t

    (** Flipped version of >>= *)
    val ( =<< ) : ('a -> 'b t) -> 'a t -> 'b t

    (** Sequentially compose two actions, discarding any value produced by the
        first, like sequencing operators (such as the semicolon) in imperative
        languages. *)
    val ( >> )  : 'a t -> 'b t -> 'b t
     
  end

  (** Provide interface for the lift operations *)
  module type LIFT =
  sig
    type 'a t

    (** Promote a function to a monad. *)
    val liftM : ('a -> 'b) -> 'a t -> 'b t

    (** Promote a function to a monad, scanning the monadic arguments from left
        to right *)
    val liftM2 : ('a -> 'b -> 'c) -> 'a t-> 'b t-> 'c t
        
  end


  (** Provide the complete interface of monadic operations *)
  module type INTERFACE =
  sig
    include BASIC_INTERFACE
    include INFIX with type 'a t := 'a t
    include LIFT with type 'a t := 'a t

    (** void value discards or ignores the result of evaluation, such as the
        return value of an IO action. *)
    val void : 'a t -> unit t
        
  end

  (** Provide the minimal interface for a Monad Plus *)
  module type PLUS =
  sig
    type 'a t

    (** Represent the neutral element *)
    val mempty : 'a t

    (** Monoïd combination *)
    val mplus : 'a t -> 'a t -> 'a t
  end

  (** Provide a complete interface for Monad plus *)
  module type PLUS_INTERFACE =
  sig
    include INTERFACE
    include PLUS with type 'a t := 'a t

    (** Infix operator for mplus *)
    val ( <+> ) : 'a t -> 'a t -> 'a t

    (** [ list >>= keep_if predicat ] returns a list containing all values
        who's respecting the gived predicat. *)
    val keep_if : ('a -> bool) -> 'a -> 'a t
  end

  
  
end


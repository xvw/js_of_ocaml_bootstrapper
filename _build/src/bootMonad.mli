
(** This module provide generators for handle monadic behaviour. *)

module Make :
sig

  (** List of all functors*)

  (** Creates the minimal context with Join and fmap.
      Returns a BASIC_INTERFACE
  *)
  module WithJoin (M : BootInterfaces.Monad.JOIN ) :
    BootInterfaces.Monad.BASIC_INTERFACE with type 'a t = 'a M.t

  (** Creates the minimal context with bind.
      Returns a BASIC_INTERFACE
  *)
  module WithBind (M : BootInterfaces.Monad.BIND) :
    BootInterfaces.Monad.BASIC_INTERFACE with type 'a t = 'a M.t

  (** Creates a complete context with a BASIC_INTERFACE 
  *)
  module Base (M : BootInterfaces.Monad.BASIC_INTERFACE) :
    BootInterfaces.Monad.INTERFACE with type 'a t = 'a M.t

  (** Creates a complete context with a BASIC_INTERFACE and a 
      PLUS interface
  *)
  module Plus
      (M : BootInterfaces.Monad.BASIC_INTERFACE)
      (P : BootInterfaces.Monad.PLUS with type 'a t = 'a M.t) :
    BootInterfaces.Monad.PLUS_INTERFACE with type 'a t = 'a M.t 
  
end

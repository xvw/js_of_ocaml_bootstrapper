open BootPervasives


module Make =
struct 

  (* Functors for monad implementation *)
  (* Using join interface *)
  module WithJoin ( M : BootInterfaces.Monad.JOIN) :
    BootInterfaces.Monad.BASIC_INTERFACE with type 'a t = 'a M.t = 
  struct
    include M 
    let bind m f = join (fmap f m)
  end

  (* Using Bind interface *)
  module WithBind(M : BootInterfaces.Monad.BIND) :
    BootInterfaces.Monad.BASIC_INTERFACE with type 'a t = 'a M.t =
  struct
    include M
    let join m = bind m id
    let fmap f m = bind m (fun x -> return (f x)) 
  end

  (* Complete interface *)
  module Base(M : BootInterfaces.Monad.BASIC_INTERFACE) :
    BootInterfaces.Monad.INTERFACE with type 'a t = 'a M.t =
  struct
    include M
    let void _ = return () 
    let ( >>= ) f x = bind f x
    let ( <*> ) fs ms =
      fs >>= fun f ->
      ms >>= fun x -> return $ f x
    let ( <$> ) = fmap
    let ( <$  ) v = fmap (fun _ -> v)
    let ( *> ) x    = ( <*> ) (fmap (fun _ -> id) x)
	  let ( <* ) x _  = ( <*> ) (return id) x
    let ( <**> ) f x = flip (<*>) f x
    let ( >> ) m n   = m >>= (fun _ -> n)         
    let liftM = fmap
    let liftM2 f x y = f <$> x <*> y
    let ( >|= ) x f = fmap f x
    let ( <=< ) f g  = fun x -> g x >>= f
	  let ( >=> ) f g  = flip ( <=< ) f g 
	  let ( =<< ) f x  = flip ( >>= ) f x  
  end

  module Plus
      (M : BootInterfaces.Monad.BASIC_INTERFACE)
      (P : BootInterfaces.Monad.PLUS with type 'a t = 'a M.t) :
    BootInterfaces.Monad.PLUS_INTERFACE with type 'a t = 'a M.t =
  struct
    include Base(M)
    let mempty = P.mempty
    let mplus a b = P.mplus a b
    let ( <+> ) = mplus
    let keep_if f x =
      if f x then return x
      else mempty

  end

end

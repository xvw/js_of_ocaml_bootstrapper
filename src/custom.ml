module Sample =
  Bootstrapper.Application (
  struct
    open Bootstrapper

    let initialize () = alert "test"
  end
  )

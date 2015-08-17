# Js_of_ocaml bootstrapper
> A simple library (imho) for recurring tasks in JavaScript

## Entry point of an Application
This library use a functor to reference the application's entry-point :

```ocaml
(* Sample *)
module App =
  Bootstrapper.Application(
  struct
    (* Where the module must be implement "initialize : unit -> unit*)
    let initialize () = ()
  end
  )

```
initialize was wrapped into a promise (binded on the Onload behaviour).

## Helper for event
`elt >- (trigger, callback)`

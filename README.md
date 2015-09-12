# Js_of_ocaml bootstrapper
> A simple library (imho) for recurring tasks in JavaScript

## Build
Actually, this project don't use a decent build system...

```
make lib # compiling the lib into bytes
make doc # build the documentation (using eliomdoc)
```

You can read the Makefile to understand how to build your own custom JS file.

### Build examples
`make example_name.js` (see `examples/`)

### Using as a bootstrapper
Write your `js_of_ocaml` file in src/custom.ml, and run `make custom.js`for
making a js file into `js/`.

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



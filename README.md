> This project is completely rewritted 

# Js_of_ocaml bootstrapper
> A simple small library for MVP in OCaml and JavaScript


## Get and install the library
Actually, the library is not on OPAM (the package is still exprimental).

```bash
git clone https://github.com/xvw/js_of_ocaml_bootstrapper
cd js_of_ocaml_bootstapper
make
make install
git checkout bootstrapp
```
And now you are in a folder with a bootstrapped project (look at the Makefile and `src/custom.ml`).

### Manual compilation
If you don't want use the bootstrapper, after installation, you can just use :

```bash
ocamlfind ocamlc -package js_of_ocaml -syntax camlp4o -package js_of_ocaml.syntax -package js_of_ocaml_bootstapper -linkpkg -o your_file.byte your_file.ml
```
and run
```bash
js_of_ocaml -o your_output.js your_file.byte
```

SRC    = src
BYTES  = bytes
JS     = js

OCAMLFIND = ocamlfind ocamlc
PACKAGES  = -package js_of_ocaml -package js_of_ocaml.syntax -package js_of_ocaml_bootstrapper
SYNTAX    = -syntax camlp4o
COMPILER  = $(OCAMLFIND) $(PACKAGES) $(SYNTAX) -linkpkg -I $(SRC)

custom.js:
	mkdir -p $(BYTES)
	mkdir -p $(JS)
	$(COMPILER) -o $(BYTES)/custom.byte $(SRC)/custom.ml
	js_of_ocaml -o $(JS)/$(@) $(BYTES)/custom.byte

SRC       = src
BYTES     = bytes
JSOUT     = js
LIB       = bootstrapper

OCAMLFIND = ocamlfind ocamlc
PACKAGES  = -package js_of_ocaml -package js_of_ocaml.syntax
SYNTAX    = -syntax camlp4o
COMPILER  = $(OCAMLFIND) $(PACKAGES) $(SYNTAX) -linkpkg

.PHONY: clean bootstrapper

init_bytes:
	mkdir -p $(BYTES)

init_js:
	mkdir -p $(JSOUT)


bootstrapper: $(SRC)/$(LIB).ml
	$(COMPILER) -c $(<)

%.byte: $(SRC)/%.ml init_bytes $(LIB)
	$(COMPILER) -o $(BYTES)/$(@) -I $(SRC) $(LIB).cmo $(<)

%.js: %.byte init_js
	js_of_ocaml -o $(JSOUT)/$(@) $(BYTES)/$(<)

clean_bytes:
	rm -rf $(BYTES)
	rm -rf $(SRC)/*.cm*

clean_js:
	rm -rf $(JSOUT)

distclean: clean_bytes clean_js
clean: clean_bytes

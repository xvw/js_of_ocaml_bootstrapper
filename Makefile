SRC       = src
EXO       = examples
BYTES     = bytes
JSOUT     = js
LIB       = bootstrapper.cmo color.cmo canvas.cmo storage.cmo

OCAMLFIND = ocamlfind ocamlc
PACKAGES  = -package js_of_ocaml -package js_of_ocaml.syntax
SYNTAX    = -syntax camlp4o
COMPILER  = $(OCAMLFIND) $(PACKAGES) $(SYNTAX) -linkpkg -I $(SRC)

.PHONY: clean lib

init_bytes:
	mkdir -p $(BYTES)

init_js:
	mkdir -p $(JSOUT)


lib:
	$(COMPILER) -c $(SRC)/bootstrapper.ml
	$(COMPILER) -c bootstrapper.cmo $(SRC)/color.ml
	$(COMPILER) -c bootstrapper.cmo color.cmo $(SRC)/canvas.ml
	$(COMPILER) -c $(SRC)/storage.ml

%.byte: $(SRC)/%.ml init_bytes lib
	$(COMPILER) -o $(BYTES)/$(@) $(LIB) $(<)

%.byte: $(EXO)/%.ml init_bytes lib
	$(COMPILER) -o $(BYTES)/$(@) $(LIB) $(<)

%.js: %.byte init_js lib
	js_of_ocaml -o $(JSOUT)/$(@) $(BYTES)/$(<)


clean_bytes:
	rm -rf $(BYTES)
	rm -rf $(SRC)/*.cm*
	rm -rf $(EXO)/*.cm*

clean_js:
	rm -rf $(JSOUT)

distclean: clean_bytes clean_js
clean: clean_bytes clean_emacs
clean_emacs:
	rm -rf *~
	rm -rf */*~
	rm -rf \#*
	rm -rf */\#*

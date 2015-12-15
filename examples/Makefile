PORT   = 7777
SERVER = python -m SimpleHTTPServer $(PORT)
JSOUT  = js
SRC    = src
BYTES  = bytes

OCAMLFIND = ocamlfind ocamlc
PACKAGES  = -package js_of_ocaml -package js_of_ocaml.syntax -package js_of_ocaml_bootstrapper
SYNTAX    = -syntax camlp4o
COMPILER  = $(OCAMLFIND) $(PACKAGES) $(SYNTAX) -linkpkg -I $(SRC)

.PHONY: all
all: run

initialize:
	mkdir -p $(BYTES)
	mkdir -p $(JSOUT)	

%.byte : $(SRC)/%.ml initialize
	$(COMPILER) -o $(BYTES)/$(@) $(<)

%.js : %.byte
	js_of_ocaml -o $(JSOUT)/$(@) $(BYTES)/$(<)
	rm -rf $(SRC)/*.cm*

clean:
	rm -rf $(BYTES)
	rm -rf $(SRC)/*.cm*
	rm -rf *~
	rm -rf */*~

distclean: clean
	rm -rf $(JSOUT)/*

run: custom.byte custom.js
	rm -rf $(BYTES)
	$(SERVER)

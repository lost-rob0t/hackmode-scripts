##
# ralp, the hackmode expert system agumented by machine learning.
# Transpile Zap Requests to rules
# Also other tool output
# @file
# @version 0.1

LISP ?= sbcl

all: test

run:
	$(LISP) --load run.lisp

build:
	$(LISP)	--non-interactive \
		--load ralp.asd \
		--eval '(ql:quickload :ralp)' \
		--eval "(sb-ext:save-lisp-and-die \"ralp\" :toplevel 'ralp::main :executable t :compression t)"
install:
	mkdir -p "~/.local/bin/"
	cp ralp "~/.local/bin/"

clean:
	rm -v ralp

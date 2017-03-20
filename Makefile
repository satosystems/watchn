.PHONY: build
build:
	stack build

.PHONY: clean
clean:
	rm -rf .stack-work

.PHONY: install
install: build
	stack install watchn

.PHONY: test
test:
	stack test


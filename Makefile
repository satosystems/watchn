.PHONY: build
build:
	stack build

.PHONY: clean
clean:
	rm -rf .stack-work

.PHONY: test
test:
	stack test


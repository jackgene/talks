.PHONY: default
default: build

## Assumes elm-make is Elm 0.18
.PHONY: build
build:
	@elm-make $(shell find src -name "*.elm") --warn --output ../docs/functional-reactive-streaming/index.html --yes

.PHONY: clean
clean:
	@cd elm-stuff &&\
	rm -rf build-artifacts exact-dependencies.json

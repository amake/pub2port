SHELL := /bin/bash

exe := dist/dart2port
version := $(shell sed -nE 's/version: *(([0-9.])+)/\1/p' pubspec.yaml)
version_define = --define=APP_VERSION=$(version)

.PHONY: build
build: ## Build the executable
build: $(exe)

$(exe): bin/dart2port.dart lib/dart2port.dart | dist
	dart compile exe $(version_define) $(<) -o $(@)

dist:
	mkdir -p $(@)

.PHONY: test
test: ## Run tests
test: test-unit test-bin test-gen

.PHONY: test-unit
test-unit:
	dart test

.PHONY: test-bin
test-bin: $(exe)
	@[[ $$($(exe) --version) = "dart2port version: $(version)" ]] && echo bin: ok

.PHONY: test-gen
test-gen: $(exe)
	@diff <($(exe) test/generate/fixture/pubspec.lock.cad57bc) test/generate/gold/output.cad57bc && echo generate: ok

.PHONY: help
help: ## Show this help text
	$(info usage: make [target])
	$(info )
	$(info Available targets:)
	@awk -F ':.*?## *' '/^[^\t].+?:.*?##/ \
         {printf "  %-24s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

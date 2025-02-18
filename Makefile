SHELL := /bin/bash

exe := dist/pub2port
version := $(shell sed -nE 's/version: *(([0-9.])+)/\1/p' pubspec.yaml)
version_define = --define=APP_VERSION=$(version)

.PHONY: build
build: ## Build the executable
build: $(exe)

$(exe): bin/pub2port.dart lib/pub2port.dart | dist
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
	@[[ $$($(exe) --version) = "pub2port version: $(version)" ]] && echo bin: ok

.PHONY: test-gen
test-gen: $(exe)
	@diff <($(exe) -v test/generate/fixture/pubspec.lock.cad57bc) test/generate/gold/output.cad57bc && echo path: ok
	@diff <($(exe) -v <test/generate/fixture/pubspec.lock.cad57bc) test/generate/gold/output.cad57bc && echo file in: ok
	@diff <(cat test/generate/fixture/pubspec.lock.cad57bc | $(exe) -v) test/generate/gold/output.cad57bc && echo pipe in: ok

.PHONY: help
help: ## Show this help text
	$(info usage: make [target])
	$(info )
	$(info Available targets:)
	@awk -F ':.*?## *' '/^[^\t].+?:.*?##/ \
         {printf "  %-24s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

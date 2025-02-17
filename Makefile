exe := dist/dart2port

.PHONY: build
build: ## Build the executable
build: $(exe)

$(exe): bin/dart2port.dart lib/dart2port.dart | dist
	dart compile exe $(<) -o $(@)

dist:
	mkdir -p $(@)

.PHONY: help
help: ## Show this help text
	$(info usage: make [target])
	$(info )
	$(info Available targets:)
	@awk -F ':.*?## *' '/^[^\t].+?:.*?##/ \
         {printf "  %-24s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

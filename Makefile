TEX_IMAGE  ?= texlive/texlive:latest
SRC_DIR    := src
BUILD_DIR  := build
MAIN_TEX   := main.tex
OUTPUT     := $(BUILD_DIR)/main.pdf

SOURCES    := $(shell find $(SRC_DIR) -name '*.tex' -o -name '*.bib')

DOCKER_RUN := docker run --rm -v "$(CURDIR)":/workdir -w /workdir/$(SRC_DIR) $(TEX_IMAGE)

$(OUTPUT): $(SOURCES) | $(BUILD_DIR)
	$(DOCKER_RUN) latexmk -pdf -f -outdir=/workdir/$(BUILD_DIR) -interaction=nonstopmode -file-line-error $(MAIN_TEX) || \
		test -s $(OUTPUT)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

.PHONY: clean shell help

## Remove all build artifacts
clean:
	rm -rf $(BUILD_DIR)

## Open an interactive shell in the container for debugging
shell:
	docker run --rm -it -v "$(CURDIR)":/workdir -w /workdir/$(SRC_DIR) $(TEX_IMAGE) bash

## Print this help message
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  $(OUTPUT)  Build the PDF (default)"
	@echo "  clean          Remove all build artifacts"
	@echo "  shell          Open a bash shell in the TeX container"
	@echo "  help           Show this help message"
	@echo ""
	@echo "Variables (override with make VAR=value):"
	@echo "  TEX_IMAGE  Docker image to use (default: $(TEX_IMAGE))"

SHELL := /usr/bin/env bash

# Makefile settings
ifndef V
MAKEFLAGS += --no-print-directory
endif

THIS_FILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
ROOT_DIR ?= $(abspath $(shell cd $(THIS_FILE_DIR) && pwd -P))
INSTALL_PATH := $(HOME)

OUTPUT_DIR := $(ROOT_DIR)/_output
SRC_ENTRY_DIR := $(ROOT_DIR)/src

ARROW_STRING := ===========>

PLATFORMS ?= mac linux termux

# Useful when replace string.
COMMA := ,
SPACE :=
SPACE +=

LINKER_NAME ?= linker

.DEFAULT_GOAL := help

define USAGE_OPTIONS
Options:
  PLATFORMS        Which platform you want to build, default is all supported platform.
                   You can alose assgin more than one platform in make command.
  V                Set to 1 enable verbose build. Default is 0.
endef
export USAGE_OPTIONS

# IFS=" " read -ra platforms <<< "${}"
### all: Build all platforms that this project support and install shell file to your user directory.
.PHONY: all
all:
	@echo "$(ARROW_STRING) Build all the platforms."
	@PLATFORMS=mac,termux,linux $(plts) V=0 $(MAKE) build
	@$(MAKE) install

### build: Build the project.
.PHONY: build
build: build.linker $(foreach plt, $(subst $(COMMA), $(SPACE), $(PLATFORMS)), build.platform.$(plt))

### install: Install the build shell file to your user directory and append into the .bashrc.
.PHONY: install
install:
	$(eval is_linux := $(shell test "$(shell uname -s)" == 'Linux' && echo 0))
	$(eval is_mac := $(shell test "$(shell uname -s)" == 'Darwin' && echo 0))
	$(eval is_termux := $(shell [[ "$(shell pwd)" =~ termux ]] && echo 0))
	$(if $(is_linux), $(MAKE) install.platform.linux)
	$(if $(is_mac), $(MAKE) install.platform.mac)
	$(if $(is_termux), $(MAKE) install.platform.termux)

.PHONY: install.platform.%
install.platform.%: $(OUTPUT_DIR)/%_output.sh
	$(eval plt := $*)
	@echo "$(ARROW_STRING) Install for the platform: $(plt)."
	$(eval from_path := $(OUTPUT_DIR)/$*_output.sh)
	$(eval install_path := $(INSTALL_PATH)/$*_helper.sh)
	$(eval env_file := $(HOME)/.bashrc)
	@touch $(env_file); cp -fp $(from_path) $(install_path); chmod 755 $(install_path); tee -a $(env_file) <<< "source $(install_path)"

.PHONY: build.platform.%
build.platform.%:
	$(eval plt := $*)
	@echo "$(ARROW_STRING) Build for the platform: $(plt)."
	@$(OUTPUT_DIR)/$(LINKER_NAME) $(SRC_ENTRY_DIR)/$(plt).sh $(OUTPUT_DIR)/$(plt)_output.sh

.PHONY: build.linker
build.linker:
ifeq ($(shell ls $(OUTPUT_DIR)/$(LINKER_NAME) 2>/dev/null),)
	@echo "$(ARROW_STRING) Build the linker."
	@mkdir $(OUTPUT_DIR) 2>/dev/null || true
	@rustc $(ROOT_DIR)/linker.rs -o $(OUTPUT_DIR)/$(LINKER_NAME)
else
	@echo "$(ARROW_STRING) command liner has been built."
endif

### clean: Clean the build directory.
.PHONY: clean
clean:
	@echo "$(ARROW_STRING) Cleean the output directory"
	@-rm -rf $(OUTPUT_DIR)

.PHONY: test.%
test.%:
	@$(MAKE) $* -n

.PHONY: test1
test1:
	$(eval platforms := a,b,c)
	@echo $(foreach plt, $(subst $(COMMA), $(SPACE), $(platforms)), $(plt))

### help: Show this help info.
.PHONY: help
help: Makefile
	@printf "\nUsage: make <TARGETS> <OPTIONS> ...\n\nTargets:\n"
	@sed -n 's/^###//p' $< | column -t -s ':' | sed -e 's/^/ /'
	@echo ""
	@echo "$$USAGE_OPTIONS"
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -euo pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --warn-undefined-variables

SUBDIRS := $(wildcard */.)

.PHONY: build
all: build

.PHONY: build
build: $(SUBDIRS)
	@echo "Building everything: $(SUBDIRS)"

	@for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir $@; \
	done

	@echo
	@echo "All done!"
	podman images | ag xatier


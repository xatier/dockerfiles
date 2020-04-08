.PHONY: all build

SUBDIRS := $(wildcard */.)

all: build

build: $(SUBDIRS)
	@echo "Building everything: $(SUBDIRS)"

	@for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir $@; \
	done

	@echo
	@echo "All done!"
	podman images | ag xatier


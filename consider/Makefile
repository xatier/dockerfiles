.PHONY: all build run

name = consider:latest
image = xatier/$(name)
registry = ghcr.io/xatier
pwd = $(shell pwd)

all: build run push

build:
	podman build --squash --no-cache -t $(image) .

run:
	# use -t flag to allocate virtual terminal
	podman run -t --rm -v "$(pwd):/mnt:ro" $(image)

push:
	podman images $(image)
	podman tag $(shell podman images $(image) -q) $(registry)/$(name)
	podman push $(registry)/$(name)

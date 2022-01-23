.PHONY: all build push

name = diffoscope-arch:latest
image = xatier/$(name)
registry = ghcr.io/xatier

all: build push

build:
	podman build --squash --no-cache -t $(image) .

push:
	podman images $(image)
	podman tag $(shell podman images $(image) -q) $(registry)/$(name)
	podman push $(registry)/$(name)

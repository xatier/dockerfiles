.PHONY: all build run push

name = arch-dev:latest
image = xatier/$(name)
registry = ghcr.io/xatier

all: build run push

build:
	podman build --squash --no-cache -t $(image) .

run:
	podman run -it --rm  $(image)

push:
	podman images $(image)
	podman tag $(shell podman images $(image) -q) $(registry)/$(name)
	podman push $(registry)/$(name)

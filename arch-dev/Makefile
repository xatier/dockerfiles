.PHONY: all build run

name = arch-dev:latest
image = xatier/$(name)
registry = docker.pkg.github.com/xatier/dockerfiles

all: build run

build:
	podman build --squash --no-cache -t $(image) .

run:
	podman run -it --rm  $(image)

push:
	podman images $(image)
	podman tag $(shell podman images $(image) -q) $(registry)/$(name)
	podman push $(registry)/$(name)

.PHONY: all build run

name = diffoscope-arch:latest
image = xatier/$(name)
registry = docker.pkg.github.com/xatier/dockerfiles

all: build run

build:
	podman build --no-cache -t $(image) .

run:
	podman run -t --rm -w $(pwd) -v $(pwd):$(pwd):ro $(image)

push:
	podman images $(image)
	podman tag $(shell podman images $(image) -q) $(registry)/$(name)
	podman push $(registry)/$(name)

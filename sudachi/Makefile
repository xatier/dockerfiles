.PHONY: all build run push

name = sudachi:latest
image = xatier/$(name)
registry = ghcr.io/xatier

all: build run

build:
	podman build --squash --no-cache -t $(image) .

run:
	podman run -it --rm  $(image)

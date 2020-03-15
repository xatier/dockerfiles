.PHONY: all build run

image = xatier/arch-dev:latest

all: build run

build:
	podman build --no-cache -t $(image) .

run:
	podman run -it --rm  $(image)

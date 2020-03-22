.PHONY: all build run

image = xatier/consider:latest
pwd = $(shell pwd)

all: build run

build:
	podman build --no-cache -t $(image) .

run:
	# use -t flag to allocate virtual terminal
	podman run -t --rm -v "$(pwd):/mnt:ro" $(image)

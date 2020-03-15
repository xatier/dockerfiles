.PHONY: all build run


all: build run

build:
	podman build --no-cache -t xatier/popcorn-desktop:latest .

run:
	xhost +
	podman run -it --rm \
		-e XMODIFIERS=${XMODIFIERS} \
		-e LANGUAGE=${LANGUAGE} \
		-e LC_ALL=${LC_ALL} \
		-e LANG=${LANG} \
		-e LC_CTYPE=${LC_CTYPE} \
		-e DISPLAY=unix${DISPLAY} \
		-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
		-v /var/run/dbus:/var/run/dbus \
		--ipc=host \
		--device /dev/dri \
		--device /dev/snd \
		xatier/popcorn-desktop:latest


.PHONY: all build run

name = steam:latest
image = xatier/$(name)
registry = ghcr.io/xatier


all: build run

build:
	podman build --squash --no-cache -t $(image) .

run:
	# group IDs: for g in video input render; do getent group $g; done
	# to copy screenshot files: podman cp steam:/tmp/2173800_3.jpg .
	xhost +local:
	podman run -it --rm \
		--name steam \
		-e XMODIFIERS=${XMODIFIERS} \
		-e LANGUAGE=${LANGUAGE} \
		-e LC_ALL=${LC_ALL} \
		-e LANG=${LANG} \
		-e LC_CTYPE=${LC_CTYPE} \
		-e DISPLAY=${DISPLAY} \
		-e "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(shell id -u)/bus" \
		-e "XDG_RUNTIME_DIR=/run/user/$(shell id -u)" \
		-e "PULSE_SERVER=unix:/run/user/$(shell id -u)/pulse/native" \
		-e NVIDIA_VISIBLE_DEVICES=all \
		-e NVIDIA_DRIVER_CAPABILITIES=all \
		-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
		-v "/run/user/$(shell id -u)/bus:/run/user/$(shell id -u)/bus:ro" \
		-v "/run/user/$(shell id -u)/pipewire-0:/run/user/$(shell id -u)/pipewire-0:Z" \
		-v "/run/user/$(shell id -u)/pulse/native:/run/user/$(shell id -u)/pulse/native:Z" \
		-v "./data/config:/home/xatier/.steam" \
		-v "./data/library:/home/xatier/.local/share/Steam" \
		--network host \
		--pid=host \
		--ipc=host \
		--userns=keep-id \
		--device nvidia.com/gpu=all \
		--device /dev/dri \
		--device /dev/input \
		--device /dev/snd \
		--group-add 91 --group-add 97 --group-add 993 \
		$(name)

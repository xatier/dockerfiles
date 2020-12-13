.PHONY: all build run

image = xatier/wireguard:latest
wg_conf = /home/xatier/wg/wg0.conf
davy_wg_conf = /home/xatier/wg/davy.conf
az_wg_conf = /home/xatier/wg/az.conf

all: build run

build:
	podman build --no-cache -t $(image) .

run:
	podman run --rm -it \
		-v $(wg_conf):/srv/wg0.conf \
		--privileged \
		-p 127.0.0.1:1081:1081 \
		$(image)

davy:
	podman run --rm -it \
		-v $(davy_wg_conf):/srv/wg0.conf \
		--privileged \
		-p 127.0.0.1:1082:1081 \
		$(image)

az:
	podman run --rm -it \
		-v $(az_wg_conf):/srv/wg0.conf \
		--privileged \
		-p 127.0.0.1:1083:1081 \
		$(image)

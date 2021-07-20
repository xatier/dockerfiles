.PHONY: all build run

image = xatier/wireguard:latest
wg_conf = /home/xatier/wg/wg0.conf
davy_wg_conf = /home/xatier/wg/davy.conf
az_wg_conf = /home/xatier/wg/az.conf
uk_wg_conf = /home/xatier/wg/uk.conf
jp_wg_conf = /home/xatier/wg/jp.conf

all: build run

build:
	podman build --no-cache -t $(image) .

run:
	podman run --rm -it \
		-v $(wg_conf):/srv/wg0.conf \
		--cap-add NET_ADMIN \
		--cap-add NET_RAW \
		--sysctl net.ipv4.conf.all.src_valid_mark=1 \
		-p 127.0.0.1:1081:1081 \
		$(image)

davy:
	podman run --rm -it \
		-v $(davy_wg_conf):/srv/wg0.conf \
		--cap-add NET_ADMIN \
		--cap-add NET_RAW \
		--sysctl net.ipv4.conf.all.src_valid_mark=1 \
		-p 127.0.0.1:1082:1081 \
		$(image)

az:
	podman run --rm -it \
		-v $(az_wg_conf):/srv/wg0.conf \
		--cap-add NET_ADMIN \
		--cap-add NET_RAW \
		--sysctl net.ipv4.conf.all.src_valid_mark=1 \
		-p 127.0.0.1:1083:1081 \
		$(image)

uk:
	podman run --rm -it \
		-v $(uk_wg_conf):/srv/wg0.conf \
		--cap-add NET_ADMIN \
		--cap-add NET_RAW \
		--sysctl net.ipv4.conf.all.src_valid_mark=1 \
		-p 127.0.0.1:1084:1081 \
		$(image)

jp:
	podman run --rm -it \
		-v $(jp_wg_conf):/srv/wg0.conf \
		--cap-add NET_ADMIN \
		--cap-add NET_RAW \
		--sysctl net.ipv4.conf.all.src_valid_mark=1 \
		-p 127.0.0.1:1085:1081 \
		$(image)

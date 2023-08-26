.PHONY: all build run push

name = wireguard:latest
image = xatier/$(name)
registry = ghcr.io/xatier

wg_conf = /home/xatier/wg/wg0.conf
davy_wg_conf = /home/xatier/wg/davy.conf
az_wg_conf = /home/xatier/wg/az.conf
uk_wg_conf = /home/xatier/wg/uk.conf
jp_wg_conf = /home/xatier/wg/jp.conf

all: build run

build:
	podman build --squash --no-cache -t $(image) .

push:
	podman images $(image)
	podman tag $(shell podman images $(image) -q) $(registry)/$(name)
	podman push $(registry)/$(name)

run:
	podman run --rm -it \
		--name $@ \
		-v $(wg_conf):/srv/wg0.conf \
		--cap-add NET_ADMIN \
		--cap-add NET_RAW \
		--sysctl net.ipv4.conf.all.src_valid_mark=1 \
		-p 127.0.0.1:1081:1081 \
		$(registry)/$(name)

davy:
	podman run --rm -it \
		--name $@ \
		-v $(davy_wg_conf):/srv/wg0.conf \
		--cap-add NET_ADMIN \
		--cap-add NET_RAW \
		--sysctl net.ipv4.conf.all.src_valid_mark=1 \
		-p 127.0.0.1:1082:1081 \
		$(registry)/$(name)

az:
	podman run --rm -it \
		--name $@ \
		-v $(az_wg_conf):/srv/wg0.conf \
		--cap-add NET_ADMIN \
		--cap-add NET_RAW \
		--sysctl net.ipv4.conf.all.src_valid_mark=1 \
		-p 127.0.0.1:1083:1081 \
		$(registry)/$(name)

uk:
	podman run --rm -it \
		--name $@ \
		-v $(uk_wg_conf):/srv/wg0.conf \
		--cap-add NET_ADMIN \
		--cap-add NET_RAW \
		--sysctl net.ipv4.conf.all.src_valid_mark=1 \
		-p 127.0.0.1:1084:1081 \
		$(registry)/$(name)

jp:
	podman run --rm -it \
		--name $@ \
		-v $(jp_wg_conf):/srv/wg0.conf \
		--cap-add NET_ADMIN \
		--cap-add NET_RAW \
		--sysctl net.ipv4.conf.all.src_valid_mark=1 \
		-p 127.0.0.1:1085:1081 \
		$(registry)/$(name)

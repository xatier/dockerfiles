.PHONY: all build run push

name = eh:latest
image = xatier/$(name)
registry = ghcr.io/xatier

data_path = /path/to/eh/data
wg_conf = /path/to/wiregaurd/config

all: build run

build:
	podman build --squash --no-cache -t $(image) .

push:
	podman images $(image)
	podman tag $(shell podman images $(image) -q) $(registry)/$(name)
	podman push $(registry)/$(name)

run:
	podman run --rm -it \
		-v $(data_path):/eh/ \
		-v $(wg_conf):/srv/wg0.conf \
		--userns keep-id \
		--cap-add NET_ADMIN \
		--cap-add NET_RAW \
		--sysctl net.ipv4.conf.all.src_valid_mark=1 \
		$(registry)/$(name)

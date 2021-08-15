.PHONY: all build run

name = eh:latest
image = xatier/$(name)
data_path = /path/to/eh/data
wg_conf = /path/to/wiregaurd/config

all: build run

build:
	podman build --squash --no-cache -t $(image) .

run:
	podman run --rm -it \
		-v $(data_path):/eh/ \
		-v $(wg_conf):/srv/wg0.conf \
		--cap-add NET_ADMIN \
		--cap-add NET_RAW \
		--sysctl net.ipv4.conf.all.src_valid_mark=1 \
		$(image)

.PHONY: all build run


all: build run

build:
	podman build -t income-tax-arch .

run:
	xhost +
	podman run -it --rm \
		-e XMODIFIERS=${XMODIFIERS} \
		-e LANGUAGE=${LANGUAGE} \
		-e LC_ALL=${LC_ALL} \
		-e LANG=${LANG} \
		-e LC_CTYPE=${LC_CTYPE} \
		-e DISPLAY=unix${DISPLAY} \
		-v $(shell xdg-user-dir DOWNLOAD):/home/firefox/Downloads \
		-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
		--add-host=iccert.nhi.gov.tw:127.0.0.1 \
		--device /dev/bus/usb \
		income-tax-arch


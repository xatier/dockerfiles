# popcorn-docker 🍿

Dockerfile for popcorntime

## podman

This project is using podman with [rootless mode](https://github.com/containers/libpod/blob/master/rootless.md).
Read the [troubleshooting guide](https://github.com/containers/libpod/blob/master/troubleshooting.md) if you encounter issues.

## usage

See [Makefile](Makefile) for details, the following will build and run the image with podman.

```bash
$ make
```

## security issues ¯\\_(ツ)_/¯

- `xhost +` to make X available inside the container.
- `sudo` to run popcorntime, since podman makes `/proc/asound` and `/dev/snd` be mounted with `nobody`.
- user `popcorn` has sudo with `NOPASSWD:ALL`.
- `--ipc=host` and `-v /var/run/dbus:/var/run/dbus`, since electron sucks.
- [popcorntime-bin](https://aur.archlinux.org/packages/popcorntime-bin/) is an AUR package, YOLO.

# write-good

Dockerfile for [write-good](https://github.com/btford/write-good) ([npm](https://www.npmjs.com/package/write-good)).

Dockerfile is modified from [here](https://hub.docker.com/r/hochzehn/write-good/dockerfile).

## usage

See [Makefile](Makefile) for details, the following will build the image with podman.

```bash
$ make
```

## bashrc

Put the following into your `.bashrc`.

```bash
write-good-check() {
    # https://github.com/btford/write-good
    podman run --rm -v "$PWD:/app:ro" xatier/write-good:latest "$@"
}
```

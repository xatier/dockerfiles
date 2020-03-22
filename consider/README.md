# consider

Dockerfile for [consider](https://github.com/mroth/consider)

## usage

See [Makefile](Makefile) for details, the following will build and run the image with podman.

```bash
$ make
```

Add the following into your `.bashrc`.

```bash
consider-lint() {
    podman run -t --rm -v "$PWD:/mnt:ro" xatier/consider:latest
}
```

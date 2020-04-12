# Wireguard (with Dante)

This container runs wireguard and the dante socks proxy server

## Configurations

- Specify your wireguard config in `Makefile`.
- Search for `XXX` on my changes in `sockd.conf`.

## Build

See [Makefile](Makefile) for details.

```bash
make
```

## known issues

- sometimes dante is acting wired ... try again with `make run`.

## security issues

- the container is running with `--privileged` mode

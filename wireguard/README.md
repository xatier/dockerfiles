# Wireguard

This container runs wireguard and my [toy socks5 proxy server](https://github.com/xatier/toy-socks5).

## Configurations

- Specify your wireguard config in `Makefile`.

- Which proxy to use (see [entrypoint.sh](entrypoint.sh)).
  - This will use my toy socks5 proxy written in Go.
  - There is also a Python version available.
  - [dante] Search for `XXX` on my changes in `sockd.conf`.

## Build

See [Makefile](Makefile) for details.

```bash
make
```

## Known issues

- Podman is using [MTU=65520](https://github.com/containers/libpod/pull/2626) for performance, one may want to have lower MTU in the `wg0.conf`.

```text
[Interface]
MTU = 1420
```

## Security issues

- the container is running with `--privileged` mode

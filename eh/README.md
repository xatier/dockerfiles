# EH

This container runs [some P2P gallery system](https://ehwiki.org/wiki/Hentai@Home) at home.

## Configurations

- Specify desired wireguard config file in `Makefile`.
- Specify desired EH data path in `Makefile`.

## Build

See [Makefile](Makefile) for details.

```bash
make
```

## Security concerns

- The container is running with `NET_ADMIN` and `NET_RAW` capabilities.

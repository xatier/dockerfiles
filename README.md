# Dockerfiles

<p align="center">
<a href="https://github.com/xatier/dockerfiles/blob/master/.github/workflows/ghcr.yaml"><img alt="Build Status" src="https://github.com/xatier/dockerfiles/actions/workflows/ghcr.yaml/badge.svg"></a>
</p>

My Dockerfile collections.

This is my collection of Dockerfile.

## Build

```bash
# this will build all subdirectories
make
```
## Pre-built images

Weekly builds are available [here](https://github.com/xatier?tab=packages).

## Preserve the history

I used to have the following dockerfiles, now consolidate them to one single repo for all kinds.

- [popcorn-docker](https://github.com/xatier/popcorn-docker) (this has been removed)
- [diffoscope-arch](https://github.com/xatier/diffoscope-arch)

I do the following trick to preserve the commit history from the other repos.

```bash
git remote add diffoscope git@github.com:xatier/diffoscope-arch.git
git pull diffoscope --allow-unrelated-histories  master --no-rebase
mv Dockerfile diffoscope-arch/
git add .
git commit
git remote rm diffoscope
```

Please see the README.md files inside each directory for details of each image.

# Docker iamge for diffoscope

[diffoscope](https://diffoscope.org/) is a great tool for comparing files and
directories recursively. It supports a variety of different file formats.


## Problem

The image built by official [Dockerfile](https://salsa.debian.org/reproducible-builds/diffoscope/blob/master/Dockerfile)
is quite huge. I tried to containerize it with [Archlinux](https://www.archlinux.org/) with some useful dependencies.

```
$ docker images
REPOSITORY                                                 TAG                 IMAGE ID            CREATED             SIZE
xatier/diffoscope-arch                                     latest              647ad3f846af        16 minutes ago      1.34GB
archlinux/base                                             latest              754519a037bc        2 weeks ago         459MB
registry.salsa.debian.org/reproducible-builds/diffoscope   latest              b400779127a1        2 weeks ago         3.69GB
```


## Usage

Pull the image from GitHub

```bash
# pull
docker pull docker.pkg.github.com/xatier/diffoscope-arch/diffoscope-arch:latest

# run
docker run --rm -t -w $(pwd) -v $(pwd):$(pwd):ro docker.pkg.github.com/xatier/diffoscope-arch/diffoscope-arch:latest file1 file2
```

Build the Dockerfile locally

```
# build
docker build --no-cache -t xatier/diffoscope-arch .

# run
docker run --rm -t -w $(pwd) -v $(pwd):$(pwd):ro xatier/diffoscope-arch:latest file1 file2
```

(Maintainance) Update docker image on GitHub

```bash
# push to registry
# build the image
docker tag 647ad3f846af docker.pkg.github.com/xatier/diffoscope-arch/diffoscope-arch:latest
docker push docker.pkg.github.com/xatier/diffoscope-arch/diffoscope-arch:latest
```

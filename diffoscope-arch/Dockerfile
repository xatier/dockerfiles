# https://hub.docker.com/r/archlinux/archlinux
FROM archlinux/archlinux:base

# pick a few dependencies
# https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/diffoscope
RUN pacman -Syyu --needed --noconfirm base-devel diffoscope \
    binwalk bzip2 diffutils e2fsprogs enjarify llvm lz4 openssh \
    python-progressbar python-tlsh unzip tar xz

RUN useradd -ms /bin/bash arch
USER arch
WORKDIR /home/arch

ENTRYPOINT ["/usr/sbin/diffoscope"]

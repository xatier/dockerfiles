FROM ghcr.io/xatier/arch-dev:latest

USER root
RUN pacman -Syuu --noconfirm --needed \
    ripgrep \
    zsh

USER xatier
WORKDIR /home/xatier

RUN git clone https://github.com/mroth/consider.git
WORKDIR /home/xatier/consider
RUN make PREFIX="." install

WORKDIR /mnt
ENTRYPOINT ["/home/xatier/consider/bin/consider"]

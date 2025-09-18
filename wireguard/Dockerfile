FROM ghcr.io/xatier/arch-dev:latest

USER root
RUN pacman -Syuu --noconfirm --needed \
    dante \
    openbsd-netcat \
    go \
    mtr \
    openresolv \
    wireguard-tools

COPY ./sockd.conf /srv/sockd.conf
COPY ./entrypoint.sh /srv/entrypoint.sh

# this will be set by `podman run`
RUN sed -i "s:sysctl -q net.ipv4.conf.all.src_valid_mark=1:echo skipping setting net.ipv4.conf.all.src_valid_mark:" /usr/bin/wg-quick

USER xatier
WORKDIR /home/xatier
RUN git clone https://github.com/xatier/toy-socks5.git \
    && cd toy-socks5 \
    && go build
ENTRYPOINT ["/srv/entrypoint.sh"]

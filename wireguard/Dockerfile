FROM ghcr.io/xatier/arch-dev:latest

USER root
RUN pacman -Syuu --noconfirm --needed \
    dante \
    gnu-netcat \
    go \
    mtr \
    openresolv \
    wireguard-tools

COPY ./sockd.conf /srv/sockd.conf
COPY ./entrypoint.sh /srv/entrypoint.sh
RUN echo "nameserver 1.1.1.1" > /etc/resolv.conf

# this will be set by `podman run`
RUN sed -i "s:sysctl -q net.ipv4.conf.all.src_valid_mark=1:echo skipping setting net.ipv4.conf.all.src_valid_mark:" /usr/bin/wg-quick

USER xatier
ENTRYPOINT ["/srv/entrypoint.sh"]

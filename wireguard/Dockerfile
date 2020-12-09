FROM xatier/arch-dev:latest

USER root
RUN pacman -Syuu --noconfirm --needed \
    dante \
    go \
    mtr \
    openresolv \
    wireguard-tools

COPY ./sockd.conf /srv/sockd.conf
COPY ./entrypoint.sh /srv/entrypoint.sh
RUN echo "nameserver 1.1.1.1" > /etc/resolv.conf

USER xatier
ENTRYPOINT ["/srv/entrypoint.sh"]

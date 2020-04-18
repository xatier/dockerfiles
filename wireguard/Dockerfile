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

USER xatier
ENTRYPOINT ["/srv/entrypoint.sh"]

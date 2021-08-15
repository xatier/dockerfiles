FROM xatier/wireguard:latest

USER root
RUN pacman -Syuu --noconfirm --needed \
    jre8-openjdk-headless

COPY ./entrypoint.sh /srv/entrypoint.sh

WORKDIR /eh
ENTRYPOINT ["/srv/entrypoint.sh"]

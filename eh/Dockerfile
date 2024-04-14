FROM ghcr.io/xatier/wireguard:latest

USER root
RUN pacman -Syuu --noconfirm --needed \
    jre21-openjdk-headless

COPY ./entrypoint.sh /srv/entrypoint.sh

WORKDIR /eh
USER xatier
ENTRYPOINT ["/srv/entrypoint.sh"]

FROM ghcr.io/xatier/arch-dev:latest

USER xatier
WORKDIR /home/xatier

COPY start.sh start.sh
RUN /home/xatier/start.sh

ENTRYPOINT ["./bin/jagger"]

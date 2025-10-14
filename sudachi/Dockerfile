FROM ghcr.io/xatier/arch-dev:latest

USER xatier
WORKDIR /home/xatier

COPY start.sh start.sh
RUN /home/xatier/start.sh

ENTRYPOINT /usr/sbin/java --sun-misc-unsafe-memory-access=allow -jar sudachi-0.7.5.jar -s '{"systemDict":"sudachi-dictionary-20250825/system_full.dic"}' -a -m B

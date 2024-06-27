FROM ghcr.io/xatier/arch-dev:latest

USER xatier
WORKDIR /home/xatier

COPY start.sh start.sh
RUN /home/xatier/start.sh

ENTRYPOINT /usr/sbin/java -jar sudachi-0.7.3.jar -s '{"systemDict":"sudachi-dictionary-20240409/system_full.dic"}' -a -m B

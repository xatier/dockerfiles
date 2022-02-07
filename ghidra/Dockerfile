FROM ghcr.io/xatier/arch-dev:latest
USER root

RUN pacman -Syuu --noconfirm --needed \
    ghidra \
    go \
    fontconfig \
    jdk-openjdk \
    libxext \
    libxrender \
    libxtst \
    ttf-dejavu \
    ttf-inconsolata \
    noto-fonts-cjk \
    unzip

WORKDIR /home/xatier
USER xatier

# a few scripts
RUN mkdir /home/xatier/ghidra_scripts
WORKDIR /home/xatier/ghidra_scripts
RUN git clone https://github.com/0xb0bb/pwndra.git 0xb0bb
RUN git clone https://github.com/Bigdrea6/winapi-ghidra.git Bigdrea6
RUN git clone https://github.com/BitsOfBinary/ghidra-scripts.git BitsOfBinary
RUN git clone https://github.com/RenaKunisaki/GhidraScripts.git RenaKunisaki
RUN git clone https://github.com/ghidraninja/ghidra_scripts ghidraninja
RUN git clone https://github.com/gsuberland/Windows-Reverse-Engineering.git gsuberland
RUN git clone https://github.com/tacnetsol/ghidra_scripts.git tacnetsol

COPY ./entrypoint.sh /srv/entrypoint.sh

WORKDIR /home/xatier
ENTRYPOINT ["/srv/entrypoint.sh"]

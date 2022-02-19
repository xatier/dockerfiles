# use reflector to find faster mirrorlist
FROM archlinux/archlinux:base as reflector
RUN pacman -Syy --noconfirm --needed reflector
RUN reflector --verbose --country 'United States' --latest 20 \
    --protocol https --age 12 --sort rate --save /mirrorlist

FROM archlinux/archlinux:base

# pacman
COPY --from=reflector /mirrorlist /etc/pacman.d/mirrorlist
RUN pacman -Syuu --noconfirm --needed \
    base \
    base-devel \
    curl \
    git \
    htop \
    pacman-contrib \
    python \
    sudo \
    vim \
    wget

# user setup
RUN useradd --create-home xatier
RUN echo "xatier ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/xatier
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8

WORKDIR /home/xatier
USER xatier

# AUR yay
RUN git clone https://aur.archlinux.org/yay.git
WORKDIR /home/xatier/yay
RUN makepkg -sri --needed --noconfirm

# install stuff
# RUN pacman -Syuu --noconfirm --needed <stuff>
# RUN yay -S --noeditmenu --nodiffmenu --noconfirm <stuff>

# cleanup
WORKDIR /home/xatier
RUN sudo paccache -rfk0 && \
    rm -rf /home/xatier/yay && \
    rm -rf /home/xatier/.cache/yay

ENV EDITOR vim

CMD ["bash"]

FROM archlinux:latest

RUN pacman -Syuu --noconfirm
RUN pacman -S --noconfirm git sudo wget base base-devel

RUN useradd --create-home popcorn
RUN echo "popcorn ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/popcorn

WORKDIR /home/popcorn
USER popcorn

RUN git clone https://aur.archlinux.org/yay.git
WORKDIR /home/popcorn/yay
RUN makepkg -sri --needed --noconfirm

RUN yay -S --noeditmenu --nodiffmenu --noconfirm popcorntime-bin

CMD ["sudo", "/usr/bin/popcorntime"]

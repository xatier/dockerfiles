FROM ghcr.io/xatier/arch-dev

USER root

# enable multilib
RUN echo '[multilib]' >> /etc/pacman.conf && \
    echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf

# remove NoExtract BS so we can install the locale files
RUN sed -i /NoExtract/d /etc/pacman.conf
RUN pacman -Syuu --noconfirm --needed base glibc

RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && \
    echo 'zh_TW.UTF-8 UTF-8' >> /etc/locale.gen && \
    echo 'ja_JP.UTF-8 UTF-8' >> /etc/locale.gen && \
    locale-gen

ENV LANG en_US.UTF-8

RUN pacman -Syuu --noconfirm --needed steam \
    lib32-nvidia-utils \
    xdg-utils xdg-desktop-portal-impl \
    noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra

WORKDIR /home/xatier
USER xatier
RUN mkdir -p /home/xatier/.steam /home/xatier/.local/share/Steam

ENV XMODIFIERS=@im=none \
    GTK_IM_MODULE=none \
    QT_IM_MODULE=none \
    LANG=zh_TW.UTF-8

ENTRYPOINT ["steam"]
CMD []

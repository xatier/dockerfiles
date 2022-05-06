FROM ghcr.io/xatier/arch-dev

USER root
RUN pacman -Syuu --noconfirm --needed \
    ccid \
    firefox \
    wqy-microhei

# install junk MOICA 內政部憑證管理中心-跨平台網頁元件 - http://moica.nat.gov.tw/rac_plugin.html
RUN wget https://moica.nat.gov.tw/download/File/HiPKILocalSignServer/linux/HiPKILocalSignServerApp.tar.gz \
    && tar xzvf HiPKILocalSignServerApp.tar.gz -C /usr/local/

WORKDIR /home/xatier
USER xatier

# install NHI junk and symlink neccesary files
RUN yay -S nhiicc --answerdiff None --answerclean All --noconfirm \
    && sudo ln -s /usr/share/NHIICC/ /usr/local/share/NHIICC \
    && sudo ln -s /var/lib/nhiicc/cert/ /usr/local/share/NHIICC/cert \
    && sudo cp /var/lib/nhiicc/cert/{NHIServerCert-real.key,NHIServerCert.key}

COPY start.sh /home/xatier/start.sh

CMD ["bash"]

#!/bin/sh -x

# smartcard driver
sudo pcscd -d -f | tee /tmp/pcscd.log &

cat /etc/hosts

# launch NHI junk
sudo /usr/bin/mLNHIICC &

# launch another junk
cd /usr/local/HiPKILocalSignServerApp
./start.sh &

sleep 10
ss -lntp

firefox \
    https://emask.taiwan.gov.tw/msk/index.jsp \
    https://efile.tax.nat.gov.tw/irxw/index.jsp \
    https://iccert.nhi.gov.tw:7777 \
    https://cloudicweb.nhi.gov.tw/cloudic/system/SMC/webtesting/SampleY.aspx &

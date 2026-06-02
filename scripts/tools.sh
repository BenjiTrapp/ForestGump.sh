#!/bin/bash
# Helper script that sources this on login to make tools available
# Source this in your shell: source /opt/scripts/tools.sh

export PATH="$PATH:/opt/tools/Responder:/opt/tools/RelayKing-Depth:/opt/tools/gopacket:/opt/tools/AdStrike:/opt/tools/EntraFalcon:/opt/tools/entra-ca-insight:/opt/tools/pySIDHistory:/opt/tools/getSPNless:/opt/tools/ad-reaper:/root/.local/bin"

alias responder='python3 /opt/tools/Responder/Responder.py'
alias relayking='python3 /opt/tools/RelayKing-Depth/relayking.py'
alias bloodhound-python='python3 -m bloodhound'
alias ca-insight='python3 /opt/tools/entra-ca-insight/main.py'
alias pysidhistory='python3 /opt/tools/pySIDHistory/main.py'
alias getspnless='python3 /opt/tools/getSPNless/getSPNless.py'
alias adreaper='python3 /opt/tools/ad-reaper/main.py'
alias adstrike='bash /opt/tools/AdStrike/run.sh'
alias entrafalcon='pwsh /opt/tools/EntraFalcon/EntraFalcon.ps1'

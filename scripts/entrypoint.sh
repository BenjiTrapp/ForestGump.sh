#!/bin/bash
# ForestGump.sh - AD Attack Platform
# Launches ttyd on port 7681 for browser-based terminal access

echo "============================================"
echo "  ForestGump.sh - AD Attack Platform"
echo "============================================"
echo ""
echo "Available tools:"
echo "  bloodyAD        - AD privilege escalation framework"
echo "  BloodHound.py   - BloodHound Python ingestor (bloodhound-python)"
echo "  roadrecon       - Azure AD exploration tool"
echo "  roadtx          - Azure AD token exchange"
echo "  nxc             - NetExec (network execution tool)"
echo "  coercer         - Auto Windows auth coercion"
echo "  Responder       - LLMNR/NBT-NS/MDNS poisoner"
echo "  RelayKing       - NTLM/Kerberos relay detection"
echo "  impacket        - Impacket toolkit"
echo "  certipy-ad      - Active Directory certificate abuse"
echo "  ldapdomaindump  - LDAP domain dumper"
echo "  AdStrike        - AI-powered AD red-team framework"
echo "  EntraFalcon     - Entra ID enumeration (PowerShell)"
echo "  entra-ca-insight - Conditional Access gap analysis"
echo "  gopacket        - Go impacket (63 tools, mandiant)"
echo "  pySIDHistory    - Remote SID History injection"
echo "  getSPNless      - SPN-less RBCD attacks"
echo "  ad-reaper       - Multi-protocol AD enumerator"
echo ""
echo "Access the terminal at http://localhost:7681"
echo "============================================"
echo ""

exec ttyd -W -p 7681 /opt/scripts/shell.sh

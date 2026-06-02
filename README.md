# ForestGump.sh

> AD Attack Platform — browser-based, containerized, ready to roll.

A single Docker image packing the sharpest Active Directory and Entra ID attack & enumeration tools, served through **ttyd** — a web-based terminal on port `7681`. Fire up a browser, and you're in.

## Tools

### On-Prem AD

| Tool | Description |
|------|-------------|
| [bloodyAD](https://github.com/CravateRouge/bloodyAD) | AD privilege escalation swiss army knife (LDAP/SAMR) |
| [BloodHound.py](https://github.com/dirkjanm/BloodHound.py) | BloodHound Python ingestor |
| [NetExec (nxc)](https://github.com/Pennyw0rth/NetExec) | Network execution toolkit (smb, ldap, winrm, etc.) |
| [Impacket](https://github.com/fortra/impacket) | Swiss army knife of AD protocols |
| [Responder](https://github.com/lgandx/Responder) | LLMNR/NBT-NS/MDNS poisoner |
| [RelayKing-Depth](https://github.com/depthsecurity/RelayKing-Depth) | NTLM & Kerberos relay detection |
| [Coercer](https://github.com/p0dalirius/Coercer) | Automatic Windows auth coercion |
| [certipy-ad](https://github.com/ly4k/Certipy) | ADCS abuse toolkit |
| [gopacket](https://github.com/mandiant/gopacket) | Go impacket — 63 tools, 24 packages (Mandiant) |
| [ldapdomaindump](https://github.com/dirkjanm/ldapdomaindump) | LDAP domain dumper |
| [pySIDHistory](https://github.com/felixbillieres/pySIDHistory) | Remote SID History injection & auditing |
| [getSPNless](https://github.com/jarnovandenbrink/getSPNless) | SPN-less RBCD attacks |
| [ad-reaper](https://github.com/mermehr/ad-reaper) | Multi-protocol AD enumerator (LDAP, SMB, SAMR) |
| [AdStrike](https://github.com/capture0x/AdStrike) | AI-powered modular AD red-team framework |

### Entra ID / Azure AD

| Tool | Description |
|------|-------------|
| [ROADtools](https://github.com/dirkjanm/ROADtools) | Azure AD exploration framework (roadrecon, roadlib) |
| [roadtx](https://github.com/dirkjanm/ROADtools) | ROADtools Token eXchange |
| [EntraFalcon](https://github.com/CompassSecurity/EntraFalcon) | Entra ID enumeration & risk assessment (PowerShell) |
| [entra-ca-insight](https://github.com/emiliensocchi/entra-ca-insight) | Conditional Access gap analysis |

## Quick Start

```bash
# Build the image
make build

# Run with host networking (recommended for AD work)
make run
```

Open **http://localhost:7681** in your browser.

### With bridge networking

```bash
make run-bridge
```

### Interactive shell

```bash
make shell
```

## Usage Examples

```bash
# BloodHound enumeration
bloodhound-python -d domain.local -u user -p Password123 -dc dc.domain.local -c all

# NetExec
nxc smb 192.168.1.0/24 -u user -p Password123

# Coercer
coercer coerce -d domain.local -u user -p Password123 --dc-ip 192.168.1.10 -l attacker-ip

# Responder
responder -I eth0 -wrf

# RelayKing
python3 /opt/tools/RelayKing-Depth/relayking.py -h

# gopacket (63 Go tools in /opt/tools/gopacket)
./GetADUsers host
./rbcd ...
```

## Running with Network Access

The container uses `--net=host` to share the host network stack — necessary for tools like Responder, Coercer, and nxc that need raw socket access or must listen on specific ports.

`--cap-add=NET_ADMIN` and `--cap-add=SYS_ADMIN` grant the privileges needed for packet crafting and network manipulation.

## Project Structure

```
ForestGump.sh/
├── Dockerfile
├── Makefile
├── README.md
├── install.sh         # Tool installation script
└── scripts/
    ├── entrypoint.sh  # ttyd launcher with tool banner
    └── tools.sh       # PATH/alias setup (sourced in .bashrc)
```

#!/bin/bash
set -x

echo "[*] Installing AD tools..."

# Create tools directory
mkdir -p /opt/tools
cd /opt/tools

# Install bloodyAD
echo "[+] Installing bloodyAD..."
pip3 install bloodyAD || echo "[-] bloodyAD failed"

# Install ROADtools and roadtx
echo "[+] Installing ROADtools..."
pip3 install roadrecon roadtx || echo "[-] ROADtools failed"

# Install Coercer
echo "[+] Installing Coercer..."
pip3 install coercer || echo "[-] Coercer failed"

# Clone and install Responder
echo "[+] Installing Responder..."
git clone --depth=1 https://github.com/lgandx/Responder.git /opt/tools/Responder || echo "[-] Responder clone failed"
pip3 install -r /opt/tools/Responder/requirements.txt || echo "[-] Responder deps failed"

# Clone RelayKing-Depth
echo "[+] Installing RelayKing-Depth..."
git clone --depth=1 https://github.com/depthsecurity/RelayKing-Depth.git /opt/tools/RelayKing-Depth || echo "[-] RelayKing-Depth clone failed"
pip3 install -r /opt/tools/RelayKing-Depth/requirements.txt || echo "[-] RelayKing-Depth deps failed"

# Install BloodHound.py (legacy)
echo "[+] Installing BloodHound.py..."
pip3 install bloodhound || echo "[-] BloodHound.py failed"

# Clone AdStrike
echo "[+] Installing AdStrike..."
git clone --depth=1 https://github.com/capture0x/AdStrike.git /opt/tools/AdStrike || echo "[-] AdStrike clone failed"

# Clone EntraFalcon
echo "[+] Installing EntraFalcon..."
git clone --depth=1 https://github.com/CompassSecurity/EntraFalcon.git /opt/tools/EntraFalcon || echo "[-] EntraFalcon clone failed"

# Clone and install entra-ca-insight
echo "[+] Installing entra-ca-insight..."
git clone --depth=1 https://github.com/emiliensocchi/entra-ca-insight.git /opt/tools/entra-ca-insight || echo "[-] entra-ca-insight clone failed"
pip3 install -r /opt/tools/entra-ca-insight/requirements.txt || echo "[-] entra-ca-insight deps failed"

# Build and install gopacket (mandiant)
echo "[+] Installing gopacket..."
git clone --depth=1 https://github.com/mandiant/gopacket.git /opt/tools/gopacket || echo "[-] gopacket clone failed"
cd /opt/tools/gopacket
./install.sh --target portable --build-only 2>/dev/null || true
# If portable build failed, try native build
if [ ! -f /opt/tools/gopacket/dist/portable/* ] 2>/dev/null; then
    make build 2>/dev/null || true
fi
cd /opt/tools

# Clone and install pySIDHistory
echo "[+] Installing pySIDHistory..."
git clone --depth=1 https://github.com/felixbillieres/pySIDHistory.git /opt/tools/pySIDHistory || echo "[-] pySIDHistory clone failed"
pip3 install -r /opt/tools/pySIDHistory/requirements.txt || echo "[-] pySIDHistory deps failed"

# Clone and install getSPNless
echo "[+] Installing getSPNless..."
git clone --depth=1 https://github.com/jarnovandenbrink/getSPNless.git /opt/tools/getSPNless || echo "[-] getSPNless clone failed"
pip3 install -r /opt/tools/getSPNless/requirements.txt 2>/dev/null || true

# Clone and install ad-reaper
echo "[+] Installing ad-reaper..."
git clone --depth=1 https://github.com/mermehr/ad-reaper.git /opt/tools/ad-reaper || echo "[-] ad-reaper clone failed"
pip3 install -r /opt/tools/ad-reaper/requirements.txt 2>/dev/null || true

# Windows binary tools (for transfer to Windows targets)
echo "[+] Downloading mimikatz..."
MIMIKATZ_URL=$(curl -sSLI -o /dev/null -w '%{url_effective}' "https://github.com/gentilkiwi/mimikatz/releases/latest" 2>/dev/null)
MIMIKATZ_TAG=${MIMIKATZ_URL##*/}
curl -sSL "https://github.com/gentilkiwi/mimikatz/releases/download/${MIMIKATZ_TAG}/mimikatz_trunk.zip" -o /tmp/mimikatz.zip && \
  mkdir -p /opt/tools/mimikatz && unzip -o /tmp/mimikatz.zip -d /opt/tools/mimikatz && \
  rm /tmp/mimikatz.zip || echo "[-] mimikatz download failed"

echo "[+] Cloning Rubeus..."
git clone --depth=1 https://github.com/GhostPack/Rubeus.git /opt/tools/Rubeus || echo "[-] Rubeus clone failed"

echo "[+] Cloning KslKatz..."
git clone --depth=1 https://github.com/vergamota/KslKatz.git /opt/tools/KslKatz || echo "[-] KslKatz clone failed"

echo "[+] Cloning Recon-AD..."
git clone --depth=1 https://github.com/outflanknl/Recon-AD.git /opt/tools/Recon-AD || echo "[-] Recon-AD clone failed"

echo "[+] Cloning ADCSCoercePotato..."
git clone --depth=1 https://github.com/decoder-it/ADCSCoercePotato.git /opt/tools/ADCSCoercePotato || echo "[-] ADCSCoercePotato clone failed"

echo "[+] Cloning adPEAS..."
git clone --depth=1 https://github.com/61106960/adPEAS.git /opt/tools/adPEAS || echo "[-] adPEAS clone failed"

# Install AD-related PowerShell modules
echo "[+] Installing AD PowerShell modules..."
pwsh -c "Install-PackageProvider -Name NuGet -Force -ErrorAction SilentlyContinue" 2>/dev/null || true
pwsh -c "Install-Module -Name Microsoft.Graph.Identity.DirectoryManagement -Force -Scope AllUser -AllowClobber -SkipPublisherCheck -ErrorAction SilentlyContinue" 2>/dev/null || echo "[-] Microsoft.Graph.Identity.DirectoryManagement failed"
pwsh -c "Install-Module -Name AzureAD -Force -Scope AllUser -AllowClobber -SkipPublisherCheck -ErrorAction SilentlyContinue" 2>/dev/null || echo "[-] AzureAD module failed"

# Install RSAT AD PowerShell modules (cross-platform equivalents for Linux)
echo "[+] Installing RSAT AD PowerShell modules..."
pwsh -c "Install-Module -Name S.DS.P -Force -Scope AllUsers -AllowClobber -SkipPublisherCheck -ErrorAction SilentlyContinue" 2>/dev/null || echo "[-] S.DS.P module failed"
pwsh -c "Install-Module -Name PSWSMan -Force -Scope AllUsers -AllowClobber -SkipPublisherCheck -ErrorAction SilentlyContinue" 2>/dev/null || echo "[-] PSWSMan module failed"
pwsh -c "Install-WSMan" 2>/dev/null || echo "[-] WSMan install failed"
pwsh -c "Install-Module -Name ActiveDirectory -Force -Scope AllUsers -AllowClobber -SkipPublisherCheck -ErrorAction SilentlyContinue" 2>/dev/null || echo "[-] ActiveDirectory module failed"
pwsh -c "Install-Module -Name GroupPolicy -Force -Scope AllUsers -AllowClobber -SkipPublisherCheck -ErrorAction SilentlyContinue" 2>/dev/null || echo "[-] GroupPolicy module failed"

# Clone PowerSploit (PowerUp, PowerView, etc.)
echo "[+] Cloning PowerSploit..."
git clone --depth=1 https://github.com/PowerShellMafia/PowerSploit.git /opt/tools/PowerSploit || echo "[-] PowerSploit clone failed"

# Clone SharpUp
echo "[+] Cloning SharpUp..."
git clone --depth=1 https://github.com/GhostPack/SharpUp.git /opt/tools/SharpUp || echo "[-] SharpUp clone failed"

# Install godap (Go LDAP TUI)
echo "[+] Installing godap..."
git clone --depth=1 https://github.com/Macmod/godap.git /opt/tools/godap || echo "[-] godap clone failed"
cd /opt/tools/godap && go install . 2>/dev/null && cp "$HOME/go/bin/godap" /usr/local/bin/godap || echo "[-] godap build failed"
cd /opt/tools

# Install ldapnomnom (anonymous LDAP username bruteforce)
echo "[+] Installing ldapnomnom..."
go install github.com/lkarlslund/ldapnomnom@latest 2>/dev/null && cp "$HOME/go/bin/ldapnomnom" /usr/local/bin/ldapnomnom || echo "[-] ldapnomnom install failed"

# Install GPOHunter (GPO security analyzer)
echo "[+] Installing GPOHunter..."
git clone --depth=1 https://github.com/PShlyundin/GPOHunter.git /opt/tools/GPOHunter || echo "[-] GPOHunter clone failed"
pip3 install -r /opt/tools/GPOHunter/requirements.txt 2>/dev/null || true

# Install TokenSmith (Entra ID token generator)
echo "[+] Installing TokenSmith..."
git clone --depth=1 https://github.com/JumpsecLabs/TokenSmith.git /opt/tools/TokenSmith || echo "[-] TokenSmith clone failed"
cd /opt/tools/TokenSmith && go build -o /usr/local/bin/tokensmith main.go 2>/dev/null || echo "[-] TokenSmith build failed"
cd /opt/tools

# Install gpoParser (GPO extraction & analysis)
echo "[+] Installing gpoParser..."
pipx install git+https://github.com/synacktiv/gpoParser 2>/dev/null || echo "[-] gpoParser install failed"

# Install DonPAPI (DPAPI credential dumper)
echo "[+] Installing DonPAPI..."
pipx install git+https://github.com/login-securite/DonPAPI.git 2>/dev/null || echo "[-] DonPAPI install failed"

# Install gontlm-proxy (NTLM proxy forwarder)
echo "[+] Installing gontlm-proxy..."
git clone --depth=1 https://github.com/bdwyertech/gontlm-proxy.git /opt/tools/gontlm-proxy || echo "[-] gontlm-proxy clone failed"
cd /opt/tools/gontlm-proxy && go build -o /usr/local/bin/gontlm-proxy ./cmd/gontlm-proxy/ 2>/dev/null || echo "[-] gontlm-proxy build failed"
cd /opt/tools

# Install px (NTLM proxy)
echo "[+] Installing px..."
pipx install px-proxy 2>/dev/null || echo "[-] px install failed"

# Install AD-Ghost (PS script)
echo "[+] Cloning AD-Ghost..."
git clone --depth=1 https://github.com/LuemmelSec/AD-Ghost.git /opt/tools/AD-Ghost || echo "[-] AD-Ghost clone failed"

echo "[+] Cloning Invoke-PassTheCert..."
git clone --depth=1 https://github.com/The-Viper-One/Invoke-PassTheCert.git /opt/tools/Invoke-PassTheCert || echo "[-] Invoke-PassTheCert clone failed"

# Clone AzureRedOps (Azure/Entra ID red team PowerShell toolkit)
echo "[+] Cloning AzureRedOps..."
git clone --depth=1 https://github.com/Mr-Un1k0d3r/AzureRedOps.git /opt/tools/AzureRedOps || echo "[-] AzureRedOps clone failed"

# Clone GraphRobber (Microsoft Graph API abuse toolkit)
echo "[+] Cloning GraphRobber..."
git clone --depth=1 https://github.com/rabbit-sec/GraphRobber.git /opt/tools/GraphRobber || echo "[-] GraphRobber clone failed"

# Clone Snitch (AD recon/enumeration)
echo "[+] Cloning Snitch..."
git clone --depth=1 https://github.com/karol-broda/snitch.git /opt/tools/snitch || echo "[-] Snitch clone failed"

# Install snafflepy (Python Snaffler port)
echo "[+] Installing snafflepy..."
git clone --depth=1 https://github.com/cisagov/snafflepy.git /opt/tools/snafflepy || echo "[-] snafflepy clone failed"
pip3 install -r /opt/tools/snafflepy/requirements.txt 2>/dev/null || true

# Install Evil-WinRM
echo "[+] Installing Evil-WinRM..."
gem install evil-winrm || echo "[-] Evil-WinRM install failed"

# Additional useful tools
echo "[+] Installing additional AD tools..."
pip3 install impacket certipy-ad ldapdomaindump kerbrute aioquic || echo "[-] Additional tools failed"

echo "[*] Installation complete!"

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

# Additional useful tools
echo "[+] Installing additional AD tools..."
pip3 install impacket certipy-ad ldapdomaindump kerbrute aioquic || echo "[-] Additional tools failed"

echo "[*] Installation complete!"

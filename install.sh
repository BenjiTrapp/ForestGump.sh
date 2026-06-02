#!/bin/bash
set -e

echo "[*] Installing AD tools..."

# Create tools directory
mkdir -p /opt/tools
cd /opt/tools

# Install bloodyAD
echo "[+] Installing bloodyAD..."
pip3 install bloodyAD

# Install ROADtools and roadtx
echo "[+] Installing ROADtools..."
pip3 install roadrecon roadtx

# Install Coercer
echo "[+] Installing Coercer..."
pip3 install coercer

# Clone and install Responder
echo "[+] Installing Responder..."
git clone --depth=1 https://github.com/lgandx/Responder.git /opt/tools/Responder
pip3 install -r /opt/tools/Responder/requirements.txt

# Clone RelayKing-Depth
echo "[+] Installing RelayKing-Depth..."
git clone --depth=1 https://github.com/depthsecurity/RelayKing-Depth.git /opt/tools/RelayKing-Depth
pip3 install -r /opt/tools/RelayKing-Depth/requirements.txt

# Install BloodHound.py (legacy)
echo "[+] Installing BloodHound.py..."
pip3 install bloodhound

# Clone AdStrike
echo "[+] Installing AdStrike..."
git clone --depth=1 https://github.com/capture0x/AdStrike.git /opt/tools/AdStrike

# Clone EntraFalcon
echo "[+] Installing EntraFalcon..."
git clone --depth=1 https://github.com/CompassSecurity/EntraFalcon.git /opt/tools/EntraFalcon

# Clone and install entra-ca-insight
echo "[+] Installing entra-ca-insight..."
git clone --depth=1 https://github.com/emiliensocchi/entra-ca-insight.git /opt/tools/entra-ca-insight
pip3 install -r /opt/tools/entra-ca-insight/requirements.txt

# Build and install gopacket (mandiant)
echo "[+] Installing gopacket..."
git clone --depth=1 https://github.com/mandiant/gopacket.git /opt/tools/gopacket
cd /opt/tools/gopacket
./install.sh --target portable --build-only 2>/dev/null || true
# If portable build failed, try native build
if [ ! -f /opt/tools/gopacket/dist/portable/* ] 2>/dev/null; then
    make build 2>/dev/null || true
fi
cd /opt/tools

# Clone and install pySIDHistory
echo "[+] Installing pySIDHistory..."
git clone --depth=1 https://github.com/felixbillieres/pySIDHistory.git /opt/tools/pySIDHistory
pip3 install -r /opt/tools/pySIDHistory/requirements.txt

# Clone and install getSPNless
echo "[+] Installing getSPNless..."
git clone --depth=1 https://github.com/jarnovandenbrink/getSPNless.git /opt/tools/getSPNless
pip3 install -r /opt/tools/getSPNless/requirements.txt 2>/dev/null || true

# Clone and install ad-reaper
echo "[+] Installing ad-reaper..."
git clone --depth=1 https://github.com/mermehr/ad-reaper.git /opt/tools/ad-reaper
pip3 install -r /opt/tools/ad-reaper/requirements.txt 2>/dev/null || true

# Additional useful tools
echo "[+] Installing additional AD tools..."
pip3 install impacket certipy-ad ldapdomaindump kerbrute

echo "[*] Installation complete!"

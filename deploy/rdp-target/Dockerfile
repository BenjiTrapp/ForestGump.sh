FROM ubuntu:24.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    xrdp \
    xorgxrdp \
    xorg \
    openbox \
    xterm \
    dbus \
    && rm -rf /var/lib/apt/lists/*

# Create a test user for RDP login
RUN useradd -m -s /bin/bash demo && echo "demo:demo" | chpasswd && adduser demo ssl-cert

# Configure xrdp session to launch openbox with xterm
RUN printf '#!/bin/bash\nsleep 2\nopenbox &\nsleep 1\nexec xterm -fa "Monospace" -fs 12 -geometry 80x24+50+50 -bg "#1a1a2e" -fg "#00ff41" -T "ForestGump.sh RDP Demo" -e bash -c "\
echo \"\";\
echo \"  === ForestGump.sh RDP Demo ===\";\
echo \"\";\
echo \"  Host: \\$(hostname)\";\
echo \"  User: \\$(whoami)\";\
echo \"  Date: \\$(date)\";\
echo \"  IP:   \\$(hostname -I)\";\
echo \"\";\
echo \"  Connected via xfreerdp from Docker.\";\
echo \"  This proves headless RDP works!\";\
echo \"\";\
exec bash"\n' > /home/demo/.xsession && \
    chmod +x /home/demo/.xsession && \
    chown demo:demo /home/demo/.xsession

EXPOSE 3389

CMD ["bash", "-c", "mkdir -p /run/dbus && dbus-daemon --system --fork 2>/dev/null; /usr/sbin/xrdp-sesman --nodaemon & sleep 1; exec /usr/sbin/xrdp --nodaemon"]

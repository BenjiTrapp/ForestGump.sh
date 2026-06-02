FROM docker.io/tsl0922/ttyd:latest
LABEL maintainer="ForestGump.sh"

EXPOSE 7681

WORKDIR /opt

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y curl && \
    . /etc/os-release && \
    curl -sSL "https://packages.microsoft.com/config/$ID/$VERSION_ID/packages-microsoft-prod.deb" -o packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        curl \
        wget \
        git \
        python3 \
        python3-pip \
        python3-venv \
        pipx \
        dnsutils \
        net-tools \
        iproute2 \
        nmap \
        jq \
        sudo \
        nano \
        openssh-client \
        golang-go \
        build-essential \
        libpcap-dev \
        libssl-dev \
        libffi-dev \
        python3-dev \
        python3-netifaces \
        rustc \
        cargo \
        powershell \
        && rm -rf /var/lib/apt/lists/*

RUN pipx ensurepath && pipx install git+https://github.com/Pennyw0rth/NetExec

COPY install.sh /opt/install.sh
RUN chmod +x /opt/install.sh && /opt/install.sh && rm -f /opt/install.sh

COPY scripts/ /opt/scripts/
RUN chmod +x /opt/scripts/*.sh && \
    echo "source /opt/scripts/tools.sh" >> /root/.bashrc

ENV PATH="$PATH:/opt/scripts:/opt/tools/Responder:/opt/tools/RelayKing-Depth:/opt/tools/gopacket/dist/portable:/opt/tools/AdStrike:/opt/tools/entra-ca-insight:/opt/tools/pySIDHistory:/opt/tools/getSPNless:/opt/tools/ad-reaper:/root/.local/bin"

WORKDIR /data

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/opt/scripts/entrypoint.sh"]

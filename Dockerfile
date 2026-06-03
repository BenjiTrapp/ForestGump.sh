FROM docker.io/tsl0922/ttyd:latest
LABEL maintainer="ForestGump.sh"

EXPOSE 7681

WORKDIR /opt

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y curl && \
    ARCH=$(dpkg --print-architecture) && \
    case $ARCH in \
        amd64) PS_ARCH="x64" ;; \
        arm64) PS_ARCH="arm64" ;; \
        *) echo "Unsupported arch: $ARCH"; exit 1 ;; \
    esac && \
    PS_URL=$(curl -sSLI -o /dev/null -w '%{url_effective}' "https://github.com/PowerShell/PowerShell/releases/latest" | grep -o 'v[0-9.]*') && \
    curl -sSL "https://github.com/PowerShell/PowerShell/releases/download/${PS_URL}/powershell-${PS_URL#v}-linux-${PS_ARCH}.tar.gz" -o /tmp/pwsh.tar.gz && \
    mkdir -p /opt/microsoft/powershell/7 && \
    tar zxf /tmp/pwsh.tar.gz -C /opt/microsoft/powershell/7 && \
    chmod +x /opt/microsoft/powershell/7/pwsh && \
    ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh && \
    rm /tmp/pwsh.tar.gz

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
        unzip \
        ruby \
        ruby-dev \
        freerdp2-x11 \
        tightvncserver \
        libkrb5-dev \
        && rm -rf /var/lib/apt/lists/*

RUN pipx ensurepath && pipx install git+https://github.com/Pennyw0rth/NetExec

COPY install.sh /opt/install.sh
RUN chmod +x /opt/install.sh && PIP_BREAK_SYSTEM_PACKAGES=1 /opt/install.sh && rm -f /opt/install.sh

COPY scripts/ /opt/scripts/
RUN chmod +x /opt/scripts/*.sh && \
    echo "source /opt/scripts/tools.sh" >> /root/.bashrc

ENV PATH="$PATH:/opt/scripts:/opt/tools/Responder:/opt/tools/RelayKing-Depth:/opt/tools/gopacket/dist/portable:/opt/tools/AdStrike:/opt/tools/entra-ca-insight:/opt/tools/pySIDHistory:/opt/tools/getSPNless:/opt/tools/ad-reaper:/root/.local/bin"

WORKDIR /data

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/opt/scripts/entrypoint.sh"]

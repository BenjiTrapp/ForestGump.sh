IMAGE_NAME := forestgump.sh
DOCKER_TAG := latest
GHCR_IMAGE := ghcr.io/benjitrapp/forestgump.sh:latest

# ─── Port Configuration ──────────────────────────────────────────────────────
# UI Ports
PORT_TTYD    := 7681
PORT_NOVNC   := 6080
PORT_VNC     := 5900

# AD / Pentesting Ports
PORT_GRAPHSPY := 5000
PORT_DNS     := 53
PORT_HTTP    := 80
PORT_KERBEROS := 88
PORT_RPC     := 135
PORT_NETBIOS_NS  := 137
PORT_NETBIOS_DGM := 138
PORT_NETBIOS_SSN := 139
PORT_LDAP    := 389
PORT_HTTPS   := 443
PORT_SMB     := 445
PORT_LDAPS   := 636
PORT_MSSQL   := 1433
PORT_RDP     := 3389
PORT_MDNS    := 5353
PORT_LLMNR   := 5355
PORT_WINRM   := 5985
PORT_WINRMS  := 5986

# macOS (Docker Desktop) port mappings.
# The privileged AD service ports (53, 80, 88, 135, 137-139, 389, 443, 445, 636, ...)
# collide with macOS host services (e.g. mDNSResponder on 53) and would fail to bind,
# so only the browser UI ports are published here. For full raw-socket / all-port
# access run on native Linux with `make run-linux`.
# NOTE: GraphSpy is published on host port 5001 because the macOS AirPlay Receiver
#       (ControlCenter) occupies port 5000. Inside the container GraphSpy still uses
#       5000 — start it with `graphspy -i 0.0.0.0` so the port forward reaches it,
#       then browse to http://localhost:5001
MAC_PORTS = \
	-p $(PORT_TTYD):7681 \
	-p $(PORT_NOVNC):6080 \
	-p $(PORT_VNC):5900 \
	-p 5001:5000

# Port mappings for Docker Desktop (Windows/Mac) where --net=host is unavailable
PORTS = \
	-p $(PORT_TTYD):7681 \
	-p $(PORT_NOVNC):6080 \
	-p $(PORT_VNC):5900 \
	-p $(PORT_GRAPHSPY):5000 \
	-p $(PORT_DNS):53/tcp \
	-p $(PORT_DNS):53/udp \
	-p $(PORT_HTTP):80 \
	-p $(PORT_KERBEROS):88/tcp \
	-p $(PORT_KERBEROS):88/udp \
	-p $(PORT_RPC):135 \
	-p $(PORT_NETBIOS_NS):137/udp \
	-p $(PORT_NETBIOS_DGM):138/udp \
	-p $(PORT_NETBIOS_SSN):139 \
	-p $(PORT_LDAP):389 \
	-p $(PORT_HTTPS):443 \
	-p $(PORT_SMB):445 \
	-p $(PORT_LDAPS):636 \
	-p $(PORT_MSSQL):1433 \
	-p $(PORT_RDP):3389 \
	-p $(PORT_MDNS):5353/udp \
	-p $(PORT_LLMNR):5355/udp \
	-p $(PORT_WINRM):5985 \
	-p $(PORT_WINRMS):5986

CAPS = \
	--cap-add=NET_ADMIN \
	--cap-add=SYS_ADMIN

.PHONY: build build_mac run run-linux run-windows run_mac shell push clean ghcr-pull ghcr ghcr-linux

# ─── Build ────────────────────────────────────────────────────────────────────

build:
	docker build -t $(IMAGE_NAME):$(DOCKER_TAG) .

build_mac: build  ## macOS: build the image (alias for build)

# ─── Run (local build) ────────────────────────────────────────────────────────

run-windows:  ## Docker Desktop (Windows/Mac) - uses port mapping
	docker run -it --rm \
		--name forestgump \
		$(PORTS) \
		$(CAPS) \
		$(IMAGE_NAME):$(DOCKER_TAG)

run-linux:  ## Native Linux - uses host networking (all ports available)
	docker run -it --rm \
		--name forestgump \
		--net=host \
		$(CAPS) \
		$(IMAGE_NAME):$(DOCKER_TAG)

run_mac:  ## macOS (Docker Desktop): UI ports only, GraphSpy on host port 5001
	docker run -it --rm \
		--name forestgump \
		$(MAC_PORTS) \
		$(CAPS) \
		$(IMAGE_NAME):$(DOCKER_TAG)

run: run-windows  ## Default: Docker Desktop (alias for run-windows)

# ─── Run (GHCR image) ────────────────────────────────────────────────────────

ghcr-pull:
	docker pull --platform linux/x86_64 $(GHCR_IMAGE)

ghcr:  ## GHCR on Docker Desktop (Windows/Mac)
	docker run -it --rm \
		--name forestgump \
		$(PORTS) \
		$(CAPS) \
		$(GHCR_IMAGE)

ghcr-linux:  ## GHCR on native Linux (all ports available via host networking)
	docker run -it --rm \
		--name forestgump \
		--net=host \
		$(CAPS) \
		$(GHCR_IMAGE)

# ─── Utility ──────────────────────────────────────────────────────────────────

shell:
	docker run -it --rm \
		--name forestgump \
		$(PORTS) \
		$(CAPS) \
		--entrypoint /bin/bash \
		$(IMAGE_NAME):$(DOCKER_TAG)

push:
	docker tag $(IMAGE_NAME):$(DOCKER_TAG) $(REGISTRY)/$(IMAGE_NAME):$(DOCKER_TAG)
	docker push $(REGISTRY)/$(IMAGE_NAME):$(DOCKER_TAG)

clean:
	docker rmi $(IMAGE_NAME):$(DOCKER_TAG) 2>/dev/null || true

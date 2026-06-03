IMAGE_NAME := forestgump.sh
DOCKER_TAG := latest
PORT := 7681
NOVNC_PORT := 6080

.PHONY: build run shell push clean

build:
	docker build -t $(IMAGE_NAME):$(DOCKER_TAG) .

run:
	docker run -it --rm \
		--name forestgump \
		-p $(PORT):7681 \
		-p $(NOVNC_PORT):$(NOVNC_PORT) \
		--net=host \
		--cap-add=NET_ADMIN \
		--cap-add=SYS_ADMIN \
		$(IMAGE_NAME):$(DOCKER_TAG)

run-bridge:
	docker run -it --rm \
		--name forestgump \
		-p $(PORT):7681 \
		-p $(NOVNC_PORT):$(NOVNC_PORT) \
		--cap-add=NET_ADMIN \
		--cap-add=SYS_ADMIN \
		$(IMAGE_NAME):$(DOCKER_TAG)

shell:
	docker run -it --rm \
		--name forestgump \
		-p $(PORT):7681 \
		-p $(NOVNC_PORT):$(NOVNC_PORT) \
		--net=host \
		--cap-add=NET_ADMIN \
		--cap-add=SYS_ADMIN \
		--entrypoint /bin/bash \
		$(IMAGE_NAME):$(DOCKER_TAG)

push:
	docker tag $(IMAGE_NAME):$(DOCKER_TAG) $(REGISTRY)/$(IMAGE_NAME):$(DOCKER_TAG)
	docker push $(REGISTRY)/$(IMAGE_NAME):$(DOCKER_TAG)

clean:
	docker rmi $(IMAGE_NAME):$(DOCKER_TAG) 2>/dev/null || true

ghcr-pull:
	docker pull ghcr.io/benjitrapp/forestgump.sh:latest --platform linux/x86_64

ghcr:
	docker run -it --rm --name forestgump -p 7681:7681 -p 6080:6080 --net=host --cap-add=NET_ADMIN --cap-add=SYS_ADMIN ghcr.io/benjitrapp/forestgump.sh:latest
	
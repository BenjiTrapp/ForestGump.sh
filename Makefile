IMAGE_NAME := forestgump.sh
DOCKER_TAG := latest
PORT := 7681

.PHONY: build run shell push clean

build:
	docker build -t $(IMAGE_NAME):$(DOCKER_TAG) .

run:
	docker run -it --rm \
		--name forestgump \
		-p $(PORT):7681 \
		--net=host \
		--cap-add=NET_ADMIN \
		--cap-add=SYS_ADMIN \
		$(IMAGE_NAME):$(DOCKER_TAG)

run-bridge:
	docker run -it --rm \
		--name forestgump \
		-p $(PORT):7681 \
		--cap-add=NET_ADMIN \
		--cap-add=SYS_ADMIN \
		$(IMAGE_NAME):$(DOCKER_TAG)

shell:
	docker run -it --rm \
		--name forestgump \
		-p $(PORT):7681 \
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

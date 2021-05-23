BUILDX_VER=v0.5.1
CI_NAME?=local
IMAGE_NAME=alpine/demo-multi-arch
VERSION?=latest

install:
	mkdir -vp ~/.docker/cli-plugins/ ~/dockercache
	curl --silent -L "https://github.com/docker/buildx/releases/download/${BUILDX_VER}/buildx-${BUILDX_VER}.linux-amd64" > ~/.docker/cli-plugins/docker-buildx
	chmod a+x ~/.docker/cli-plugins/docker-buildx

prepare: install
	docker buildx create --use
	docker buildx inspect

build-push:
	docker buildx build --push \
		--build-arg CI_NAME=${CI_NAME} \
		--platform linux/amd64,linux/arm/v7,linux/arm64/v8,linux/arm/v6,linux/ppc64le,linux/s390x \
		-t ${IMAGE_NAME}:${VERSION}-${CI_NAME} .

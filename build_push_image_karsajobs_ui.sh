#!/bin/bash

#config
GITHUB_TOKEN=${GITHUB_TOKEN:-""}
IMAGE_NAME="karsajobs-ui"
IMAGE_TAG="latest"
GHCR_USER="aditya3232"
GHCR_IMAGE="ghcr.io/${GHCR_USER}/${IMAGE_NAME}:${IMAGE_TAG}"

# 1. Build Docker image dari Dockerfile
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .

# 2. Melihat daftar image di lokal
docker images

# 3. Tag ulang image agar sesuai format Docker Hub
docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${GHCR_IMAGE}

# 4. Login ke GitHub Container Registry
echo ${GITHUB_TOKEN} | docker login ghcr.io -u ${GHCR_USER} --password-stdin

# 5. Push image ke GitHub Container Registry
docker push ${GHCR_IMAGE}

echo "Image ${GHCR_IMAGE} berhasil dibangun dan di-push ke GitHub Container Registry."

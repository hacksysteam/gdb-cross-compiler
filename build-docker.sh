#!/usr/bin/env bash

set -e

DOCKERFILE_PATH=$(realpath Dockerfile)
DOCKER_IMAGE_NAME="gdb-compiler-image"
DOCKER_CONTAINER_NAME="gdb-compiler-builder"

echo "[+] Building docker image: ${DOCKER_IMAGE_NAME}"
docker build --tag ${DOCKER_IMAGE_NAME} -f "${DOCKERFILE_PATH}" .

echo
echo "[+] Running gdb container: ${DOCKER_CONTAINER_NAME}"
docker run -it --rm -v "$PWD:/gdb" --name ${DOCKER_CONTAINER_NAME} ${DOCKER_IMAGE_NAME}
echo

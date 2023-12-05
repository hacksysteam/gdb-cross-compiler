#!/usr/bin/env bash

set -e

DOCKERFILE_PATH=$(realpath ./Dockerfile)
NAME_PREFIX="gdb-compiler"
BOOKWORM_TAG="${NAME_PREFIX}-bookworm"
BULLSEYE_TAG="${NAME_PREFIX}-bullseye"
JAMMY_TAG="${NAME_PREFIX}-jammy"

echo "[+] Building docker image: ${JAMMY_TAG}"
docker build --tag ${JAMMY_TAG} --build-arg CODE_NAME=ubuntu:jammy - < "${DOCKERFILE_PATH}"

echo "[+] Running gdb container: ${JAMMY_TAG}-builder"
docker run -it --rm -v "${PWD}:/gdb" --name "${JAMMY_TAG}-builder" ${JAMMY_TAG} /bin/bash -c "/bin/bash /gdb/build.sh"

#!/usr/bin/env bash

set -e

PROJECT_DIR=$(dirname "$(realpath -s "$0")")

GCC_VERSION=12
GDB_VERSION=12.1
PYTHON_VERSION=3.10
GDB_ARCHS=("x86_64-linux-gnu")
GDBSERVER_ARCHS=("i686-linux-gnu" "x86_64-linux-gnu" "arm-linux-gnueabi" "aarch64-linux-gnu")
BUILD_PATH="${PROJECT_DIR}/build"
SOURCE_DIR="${BUILD_PATH}/gdb-${GDB_VERSION}"

function buildGDB() {
    local isGDBServer="$1"
    local eabi="$2"
    local buildPath
    local prefix

    echo ""

    if [ "${isGDBServer}" = true ]; then
        echo "[+] Building GDB server for abi: ${eabi}"
        prefix=gdbserver
    else
        echo "[+] Building GDB for abi: ${eabi}"
        prefix=gdb
    fi

    local buildPath="${BUILD_PATH}/${prefix}/${eabi}"

    if [[ ! -d "${buildPath}" ]]; then
        mkdir -p "${buildPath}"
        cd "${buildPath}" || exit

        if [ "${isGDBServer}" = true ]; then
            ${SOURCE_DIR}/configure \
                --host="${eabi}" \
                --disable-gdb \
                --disable-docs \
                --disable-binutils \
                --disable-gas \
                --disable-sim \
                --disable-gprof \
                --disable-inprocess-agent \
                --enable-gdbserver \
                --prefix="${buildPath}/binaries" \
                CC="${eabi}-gcc-${GCC_VERSION}" \
                CXX="${eabi}-g++-${GCC_VERSION}" \
                LDFLAGS="-static -static-libstdc++"
        else
            ${SOURCE_DIR}/configure \
                --host="${eabi}" \
                --enable-targets=all \
                --with-python=/usr/bin/python${PYTHON_VERSION} \
                --disable-docs \
                --disable-gdbserver \
                --disable-binutils \
                --disable-gas \
                --disable-sim \
                --disable-gprof \
                --disable-inprocess-agent \
                --prefix="${buildPath}/binaries" \
                CC="${eabi}-gcc-${GCC_VERSION}" \
                CXX="${eabi}-g++-${GCC_VERSION}"
        fi
    else
        cd "${buildPath}" || exit
    fi

    echo -e "\t[*] Path: ${buildPath}"

    make
    make install

    find ./* -maxdepth 0 -name "binaries" -prune -o -exec rm -rf {} \;
    mv binaries/* .
    rm -rf binaries

    echo ""

    cd "${PROJECT_DIR}" || exit
}

function downloadGDB() {
    local url="https://ftp.gnu.org/gnu/gdb/gdb-${GDB_VERSION}.tar.gz"
    local sourceDir="$1"

    if [[ ! -d "${sourceDir}" ]]; then
        mkdir -p "${sourceDir}"
        echo "[+] Downloading: ${url} in ${sourceDir}"
        wget -qO- "${url}" | tar -xz --strip-components=1 -C "${sourceDir}"
    fi
}

mkdir -p "${BUILD_PATH}"

downloadGDB "${SOURCE_DIR}"

#
# Build gdb and gdbserver
#

for ABI in "${GDB_ARCHS[@]}"; do
    buildGDB false "${ABI}"
done

for ABI in "${GDBSERVER_ARCHS[@]}"; do
    buildGDB true "${ABI}"
done

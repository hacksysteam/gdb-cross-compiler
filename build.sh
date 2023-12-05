#!/usr/bin/env bash

set -e

GDB_FTP_URL="https://ftp.gnu.org/gnu/gdb/"

if [ -z "${GDB_VERSION}" ]; then
    echo "[!] GDB_VERSION not provided. Fetching from website..."
    GDB_VERSION=$(curl -s ${GDB_FTP_URL} | grep -o 'gdb-[0-9.]*\.tar\.gz' | sort -V | tail -1 | sed 's/gdb-\([0-9.]*\)\.tar\.gz/\1/' | tr -d '\n')

    if [ -z "${GDB_VERSION}" ]; then
        echo "[-] Error: GDB version not found."
        exit 1
    fi
fi

PROJECT_DIR=$(dirname "$(realpath -s "$0")")
GDB_ARCHS=("x86_64-linux-gnu")
GDBSERVER_ARCHS=("i686-linux-gnu" "x86_64-linux-gnu" "arm-linux-gnueabi" "aarch64-linux-gnu")
BUILD_PATH="${PROJECT_DIR}/build"
SOURCE_DIR="${BUILD_PATH}/gdb-${GDB_VERSION}"

function buildGDB() {
    local isGDBServer="$1"
    local eabi="$2"
    local buildPath
    local prefix

    echo "[+] GDB version: ${GDB_VERSION}"

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
                --enable-gdbserver \
                --disable-gdb \
                --disable-docs \
                --disable-binutils \
                --disable-gas \
                --disable-sim \
                --disable-gprof \
                --disable-inprocess-agent \
                --prefix="${buildPath}/binaries" \
                CC="${eabi}-gcc" \
                CXX="${eabi}-g++" \
                LDFLAGS="-static -static-libstdc++"
        else
            ${SOURCE_DIR}/configure \
                --host="${eabi}" \
                --enable-targets=all \
                --disable-docs \
                --disable-gdbserver \
                --disable-binutils \
                --disable-gas \
                --disable-sim \
                --disable-gprof \
                --disable-inprocess-agent \
                --with-python=/usr/bin/python3 \
                --prefix="${buildPath}/binaries" \
                CC="${eabi}-gcc" \
                CXX="${eabi}-g++"
        fi
    else
        cd "${buildPath}" || exit
    fi

    echo "[+] Path: ${buildPath}"

    make -j`nproc`
    make install

    find ./* -maxdepth 0 -name "binaries" -prune -o -exec rm -rf {} \;
    mv binaries/* .
    rm -rf binaries

    if [ "${isGDBServer}" = true ]; then
        OUTPUT_ARCHIVE_PATH="${buildPath}/gdbserver-${eabi}.zip"
        echo "[+] Creating gdbserver archive: ${OUTPUT_ARCHIVE_PATH}"
        cd bin/
        zip -q ${OUTPUT_ARCHIVE_PATH} ./gdbserver
    else
        OUTPUT_ARCHIVE_PATH="${buildPath}/gdb-${eabi}.zip"
        echo "[+] Creating gdb archive: ${OUTPUT_ARCHIVE_PATH}"
        zip -q -r ${OUTPUT_ARCHIVE_PATH} ./*
    fi

    cd "${PROJECT_DIR}" || exit
}

function downloadGDB() {
    local url="${GDB_FTP_URL}gdb-${GDB_VERSION}.tar.gz"
    local sourceDir="$1"

    if [[ ! -d "${sourceDir}" ]]; then
        mkdir -p "${sourceDir}"
        echo "[+] Downloading: ${url} in ${sourceDir}"
        curl -sL "${url}" | tar -xz --strip-components=1 -C "${sourceDir}"
    fi
}

mkdir -p "${BUILD_PATH}"

downloadGDB "${SOURCE_DIR}"

for ABI in "${GDB_ARCHS[@]}"; do
    buildGDB false "${ABI}"
done

for ABI in "${GDBSERVER_ARCHS[@]}"; do
    buildGDB true "${ABI}"
done

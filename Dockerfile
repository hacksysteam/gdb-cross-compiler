FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG GCC_VERSION=12

#
# Install utils
#

RUN apt-get update -qq && \
    apt-get clean && \
    apt-get -qq -y upgrade && \
    apt-get -y install git \
        gpg \
        curl \
        cmake \
        make \
        file \
        zip \
        unzip \
        wget \
        xxd \
        xz-utils \
        software-properties-common && \
    rm -rf /var/lib/apt/lists/* && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 2

#
# Install cross compilers
#

RUN apt-get update -qq && \
    apt-get clean && \
    apt-get -y install build-essential \
        binutils \
        binutils-i686-gnu \
        binutils-i686-linux-gnu \
        binutils-x86-64-linux-gnu \
        binutils-aarch64-linux-gnu \
        binutils-arm-linux-gnueabi \
        binutils-arm-linux-gnueabihf \
        cpp-${GCC_VERSION} \
        cpp-${GCC_VERSION}-aarch64-linux-gnu \
        cpp-${GCC_VERSION}-arm-linux-gnueabi \
        cpp-${GCC_VERSION}-arm-linux-gnueabihf \
        cpp-${GCC_VERSION}-i686-linux-gnu \
        gcc-${GCC_VERSION} \
        gcc-${GCC_VERSION}-aarch64-linux-gnu \
        gcc-${GCC_VERSION}-arm-linux-gnueabi \
        gcc-${GCC_VERSION}-arm-linux-gnueabihf \
        gcc-${GCC_VERSION}-i686-linux-gnu \
        gcc-${GCC_VERSION}-multilib \
        gcc-${GCC_VERSION}-multilib-i686-linux-gnu \
        g++-${GCC_VERSION} \
        g++-${GCC_VERSION}-aarch64-linux-gnu \
        g++-${GCC_VERSION}-arm-linux-gnueabi \
        g++-${GCC_VERSION}-arm-linux-gnueabihf \
        g++-${GCC_VERSION}-i686-linux-gnu \
        g++-${GCC_VERSION}-multilib \
        g++-${GCC_VERSION}-multilib-i686-linux-gnu && \
    rm -rf /var/lib/apt/lists/*

#
# Install gdb dependencies
#

RUN apt-get update -qq && \
    apt-get clean && \
    apt-get -y install texinfo \
        libncurses5-dev \
        libmpfr-dev \
        libgmp-dev \
        libexpat1-dev \
        libunwind-dev \
        libpython3.10-dev \
        python3.10-distutils && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /gdb/

ADD ./build.sh /gdb/build.sh

#
# Add docker user
#

RUN adduser --disabled-password --gecos "" gdb && \
    adduser gdb sudo && \
    echo "%sudo ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers

USER gdb

WORKDIR /gdb/

ENTRYPOINT ["bash", "build.sh"]

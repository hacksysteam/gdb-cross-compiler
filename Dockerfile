ARG CODE_NAME
FROM ${CODE_NAME}

ENV DEBIAN_FRONTEND=noninteractive

#
# Install utils
#

RUN apt-get update -q && \
    apt-get -q -y upgrade && \
    apt-get -y install --no-install-recommends \
        sudo \
        git \
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
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

#
# Install cross compilers
#

RUN apt-get update -q && \
    apt-get -q -y upgrade && \
    apt-get -y install --no-install-recommends \
        binutils \
        binutils-multiarch \
        binutils-multiarch-dev \
        build-essential \
        crossbuild-essential-i386 \
        crossbuild-essential-armel \
        crossbuild-essential-armhf \
        crossbuild-essential-arm64 && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

#
# Install gdb dependencies
#

RUN apt-get update -q && \
    apt-get -q -y upgrade && \
    apt-get -y install --no-install-recommends \
        texinfo \
        libncurses-dev \
        libmpfr-dev \
        libmpfrc++-dev \
        libgmp-dev \
        libexpat1-dev \
        libunwind-dev \
        libc6-dev \
        python3 \
        python3-dev \
        python3-distutils \
        python-is-python3 && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN mkdir -p /gdb/

ARG USER="gdb"

RUN adduser --disabled-password --gecos "" ${USER} && \
    adduser ${USER} sudo && \
    echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USER}

WORKDIR /gdb/

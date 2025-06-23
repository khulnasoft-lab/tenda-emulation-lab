FROM ubuntu:24.04

LABEL maintainer="KhulnaSoft ARM firmware emulation"

ENV DEBIAN_FRONTEND=noninteractive

# Install core tools
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    unrar \
    binwalk \
    rsync \
    gdb \
    qemu-user-static \
    qemu-system-arm \
    gcc \
    make \
    sudo \
    build-essential \
    iproute2 \
    iputils-ping \
    net-tools \
    python3 \
    python3-pip \
    terminator \
    git \
    unzip \
    ssh \
    vim \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Add a non-root user for emulation use
RUN useradd -ms /bin/bash user && echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER user
WORKDIR /home/user

# Download cross compiler for ARMv5
RUN wget https://uclibc.org/downloads/binaries/0.9.30.1/cross-compiler-armv5l.tar.bz2 && \
    tar xjf cross-compiler-armv5l.tar.bz2

# Add cross-compiler to PATH
ENV PATH="/home/user/cross-compiler-armv5l/bin:${PATH}"

# Copy local hooks.c and emulate.sh into the image
COPY hooks.c .
COPY emulate.sh .

# Compile hooks.c into a shared object
RUN armv5l-gcc hooks.c -o hooks.so -shared

# Make the emulate script executable
RUN chmod +x emulate.sh

# Download the firmware
RUN wget https://down.tendacn.com/uploadfile/AC6/US_AC6V1.0BR_V15.03.05.16_multi_TD01.rar && \
    unrar e US_AC6V1.0BR_V15.03.05.16_multi_TD01.rar && \
    binwalk -e US_AC6V1.0BR_V15.03.05.16_multi_TD01.bin

# Default command
CMD ["/bin/bash"]

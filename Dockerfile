FROM debian:buster

RUN apt update -y && apt upgrade -y && apt install -y gcc git wget make libncurses-dev flex bison gperf python python-serial cmake python-pip
# Prepare directory for tools
ARG TOOLS_PATH=/tools
RUN mkdir ${TOOLS_PATH}
WORKDIR ${TOOLS_PATH}

# Install toolchain
ARG TOOLCHAIN_TARBALL_URL=https://dl.espressif.com/dl/xtensa-lx106-elf-gcc8_4_0-esp-2020r3-linux-amd64.tar.gz
ARG TOOLCHAIN_PATH=${TOOLS_PATH}/toolchain
RUN wget -O ./toolchain.tar.gz ${TOOLCHAIN_TARBALL_URL}
RUN tar -xzf ./toolchain.tar.gz
RUN mv $(tar --list -f toolchain.tar.gz | head -n 1)/ toolchain
RUN rm toolchain.tar.gz

ENV PATH="${TOOLCHAIN_PATH}/bin:${PATH}"

# Install RTOS sdk
ARG IDF_PATH=${TOOLS_PATH}/ESP8266_RTOS_SDK
WORKDIR ${TOOLS_PATH}
RUN git clone --recursive https://github.com/espressif/ESP8266_RTOS_SDK.git
RUN python -m pip install pip==20.1 \
	&& pip install --upgrade setuptools \
	&& python -m pip install --user -r ${IDF_PATH}/requirements.txt 

ENV PATH="${IDF_PATH}/tools:${PATH}"
ENV IDF_PATH=${IDF_PATH}

# Change workdir
WORKDIR /build

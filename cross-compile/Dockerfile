# Docker file to build the cloud comms plugin
#
# Current cross toolhains:
# - armv5tej (fpu=vfpv2, float-abi=hard, libc=glibc)
#
# TOOLCHAIN FILE STRUCTURE:
FROM ubuntu:18.04

WORKDIR /
RUN apt-get update && apt-get install -y \
    autoconf \
    automake \
    binutils \
    ca-certificates \
    wget \
    curl \
    file \
    git \
    build-essential \
    gcc \
    g++ \
    libc6-dev \
    pkg-config \
    python3 \
    bison \
    bzip2 \
    flex \
    libtool \
    patch \
    libglib2.0-dev \
    pkg-config  \
    zlib1g-dev  \
    libcap-dev  \
    libattr1-dev  \
    libpixman-1-dev  \
    xz-utils \
    xsltproc \
    cmake \
    gawk \
    texinfo \
    rsync  \
    gettext  \
    python3-venv \
    lcov \
    screen \
    neovim \
    libfile-tee-perl \
    tree \
    util-linux  \
    bsdmainutils


# download and extract the souces for libc, glibc, gcc/g++ toolchain, binutils
RUN mkdir -p /toolchain-build
WORKDIR /toolchain-build
RUN wget https://ftpmirror.gnu.org/binutils/binutils-2.30.tar.bz2 && \
    wget https://ftpmirror.gnu.org/gcc/gcc-8.1.0/gcc-8.1.0.tar.gz && \
    wget https://ftpmirror.gnu.org/glibc/glibc-2.27.tar.bz2 && \
    tar xf binutils-2.30.tar.bz2 && \
    tar xf glibc-2.27.tar.bz2 && \
    tar xf gcc-8.1.0.tar.gz && \
    rm *.tar.*


################################################################################
## REPLACE ME WITH THE PROPER KERNEL HEADERS WHEN THE RASPERRY-PI BUILD WORKS
################################################################################
RUN git clone --depth=1 https://github.com/raspberrypi/linux

# arch-specific toolchain options
ARG TOOLCHAIN_NAME=arm-linux-gnueabihf
ARG TOOLCHAIN_ARCH=armv5tej
ARG TOOLCHAIN_FPU=vfpv2
ARG TOOLCHAIN_FLOAT_ABI=hard

# Prefix directories
ARG CROSS_ROOT=/opt
ARG TOOLCHAIN_ROOT="${CROSS_ROOT}/${TOOLCHAIN_NAME}-root"
ARG TOOLCHAIN_SYSROOT="${TOOLCHAIN_ROOT}/${TOOLCHAIN_NAME}"

ARG TOOLCHAIN_BINUTILS_DIR="${TOOLCHAIN_ROOT}/bin/"
ARG TOOLCHAIN_USR_DIR="${TOOLCHAIN_SYSROOT}/usr"


# Okay, so for some reason, in certain releases of docker, 
# the container doesn't inherit MACHTYPE from calling shell 
# so we have to manually set it here
ARG MACHTYPE=x86_64-pc-linux-gnu

# Toolchain component build-time configuration options
ARG TOOLCHAIN_RUNTIME_HOST="${TOOLCHAIN_NAME}"
ARG TOOLCHAIN_COMPILE_TARGET="${TOOLCHAIN_NAME}"
ARG TOOLCHAIN_BUILD_HOST="${MACHTYPE}"

# Create directories for crossbuild
RUN mkdir -p "${TOOLCHAIN_ROOT}" && \
    mkdir -p "${TOOLCHAIN_SYSROOT}" && \
    mkdir -p "${TOOLCHAIN_SYSROOT}/etc"

RUN mkdir -p "${TOOLCHAIN_USR_DIR}" && \
    mkdir -p "${TOOLCHAIN_USR_DIR}/bin" && \
    mkdir -p "${TOOLCHAIN_USR_DIR}/lib" && \
    mkdir -p "${TOOLCHAIN_USR_DIR}/include" && \
    mkdir -p "${TOOLCHAIN_USR_DIR}/share" && \
    mkdir -p "${TOOLCHAIN_USR_DIR}/src"


# Prepend directories to path so executables are found first

ENV PATH ${TOOLCHAIN_USR_DIR}/bin:$PATH

# Put the toolchain binutils directory at the front of the path so if gets
# found first during the build
ENV PATH ${TOOLCHAIN_BINUTILS_DIR}:$PATH 

# https://stackoverflow.com/questions/21740619/how-can-i-generate-kernel-headers-for-an-unknown-embedded-arm-system


# Build binutils first
RUN mkdir -p /toolchain-build/build-binutils
WORKDIR /toolchain-build/build-binutils 
RUN ../binutils-2.30/configure \
    --prefix=${TOOLCHAIN_ROOT} \
    --target=${TOOLCHAIN_COMPILE_TARGET} \
    --with-arch=${TOOLCHAIN_ARCH} \
    --with-fpu=${TOOLCHAIN_FPU} \
    --with-float=${TOOLCHAIN_FLOAT_ABI} \
    --disable-multilib && \
    make -j$(nproc) && \
    make install
WORKDIR /toolchain-build


# Install kernel headers
WORKDIR /toolchain-build/linux
ARG KERNEL=kernel7
RUN make ARCH=arm INSTALL_HDR_PATH=${TOOLCHAIN_SYSROOT} headers_install
WORKDIR /toolchain-build


# Get gcc build prereqs
WORKDIR /toolchain-build/gcc-8.1.0
RUN contrib/download_prerequisites
RUN rm ./*.tar.*
WORKDIR /toolchain-build


# Start the gcc build. We will only build targets 
# required for the compiler support lib.
RUN mkdir -p /toolchain-build/build-gcc
WORKDIR /toolchain-build/build-gcc
RUN ../gcc-8.1.0/configure \
    --prefix=${TOOLCHAIN_ROOT} \
    --target=${TOOLCHAIN_COMPILE_TARGET} \
    --with-arch=${TOOLCHAIN_ARCH} \
    --with-fpu=${TOOLCHAIN_FPU} \
    --with-float=${TOOLCHAIN_FLOAT_ABI} \
    --enable-threads=posix \
    --enable-languages=c,c++ \
    --enable-lto \
    --disable-multilib \
    --includedir=${TOOLCHAIN_USR_DIR}/local/include \
    --oldincludedir=${TOOLCHAIN_USR_DIR}/include
RUN make -j$(nproc) all-gcc && make install-gcc
WORKDIR /toolchain-build


# PARTIALLY build glibc (with libgcc stubs) using partially built cross compiler
RUN mkdir -p /toolchain-build/build-glibc
WORKDIR /toolchain-build/build-glibc
RUN ../glibc-2.27/configure \
    --prefix=${TOOLCHAIN_SYSROOT} \
    --build=${TOOLCHAIN_BUILD_HOST} \
    --host=${TOOLCHAIN_RUNTIME_HOST} \
    --target=${TOOLCHAIN_COMPILE_TARGET} \
    --with-arch=${TOOLCHAIN_ARCH} \
    --with-fpu=${TOOLCHAIN_FPU} \
    --with-float=${TOOLCHAIN_FLOAT_ABI} \
    --with-headers=${TOOLCHAIN_SYSROOT}/include/ \
    --disable-multilib \
    libc_cv_forced_unwind=yes
RUN make install-bootstrap-headers=yes install-headers
RUN make csu/subdir_lib
RUN install csu/crt1.o csu/crti.o csu/crtn.o ${TOOLCHAIN_SYSROOT}/lib
RUN ${TOOLCHAIN_NAME}-gcc \
    -nostdlib \
    -nostartfiles \
    -shared \
    -x c /dev/null \
    -o ${TOOLCHAIN_SYSROOT}/lib/libc.so
RUN touch ${TOOLCHAIN_SYSROOT}/include/gnu/stubs.h 
WORKDIR /toolchain-build


# Use the glibc stubs to create the runtime libs for arm-linux-gnueabihf-gcc
WORKDIR /toolchain-build/build-gcc
RUN make -j$(nproc) all-target-libgcc && \
    make install-target-libgcc
WORKDIR /toolchain-build


# Finish building glibc now that we have replaced the stubs with support libs
WORKDIR /toolchain-build/build-glibc
RUN make -j$(nproc) && \
    make install
WORKDIR /toolchain-build


# Complete the build of gcc now that we have built our desired glibc
WORKDIR /toolchain-build/build-gcc
RUN make -j$(nproc) && \
    make install
WORKDIR /toolchain-build


# Create symbolic links from toolchain binutils directory to the native binutils directory
# Technically it would be better to do something like:
#
# RUN find ${TOOLCHAIN_BINUTILS_DIR} -perm /a+x -name "${TOOLCHAIN_NAME}-*"" -exec cp -s {} /usr/bin \;
# 
# but I'm not rebuilding the entire compiler toolchain and docker environment over it.
RUN cp -s ${TOOLCHAIN_BINUTILS_DIR}/* /usr/bin/

# Create ascii chart of toolchain directory structure and place it in ${CROSS_ROOT}
RUN tree --dirsfirst --charset=ascii ${TOOLCHAIN_ROOT} > ${CROSS_ROOT}/${TOOLCHAIN_NAME}.tree
RUN cat ${CROSS_ROOT}/${TOOLCHAIN_NAME}.tree



# Create file comparing search directories between native and cross toolchains 
# useful for debugging linker / preprocessor issues
COPY scripts/compare-toolchain-paths.sh ./compare-toolchain-paths.sh
RUN /bin/bash ./compare-toolchain-paths.sh

################################################################################
### TOOLCHAIN IS COMPLETE
################################################################################
ARG PROJECT_STAGING_DIR=/staging
RUN mkdir -p ${PROJECT_STAGING_DIR}

# Add source repositories to the apt list because we will have to compile
# some of the packages for the target architecture from source
RUN sed -i 's/^[\t ]*#[\t ]*deb-src[\t ]\+/deb-src /g' /etc/apt/sources.list 
RUN apt-get update
RUN mkdir -p /work
WORKDIR /work


# Build and install boost 
#
# SOME URLS THAT PROVIDE HELPFUL READING
# https://github.com/moritz-wundke/Boost-for-Android/issues/130
# https://blog.conan.io/2018/01/30/Cross-building-Boost-Android.html
ARG TOOLCHAIN_BOOST_INSTALL_DIR=${TOOLCHAIN_USR_DIR}
RUN apt-get install -y libboost1.65-all-dev
RUN wget http://sourceforge.net/projects/boost/files/boost/1.65.1/boost_1_65_1.tar.bz2/download
RUN mv download boost.tar.bz2 && tar -xjvf boost.tar.bz2 && rm boost.tar.bz2
WORKDIR ./boost_1_65_1
RUN ./bootstrap.sh && sed -i 's/using gcc/using gcc : arm : arm-linux-gnueabihf-g++/g' project-config.jam
RUN ./b2 \
    --without-context \
    --without-coroutine \
    --without-fiber \
    --without-python \
    --prefix=${TOOLCHAIN_BOOST_INSTALL_DIR} \
    -toolset=arm-linux-gnueabihf-g++ \
    --abi=arm-linux-gnueabihf \
    --architecture=arm \
    --address-model=32 \
    --binary-fomat=elf \
    -threading=multi \
    -j$(nproc)
RUN cp -r ./stage/lib/ ${TOOLCHAIN_BOOST_INSTALL_DIR}/ && \
    cp -r ./boost/ ${TOOLCHAIN_BOOST_INSTALL_DIR}/include/
WORKDIR /work



# Build and install openssl
ARG TOOLCHAIN_OPENSSL_INSTALL_DIR=${TOOLCHAIN_USR_DIR}
ARG OPENSSL_VERSION=1.1.1
RUN apt-get install -y libssl-dev
RUN apt-get install -y libssl1.1
RUN mkdir openssl
WORKDIR /work/openssl
RUN wget https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
RUN tar -xvf openssl-${OPENSSL_VERSION}.tar.gz
WORKDIR openssl-${OPENSSL_VERSION}
RUN ./Configure \
    linux-generic32 \
    --cross-compile-prefix=${TOOLCHAIN_NAME}- \
    --prefix=${TOOLCHAIN_OPENSSL_INSTALL_DIR} \
    --openssldir=${TOOLCHAIN_OPENSSL_INSTALL_DIR} \
    -shared
RUN make install
WORKDIR /work/openssl
RUN rm openssl-${OPENSSL_VERSION}.tar.gz
WORKDIR /work


################################################################################
################################################################################
# ANYTHING THAT USES CMAKE SHOULD GO BELOW HERE BECAUSE BUILDING BOOST FROM
# SOURCE TAKES FOREVER
################################################################################
################################################################################

COPY toolchain.cmake .

# Build and install libmosquitto (native and cross)
RUN apt-get install -y libmosquitto-dev
RUN git clone https://github.com/eclipse/mosquitto.git
WORKDIR /work/mosquitto
RUN sed -i 's/find_package(OpenSSL REQUIRED)/find_package(OpenSSL 1.1.1 REQUIRED)/g' CMakeLists.txt
RUN mkdir -p /work/mosquitto/build
WORKDIR /work/mosquitto/build
RUN cmake ../ \
    -DCMAKE_TOOLCHAIN_FILE=/work/toolchain.cmake \
    -DCMAKE_INSTALL_PREFIX=${TOOLCHAIN_USR_DIR} \
    -DCMAKE_BUILD_TYPE=Release \
    -DWITH_CLIENTS=OFF \
    -DWITH_BROKER=OFF \
    -DWITH_APPS=OFF \
    -DWITH_PLUGINS=OFF \
    -DDOCUMENTATION=OFF \
    -DWITH_CJSON=OFF
RUN make -j$(nproc) && make install
WORKDIR /work

# Build and install JSONCPP
RUN apt-get install -y libjsoncpp-dev
RUN apt-get source libjsoncpp-dev && rm ./*\.dsc && rm ./*\.tar\.*
RUN ln -s $(pwd)/$(ls . | grep libjsoncpp) $(pwd)/jsoncpp
WORKDIR ./jsoncpp
RUN cmake . \
    -DCMAKE_TOOLCHAIN_FILE=/work/toolchain.cmake \
    -DCMAKE_INSTALL_PREFIX=${TOOLCHAIN_USR_DIR} \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_STANDARD=17 \
    -DJSONCPP_WITH_POST_BUILD_UNITTEST=OFF \
    -DBUILD_SHARED_LIBS=ON
RUN make -j$(nproc) && make install

# So there seems to be a difference in the installation directories between
# version of libjsoncpp. 
# 
# Older versions install headers in ......./usr/include/json
# and libs in /usr/lib/
#
# Newer versions install headers in ...../usr/include/jsoncpp/json 
# and libs in /usr/lib
#
# as a workaround and to remain flexible to future changes to the docker image,
#
# we install in the newer directory and softlink from the older header install
# dir into the new one
RUN mkdir -p ${TOOLCHAIN_USR_DIR}/include/jsoncpp && \
    mv ${TOOLCHAIN_USR_DIR}/include/json ${TOOLCHAIN_USR_DIR}/include/jsoncpp/ && \
    ln -s ${TOOLCHAIN_USR_DIR}/include/jsoncpp/json ${TOOLCHAIN_USR_DIR}/include/json

# Clean up our hacky symlink when working with docker working directories
WORKDIR ../
RUN rm ./jsoncpp
WORKDIR /work

# Standalone examples to test network connection, certs, etc, with MQTT
COPY standalone ./standalone
WORKDIR ./standalone
RUN mkdir -p build
WORKDIR ./build
RUN cmake ../ \
    -DCMAKE_TOOLCHAIN_FILE=/work/toolchain.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_RUNTIME_OUTPUT_DIRECTORY=${PROJECT_STAGING_DIR}
RUN make -j$(nproc)
WORKDIR /work


# Build mabel-abi 
# You must clone/wget/curl/magically-download mabel-abi from nautel repository
# and put it inside a directory called "docker-imports"
#
# This is because docker network permissions are sandboxed and it is a pain 
# to get a double NAT -> double PAT working from within a docker container 
# while tunnelled into Rimot's VPN while ALSO tunnelled into Nautel's VPN.
COPY docker-imports/mabel-abi /work/mabel-abi
WORKDIR /work/mabel-abi
RUN if [ -d build ]; then rm -rf build; fi && mkdir -p ./build
WORKDIR ./build
RUN cmake ../ \
    -DCMAKE_TOOLCHAIN_FILE=/work/toolchain.cmake \
    -DCMAKE_INSTALL_PREFIX=${TOOLCHAIN_USR_DIR} \
    -DPRODUCTION=ON \
    -DCMAKE_CXX_STANDARD=17
RUN make -j$(nproc) && make install
RUN rm /etc/ld.so.conf.d/mabelabi.conf && \
    echo "${TOOLCHAIN_USR_DIR}/lib/mabelabi" > /etc/ld.so.conf.d/mabelabi.conf && \
    ldconfig
WORKDIR /work/mabel-abi

# Build cloudcommsplugin
RUN mkdir /cloudcommplugin
WORKDIR /cloudcommplugin
COPY . .
RUN mkdir ./build
WORKDIR ./build
RUN cmake ../ \
    -DCMAKE_TOOLCHAIN_FILE=/work/toolchain.cmake \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -DPRODUCTION=ON \
    -DCMAKE_CXX_STANDARD=17
RUN make -j$(nproc) 
RUN cpack 
WORKDIR /work





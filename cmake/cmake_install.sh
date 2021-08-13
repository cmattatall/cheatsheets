#!/bin/bash
################################################################################
#                                                                              #
# bash script to build and install multiple versions of cmake,                 #
# and configure them using update-alternatives                                 #
#                                                                              #
#                                                                              #
################################################################################
#                                                                              #
# Note: RUN AS SUDO                                                            #
#                                                                              #
################################################################################
#                                                                              #
# Tested on Ubuntu 18.04                                                       #
#                                                                              #
################################################################################

declare -a required_packages=("wget" "tar" "make" "gcc" "g++")
UPDATED=0
for pkg in ${required_packages[@]}; do
    echo -n "Checking for ${pkg} ..."
    dpkg -s ${pkg} > /dev/null # check if installed
    if [ "$?" -ne 0 ]; then
        if [ -z $UPDATED ]; then
            apt-get update
            UPDATED=1
        fi
        apt-get install -y ${pkg}
        if [ "$?" -ne 0 ] ; then
                apt-cache search "${pkg}" | grep "${pkg}"
            if [ "$?" -ne 0 ]; then
                echo "Could not install package ${pkg} because apt says it does not exist."
                exit 0
            else 
                echo "" # formatting
                echo "Could not install ${pkg} using the package manager. Please try installing it manually"
                exit 0
            fi
        fi
    else
        echo -n " ok "
        echo "" # formatting
    fi
done

set -e

# Put the versions you want to install here
declare -a CMAKE_VERSIONS=("3.16.5" "3.21.1" "3.10.3" "3.20.5")


# If there are broken link groups,
# You may have to manually delete the old alternatives.
# See below:
#
# rm /etc/alternatives/cmake
# rm /etc/alternatives/ctest
# rm /etc/alternatives/cpack
# rm -r /var/lib/dpkg/alternatives/cmake

CMAKE_INSTALL_DIR_ABSOLUTE="/usr/cmake"

if [ -d "${CMAKE_INSTALL_DIR_ABSOLUTE}" ]; then
    echo ""
else
	mkdir -p ${CMAKE_INSTALL_DIR_ABSOLUTE} 
fi
pushd ${CMAKE_INSTALL_DIR_ABSOLUTE} > /dev/null


TMP_BUILD_DIR="build"
if [ -d "${TMP_BUILD_DIR}" ]; then
    rm -r ${TMP_BUILD_DIR} && mkdir "${TMP_BUILD_DIR}"
else 
    mkdir "${TMP_BUILD_DIR}"
fi
pushd ${TMP_BUILD_DIR} > /dev/null

set +e
for version in "${CMAKE_VERSIONS[@]}"; do
    echo "Attempting to install cmake version : ${version}..."
    update-alternatives --list cmake > /dev/null && update-alternatives --list cmake | grep -q "${version}" > /dev/null
    if [ "$?" -ne 0 ]; then
    	echo "Attempting to download cmake version : ${version}..."
	    CMAKE_TARBALL_URL="https://github.com/Kitware/CMake/releases/download/v${version}/cmake-${version}.tar.gz"
        wget "${CMAKE_TARBALL_URL}"
        if [ "$?" -ne 0  ]; then
            echo "Could not download ${CMAKE_TARBALL_URL}"
        else	
            echo "Downloaded ${CMAKE_TARBALL_URL} sucessfully!"
            tar -xvf cmake-"${version}".tar.gz
            rm cmake-"${version}".tar.gz

            # cmake-${version} will already exist from untarring the archive
            pushd cmake-"${version}" > /dev/null
            CURRENT_CMAKE_VERSION_INSTALL_DIR="${CMAKE_INSTALL_DIR_ABSOLUTE}/cmake-${version}"
            if [ -d "${CURRENT_CMAKE_VERSION_INSTALL_DIR}" ]; then
                echo ""
            else 
                mkdir -p "${CURRENT_CMAKE_VERSION_INSTALL_DIR}"
            fi
            ./bootstrap --prefix="${CURRENT_CMAKE_VERSION_INSTALL_DIR}"
            make -j"$(nproc)" install

            ALT_PRIO=$(echo "$version" | sed 's/\.//g')
            update-alternatives --force \
            --install /usr/bin/cmake cmake "${CURRENT_CMAKE_VERSION_INSTALL_DIR}"/bin/cmake "${ALT_PRIO}" \
            --slave   /usr/bin/ctest ctest "${CURRENT_CMAKE_VERSION_INSTALL_DIR}"/bin/ctest \
            --slave   /usr/bin/cpack cpack "${CURRENT_CMAKE_VERSION_INSTALL_DIR}"/bin/cpack
            popd > /dev/null # leave BUILD_FOLDER/cmake-${version}
        fi
    else 
	    echo "cmake ${version} is already registered as an alternative"
    fi
    echo "" # newline formatting
done

popd > /dev/null # leave TMP_BUILD_DIR

popd > /dev/null # leave CMAKE_INSTALL_DIR_ABSOLUTE

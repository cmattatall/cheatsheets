#!/bin/bash
################################################################################
#                                                                              #
# bash script to build and install multiple versions of cmake,                 #
# and configure them using update-alternatives                                 #
#                                                                              #
#                                                                              #
################################################################################
#                                                                              #
# Note: RUN WITH ROOT PERMISSIONS                                              #
#                                                                              #
################################################################################
#                                                                              #
# Tested on Ubuntu 18.04                                                       #
#                                                                              #
################################################################################

# Put the versions you want to install here
declare -a CMAKE_VERSIONS=("3.16.5" "3.21.1" "3.10.3" "3.20.5")

# Change these as needed. You don't even have to make the directories yourself
CMAKE_INSTALL_PREFIX="/usr/local/cmake"
CMAKE_BUILD_PREFIX="/usr/local/src/cmake"
CMAKE_BIN_LINK_PATH="/usr/local/bin"

################################################################################
# Note:
################################################################################
# If there are broken update-alternatives link groups,
# You may have to manually delete the old alternatives.
# See below:
#
# rm /etc/alternatives/cmake
# rm /etc/alternatives/ctest
# rm /etc/alternatives/cpack
# rm -r /var/lib/dpkg/alternatives/cmake
################################################################################

################################################################################
################################################################################
# SCRIPT AUTOMATION BEGINS BELOW
################################################################################
################################################################################

declare -a required_packages=("wget" "tar" "make" "gcc" "g++" "libssl-dev" "build-essential")
UPDATED=0
for pkg in ${required_packages[@]}; do
    echo -n "Checking for ${pkg} ..."
    echo ""
    dpkg -s ${pkg} 2> /dev/null # check if installed
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


function create_directories () {
    if [ ! -d "${CMAKE_BUILD_PREFIX}" ]; then
    	mkdir -p "${CMAKE_BUILD_PREFIX}"
    else
        echo "CMAKE_BUILD_PREFIX : ${CMAKE_BUILD_PREFIX} already exists"
    fi

    if [ ! -d "${CMAKE_INSTALL_PREFIX}" ]; then
    	mkdir -p "${CMAKE_INSTALL_PREFIX}"
    else 
        echo "CMAKE_INSTALL_PREFIX : ${CMAKE_INSTALL_PREFIX} already exists"
    fi

    # We won't touch CMAKE_BIN_LINK_PATH because we'll assume that is 
    # already exists and it will likely be /usr/bin or /usr/local/bin
    # and the consequences of a bug in the script can cause big problems
}



function download_cmake_version () {
    if [ "$#" -ne 1 ]; then
        echo "Illegal number of parameters. Expected 1 but $# were given." 
        echo "Only 1 cmake version can be downloaded at the same time"
        echo "Args provided:"
        for arg; do
            echo "-n $arg" 
        done
        exit -1
    else
        [ -z "${CMAKE_BUILD_PREFIX}" ] && echo "CMAKE_BUILD_PREFIX not set. Exiting ... " && exit 1
        [ -z "${CMAKE_INSTALL_PREFIX}" ] && echo "CMAKE_INSTALL_PREFIX not set. Exiting ... " && exit 1

        version=$1
        local CMAKE_CURRENT_VERSION_DIR="cmake-${version}"
        local CMAKE_CURRENT_BUILD_PATH="${CMAKE_BUILD_PREFIX}/${CMAKE_CURRENT_VERSION_DIR}"
        local CMAKE_CURRENT_INSTALL_PREFIX="${CMAKE_INSTALL_PREFIX}/${CMAKE_CURRENT_VERSION_DIR}"

        echo "Before download, checking if ${CMAKE_BUILD_PREFIX} exists ... "
        if [ ! -d "${CMAKE_BUILD_PREFIX}" ]; then
            echo "Build directory ${CMAKE_BUILD_PREFIX} for cmake ${version} does not exist. Creating..."
            mkdir -p "${CMAKE_BUILD_PREFIX}"
            if [ "$?" -ne 0 ]; then
                echo "Could not create directory to be used as Build directory for cmake ${version}. Exiting ..."
                exit 1
            fi
        else 
            echo "Ok."
            echo ""
        fi
        cd "${CMAKE_BUILD_PREFIX}"

        local CMAKE_CURRENT_TARBALL_FILE="cmake-${version}.tar.gz"
        local CMAKE_TARBALL_URL="https://github.com/Kitware/CMake/releases/download/v${version}/cmake-${version}.tar.gz"
        echo "Downloading source for cmake ${version} ..."
        wget "${CMAKE_TARBALL_URL}" -O ${CMAKE_CURRENT_TARBALL_FILE}
        if [ "$?" -ne 0  ]; then
            echo "Could not download ${CMAKE_TARBALL_URL}"
            exit -1
        else
            echo "Downloaded ${CMAKE_TARBALL_URL} sucessfully!"
            tar -xvf "${CMAKE_CURRENT_TARBALL_FILE}" -C ${CMAKE_BUILD_PREFIX}
            rm "${CMAKE_CURRENT_TARBALL_FILE}"
        fi


        echo "Checking if cmake ${version} sources downloaded correctly ..."
        if [[ -d "${CMAKE_CURRENT_BUILD_PATH}" ]]; then
            echo "Ok."
            echo ""
        else
            echo "Directory ${CMAKE_CURRENT_BUILD_PATH} does not exist. "
            echo "There was an error downloading the sources for cmake ${version}."
            echo "Exiting."
            exit 1
        fi
    fi
}


function build_and_install_cmake_version () {
    if [ "$#" -ne 1 ]; then
        echo "Illegal number of parameters. Expected 1 but $# were given." 
        echo "Only 1 cmake version can be built and installed at the same time"
        echo "Args provided:"
        for arg; do
            echo "-n $arg" 
        done
        exit -1
    else
        [ -z "${CMAKE_BUILD_PREFIX}" ] && echo "CMAKE_BUILD_PREFIX not set. Exiting ... " && exit 1
        [ -z "${CMAKE_INSTALL_PREFIX}" ] && echo "CMAKE_INSTALL_PREFIX not set. Exiting ... " && exit 1

        version=$1
        local CMAKE_CURRENT_VERSION_DIR="cmake-${version}"
        local CMAKE_CURRENT_BUILD_PATH="${CMAKE_BUILD_PREFIX}/${CMAKE_CURRENT_VERSION_DIR}"
        local CMAKE_CURRENT_INSTALL_PREFIX="${CMAKE_INSTALL_PREFIX}/${CMAKE_CURRENT_VERSION_DIR}"

        if [ ! -d "${CMAKE_CURRENT_INSTALL_PREFIX}" ]; then
            echo "Install prefix ${CMAKE_CURRENT_INSTALL_PREFIX} for cmake ${version} does not exist. Creating..."
            mkdir -p "${CMAKE_CURRENT_INSTALL_PREFIX}"
            if [ "$?" -ne 0 ]; then
                echo "Could not create directory to be used as Install prefix for cmake ${version}. Exiting ..."
                exit 1
            fi
        fi

        echo "Checking for current cmake build path : ${CMAKE_CURRENT_BUILD_PATH} ... "
        if [ -d "${CMAKE_CURRENT_BUILD_PATH}" ]; then
            echo "Ok."
            cd "${CMAKE_CURRENT_BUILD_PATH}"
            if [ -d "${CMAKE_CURRENT_INSTALL_PREFIX}" ]; then
                echo "Starting build of cmake ${version} ..."
                ./bootstrap --prefix="${CMAKE_CURRENT_INSTALL_PREFIX}"
                if [ "$?" -eq 0 ]; then
                    echo "Built cmake ${version} successfully! Now installing..."
                    make -j"$(nproc)" install
                else
                    echo "Failed to build cmake ${version}. Now exiting..."
                    exit 3
                fi
            else 
                echo "Install prefix ${CMAKE_CURRENT_INSTALL_PREFIX} for cmake ${version} does not exist. Exiting"
                exit 2
            fi
        else
            echo "Build directory ${CMAKE_CURRENT_BUILD_PATH} for cmake ${version} does not exist. Exiting"
            exit 1
        fi
    fi
}



function check_built_cmake_version_executables_exist () {
    if [ "$#" -ne 1 ]; then
        echo "Illegal number of parameters. Expected 1 but $# were given." 
        echo "Only 1 cmake version can be checked at the same time"
        echo "Args provided:"
        for arg; do
            echo "-n $arg" 
        done
        exit -1
    else
        [ -z "${CMAKE_BUILD_PREFIX}" ] && echo "CMAKE_BUILD_PREFIX not set. Exiting ... " && exit 1
        [ -z "${CMAKE_INSTALL_PREFIX}" ] && echo "CMAKE_INSTALL_PREFIX not set. Exiting ... " && exit 1

        version=$1
        local CMAKE_CURRENT_VERSION_DIR="cmake-${version}"
        local CMAKE_CURRENT_BUILD_PATH="${CMAKE_BUILD_PREFIX}/${CMAKE_CURRENT_VERSION_DIR}"
        local CMAKE_CURRENT_INSTALL_PREFIX="${CMAKE_INSTALL_PREFIX}/${CMAKE_CURRENT_VERSION_DIR}"
        
        local CURRENT_CMAKE_EXE_PATH="${CMAKE_CURRENT_INSTALL_PREFIX}/bin/cmake"
        local CURRENT_CPACK_EXE_PATH="${CMAKE_CURRENT_INSTALL_PREFIX}/bin/cpack"
        local CURRENT_CTEST_EXE_PATH="${CMAKE_CURRENT_INSTALL_PREFIX}/bin/ctest"

        if [[ -e "${CURRENT_CMAKE_EXE_PATH}" ]]; then
            if [[ ! -x "$CURRENT_CMAKE_EXE_PATH" ]]; then 
                echo "File ${CURRENT_CMAKE_EXE_PATH} exists but does not have executable permissions"
                exit 1
            fi
        else 
            echo "File ${CURRENT_CMAKE_EXE_PATH} does not exist"
            exit 1
        fi

        
        if [[ -e "${CURRENT_CPACK_EXE_PATH}" ]]; then
            if [[ ! -x "$CURRENT_CPACK_EXE_PATH" ]]; then 
                echo "File ${CURRENT_CPACK_EXE_PATH} exists but does not have executable permissions"
                exit 1
            fi
        else 
            echo "File ${CURRENT_CPACK_EXE_PATH} does not exist"
            exit 1
        fi


        if [[ -e "${CURRENT_CTEST_EXE_PATH}" ]]; then
            if [[ ! -x "$CURRENT_CTEST_EXE_PATH" ]]; then 
                echo "File ${CURRENT_CTEST_EXE_PATH} exists but does not have executable permissions"
                exit 1
            fi
        else 
            echo "File ${CURRENT_CTEST_EXE_PATH} does not exist"
            exit 1
        fi

    fi
}


function symlink_cmake_version () {
    if [ "$#" -ne 1 ]; then
        echo "Illegal number of parameters. Expected 1 but $# were given." 
        echo "Only 1 cmake version can be configured with update-altneratives at the same time"
        echo "Args provided:"
        for arg; do
            echo "-n $arg" 
        done
        exit -1
    else
        [ -z "${CMAKE_BUILD_PREFIX}" ] && echo "CMAKE_BUILD_PREFIX not set. Exiting ... " && exit 1
        [ -z "${CMAKE_INSTALL_PREFIX}" ] && echo "CMAKE_INSTALL_PREFIX not set. Exiting ... " && exit 1

        version=$1
        local CMAKE_CURRENT_VERSION_DIR="cmake-${version}"
        local CMAKE_CURRENT_BUILD_PATH="${CMAKE_BUILD_PREFIX}/${CMAKE_CURRENT_VERSION_DIR}"
        local CMAKE_CURRENT_INSTALL_PREFIX="${CMAKE_INSTALL_PREFIX}/${CMAKE_CURRENT_VERSION_DIR}"

        # Check that paths to the current alternative for cmake, ctest, cpack actually exist
        local CURRENT_CMAKE_EXE_PATH="${CMAKE_CURRENT_INSTALL_PREFIX}/bin/cmake"
        local CURRENT_CPACK_EXE_PATH="${CMAKE_CURRENT_INSTALL_PREFIX}/bin/cpack"
        local CURRENT_CTEST_EXE_PATH="${CMAKE_CURRENT_INSTALL_PREFIX}/bin/ctest"
        check_built_cmake_version_executables_exist ${version}

        local ALT_PRIO=$(echo "$version" | sed 's/\.//g')
        update-alternatives --force \
        --install ${CMAKE_BIN_LINK_PATH}/cmake cmake "${CURRENT_CMAKE_EXE_PATH}" "${ALT_PRIO}" \
        --slave   ${CMAKE_BIN_LINK_PATH}/ctest ctest "${CURRENT_CPACK_EXE_PATH}" \
        --slave   ${CMAKE_BIN_LINK_PATH}/cpack cpack "${CURRENT_CTEST_EXE_PATH}"

        if [ "$?" -ne 0 ]; then
            echo "Error configuring update-alternatives for cmake ${version}"
            exit 1
        fi
    fi
}


function setup_cmake_version (){
    if [ "$#" -ne 1 ]; then
        echo "Illegal number of parameters. Expected 1 but $# were given." 
        echo "Only 1 cmake version can be setup at the same time"
        echo "Args provided:"
        for arg; do
            echo "-n $arg" 
        done
        exit -1
    else
        [ -z "${CMAKE_BUILD_PREFIX}" ] && echo "CMAKE_BUILD_PREFIX not set. Exiting ... " && exit 1
        [ -z "${CMAKE_INSTALL_PREFIX}" ] && echo "CMAKE_INSTALL_PREFIX not set. Exiting ... " && exit 1

        version=$1
        echo "Setting up cmake version ${version} ..."
        local CMAKE_CURRENT_VERSION_DIR="cmake-${version}"
        local CMAKE_CURRENT_BUILD_PATH="${CMAKE_BUILD_PREFIX}/${CMAKE_CURRENT_VERSION_DIR}"
        local CMAKE_CURRENT_INSTALL_PREFIX="${CMAKE_INSTALL_PREFIX}/${CMAKE_CURRENT_VERSION_DIR}"

        echo "CMAKE_CURRENT_BUILD_PATH = ${CMAKE_CURRENT_BUILD_PATH}"
        echo "CMAKE_CURRENT_INSTALL_PREFIX = ${CMAKE_CURRENT_INSTALL_PREFIX}"

        # Before we try to download and build a cmake version, check if we already have it     
        update-alternatives --list cmake > /dev/null && \
        update-alternatives --list cmake | grep "${version}" > /dev/null
        if [ "$?" -ne 0 ]; then
            download_cmake_version $version
            build_and_install_cmake_version $version
            symlink_cmake_version $version
        else 
            echo "cmake ${version} is already registered as an alternative"
        fi
    fi
}



function setup_multiple_cmake_versions () {
    cd "${CMAKE_BUILD_PREFIX}"
    if [ "$?" -ne 0 ]; then
        exit -1
    else 
        if [ "$#" -eq 0 ]; then
            echo "Illegal number of parameters. At least 1 argument must be given."
            exit -1
        else
            # Note that:
            # $ for i; do ... done
            # is equivalent to
            # $ for i in "$@"; do .... done
            for version; do
                setup_cmake_version ${version}
            done
        fi
    fi
}



function main () {
    create_directories
    setup_multiple_cmake_versions "${CMAKE_VERSIONS[@]}"

    for version in "${CMAKE_VERSIONS[@]}"; do
        echo "Checking cmake ${version} was installed correctly ... "
        update-alternatives --list cmake 2> /dev/null && \
        update-alternatives --list cmake | grep ${version} 2> /dev/null
        if [ "$?" -eq 0 ]; then
            echo "Ok."
            echo ""
        else 
            echo "" # CLI output formatting
            echo -n "An error occurred when installing cmake ${version}." 
            echo -n "Try installing manually"
            echo "" # CLI output formatting
            exit 1
        fi
    done
}


main
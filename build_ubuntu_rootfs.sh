#!/bin/bash

source general.sh

TAG=""

print_menu()
{
    local PLATFORM=("AMD64" "ARM64" "ARMHF")

    echo "select platform:"
    echo "0. amd64"
    echo "1. arm64"
    echo "2. armhf"
    read input

    if [ -z ${PLATFORM[$input]} ];then
        echo "don't support this platform!"
        exit 1
    else
        echo "build ubuntu rootfs for ${PLATFORM[$input]}"
        TAG="UBUNTU_BASE_${PLATFORM[$input]}"
        
        echo "build:"
        echo "0. 16.04"
        echo "1. 18.04"
        echo "2. 20.04"
        read input

        echo ${TAG[$input]}
    fi
}

get_ubuntu_base()
{
    if [ ! -d rootfs ];then
        mkdir rootfs
    fi


}

print_menu
#!/bin/bash

source general.sh

BASE_DIR=`pwd`
TAG=""
TAG_ROOTFS_PACKAGE=""
TAG_SOURCE_MIRROR="ports.ubuntu.com"
SOURCE_MIRROR="mirrors.ustc.edu.cn"
IMG=rootfs.img

print_menu()
{
    local PLATFORM=("AMD64" "ARM64" "ARMHF")

    echo "select platform:"
    echo "0. amd64"
    echo "1. arm64"
    echo "2. armhf"
    read input1

    echo "build:"
    echo "0. 16.04"
    echo "1. 18.04"
    echo "2. 20.04"
    read input2

    case $input1 in
    0)
        TAG=${UBUNTU_BASE_AMD64[$input2]}
    ;;
    1)
        TAG=${UBUNTU_BASE_ARM64[$input2]}
    ;;
    2)
        TAG=${UBUNTU_BASE_ARMHF[$input2]}
    ;;
    *)
        echo "platform has not support!"
        exit 1
    ;;
    esac
}

get_ubuntu_base()
{
    if [ ! -d rootfs ];then
        mkdir rootfs
    fi

    rm -rf rootfs/*
    wget $TAG
    tar xvzf *.tar.gz -C rootfs
    rm *.tar.gz

    cp chroot.sh rootfs
    chmod +x rootfs/chroot.sh
    cp -b /etc/resolv.conf rootfs/etc/resolv.conf
    cp /usr/bin/qemu-aarch64-static rootfs/usr/bin/
    cp  -r /etc/skel rootfs/etc/
    sed -i s@/$TAG_SOURCE_MIRROR/@/$SOURCE_MIRROR/@g rootfs/etc/apt/sources.list
}

build_rootfs()
{
    mount -v --bind /dev rootfs/dev
    mount -vt devpts devpts rootfs/dev/pts -o gid=5,mode=620
    mount -vt proc proc rootfs/proc
    mount -vt sysfs sysfs rootfs/sys
    mount -vt tmpfs tmpfs rootfs/run

    chmod 777 rootfs/tmp
    chroot rootfs /bin/bash -c "./chroot.sh"
    
    rm rootfs/chroot.sh
    umount -vt devpts rootfs/dev/pts
    umount -vt proc rootfs/proc 
    umount -vt sysfs rootfs/sys
    umount -vt tmpfs rootfs/run
    umount -v rootfs/dev

    rm -rf rootfs/etc/apt/sources.list.d/*.key
    rm -rf rootfs/var/lib/apt/lists/*
}

pack_img()
{
    local MKDIR=build-rootfs
    local size=`du -sh rootfs | awk '{print $1}'`
    dd if=/dev/zero of=$IMG bs=$size count=2 status=progress

    if [ ! -d  $MKDIR ];then
        mkdir $MKDIR
    fi

    mkfs.ext4 $IMG
    mount $IMG $MKDIR

    cp -rf rootfs/* $MKDIR/
    umount $MKDIR
    rm -rf $MKDIR
    e2fsck -p -f $IMG
    resize2fs  -M $IMG
}

print_menu
get_ubuntu_base
build_rootfs
pack_img
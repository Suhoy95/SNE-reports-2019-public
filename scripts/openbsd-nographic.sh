#!/bin/bash

set -x

CDISO=~/VM/iso/install64.iso
HDD=~/VM/kvm-hdd/openbsd-nographic.raw

if [ "$1" = "reinstall" ]; then
    rm -f "$HDD"
    BOOT="-boot once=d"
fi


if [ ! -f "$HDD" ]; then
    qemu-img create -f raw "$HDD" 1G
fi

sudo kvm -cdrom "$CDISO" \
    -drive file="$HDD",if=virtio,format=raw \
    -m 512M \
    $BOOT \
    -nographic \
    -serial telnet::5555,server \
    -netdev tap,id=openbsd,ifname=tap0-kvm,script=no \
    -device virtio-net,netdev=openbsd,mac=02:6f:6a:b0:87:3e


#!/bin/bash

set -x

CDISO=~/VM/iso/windows7.iso
HDD=~/VM/kvm-hdd/windows.raw

if [ "$1" = "reinstall" ]; then
    rm -f "$HDD"
    BOOT="-boot once=d"
fi


if [ ! -f "$HDD" ]; then
    qemu-img create -f raw "$HDD" 10G
fi

sudo kvm -cdrom "$CDISO" \
    -drive file="$HDD",format=raw \
    -m 1024M \
    $BOOT \
    -monitor telnet::45454,server \
    -netdev tap,id=windows7,ifname=tap0-kvm,script=no \
    -device e1000,netdev=windows7,mac=02:9b:e1:1c:71:50


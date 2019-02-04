#!/bin/bash

set -x

CDISO=~/VM/iso/ubuntu-18.04.1-live-server-amd64.iso
HDD=~/VM/kvm-hdd/ubuntu-server.raw

if [ "$1" = "reinstall" ]; then
    rm -f "$HDD"
    BOOT="-boot once=d"
fi


if [ ! -f "$HDD" ]; then
    qemu-img create -f raw "$HDD" 10G
fi

sudo kvm -cdrom "$CDISO" \
    -drive file="$HDD",if=virtio,format=raw \
    -m 512M \
    $BOOT \
    -netdev tap,id=ubuntu-server,ifname=tap0-kvm,script=no \
    -device virtio-net,netdev=ubuntu-server,mac=02:c2:03:bc:48:6f

    # -monitor telnet::45454,server \

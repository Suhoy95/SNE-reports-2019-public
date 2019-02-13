#!/bin/bash

set -x

USBISO=~/VM/iso/FreeBSD-12.0-RELEASE-amd64-memstick.img
HDD=~/VM/kvm-hdd/freebsd.raw

if [ "$1" = "reinstall" ]; then
    rm -f "$HDD"
    BOOT="-boot menu=on"
fi


if [ ! -f "$HDD" ]; then
    qemu-img create -f raw "$HDD" 15G
fi

kvm -cpu host,vmx \
    -usb -usbdevice "disk:$USBISO" \
    -drive file="$HDD",if=virtio,format=raw \
    -m 2048M \
    $BOOT \
    -monitor stdio \
    -netdev tap,id=freebsd,ifname=tap0-kvm,script=no \
    -device virtio-net,netdev=freebsd,mac=02:4f:88:2e:9b:e7

    # -nographic \
    # -serial telnet::5555,server \

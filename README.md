

# Preface

# Task 1. KVM & Rassbery PI 3B+

## Install ArchLinux

- [Raspberry Pi 3 | Arch Linux ARM](https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-3)

### Preparing MicroSD card

*We are installing on Samsung MicroSD 32GB*

```
fdisk /dev/sdb
> o
> n [new] -> p [primary] -> ENTER [1st part] -> ENTER [start sector = 2048] -> +100M
> t [type] -> c ['Linux' -> 'W95 FAT32 (LBA)']
> n -> p -> ENTER -> ENTER
> w
```

```
mkfs.vfat /dev/sdb1
mkdir boot
mount /dev/sdb1 boot/

mkfs.ext4 /dev/sdb2
mkdir root
mount /dev/sdb2 root

wget http://de3.mirror.archlinuxarm.org/os/ArchLinuxARM-rpi-3-latest.tar.gz{,.md5}
md5sum -c ArchLinuxARM-rpi-3-latest.tar.gz.md5
bsdtar -xpf ArchLinuxARM-rpi-2-latest.tar.gz -C root
sync && sync && sync

mv root/boot/* boot
sync && sync && sync

umount boot root
```

### Configuring system

- basic users and network status

```
# passwd
# userdel alarm
# rm -r /home/alarm

systemctl status systemd-networkd
systemctl status systemd-resolved
resolvectl status
```

- enable DNSSEC

```
mkdir /etc/systemd/resolved.conf.d
cat /etc/systemd/resolved.conf.d/dnssec.conf
> [Resolve]
> DNSSEC=true

systemctl restart systemd-resolved && resolvectl status
resolvectl query sigfail.verteiltesysteme.net
> sigfail.verteiltesysteme.net: resolve call failed: DNSSEC validation failed: invalid
```

- enroll archlinux keys and check if the validation is enabled (see [archlinuxarm](https://archlinuxarm.org/about/package-signing))

```
systemctl status haveged
pacman-key --init
pacman -S archlinuxarm-keyring
> ...
>  -> Locally signing key 69DD6C8FD314223E14362848BF7EEF7A9C6B5765...
>  -> Locally signing key 02922214DE8981D14DC2ACABBC704E86B823CD25...
>  -> Locally signing key 9D22B7BB678DC056B1F7723CB55C5315DCD9EE1A...
> ...
pacman-key --populate archlinuxarm
vi /etc/pacman.conf
> ...
> SigLevel    = Required DatabaseOptional
> LocalFileSigLevel = Optional
> ...
```

- set network

```
hostnamectl set-hostname laputa

cat /etc/systemd/network/eth.network
> [Match]
> Name=eth0
>
> [Network]
> Address=192.168.16.242/24
> Gateway=192.168.16.1
> DNS=8.8.8.8
systemctl restart systemd-networkd && ip addr
```

- set SSH and also import public keys

```
cat /etc/ssh/sshd_config
> Port 22922
> PasswordAuthentication no
```

- Install convinient packages

```
packman -S vim bash-completion
```

## Installing KVM

### Checking the environment

```
[root@laputa ~]# lscpu
Architecture:        aarch64
Byte Order:          Little Endian
CPU(s):              4
On-line CPU(s) list: 0-3
Thread(s) per core:  1
Core(s) per socket:  4
Socket(s):           1
Vendor ID:           ARM
Model:               4
Model name:          Cortex-A53
Stepping:            r0p4
BogoMIPS:            38.40
Flags:               fp asimd evtstrm crc32 cpuid
```

```
[root@laputa ~]# zgrep CONFIG_KVM /proc/config.gz
CONFIG_KVM_MMIO=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM=y
CONFIG_KVM_ARM_HOST=y
CONFIG_KVM_ARM_PMU=y
CONFIG_KVM_INDIRECT_VECTORS=y
```

```
pacman -Sy
pacman -S qemu-headless
mkdir -p distros/debian && cd distros/debian
wget https://cdimage.debian.org/debian-cd/current/arm64/iso-cd/debian-9.7.0-arm64-netinst.iso \
     https://cdimage.debian.org/debian-cd/current/arm64/iso-cd/SHA256SUMS

qemu-img create -f qcow debianhdd.qcow 1G

qemu-system-aarch64 -M virt -cpu cortex-a57 -drive file=./debianhdd.qcow,if=virtio,format=qcow -drive if=virtio,format=raw,file=debian-9.7.0-arm64-netinst.iso -m 100M -boot once=d -monitor telnet::45454,server -vnc 0.0.0.0:0

# fail
```


# Task 2. HyperV & Windows Server 2016

# Conclusion

# References

## Arch

- [https://wiki.archlinux.org/index.php/Network configuration#Static_IP_address](https://wiki.archlinux.org/index.php/Network configuration#Static_IP_address)
- [https://wiki.archlinux.org/index.php/Network configuration#Network_managers](https://wiki.archlinux.org/index.php/Network configuration#Network_managers)
- [https://jlk.fjfi.cvut.cz/arch/manpages/man/networkctl.1](https://jlk.fjfi.cvut.cz/arch/manpages/man/networkctl.1)
- [https://wiki.archlinux.org/index.php/Systemd-networkd](https://wiki.archlinux.org/index.php/Systemd-networkd)
- [https://wiki.archlinux.org/index.php/Systemd-resolved#DNSSEC](https://wiki.archlinux.org/index.php/Systemd-resolved#DNSSEC)
- [https://jlk.fjfi.cvut.cz/arch/manpages/man/resolved.conf.5](https://jlk.fjfi.cvut.cz/arch/manpages/man/resolved.conf.5)
- [https://wiki.archlinux.org/index.php/Systemd-networkd#Wired_adapter_using_a_static_IP](https://wiki.archlinux.org/index.php/Systemd-networkd#Wired_adapter_using_a_static_IP)
- [https://en.wikipedia.org/wiki/Castle_in_the_Sky](https://en.wikipedia.org/wiki/Castle_in_the_Sky)
- [https://wiki.archlinux.org/index.php/Pacman](https://wiki.archlinux.org/index.php/Pacman)
- [https://wiki.archlinux.org/index.php/Bash#Tab_completion](https://wiki.archlinux.org/index.php/Bash#Tab_completion)
- [https://wiki.archlinux.org/index.php/KVM](https://wiki.archlinux.org/index.php/KVM)
- [http://www.linux-kvm.org/page/FAQ#General_KVM_information](http://www.linux-kvm.org/page/FAQ#General_KVM_information)


# Appendix

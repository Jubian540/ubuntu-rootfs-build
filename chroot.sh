#!/bin/bash

USER=ubuntu
BOARD=board

apt update
apt -y upgrade

install_base()
{
    apt install -y sudo systemd systemd-sysv gdisk parted u-boot-tools linux-base initramfs-tools util-linux 
    apt install -y rfkill file findutils vim bc net-tools isc-dhcp-client iputils-ping network-manager
    apt install -y openssh-client openssh-server ssh bluez gnupg2
}

install_net()
{
    apt install -y isc-dhcp-client avahi-utils avahi-daemon dhcpcd5 ethtool fping
    apt install -y iperf3 iproute2 iputils-ping iw net-tools network-manager ntp
    apt install -y openssh-client openssh-server resolvconf ssh wireless-tools
    apt install -y wpasupplicant 
}

setup_user()
{
    adduser --gecos "$USER" \
            --disabled-password \
            --shell /bin/bash \
            "$USER"

    adduser "$USER" audio
    adduser "$USER" sudo
    adduser "$USER" video
    #adduser "$USER" render

    echo "$USER:$USER" | chpasswd
}

setup_hostname()
{
    rm -rf /etc/hosts /etc/hostname
    touch /etc/hosts /etc/hostname

    cat <<-EOF > /etc/hostname
    $BOARD
EOF

    cat <<-EOF > /etc/hosts
    127.0.0.1 localhost
    127.0.1.1 $BOARD
    # The following lines are desirable for IPv6 capable hosts
    #::1     localhost ip6-localhost ip6-loopback
    #fe00::0 ip6-localnet
    #ff00::0 ip6-mcastprefix
    #ff02::1 ip6-allnodes
    #ff02::2 ip6-allrouters
EOF
}

setup_autologin()
{
    cat <<-EOF >> /usr/share/lightdm/lightdm.conf.d/01_debian.conf
    [SeatDefaults]
    autologin-user=$USER
    autologin-user-timeout=0
EOF
}

setup()
{
    chown root:root /usr/bin/sudo
    chmod 4755 /usr/bin/sudo
    rm -rf /home/$USER/*
}

install_base
install_net
setup_user
setup_hostname
setup_autologin
setup
exit
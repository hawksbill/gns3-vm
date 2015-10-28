#!/bin/sh
#
# Copyright (C) 2015 GNS3 Technologies Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Install the config files on the system.
# This script need to run as root and you need to cd in
# the directory before running it
#

set -e

export DEBIAN_FRONTEND="noninteractive"

# Add our ppa
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:gns3/qemu
sudo add-apt-repository -y ppa:gns3/ppa
sudo apt-get update


# VMware open-vm-tools
apt-get install -y open-vm-tools-lts-trusty

# Autologin
apt-get install -y mingetty

# Python
apt-get install -y python3-dev python3.4-dev python3-setuptools

# Install netifaces
apt-get install -y python3-netifaces

# Install qemu
apt-get install -y qemu-system-x86 qemu-system-arm qemu-kvm cpulimit

# Install gns3 dependencies
apt-get install -y dynamips iouyap ubridge

# Install iou dependencies
apt-get install -y lib32z1
apt-get install -y libssl1.0.0
apt-get install -y 'libssl1.0.0:i386'

if [ -f /lib/i386-linux-gnu/libcrypto.so.4 ]
then
    echo "Libcrypto is already installed"
else
    ln -s /lib/i386-linux-gnu/libcrypto.so.1.0.0 /lib/i386-linux-gnu/libcrypto.so.4
fi

# Setup Python 3
apt-get install -y python3-pip

mv "rc.local" "/etc/rc.local"
chmod 700 /etc/rc.local
chown root:root /etc/rc.local

# Setup dhclient
mv "dhclient.conf" "/etc/dhcp/dhclient.conf"
chown root:root /etc/dhcp/dhclient.conf
chmod 644 /etc/dhcp/dhclient.conf

# Setup grub
mv "grub" "/etc/default/grub"
chown root:root /etc/default/grub
chmod 700 /etc/default/grub
update-grub

# Setup upstart
mv "gns3.conf" "/etc/init/gns3.conf"
chown root:root /etc/init/gns3.conf
chmod 644 /etc/init/gns3.conf

# Configure network
mv interfaces /etc/network/interfaces
chmod 644 /etc/network/interfaces
chown root:root /etc/network/interfaces

# Sources.list
mv sources.list /etc/apt/sources.list
chmod 644 /etc/apt/sources.list
chown root:root /etc/apt/sources.list

# Zerofree
mv zerofree /etc/init.d/zerofree
chown root:root /etc/init.d/zerofree
chmod 744 /etc/init.d/zerofree
update-rc.d zerofree defaults 61
if [ -f /etc/rc0.d/K61zerofree ]
then
    mv /etc/rc0.d/K61zerofree /etc/rc0.d/S61zerofree
    mv /etc/rc6.d/K61zerofree /etc/rc6.d/S61zerofree
fi

mv tty1.conf /etc/init/tty1.conf
mv tty2.conf /etc/init/tty2.conf

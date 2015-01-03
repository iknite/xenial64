#!/bin/bash

# Setup sudo to allow no-password sudo for "admin"
groupadd -r admin
usermod -a -G admin vagrant

# vagrant user needs sudo without ask password, yikes
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers


# sudo install requiered dependencies
apt-get install -y -qq linux-headers-generic build-essential dkms nfs-common > /dev/null


# install virtualbox guest additions
# mount iso
mkdir /tmp/isomount
mount -t iso9660 -o loop /tmp/VBoxGuestAdditions.iso /tmp/isomount

# Install the drivers
/tmp/isomount/VBoxLinuxAdditions.run

# Cleanup
umount /tmp/isomount
rm -rf /tmp/isomount /tmp/VBoxGuestAdditions.iso
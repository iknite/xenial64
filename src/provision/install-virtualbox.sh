#!/bin/bash
set -x

# delete all unused linux headers and images, to ensure VBoxAdditions it in the correct kernel
dpkg --list linux-* | awk '/headers-[0-9]|image-[0-9]/ { print $2 }' \
    | grep -v $(uname -r | cut -d '-' -f 1) | xargs apt-get -y purge

# sudo install required dependencies
apt-get install -y -qq build-essential dkms nfs-common

# Download virtualbox guest additions
version=$(cat ~vagrant/.vbox_version)
cd /tmp && wget \
    http://download.virtualbox.org/virtualbox/$version/VBoxGuestAdditions_$version.iso

# mount iso
mkdir /tmp/isomount
mount -t iso9660 -o loop /tmp/VBoxGuestAdditions_$version.iso /tmp/isomount

# Install the drivers
/tmp/isomount/VBoxLinuxAdditions.run

#tweak opensshserver to connect faster
echo 'UseDNS no' >> /etc/ssh/sshd_config

# Cleanup
umount /tmp/isomount
rm -rf /tmp/isomount /tmp/VBoxGuestAdditions_$version.iso
apt-get remove --purge build-essential -y -qq

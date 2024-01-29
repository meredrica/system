#!/bin/bash
# TODOS:
# mount cifs etc
# read passwords from commandline once
# auto setup cups
# configure dhcp to static
# configure keyboard layout

# save current dir
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# set ntp server
echo 'NTP=0.at.pool.ntp.org 1.at.pool.ntp.org 2.at.pool.ntp.org 3.at.pool.ntp.org' >> /etc/systemd/timesyncd.conf
timedatectl set-ntp true

# install base things that are necessary
pacman -Suy
pacman -S --needed base-devel git zsh sudo openssh wget reflector yadm --noconfirm

# update mirrors
reflector -c at,deh -f 10

# create meredrica user
useradd -m -G wheel -s /usr/bin/zsh meredrica

# podman rootless setup
touch /etc/containers/nodocker
touch /etc/subuid /etc/subgid
usermod --add-subuids 100000-165535 --add-subgids 100000-165535 meredrica

echo 'get PASSWORD for meredrica'
passwd meredrica

# enable the wheel group
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

# change to user
su meredrica <<'EOF'
# save current dir
# KEEP THIS, we need it twice
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $DIR

# dotfiles setup
yadm clone --bootstrap https://git.meredrica.org/meredrica/dotfiles.git

# install yay
cd /tmp
git clone https://aur.archlinux.org/yay.git

cd /tmp/yay
makepkg -sri --noconfirm

# install a lot of packages via yay
cd $DIR
./packages.sh
./node.sh

podman system migrate

EOF

# enable a few things we need
systemctl enable lightdm

# set default font to ttf-droid
ln -s /etc/fonts/conf.avail/60-ttf-droid-sans-mono.conf /etc/fonts/conf.d/
ln -s /etc/fonts/conf.avail/65-ttf-droid-kufi.conf /etc/fonts/conf.d/
ln -s /etc/fonts/conf.avail/65-ttf-droid-sans.conf /etc/fonts/conf.d/
ln -s /etc/fonts/conf.avail/65-ttf-droid-serif.conf /etc/fonts/conf.d/

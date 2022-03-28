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

# install base-devel and git
pacman -Suy
pacman -S --needed base-devel git zsh sudo openssh yajl wget reflector --noconfirm

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
cd ~

# set git stuff
git config --global user.email "stuff@meredrica.org"
git config --global user.name "meredrica"
git config --global rerere.enabled true
git config --global push.default upstream
git config --global core.editor nvim

# install yay
cd /tmp
git clone https://aur.archlinux.org/yay.git

cd /tmp/yay
makepkg -sri --noconfirm

# set the yay flags
yay --cleanafter --sudoloop --answerclean y --answerdiff n --answeredit n --save

# install a lot of packages
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


# copy all the configs etc
cd $DIR
./install-configs.sh
chown meredrica:meredrica /home/meredrica -R

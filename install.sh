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
pacman -S --needed base-devel git zsh sudo openssh yajl wget --noconfirm

# create meredrica user
useradd -m -G wheel -s /usr/bin/zsh meredrica
echo 'get PASSWORD for meredrica'
passwd meredrica

# enable the wheel group
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

# change to user
su meredrica <<'EOF'
cd ~
# install oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# set git stuff
git config --global user.email "stuff@meredrica.org"
git config --global user.name "meredrica"
git config --global rerere.enabled true
git config --global push.default upstream

# install yay
cd /tmp
git clone https://aur.archlinux.org/yay.git

cd /tmp/yay
makepkg -sri --noconfirm

# set the yay flags
yay --cleanafter --sudoloop --answerclean y --answerdiff n --answeredit n --save

# install a lot of packages
cd $DIR
sh packages.sh
sh node.sh

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
cp -rT ./h/ /home/meredrica
chown meredrica:meredrica /home/meredrica -R

# cleanup
yay -c

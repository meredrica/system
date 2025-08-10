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
pacman -S --needed --noconfirm base-devel git zsh sudo openssh wget reflector yadm go

# update mirrors
reflector --country at,de --fastest 20 --latest 100 --threads 10 --sort rate --protocol https --save /etc/pacman.d/mirrorlist

# create meredrica user
useradd --create-home --groups wheel --shell /usr/bin/zsh meredrica

# podman rootless setup
mkdir /etc/containers
touch /etc/containers/nodocker
touch /etc/subuid /etc/subgid
usermod --add-subuids 100000-165535 --add-subgids 100000-165535 meredrica

echo 'get PASSWORD for meredrica'
passwd meredrica

# enable the wheel group
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
# disable max login attempts
sed -i 's/# deny = 3/deny = 0/' /etc/security/faillock.conf

# change to user
su meredrica <<'EOF'
# save current dir
# KEEP THIS, we need it twice
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $DIR

# install yay
cd /tmp
git clone https://aur.archlinux.org/yay.git

cd /tmp/yay
makepkg -sri --noconfirm

# install a lot of packages via yay
cd $DIR
./packages.sh

# dotfiles setup
yadm clone --bootstrap https://gitea.home.meredrica.org/meredrica/dotfiles.git

# install sdkman
curl -s "https://get.sdkman.io" | bash
source /home/meredrica/.sdkman/bin/sdkman-init.sh

# install java stuff
sdk install java
sdk install gradle
sdk install maven

# update tldr
tldr --update

EOF

# enable a few things we need
systemctl enable lightdm
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups
systemctl enable blueman-mechanism.service
systemctl enable tailscaled

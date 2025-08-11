#!/bin/bash
#
# PREREQUISITES:
# we're arch-chrooted and disks are set up & mounted
# hostname is set
#
# swap is set up:
# mkswap -U clear --file /swapfile --size <RAM>
# swapon /swapfile
#
#
# TODOS:
# mount cifs etc
# read passwords from commandline once
# auto setup cups
# configure dhcp to static
# configure keyboard layout

# save current dir
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# install base things that are necessary
pacman -Suy
pacman -S --needed --noconfirm base-devel git zsh sudo openssh wget reflector yadm go

# swap
echo '/swapfile           	none      	swap      	defaults  	0 0' >> /etc/fstab


# time setup
ln -sf /usr/share/zoneinfo/Europe/Vienna /etc/localtime
hwclock --systohc
echo 'NTP=0.at.pool.ntp.org 1.at.pool.ntp.org 2.at.pool.ntp.org 3.at.pool.ntp.org' >> /etc/systemd/timesyncd.conf
timedatectl set-ntp true

# locale setup
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
#
# initramifs setup to have encrtption and resume
sed -i 's/HOOKS=.*$/HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt filesystems fsck resume)/' /etc/mkinitcpio.conf
mkinitcpio -P

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

# setup goimapnotify
for file in ~/.config/mail ; do systemctl enable goimapnotify@$file --user; done

# sync all email
mbsync -a

EOF

# enable a few things we need
systemctl enable lightdm
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups
systemctl enable blueman-mechanism.service
systemctl enable tailscaled

# install grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

echo "*********** MANUAL GRUB SETUP **************"
echo "cryptdevice=UUID"
blkid | grep crypto_LUKS
echo "resume=UUID"
blkid | grep ext4

echo "resume_offset = physical_offset value"
filefrag -v /swapfile | head -4
# find physical offset:
echo edit /etc/default/grub to be simmilar to this:
echo 'GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet cryptdevice=UUID=e3ac2019-6688-4c75-9978-171460165f76:cryptroot root=/dev/mapper/cryptroot resume=UUID=f53d0881-a52b-4d64-8f57-d19db8b261d6 resume_offset=4161536"'
echo 'then run grub-mkconfig -o /boot/grub/grub.cfg'

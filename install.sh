#!/bin/bash
#
# PREREQUISITES:
# we're arch-chrooted and disks are set up & mounted
#
# TODOS:
# mount cifs etc
# read passwords from commandline once
# configure keyboard layout

# get variables for set up
read -p 'hostname to set: ' hostname
echo $hostname > /etc/hostname

swap_size=`free | sed -n '2,2p' | cut -d ':' -f 2 | sed  's/ */ /' | cut -d ' ' -f 2`
read -p "swap size ($swap_size): " userswap
swap_size = ${userswap:-$swap_size}

# save current dir
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# install base things that are necessary
pacman -Suy
pacman -S --needed --noconfirm base-devel git zsh sudo openssh wget reflector yadm go

# swap setup
swap_size=free | sed -n '2,2p' | cut -d ':' -f 2 | sed  's/ */ /' | cut -d ' ' -f 2
mkswap -U clear --file /swapfile --size $swap_size
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

# initramifs setup to have encrtption and resume
sed -i 's/HOOKS=.*$/HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt filesystems fsck resume)/' /etc/mkinitcpio.conf
mkinitcpio -P

# update mirrors
reflector --country at,de --fastest 20 --latest 100 --threads 10 --sort rate --protocol https --save /etc/pacman.d/mirrorlist

# create user
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

# update tldr
tldr --update

# enable podman
systemctl --user enable podman.socket

EOF

# enable a few things we need
systemctl enable lightdm
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups
systemctl enable blueman-mechanism.service
systemctl enable tailscaled

# GRUB setup
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
cryptdevice=`blkid | grep crypto_LUKS | cut -d ' ' -f 2 | sed 's/"//g'`
resume=`blkid | grep ext4 | cut -d ' ' -f 2 | sed 's/"//g'`
resume_offset=`filefrag /swapfile -v | sed -n '4,0p' | cut -d ':' -f 3 | cut -d '.' -f 1 | sed 's/ //g'`

sed -i 's/GRUB_DEFAULT=.*$/GRUB_DEFAULT=0' /etc/default/grub
sed -i 's/GRUB_TIMEOUT=.*$/GRUB_TIMEOUT=1' /etc/default/grub
# set up variables to replace because my shell escape foo isn't good enough
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=.*$/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet cryptdevice=_cryptdevice:cryptroot root=\/dev\/mapper\/cryptroot resume=_resume resume_offset=_resume_offset/"' /etc/default/grub
sed -i "s/_cryptdevice/$cryptdevice/" /etc/default/grub
sed -i "s/_resume/$resume/" /etc/default/grub
sed -i "s/_resume_offset/$resume_offset/" /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

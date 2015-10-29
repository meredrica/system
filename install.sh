#!/bin/bash
# save current dir
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# set ntp server
echo 'NTP=0.at.pool.ntp.org 1.at.pool.ntp.org 2.at.pool.ntp.org 3.at.pool.ntp.org' >> /etc/systemd/timesyncd.conf
timedatectl set-ntp true

# create meredrica user
useradd -m -G wheel -s /usr/bin/zsh meredrica
echo 'get PASSWORD for meredrica?'
passwd meredrica

# install base-devel and git
pacman -S needed base-devel git --noconfirm

# install yaourt
cd /tmp
git clone https://aur.archlinux.org/package-query.git
git clone https://aur.archlinux.org/yaourt.git

cd /tmp/package-query
makepkg -sri --noconfirm

cd /tmp/yaourt
makepkg -sri --noconfirm

# install a lot of packages
yaourt --noconfirm -S \
	arandr \
	awesome \
	google-chrome \
	jdk8-openjdk \
	lightdm \
	lightdm-gtk-greeter \
	lilyterm \
	openssh \
	pavucontrol \
	pulseaudio \
	qpdfview \
	sudo \
	sxiv \
	thunderbird \
	ttf-droid \
	vim \
	xorg-server \
	zsh \

# enable a few things we need
systemctl enable lightdm

# some links that make me more sane
ln -s $(which google-chrome-stable) /usr/bin/chrome
ln -s /etc/fonts/conf.avail/60-ttf-droid-sans-mono-fontconfig.conf /etc/fonts/conf.d/
ln -s /etc/fonts/conf.avail/65-ttf-droid-kufi-fontconfig.conf /etc/fonts/conf.d/
ln -s /etc/fonts/conf.avail/65-ttf-droid-sans-fontconfig.conf /etc/fonts/conf.d/
ln -s /etc/fonts/conf.avail/65-ttf-droid-serif-fontconfig.conf /etc/fonts/conf.d/

# change to user
su meredrica <<'EOF'
cd ~
# install oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# set git stuff
git config --global user.email "stuff@meredrica.org"
git config --global user.name "meredrica"
git config --global rerere.enabled true
git config --global push.default simple

# download ssh ids, will require password, which is intended
scp -r meredrica.org:~/.ssh ~/.ssh
EOF

# copy all the configs etc
cd $DIR
cp -rT ./h/ /home/meredrica
chown meredrica:meredrica /home/meredrica -R

# clean up stuff
yaourt -Qdtq | yaourt -Rs --noconfirm -

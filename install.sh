#!/bin/bash
# save current dir
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# create meredrica user
useradd -m -G wheel -s /usr/bin/zsh meredrica
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

# some links that make me more sane
ln -s $(which google-chrome-stable) /usr/bin/chrome

# change to user
su meredrica
cd ~
# install oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# set git stuff
git config --global user.email "stuff@meredrica.org"
git config --global user.name "meredrica"
git config --global rerere.enabled true
git config --global push.default simple

# download ssh ids
scp -r meredrica.org:~/.ssh ~/.ssh

exit

# copy all the configs etc
cd $DIR
cp -rT ./h/ /home/meredrica
chown meredrica:meredrica /home/meredrica -R

# clean up stuff
yaourt -Qdtq | yaourt -Rs --noconfirm -

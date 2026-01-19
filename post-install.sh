#!/bin/zsh
# this script is to be run as the user with a GUI since yadm asks for a password via GUI
# enable swap
sudo swapon /swapfile

# dotfiles setup
yadm clone --bootstrap https://gitea.home.meredrica.org/meredrica/dotfiles.git

# install sdkman
curl -s "https://get.sdkman.io" | bash
source /home/meredrica/.sdkman/bin/sdkman-init.sh

# install java stuff
sdk install java
sdk install gradle

# setup goimapnotify
cd ~/.config/mail
for file in *@* ; do systemctl enable goimapnotify@$file --user ; mkdir -p /home/meredrica/mail/$file ; done

# sync all email
mbsync -a

# enable backup timer
systemctl enable backup.timer --user

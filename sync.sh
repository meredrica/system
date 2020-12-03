#!/bin/bash
cp -v /home/meredrica/.zshrc ./h/
cp -v /home/meredrica/.vimrc ./h/
cp -v /home/meredrica/.config/awesome/rc.lua ./h/.config/awesome/rc.lua
cp -v /home/meredrica/.config/kitty/kitty.conf ./h/.config/kitty/kitty.conf
cp -v /home/meredrica/.oh-my-zsh/themes/meredrica.zsh-theme ./h/.oh-my-zsh/themes/meredrica.zsh-theme
cp -v /home/meredrica/.xprofile ./h/
cp -v /home/meredrica/.gitconfig ./h/

git add -p && git commit && git push

#!/bin/bash
cp -v /home/meredrica/.zshrc ./h/
cp -v /home/meredrica/.vimrc ./h/
cp -v /home/meredrica/.config/awesome/rc.lua ./h/.config/awesome/rc.lua
cp -v /home/meredrica/.config/lilyterm/default.conf ./h/.config/lilyterm/default.conf
cp -v /home/meredrica/.oh-my-zsh/themes/meredrica.zsh-theme ./h/.oh-my-zsh/themes/meredrica.zsh-theme

git add .
git commit

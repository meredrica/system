#!/bin/bash
cp -v /home/meredrica/.zshrc ./h/
cp -v /home/meredrica/.vimrc ./h/
cp -v /home/meredrica/.config/nvim/init.vim ./h/.config/nvim/init.vim
cp -v /home/meredrica/.config/nvim/coc-settings.json ./h/.config/nvim/coc-settings.json
cp -v /home/meredrica/.config/nvim/format.xml ./h/.config/nvim/format.xml
cp -v /home/meredrica/.config/awesome/rc.lua ./h/.config/awesome/rc.lua
cp -v /home/meredrica/.config/alacritty/* ./h/.config/alacritty/
cp -v /home/meredrica/.config/htop/* ./h/.config/htop/
cp -v /home/meredrica/.oh-my-zsh/themes/meredrica.zsh-theme ./h/.oh-my-zsh/themes/meredrica.zsh-theme
cp -v /home/meredrica/.xprofile ./h/
cp -v /home/meredrica/.gitconfig ./h/

git add -p && git commit && git push

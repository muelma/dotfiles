#/usr/bin/env bash
# install yay
sudo pacman --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
# install packages from former list
yay -S --needed $HOME/dotfiles/packages.list
# install tmux tpm
git clone https://github.com/tmux-plugins/tpm $HOME/.config/tmux/plugins/tpm

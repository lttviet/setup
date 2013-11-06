#!/bin/sh
# Simple setup.sh for configuring Ubuntu instance for headless setup

# Install Heroku toolbelt
# https://toolbelt.heroku.com/debian
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# Install apt-fast
sudo add-apt-repository ppa:apt-fast/stable
sudo apt-get update
sudo apt-get install -y apt-fast

sudo apt-get install git tmux

# git pull and install dotfiles
cd $HOME
if [ -d ./dotfiles/ ]; then
    mv dotfiles dotfiles.old
fi
if [ -d .vimrc ]; then
    mv .vimrc .vimrc.old
fi
git clone https://github.com/lttviet/dotfiles.git
ln -sb dotfiles/.tmux.conf .
ln -sb dotfiles/.vimrc .
ln -sb dotfiles/.bashrc .
source .bashrc

# Install vim
sudo apt-fast install vim
# Install vundle for managing plugins
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
vim +BundleInstall +qall

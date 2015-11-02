#!/bin/sh
# setup.sh for configuring Ubuntu home pc

# Alias
alias purge="sudo apt-get purge -y"
alias instal="sudo apt-get install -y"
alias update="sudo apt-get update"
alias upgrade="sudo apt-get upgrade"

# Remove unnecessary softwares
purge friends* empathy totem
purge unity-scope-musicstores unity-scope-openclipart unity-scope-yelp
purge unity-scope-colourlovers
purge evolution-data-server rhythmbox*

# Install Heroku toolbelt
# https://toolbelt.heroku.com/debian
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# Add PPA repos
sudo add-apt-repository -y ppa:linrunner/tlp
sudo add-apt-repository -y ppa:webupd8team/sublime-text-3
sudo add-apt-repository -y ppa:maarten-baert/simplescreenrecorder
sudo add-apt-repository -y ppa:neovim-ppa/unstable

update

instal -y ubuntu-restricted-extras openjdk-8-jdk clang yasm devscripts
instal -y htop iotop mpv python-pip synaptic xclip build-essential python-dev
instal -y redshift-gtk zram-config tlp nautilus-dropbox sublime-text-installer
instal -y neovim iojs simplescreenrecorder python3-dev python3-pip curl
instal -y rbenv cmake ruby-dev libtool-bin autoconf libzmq3 libzmq3-dev
#instal -y texlive texlive-xetex

# neovim plugins
sudo pip install neovim
#sudo pip3 install neovim

# patched fonts for vim-airline
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
mkdir -p .fonts
mv PowerlineSymbols.otf ~/.fonts/
fc-cache -vf ~/.fonts/
mkdir -p .congig/fontconfig/conf.d
mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

# vim-plug
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# compile YouCompleteMe
~/.config/nvim/plugged/YouCompleteMe/install.sh --clang-completer

sudo tlp start

# fix dropbox
echo fs.inotify.max_user_watches=100000 | sudo tee -a /etc/sysctl.conf; sudo sysctl -p

# Install virtual env wrapper for Python
sudo pip install virtualenvwrapper

# git pull and install dotfiles
cd $HOME
if [ -d ./dotfiles/ ]; then
    mv dotfiles dotfiles.old
fi
if [ -d .nvimrc ]; then
    mv .nvimrc .nvimrc.old
fi
git clone https://github.com/lttviet/dotfiles.git
ln -sb ~/dotfiles/.nvimrc .config/nvim/init.vim
ln -sb dotfiles/.bashrc .
ln -sb dotfiles/redshift.conf .config
ln -sb dotfiles/.gitconfig .
ln -sb dotfiles/.gitignore_global .

source .bashrc

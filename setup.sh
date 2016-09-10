#!/bin/sh
# setup.sh for configuring Ubuntu home pc

# Alias
alias purge="sudo apt purge -y"
alias instal="sudo apt install -y"
alias update="sudo apt update"
alias upgrade="sudo apt upgrade"

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

# Add Syncthing
curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
echo "deb http://apt.syncthing.net/ syncthing release" | sudo tee /etc/apt/sources.list.d/syncthing.list

update

instal ubuntu-restricted-extras openjdk-8-jdk clang yasm devscripts apt-transport-https ca-certificates
instal htop iotop iftop nethogs mpv python-pip synaptic xclip build-essential python-dev
instal redshift-gtk zram-config tlp sublime-text-installer virtualenvwrapper
instal neovim simplescreenrecorder python3-dev python3-pip curl neovim docker-engine
instal rbenv cmake ruby-dev libtool-bin autoconf libzmq3 libzmq3-dev syncthing

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

sudo tlp start

# git pull and install dotfiles
cd $HOME
if [ -d ~/dotfiles/ ]; then
    mv ~/dotfiles ~/dotfiles.old
fi
if [ -d ./.config/nvim/init.vim ]; then
    mv ./.config/nvim/init.vim ./.config/nvim/init.vim.old
fi

git clone https://github.com/lttviet/dotfiles.git
ln -sb ~/dotfiles/init.vim .config/nvim/init.vim
ln -sb ~/dotfiles/.bashrc .
ln -sb ~/dotfiles/redshift.conf .config
ln -sb ~/dotfiles/.gitconfig .
ln -sb ~/dotfiles/.gitignore_global .

# syncthing systemd
mkdir -p ~/.config/systemd/user
cp ~/dotfiles/syncthing* ~/.config/systemd/user/
systemctl --user enable syncthing.service
systemctl --user start syncthing.service
systemctl --user enable syncthing-inotify.service
systemctl --user start syncthing-inotify.service

source .bashrc

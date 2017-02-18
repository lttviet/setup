#!/bin/sh
# setup.sh for configuring Ubuntu home pc

# Alias
alias purge="sudo apt purge -y"
alias instal="sudo apt install -y"
alias update="sudo apt update"
alias upgrade="sudo apt upgrade"

# Remove unnecessary softwares
purge totem unity-scope-openclipart unity-scope-yelp unity-scope-colourlovers
purge evolution-data-server rhythmbox* unity-scope-zotero

# Install Heroku toolbelt
# https://toolbelt.heroku.com/debian
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# Add PPA repos
sudo add-apt-repository -y ppa:linrunner/tlp
sudo add-apt-repository -y ppa:webupd8team/sublime-text-3
sudo add-apt-repository -y ppa:neovim-ppa/unstable

# Add Syncthing
curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
echo "deb http://apt.syncthing.net/ syncthing release" | sudo tee /etc/apt/sources.list.d/syncthing.list
echo "fs.inotify.max_user_watches=204800" | sudo tee -a /etc/sysctl.conf

update

instal ubuntu-restricted-extras openjdk-8-jdk clang yasm devscripts apt-transport-https ca-certificates
instal htop iotop iftop nethogs mpv python-pip synaptic xclip build-essential python-dev
instal redshift-gtk zram-config tlp sublime-text-installer virtualenvwrapper
instal neovim python3-dev python3-pip curl neovim docker.io docker-compose
instal rbenv cmake ruby-dev libtool-bin autoconf libzmq3-dev syncthing keepassx
install libssl-dev libreadline-dev zlib1g-dev

# patched fonts for vim-airline
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
mkdir -p ~/.fonts
mv PowerlineSymbols.otf ~/.fonts/
fc-cache -vf ~/.fonts/
mkdir -p ~/.config/fontconfig/conf.d
mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

# vim-plug
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# neovim python plugins
pip install --upgrade neovim
pip3 install --upgrade neovim

# symlinks dotfiles
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
ln -sb ~/dotfiles/.tmux.conf .

# syncthing systemd
mkdir -p ~/.config/systemd/user
cp ~/dotfiles/syncthing* ~/.config/systemd/user/
systemctl --user enable syncthing.service
systemctl --user start syncthing.service
systemctl --user enable syncthing-inotify.service
systemctl --user start syncthing-inotify.service

# rbenv install plugins
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

sudo tlp start

source .bashrc

#!/bin/sh
# setup.sh for configuring Ubuntu home pc

# Alias
alias purge="sudo apt purge -y"
alias instal="sudo apt install -y"
alias update="sudo apt update"
alias upgrade="sudo apt upgrade"

# Remove unnecessary softwares
purge totem unity-scope-openclipart unity-scope-yelp unity-scope-colourlovers
purge rhythmbox* unity-scope-zotero unity-scope-tomboy unity-scope-gdrive
purge thunderbird

# Add PPA repos
sudo add-apt-repository -y ppa:webupd8team/sublime-text-3

# Add Syncthing
curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
echo "deb http://apt.syncthing.net/ syncthing release" | sudo tee /etc/apt/sources.list.d/syncthing.list
echo "fs.inotify.max_user_watches=204800" | sudo tee -a /etc/sysctl.conf

update

instal ubuntu-restricted-extras openjdk-8-jdk clang yasm devscripts git
instal neovim nethogs mpv python-pip synaptic xclip build-essential
instal redshift-gtk sublime-text-installer htop iotop
instal python3-dev python3-pip neovim syncthing syncthing-inotify
instal cmake ruby-dev libtool-bin autoconf libzmq3-dev
instal libssl-dev libreadline-dev zlib1g-dev

sudo snap install keepassxc

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

# systemd
mkdir -p ~/.config/systemd/user
cp ~/dotfiles/syncthing* ~/.config/systemd/user/
systemctl --user enable syncthing.service
systemctl --user start syncthing.service
systemctl --user enable syncthing-inotify.service
systemctl --user start syncthing-inotify.service

sudo sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf
cp ~/dotfiles/rclone-mount.service ~/.config/systemd/user/
systemctl --user enable rclone-mount.service
systemctl --user start rclone-mount.service

# rbenv install plugins
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
cd ~/.rbenv && src/configure && make -C src

#pyenv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

sudo sed -i 's/quiet splash//' /etc/default/grub
sudo sed -i 's/#GRUB_TERMINAL/GRUB_TERMINAL/' /etc/default/grub
sudo update-grub

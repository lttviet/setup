#!/bin/sh
# setup.sh for configuring Ubuntu home pc

# Alias
alias purge="sudo apt purge -y"
alias instal="sudo apt install -y"
alias update="sudo apt update"
alias upgrade="sudo apt upgrade"

instal apt-transport-https

# select best repo
#https://askubuntu.com/questions/39922/how-do-you-select-the-fastest-mirror-from-the-command-line
#curl -s http://mirrors.ubuntu.com/mirrors.txt | xargs -n1 -I {} sh -c 'echo `curl -r 0-102400 -s -w %{speed_download} -o /dev/null {}/ls-lR.gz` {}' |sort -g -r |head -1| awk '{ print $2  }'

# sublime text 3 repo
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

update

instal ubuntu-restricted-extras openjdk-8-jdk clang yasm devscripts git
instal neovim nethogs mpv python-pip synaptic xclip build-essential
instal redshift-gtk sublime-text-installer htop iotop linux-image-extra-virtual
instal python3-dev python3-pip neovim cmake ruby-dev libtool-bin autoconf
instal libssl-dev libreadline-dev zlib1g-dev tmux libzmq3-dev keepassxc

# texlive
#instal texlive-fonts-extra texlive-xetex

# patched fonts for vim-airline
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
mkdir -p ~/.fonts
mv PowerlineSymbols.otf ~/.fonts/
fc-cache -vf ~/.fonts/
mkdir -p ~/.config/fontconfig/conf.d
mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

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
#mkdir -p ~/.config/systemd/user
#sudo sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf
#cp ~/dotfiles/rclone-mount.service ~/.config/systemd/user/
#systemctl --user enable rclone-mount.service
#systemctl --user start rclone-mount.service

# rbenv install plugins
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
cd ~/.rbenv && src/configure && make -C src

# pyenv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# grub
sudo sed -i 's/quiet splash//' /etc/default/grub
sudo sed -i 's/#GRUB_TERMINAL/GRUB_TERMINAL/' /etc/default/grub
sudo update-grub

# docker
#sudo usermod -aG docker $(whoami)

#!/usr/bash

CURRENT_USER=$(whoami)

echo "Installing base components"
curl -s https://raw.githubusercontent.com/fullbright/historycrawler/master/install_base_tools.sh | sudo sh /dev/stdin $CURRENT_USER

echo "Pulling configuration from git repo"
cd ~
sudo -u $CURRENT_USER git init
sudo -u $CURRENT_USER git remote add origin https://github.com/fullbright/xfce-laptop-config.git
sudo -u $CURRENT_USER git fetch --all
sudo -u $CURRENT_USER git reset --hard origin/master
#sudo -u $CURRENT_USER git clone https://github.com/fullbright/xfce-laptop-config.git  ~/ --depth 1

echo "Installating custom applications"
# Albert, Filezilla, vlc, audacity, Inkscape
apt-get install albert vlc browser-plugin-vlc filezilla audacity inkscape -y

# Google chrome, docker, Sublime text
sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
apt-get update
apt-get install google-chrome-stable -y

# Docker

apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update

apt-get install docker-ce -y

groupadd docker
usermod -aG docker $USER
systemctl enable docker

# Sublime text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
apt-get update
apt-get install sublime-text -y

# Arc theme
sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' >> /etc/apt/sources.list.d/arc-theme.list"
wget http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_16.04/Release.key
sudo apt-key add - < Release.key
apt-get update
apt-get install arc-theme
rm Release.key




echo "Installation finished"

#!/usr/bash

CURRENT_USER=$(whoami)

echo "Current user is $CURRENT_USER"

echo "=== Installing base components"
curl -s https://raw.githubusercontent.com/fullbright/historycrawler/master/install_base_tools.sh | sudo sh /dev/stdin $CURRENT_USER

echo "=== Pulling configuration from git repo"
cd ~
sudo -u $CURRENT_USER git init
sudo -u $CURRENT_USER git remote add origin https://github.com/fullbright/xfce-laptop-config.git
sudo -u $CURRENT_USER git fetch --all
sudo -u $CURRENT_USER git reset --hard origin/master
#sudo -u $CURRENT_USER git clone https://github.com/fullbright/xfce-laptop-config.git  ~/ --depth 1

echo "=== Installating custom applications: Filezilla, vlc, audacity, Inkscape"
# Filezilla, vlc, audacity, Inkscape
sudo apt-get install vlc browser-plugin-vlc filezilla audacity inkscape -y

# Google chrome
echo "=== Installing Google Chrome"
sudo sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo apt-get update
sudo apt-get install google-chrome-stable -y

# Docker
echo "=== Installing docker"
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update

sudo apt-get install docker-ce -y

sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker

# Install docker-compose
# Compose releases available here : https://github.com/docker/compose/releases
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Grive2 for Google Drive sync
sudo apt-get install git cmake build-essential libgcrypt11-dev libyajl-dev \
    libboost-all-dev libcurl4-openssl-dev libexpat1-dev libcppunit-dev binutils-dev \
    debhelper zlib1g-dev dpkg-dev pkg-config -y
sudo -u $CURRENT_USER git clone https://github.com/vitalif/grive2
cd grive2
mkdir build
cd build
sudo -u $CURRENT_USER cmake ..
sudo -u $CURRENT_USER make -j4
sudo make install

# Sublime text
echo "=== Installing Sublime text"
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text -y

# Arc theme
echo "=== Installing arc theme"
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' >> /etc/apt/sources.list.d/arc-theme.list"
wget http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_16.04/Release.key
sudo apt-key add - < Release.key
sudo apt-get update
sudo apt-get install arc-theme -y
rm Release.key

# Albert
echo "=== Installing albert"
#wget -nv -O Albert_Release.key https://build.opensuse.org/projects/home:manuelschneid3r/public_key 
#sudo apt-key add - < Albert_Release.key
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_18.04/ /' > /etc/apt/sources.list.d/home:manuelschneid3r.list"
sudo apt-get update
sudo apt-get install albert -y

echo "Installation finished"

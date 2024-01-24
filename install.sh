#!/bin/bash

# Actualiza el sistema
apt --assume-yes update && apt --assume-yes upgrade

# Instala los paquetes necesarios
sudo add-apt-repository multiverse
sudo dpkg --add-architecture i386;
sudo apt update
sudo apt install --assume-yes curl
sudo apt install --assume-yes wget
sudo apt install --assume-yes file
sudo apt install --assume-yes tar
sudo apt install --assume-yes bzip2
sudo apt install --assume-yes gzip
sudo apt install --assume-yes unzip
sudo apt install --assume-yes bsdmainutils
sudo apt install --assume-yes python3
sudo apt install --assume-yes util-linux
sudo apt install --assume-yes ca-certificates
sudo apt install --assume-yes binutils
sudo apt install --assume-yes bc
sudo apt install --assume-yes jq
sudo apt install --assume-yes tmux
sudo apt install --assume-yes netcat
sudo apt install --assume-yes lib32gcc-s1
sudo apt install --assume-yes lib32stdc++6
sudo apt install --assume-yes libsdl2-2.0-0:i386
sudo apt install --assume-yes steamcmd
sudo apt install --assume-yes libtinfo5:i386
sudo apt install --assume-yes openjdk-17-jre
sudo apt install --assume-yes openjdk-16-jre
sudo apt install --assume-yes openjdk-11-jre
sudo apt install --assume-yes lib32z1
sudo apt install --assume-yes libcurl4-gnutls-dev:i386
sudo apt install  libmariadb3
sudo apt-get install --assume-yes build-essential cmake git libjson-c-dev libwebsockets-dev

# Clona el repositorio ttyd y compila e instala
git clone https://github.com/tsl0922/ttyd.git
cd ttyd && mkdir build && cd build
cmake ..
make && sudo make install

# Añade un nuevo usuario
adduser "$1"

# Cambia al nuevo usuario y ejecuta comandos dentro de su sesión
su - "$1" << EOF

# Descarga e instala LinuxGSM
wget -O linuxgsm.sh https://linuxgsm.sh && chmod +x linuxgsm.sh && bash linuxgsm.sh "$1"
wget https://raw.githubusercontent.com/ALFREDYTX/Cloudvgs/main/install1.sh
wget https://raw.githubusercontent.com/ALFREDYTX/Cloudvgs/main/start_console.sh
chmod +x install1.sh

#!/bin/bash

# Actualiza el sistema
apt update && apt upgrade

# Instala los paquetes necesarios
sudo add-apt-repository multiverse
sudo dpkg --add-architecture i386;
sudo apt update
sudo apt install curl
sudo apt install wget
sudo apt install file
sudo apt install tar
sudo apt install bzip2
sudo apt install gzip
sudo apt install unzip
sudo apt install bsdmainutils
sudo apt install python3
sudo apt install util-linux
sudo apt install ca-certificates
sudo apt install binutils
sudo apt install bc
sudo apt install jq
sudo apt install tmux
sudo apt install netcat
sudo apt install lib32gcc-s1
sudo apt install lib32stdc++6
sudo apt install libsdl2-2.0-0:i386
sudo apt install steamcmd
sudo apt install libtinfo5:i386
sudo apt install openjdk-17-jre
sudo apt install openjdk-16-jre
sudo apt install openjdk-11-jre
sudo apt install lib32z1
sudo apt install libcurl4-gnutls-dev:i386
sudo apt install libmariadb3
sudo apt-get install -y build-essential cmake git libjson-c-dev libwebsockets-dev

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
./install1.sh "$1"

#!/bin/bash

# Actualiza el sistema
apt update && apt -y upgrade

# Instala los paquetes necesarios
sudo add-apt-repository multiverse
sudo dpkg --add-architecture i386;
sudo apt update
sudo apt install -y curl
sudo apt install -y wget
sudo apt install -y file
sudo apt install -y tar
sudo apt install -y bzip2
sudo apt install -y gzip
sudo apt install -y unzip
sudo apt install -y bsdmainutils
sudo apt install -y python3
sudo apt install -y util-linux
sudo apt install -y ca-certificates
sudo apt install -y binutils
sudo apt install -y bc
sudo apt install -y jq
sudo apt install -y tmux
sudo apt install -y netcat
sudo apt install -y lib32gcc-s1
sudo apt install -y lib32stdc++6
sudo apt install -y libsdl2-2.0-0:i386
sudo apt install -y steamcmd
sudo apt install -y libtinfo5:i386
sudo apt install -y openjdk-17-jre
sudo apt install -y openjdk-16-jre
sudo apt install -y openjdk-11-jre
sudo apt install -y lib32z1
sudo apt install -y libcurl4-gnutls-dev:i386
sudo apt install -y libmariadb3
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

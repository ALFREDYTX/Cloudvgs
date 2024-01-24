#!/bin/bash

# Actualiza el sistema
apt update && apt upgrade

# Instala los paquetes necesarios
sudo apt install curl wget file tar bzip2 gzip unzip bsdmainutils python3 util-linux ca-certificates binutils bc jq tmux netcat lib32gcc-s1 lib32stdc++6 libsdl2-2.0-0:i386 steamcmd libtinfo5:i386 openjdk-17-jre lib32z1 libcurl4-gnutls-dev:i386 libmariadb3

# Añade un nuevo usuario
adduser "$1"

# Cambia al nuevo usuario
su - "$1"

# Descarga e instala LinuxGSM
wget -O linuxgsm.sh https://linuxgsm.sh && chmod +x linuxgsm.sh && bash linuxgsm.sh "$1"
./"$1" install

# Cambia de nuevo al usuario anterior
su -

# Instala paquetes adicionales
sudo apt-get install -y build-essential cmake git libjson-c-dev libwebsockets-dev

# Clona el repositorio ttyd y compila e instala
git clone https://github.com/tsl0922/ttyd.git
cd ttyd && mkdir build && cd build
cmake ..
make && sudo make install

# Cambia al nuevo usuario
su - "$1"

# Descarga el script start_console.sh
wget https://raw.githubusercontent.com/ALFREDYTX/Cloudvgs/main/start_console.sh

# Ejecuta ttyd con el script start_console.sh
ttyd -W bash -e ./start_console.sh "$1"

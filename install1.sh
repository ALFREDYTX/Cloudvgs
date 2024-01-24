./"$1" install

# Cambia al usuario root
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

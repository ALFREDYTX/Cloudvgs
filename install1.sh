# inicializa install de linuxgsm
./"$1" install

# Descarga el script start_console.sh
wget https://raw.githubusercontent.com/ALFREDYTX/Cloudvgs/main/start_console.sh

# Ejecuta ttyd con el script start_console.sh
ttyd -W bash -e ./start_console.sh "$1"

# inicializa install de linuxgsm
./"$USER" install

# Descarga el script start_console.sh
wget https://raw.githubusercontent.com/ALFREDYTX/Cloudvgs/main/start_console.sh
wget https://raw.githubusercontent.com/ALFREDYTX/Cloudvgs/main/start_ttyd.sh
chmod +x start.ttyd.sh

# Cambia al directorio lgsm/modules
cd lgsm/modules || exit 1

# Elimina el script existente
rm command_console.sh || exit 1

# Descarga el script desde GitHub
wget https://raw.githubusercontent.com/ALFREDYTX/Cloudvgs/main/command_console.sh || exit 1

# Asigna permisos de ejecuci  n al script
chmod +x command_console.sh || exit 1

# Cambia al directorio home
cd || exit 1

# Ejecuta ttyd con el script start_console.sh
./start.ttyd.sh

#!/bin/bash

# Función para manejar errores y registrarlos en un archivo de registro
handle_error() {
    local error_message="$1"
    echo "Error: $error_message" >> error.log
    exit 1
}

# Verificar privilegios de superusuario
if [ "$EUID" -ne 0 ]; then
    handle_error "Este script debe ejecutarse con privilegios de superusuario (sudo)."
fi

# Actualizar e instalar dependencias
apt --assume-yes update && apt --assume-yes upgrade || handle_error "Fallo al actualizar e instalar dependencias"
apt install --assume-yes screen || handle_error "Fallo al instalar screen"
apt install --assume-yes ttyd || handle_error "Fallo al instalar ttyd"
apt install --assume-yes software-properties-common
sudo add-apt-repository multiverse; sudo dpkg --add-architecture i386; sudo apt update
sudo apt install --assume-yes steamcmd || handle_error "Fallo al instalar steamcmd"
apt install --assume-yes jq || handle_error "Fallo al instalar jq"
apt install --assume-yes curl || handle_error "Fallo al instalar curl"
curl -s https://raw.githubusercontent.com/ALFREDYTX/Cloudvgs/main/stop.sh --output /stop.sh || handle_error "Fallo al descargar stop.sh"
curl -s https://raw.githubusercontent.com/ALFREDYTX/Cloudvgs/main/start.sh --output /start.sh || handle_error "Fallo al descargar start.sh"

# Establecer permisos
chmod +x /stop.sh || handle_error "Fallo al establecer permisos para stop.sh"
chmod +x /start.sh || handle_error "Fallo al establecer permisos para start.sh"

# Solicitar el nombre del usuario
read -p "Ingrese el nombre del usuario: " username

# Solicitar el mapa
read -p "Ingrese el mapa de ark survival envolved: " mapa

# Agregar usuario interactivo
sudo useradd $username || handle_error "Fallo al agregar usuario $username"

# Crear el directorio raíz del usuario
sudo mkdir /home/$username || handle_error "Fallo al crear directorio /home/$username"

# Establecer el propietario y el grupo del directorio
sudo chown $username:$username /home/$username || handle_error "Fallo al establecer propietario y grupo para /home/$username"

# Establecer la contraseña de manera no interactiva
echo "$username:123456" | sudo chpasswd || handle_error "Fallo al establecer contraseña para usuario $username"

# Establecer el directorio de inicio de usuario
STOP_SCRIPT="/stop.sh"
START_SCRIPT="/start.sh"

# Verificar si los archivos existen
if [ ! -f "$STOP_SCRIPT" ] || [ ! -f "$START_SCRIPT" ]; then
    handle_error "Los archivos stop.sh o start.sh no existen en las rutas proporcionadas."
fi

# Reemplazar "name-server" con el valor de $username y "user" con el valor de $username en stop.sh
sed -i "s/name-server/$username/g" "$STOP_SCRIPT" || handle_error "Fallo al modificar stop.sh"
sed -i "s/user/$username/g" "$STOP_SCRIPT" || handle_error "Fallo al modificar stop.sh"

# Reemplazar "name-server" con el valor de $username, "command-start" con el valor de "java -Xms512M -Xmx${ram} -jar server.jar nogui" y "user" con el valor de $username en start.sh
sed -i "s/name-server/$username/g" "$START_SCRIPT" || handle_error "Fallo al modificar start.sh name-server"
sed -i "s/user/$username/g" "$START_SCRIPT" || handle_error "Fallo al modificar start.sh user"
# Definir la variable
script="./ShooterGame/Binaries/Linux/ShooterGameServer $mapa?SessionName=$username?Port=7777?QueryPort=7778"

# Usar la variable en el comando sed
sed -i "s/command-start/$(printf '%s\n' "$script" | sed -e 's/[\/&]/\\&/g')/g" "$START_SCRIPT" || handle_error "Fallo al modificar start.sh start script"

echo "Los archivos stop.sh y start.sh han sido modificados exitosamente."

# Actualizar e instalar dependencias
steamcmd +force_install_dir /home/$username +login anonymous +app_update 376030 +quit || handle_error "Fallo al actualizar e instalar dependencias de SteamCMD"
# Crear el archivo de servicio
SERVICE_FILE="/etc/systemd/system/ttyd.service"

# Verifica si el usuario actual tiene permisos de escritura en el directorio
if [ ! -w "$(dirname "$SERVICE_FILE")" ]; then
    handle_error "No tienes permisos para escribir en $(dirname "$SERVICE_FILE")"
fi

# Verifica si el archivo de servicio ya existe
if [ ! -e "$SERVICE_FILE" ]; then
    # Crea el archivo de servicio si no existe
    echo "[Unit]" > "$SERVICE_FILE"
    echo "Description=$username Server" >> "$SERVICE_FILE"
    echo "" >> "$SERVICE_FILE"
    echo "[Service]" >> "$SERVICE_FILE"
    echo "Type=simple" >> "$SERVICE_FILE"
    echo "User=$username" >> "$SERVICE_FILE"
    echo "WorkingDirectory=/home/$username" >> "$SERVICE_FILE"
    echo "ExecStart=/usr/bin/ttyd -W -p 8080 /usr/bin/screen -x $username" >> "$SERVICE_FILE"
    echo "Restart=always" >> "$SERVICE_FILE"
    echo "" >> "$SERVICE_FILE"
    echo "[Install]" >> "$SERVICE_FILE"
    echo "WantedBy=multi-user.target" >> "$SERVICE_FILE"
    echo "Archivo $SERVICE_FILE creado exitosamente."
else
    echo "El archivo $SERVICE_FILE ya existe. No es necesario crear uno nuevo."
fi

# Reinicia el servicio
sudo systemctl daemon-reload || handle_error "Fallo al recargar el demonio del sistema"
sudo systemctl restart ttyd || handle_error "Fallo al reiniciar el servicio ttyd"

su - $username || handle_error "Fallo al cambiar al usuario $username"

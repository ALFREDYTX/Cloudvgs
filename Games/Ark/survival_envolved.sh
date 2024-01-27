#!/bin/bash

# Verificar privilegios de superusuario
if [ "$EUID" -ne 0 ]; then
    echo "Este script debe ejecutarse con privilegios de superusuario (sudo)."
    exit 1
fi

# Actualizar e instalar dependencias
apt --assume-yes update && apt --assume-yes upgrade
apt install --assume-yes screen
apt install --assume-yes ttyd  
sudo add-apt-repository --assume-yes multiverse
sudo dpkg --assume-yes --add-architecture i386
sudo apt --assume-yes update
sudo apt install --assume-yes steamcmd
apt install --assume-yes jq
apt install --assume-yes curl
curl -s https://raw.githubusercontent.com/ALFREDYTX/Cloudvgs/main/stop.sh --output /stop.sh
curl -s https://raw.githubusercontent.com/ALFREDYTX/Cloudvgs/main/start.sh --output /start.sh

# Establecer permisos
chmod +x /stop.sh
chmod +x /start.sh

# Solicitar el nombre del usuario
read -p "Ingrese el nombre del usuario: " username

# Solicitar la mapa
read -p "Ingrese el mapa de ark survival envolved: " mapa

# Agregar usuario interactivo
sudo useradd $username

# Crear el directorio raíz del usuario
sudo mkdir /home/$username

# Establecer el propietario y el grupo del directorio
sudo chown $username:$username /home/$username

# Establecer la contraseña de manera no interactiva
echo "$username:123456" | sudo chpasswd

# Establecer el directorio de inicio de usuario
STOP_SCRIPT="/stop.sh"
START_SCRIPT="/start.sh"

# Verificar si los archivos existen
if [ ! -f "$STOP_SCRIPT" ] || [ ! -f "$START_SCRIPT" ]; then
    echo "Error: Los archivos stop.sh o start.sh no existen en las rutas proporcionadas."
    exit 1
fi

# Reemplazar "name-server" con el valor de $username y "user" con el valor de $username en stop.sh
sed -i "s/name-server/$username/g" "$STOP_SCRIPT"
sed -i "s/user/$username/g" "$STOP_SCRIPT"

# Reemplazar "name-server" con el valor de $username, "command-start" con el valor de "java -Xms512M -Xmx${ram} -jar server.jar nogui" y "user" con el valor de $username en start.sh
sed -i "s/name-server/$username/g" "$START_SCRIPT"
sed -i "s/user/$username/g" "$START_SCRIPT"
# Solicitar el nombre del usuario
sed -i "s/command-start/./ShooterGameServer $mapa?SessionName=$username?Port=7777?QueryPort=7778/g" "$START_SCRIPT"

echo "Los archivos stop.sh y start.sh han sido modificados exitosamente."

# Actualizar e instalar dependencias
steamcmd +force_install_dir /home/$username +login anonymous +app_update 376030 +quit

# Crear el archivo de servicio
SERVICE_FILE="/etc/systemd/system/ttyd.service"

# Verifica si el usuario actual tiene permisos de escritura en el directorio
if [ ! -w "$(dirname "$SERVICE_FILE")" ]; then
    echo "No tienes permisos para escribir en $(dirname "$SERVICE_FILE")."
    exit 1
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
sudo systemctl daemon-reload

# Reinicia el servicio ttyd
sudo systemctl restart ttyd

su - $username

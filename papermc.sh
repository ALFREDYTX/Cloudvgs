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
apt install --assume-yes openjdk-17-jre-headless
apt install --assume-yes openjdk-16-jre-headless
apt install --assume-yes openjdk-11-jre-headless
apt install --assume-yes openjdk-8-jre-headless
apt install --assume-yes jq
apt install --assume-yes curl
curl -s https://raw.githubusercontent.com/ALFREDYTX/Cloudvgs/main/stop.sh --output /stop.sh
curl -s https://raw.githubusercontent.com/ALFREDYTX/Cloudvgs/main/start.sh --output /start.sh

# Solicitar el nombre del usuario
read -p "Ingrese el nombre del usuario: " username

# Solicitar el nombre del usuario
read -p "Ingrese la cantidad de ram maxima (1G): " ram

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
sed -i "s/command-start/java -Xms512M -Xmx${ram} -jar server.jar nogui/g" ""

echo "Los archivos stop.sh y start.sh han sido modificados exitosamente."

# Solicitar la versión de Minecraft
read -p "Ingrese la versión de Minecraft: " version

PROJECT=paper
MINECRAFT_VERSION=$version

# Verificar si la versión especificada existeEOF
VER_EXISTS=$(curl -s https://api.papermc.io/v2/projects/${PROJECT} | jq -r --arg VERSION $MINECRAFT_VERSION '.versions[] | contains($VERSION)' | grep -m1 true)
LATEST_VERSION=$(curl -s https://api.papermc.io/v2/projects/${PROJECT} | jq -r '.versions' | jq -r '.[-1]')

if [ -z "${VER_EXISTS}" ]; then
    echo "Error: Specified version ${MINECRAFT_VERSION} not found for project ${PROJECT}"
    exit 1
fi

# Obtener información sobre la versión y la compilación
LATEST_BUILD=$(curl -s https://api.papermc.io/v2/projects/${PROJECT}/versions/${MINECRAFT_VERSION} | jq -r '.builds' | jq -r '.[-1]')

if [ -z "${LATEST_BUILD}" ]; then
    echo "Error: Unable to retrieve the latest build for version ${MINECRAFT_VERSION} of project ${PROJECT}"
    exit 1
fi

echo -e "Using the latest ${PROJECT} build for version ${MINECRAFT_VERSION}"
BUILD_NUMBER=${LATEST_BUILD}

JAR_NAME=${PROJECT}-${MINECRAFT_VERSION}-${BUILD_NUMBER}.jar

echo "Version being downloaded"
echo -e "MC Version: ${MINECRAFT_VERSION}"
echo -e "Build: ${BUILD_NUMBER}"
echo -e "JAR Name of Build: ${JAR_NAME}"

# Construir la URL de descarga
DOWNLOAD_URL=https://api.papermc.io/v2/projects/${PROJECT}/versions/${MINECRAFT_VERSION}/builds/${BUILD_NUMBER}/downloads/${JAR_NAME}

# Descargar el archivo JAR
curl -s ${DOWNLOAD_URL} --output /home/$username/server.jar

if [ $? -eq 0 ]; then
    echo "Download successful"
else
    echo "Error: Download failed. Please check your internet connection."
    exit 1
fi

SERVICE_FILE="/etc/systemd/system/ttyd.service"

# Verifica si el usuario actual tiene permisos de escritura en el archivo de servicio
if [ ! -w "$SERVICE_FILE" ]; then
    echo "No tienes permisos para escribir en $SERVICE_FILE. Ejecuta el script con privilegios de superusuario."
    exit 1
fi

# Contenido del archivo de servicio
SERVICE_CONTENT="[Unit]
Description=$username Server

[Service]
Type=simple
User=$username
WorkingDirectory=/home/$username
ExecStart=/usr/bin/ttyd -W -p 8080 /usr/bin/screen -x $username
Restart=always

[Install]
WantedBy=multi-user.target
"

# Escribe el contenido en el archivo de servicio
echo "$SERVICE_CONTENT" | sudo tee "$SERVICE_FILE" > /dev/null

# Notifica al usuario que la operación se completó
echo "El archivo de servicio ha sido creado con éxito en $SERVICE_FILE."

# Reinicia el servicio
sudo systemctl daemon-reload

# Reinicia el servicio ttyd
sudo systemctl restart ttyd

su - $username

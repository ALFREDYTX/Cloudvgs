#!/bin/sh

# Asigna el valor "$1" a la variable "entrada"
entrada="$1"

# Verifica si la variable "entrada" es igual a "si"
if [ "$entrada" = "mcserver" ]; then
    #!/bin/bash

# Ruta al archivo de configuración
config_file="lgsm/config-default/config-lgsm/mcserver/_default.cfg"

# Línea que contiene la versión de Minecraft
version_line="mcversion=\"latest\""

# Imprimir el contenido actual de la línea
echo "Contenido actual de la línea:"
grep "$version_line" "$config_file"

# Solicitar al usuario la nueva versión
read -p "Ingrese la nueva versión de Minecraft: " new_version

# Reemplazar la versión en el archivo
sed -i "s/$version_line/mcversion=\"$new_version\"/" "$config_file"

# Imprimir el contenido modificado de la línea
echo "Contenido modificado de la línea:"
grep "mcversion" "$config_file"

# inicializa install de linuxgsm
./"$1" install

# Descarga el script start_console.sh
wget https://raw.githubusercontent.com/ALFREDYTX/Cloudvgs/main/start_console.sh

# Cambia al directorio lgsm/modules
cd lgsm/modules || exit 1

# Descarga el script desde GitHub
wget https://raw.githubusercontent.com/ALFREDYTX/Cloudvgs/main/command_console.sh || exit 1

# Elimina el script existente
rm command_console.sh || exit 1

# Renombra el nuevo script
mv command_console.sh.1 command_console.sh || exit 1

# Asigna permisos de ejecuci  n al script
chmod +x command_console.sh || exit 1

# Cambia al directorio home
cd || exit 1

# Ejecuta ttyd con el script start_console.sh
ttyd -W bash -e ./start_console.sh "$1"



else



    # inicializa install de linuxgsm
./"$1" install

# Descarga el script start_console.sh
wget https://raw.githubusercontent.com/ALFREDYTX/Cloudvgs/main/start_console.sh

# Cambia al directorio lgsm/modules
cd lgsm/modules || exit 1

# Descarga el script desde GitHub
wget https://raw.githubusercontent.com/ALFREDYTX/Cloudvgs/main/command_console.sh || exit 1

# Elimina el script existente
rm command_console.sh || exit 1

# Renombra el nuevo script
mv command_console.sh.1 command_console.sh || exit 1

# Asigna permisos de ejecuci  n al script
chmod +x command_console.sh || exit 1

# Cambia al directorio home
cd || exit 1

# Ejecuta ttyd con el script start_console.sh
ttyd -W bash -e ./start_console.sh "$1"
fi

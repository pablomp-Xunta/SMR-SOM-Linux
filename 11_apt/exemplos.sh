#!/bin/bash

# Actualizar la lista de paquetes
sudo apt update

# Buscar paquetes relacionados con 'editor'
apt search editor
# Salida esperada: lista de paquetes que contienen "editor" en el nombre o descripción.

# Instalar un paquete (por ejemplo, curl) y comprobar versión
sudo apt install curl -y
curl --version
# Muestra la versión instalada de curl.

# Obtener información detallada de un paquete (por ejemplo, nano)
apt show nano
# Muestra descripción, versión, dependencias, etc.

# Eliminar (quitar) un paquete instalado (por ejemplo, nano)
sudo apt remove --purge nano -y
sudo apt autoremove -y


apt search apache2
git clone https://github.com/git/git.git
cd git && git status

# Hash
sha256sum archivo.iso

# Bash
chmod +x script.sh
./script.sh
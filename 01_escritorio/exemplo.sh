#!/bin/bash
# Actualizar listas de paquetes e instalar Xfce (entorno ligero)
sudo apt update
sudo apt install xfce4 -y

# Ver los archivos .desktop de sesiones instaladas (ver entornos disponibles)
ls /usr/share/xsessions
# Ejemplo de salida esperada: 
# XFCE.desktop   gnome.desktop  kde.desktop   (nombres aproximados)

# Mostrar el entorno actual (variable de entorno DESKTOP_SESSION)
echo "Entorno actual: $DESKTOP_SESSION"
echo $XDG_CURRENT_DESKTOP


# Cambiar el gestor de sesión predeterminado (por ejemplo a Xfce si hay varios)
sudo update-alternatives --config x-session-manager
# Esto mostrará un menú para seleccionar el gestor predeterminado.

# (Opcional) Si se desea eliminar Xfce al terminar la práctica:
sudo apt remove --purge xfce4 -y

#!/bin/bash
# Crear un usuario 'juan' con home y contraseña (se le pedirá contraseña)
sudo useradd -m -s /bin/bash juan
sudo passwd juan

# Crear un grupo 'desarrolladores' y agregar 'juan' a él
sudo groupadd desarrolladores
sudo usermod -aG desarrolladores juan

# Ver información del usuario
id juan
groups juan
# Ejemplo de salida:
# uid=1001(juan) gid=1001(juan) groups=1001(juan),1002(desarrolladores)

# En el directorio de juan, crear un archivo y ajustar permisos
sudo -u juan bash -c "touch /home/juan/proyecto.txt"
ls -l /home/juan/proyecto.txt
# Ejemplo:
# -rw-r--r-- 1 juan juan 0 Jan 1 00:00 /home/juan/proyecto.txt

# Cambiar permisos a rw-r----- (640) y propietario a juan:desarrolladores
sudo chown juan:desarrolladores /home/juan/proyecto.txt
sudo chmod 640 /home/juan/proyecto.txt

ls -l /home/juan/proyecto.txt
# Salida esperada:
# -rw-r----- 1 juan desarrolladores 0 Jan 1 00:00 proyecto.txt

# Finalmente, eliminar el usuario y el grupo creados
sudo userdel -r juan
sudo groupdel desarrolladores

# Permisos especiales
sudo mkdir -p /tmp/prueba
chmod +t /tmp/prueba


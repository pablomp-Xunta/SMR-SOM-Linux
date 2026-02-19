#!/bin/bash
# Listar discos y particiones
lsblk
sudo fdisk -l
lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
# Ejemplo de salida:
# NAME   SIZE FSTYPE TYPE MOUNTPOINT
# sda    100G        disk 
# ├─sda1  96G ext4   part /
# └─sda2   4G swap   part [SWAP]
# sdb    10G         disk 
# (Asumimos que /dev/sdb no tiene particiones previas)

# Crear sistema de archivos
echo "Formateando /dev/sdb1 como ext4..."
sudo mkfs.ext4 /dev/sdb1

# Formatear y montar partición /dev/sdb1 (¡sólo en entorno de pruebas!)

sudo parted -s /dev/sdb mklabel gpt
sudo parted -s /dev/sdb mkpart primary ext4 1MiB 100%
# Actualizar la tabla de particiones
sudo partprobe


sudo mkfs.ext4 /dev/sdb1

# Montaje manual
echo "Creando punto de montaje..."
sudo mkdir -p /mnt/datos
echo "Montando /dev/sdb1 en /mnt/mi_disco..."
sudo mount /dev/sdb1 /mnt/datos

# Verificar montaje
df -h

echo "Verificando montaje:"
df -h | grep /mnt/mi_disco

# Al terminar, desmontar la partición y (opcional) limpiar
sudo umount /mnt/mi_disco
sudo rmdir /mnt/mi_disco

# Obtener UUID
sudo blkid

# Editar fstab (requiere intervención manual)
echo "Editar línea en /etc/fstab con:"
echo "UUID=xxxxx-xxxx  /mnt/datos  ext4  defaults  0  2"
sudo nano /etc/fstab

# Crear archivo swap
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Verificar swap
free -h

# Crear SWAP
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Crear LVM
sudo pvcreate /dev/sdb1
sudo vgcreate vgdatos /dev/sdb1
sudo lvcreate -L 1G -n lvtest vgdatos
sudo mkfs.ext4 /dev/vgdatos/lvtest
sudo mkdir -p /mnt/lvtest
sudo mount /dev/vgdatos/lvtest /mnt/lvtest

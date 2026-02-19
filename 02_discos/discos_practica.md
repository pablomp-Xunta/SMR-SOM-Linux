# Práctica: Gestión de discos en Linux

## 1. Ver discos y particiones

```bash
lsblk
sudo fdisk -l
```

## 2. Crear una partición con `parted`

```bash
sudo parted /dev/sdb mklabel gpt
sudo parted /dev/sdb mkpart primary ext4 1MiB 100%
```

## 3. Formatear y montar una partición

```bash
sudo mkfs.ext4 /dev/sdb1
sudo mkdir /mnt/datos
sudo mount /dev/sdb1 /mnt/datos
df -h | grep /mnt/datos
```

## 4. Obtener UUID y editar fstab

```bash
sudo blkid
sudo nano /etc/fstab
# Ejemplo:
# UUID=xxxx-xxxx /mnt/datos ext4 defaults 0 2
```

## 5. Crear y activar SWAP

```bash
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
free -h
```

## 6. Configurar LVM básico

```bash
sudo pvcreate /dev/sdb1
sudo vgcreate vgdatos /dev/sdb1
sudo lvcreate -L 2G -n lvpruebas vgdatos
sudo mkfs.ext4 /dev/vgdatos/lvpruebas
sudo mount /dev/vgdatos/lvpruebas /mnt/lvtest
```


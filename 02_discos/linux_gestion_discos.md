## 💽 Gestión de Discos y Montajes

### Información general

```bash
lsblk
lsblk -f
sudo fdisk -l
sudo parted /dev/sda print
sudo blkid
```

### Crear y formatear partición

```bash
sudo parted --script /dev/sdb mklabel gpt
sudo parted --script /dev/sdb mkpart primary ext4 1MiB 100%
sudo mkfs.ext4 /dev/sdb1
```

### Montaje manual

```bash
sudo mkdir /mnt/datos
sudo mount /dev/sdb1 /mnt/datos
df -h | grep /mnt/datos
```

### Montaje automático en /etc/fstab

```bash
sudo blkid /dev/sdb1
sudo nano /etc/fstab
# UUID=... /mnt/datos ext4 defaults 0 2
```

Montar todo según fstab:
```bash
sudo mount -a
```

---

## 📦 LVM Básico

```bash
sudo pvcreate /dev/sdb1
sudo vgcreate datos_vg /dev/sdb1
sudo lvcreate -n volumen1 -L 50G datos_vg
sudo mkfs.ext4 /dev/datos_vg/volumen1
sudo mount /dev/datos_vg/volumen1 /mnt/volumen1
```

Extender volumen:
```bash
sudo lvextend -L +10G /dev/datos_vg/volumen1
sudo resize2fs /dev/datos_vg/volumen1
```

Consultar:
```bash
lvs
vgs
pvs
```

---


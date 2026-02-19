## 🔄 Recuperación de Archivos en ext4

### Recuperación manual con `debugfs` y `dd`

1. **Consultar tamaño de bloque**:
```bash
sudo dumpe2fs -h /dev/sda1 | grep -i 'Block size'
```

2. **Volcar contenido del bloque conocido (ej. 557056)**:
```bash
sudo dd if=/dev/sda1 of=recovery-data.txt bs=4096 count=1 skip=557056
cat recovery-data.txt
```

3. **Uso de debugfs para explorar inodos**:
```bash
sudo debugfs /dev/sda1
debugfs: stat <131074>
debugfs: dump <131074> archivo_recuperado.txt
```

---

### Recuperación automática con `extundelete`

1. **Instalación**:
```bash
sudo apt install extundelete
```

2. **Recuperar archivos (con partición desmontada)**:
```bash
sudo extundelete --restore-all /dev/sda1
```

---

## 🧰 Comandos útiles ext2/ext3/ext4

```bash
stat archivo.txt            # Información de archivo
df -h                       # Uso de espacio en disco
df -i                       # Inodos disponibles
sudo dumpe2fs /dev/sda1     # Metadatos del sistema de archivos
sudo tune2fs -l /dev/sda1   # Parámetros ajustables
sudo debugfs /dev/sda1      # Acceso bajo nivel (partición desmontada)
```

---


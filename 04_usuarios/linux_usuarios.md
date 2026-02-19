## 👥 Gestión de Usuarios y Grupos

### Crear y modificar usuarios

```bash
sudo adduser prueba
sudo useradd -m -d /home/pepito -s /bin/bash pepito
sudo passwd pepito
sudo usermod -aG sudo prueba
sudo usermod -a -G docker,sudo pepito
```

### Eliminar usuarios

```bash
sudo deluser prueba
sudo userdel -r pepito
```

---

### Grupos

```bash
sudo addgroup desarrolladores
sudo adduser pepito desarrolladores
sudo gpasswd desarrolladores
```

Consultar:
```bash
groups pepito
getent group desarrolladores
```

---

## 🔐 Permisos y Propiedad

### Ver permisos

```bash
ls -l archivo.txt
```

### Cambiar permisos

```bash
chmod u+x script.sh
chmod 750 archivo.txt
chmod +t /tmp/compartido
```

### Cambiar propietario

```bash
sudo chown pepito:users archivo.txt
sudo chown -R usuario:grupo carpeta/
```

---
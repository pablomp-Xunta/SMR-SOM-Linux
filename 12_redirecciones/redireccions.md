# Ejemplos prácticos: Redirecciones, Pipes, grep y find

## 🔁 Redirecciones

### 1. Redirigir salida estándar a archivo
```bash
echo "Hola mundo" > salida.txt
```

### 2. Añadir al final del archivo (append)
```bash
echo "Otra línea" >> salida.txt
```

### 3. Redirigir errores estándar
```bash
ls carpeta_inexistente 2> errores.txt
```

### 4. Redirigir salida y errores juntos
```bash
ls carpeta_inexistente > salida.txt 2>&1
```

---

## 🔗 Pipes

### 1. Encadenar comandos (ej: contar líneas con grep)
```bash
ps aux | grep firefox | wc -l
```

### 2. Ver líneas más frecuentes
```bash
cat archivo.txt | sort | uniq -c | sort -nr | head
```

---

## 🔍 grep – Buscar patrones

### 1. Buscar líneas que contengan "bash" en /etc/passwd
```bash
grep "bash" /etc/passwd
```

### 2. Buscar sin distinguir mayúsculas
```bash
grep -i "usuario" /etc/passwd
```

### 3. Buscar recursivamente en directorios
```bash
grep -r "ERROR" /var/log/
```

### 4. Buscar líneas que NO contienen un patrón
```bash
grep -v "nologin" /etc/passwd
```

---

## 🔎 find – Buscar archivos

### 1. Buscar archivos por nombre
```bash
find /home -name "*.txt"
```

### 2. Buscar archivos modificados hace menos de 2 días
```bash
find /etc -mtime -2
```

### 3. Buscar archivos vacíos
```bash
find . -type f -empty
```

### 4. Buscar por permisos
```bash
find /var -perm 0777
```

### 5. Buscar y ejecutar acción (eliminar .bak)
```bash
find . -name "*.bak" -exec rm -v {} \;
```

---

## Ejemplo combinado: encontrar errores recientes en logs
```bash
find /var/log -name "*.log" -mtime -1 | xargs grep -i "error"
```

## 🧪 Escenario: Simulación de eventos de login

Vamos a simular un script que genera un evento de login registrando:
- Usuario actual
- Fecha y hora
- Nombre del host

Guardaremos cada evento en un archivo `login.log`, y luego usaremos `grep` para consultar eventos por usuario.

---

## 📝 Script de simulación

```bash
#!/bin/bash
# Simular un evento de login

usuario=$USER
fecha=$(date +"%Y-%m-%d %H:%M:%S")
equipo=$(hostname)

echo "$fecha - LOGIN - Usuario: $usuario en $equipo" >> login.log
```

Puedes ejecutar este script varias veces o usar diferentes usuarios.

---

### 🔍 Consultar eventos con `grep`

#### 1. Ver todos los eventos registrados
```bash
cat login.log
```

#### 2. Buscar eventos de un usuario específico
```bash
grep "Usuario: ana" login.log
```

#### 3. Buscar eventos por fecha (ej: 2024-04-01)
```bash
grep "2024-04-01" login.log
```

#### 4. Contar logins por usuario
```bash
grep "Usuario:" login.log | cut -d':' -f2 | sort | uniq -c
```

---

### 🧹 Borrar archivo de log (si se desea reiniciar)
```bash
rm login.log
```

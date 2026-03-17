![IES Castro da Uz](https://www.edu.xunta.gal/centros/iescastrodauz/system/files/zeropoint3_logo.jpg)

# Práctica de Usuarios y Grupos en Linux

---

## 1. Crear usuarios

Crear 2 usuarios:
- patacas → contraseña: patacas  
- chicharo → contraseña: chicharo  

```
useradd -m patacas
passwd patacas
```

```
useradd -m chicharo
passwd chicharo
```

---

## 2. Crear grupo

Crear el grupo:
- ingredientes  

```
groupadd ingredientes
```

---

## 3. Añadir usuarios al grupo

Añadir los usuarios al grupo usando comandos  

```
usermod -aG ingredientes patacas
usermod -aG ingredientes chicharo
```

  >
  > `-aG`: añade al grupo sin eliminar los anteriores
  >

---

## 4. Borrar usuario

Borrar el usuario:
- patacas  

```
userdel patacas
```

```
userdel -r patacas
```

  >
  > `-r`: elimina también el directorio personal
  >

---

## 5. Crear grupo bebidas

Crear el grupo:
- bebidas  

```
groupadd bebidas
```

---

## 6. Crear usuario auga

Crear el usuario:
- auga (debe pedir cambio de contraseña en el primer inicio de sesión)  

```
useradd -m auga
passwd auga
passwd -e auga
```

  >
  > `passwd -e`: fuerza cambio de contraseña en el siguiente login
  >

---

## 7. Crear usuario fanta

Crear el usuario:
- fanta → contraseña: fanta (caduca en 1 mes)

```
useradd -m -K PASS_MAX_DAYS=30 fanta
```

o

```
useradd -m fanta
passwd fanta
chage -M 30 fanta
```

  >
  > `chage -M 30`: caducidad en 30 días
  >

---

## 8. Añadir usuarios al grupo por archivo

Añadir los nuevos usuarios al grupo bebidas editando archivos  

```
nano /etc/group
```

Añadir:

```
bebidas:x:1002:auga,fanta
```

---

## 9. Dar permisos sudo

Darle al usuario auga permisos de sudo editando archivos  

```
visudo
```

O modificando el archivo

```
nano /etc/sudoers
```

Añadir:

```
auga	ALL=(ALL:ALL) ALL
```

---

## 10. Consultar archivos del sistema

Ver las últimas 3 líneas del archivo de usuarios  

```
tail -n 3 /etc/passwd
```

Ver el archivo de grupos  

```
cat /etc/group
```

  >
  > `/etc/passwd`: archivo de usuarios  
  > `/etc/group`: archivo de grupos  
  >

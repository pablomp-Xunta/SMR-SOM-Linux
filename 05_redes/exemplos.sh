#!/bin/bash
# Mostrar interfaces y direcciones IP actuales
ip addr show
# Por ejemplo:
# 2: eth0: <...> inet 192.168.1.10/24 ...

# Asignar una IP estática temporal (requiere privilegios)
sudo ip addr add 192.168.1.50/24 dev eth0
sudo ip route add default via 192.168.1.1

# Verificar conectividad externa
ping -c 3 8.8.8.8
# Debería recibir respuestas (bytes=64, tiempo de ida/vuelta, etc.)

ping -c 3 www.google.com
# Verifica resolución DNS y conectividad HTTP básica.

# Consultar un servidor DNS manualmente
nslookup example.com
# Muestra la IP de example.com

# Configurar UFW (cortafuegos simple)
sudo ufw enable
sudo ufw status verbose
# Salida esperada inicial:
# Status: active
# Logging: on (low)
# Default: deny (incoming), allow (outgoing), disabled (routed)

# Permitir tráfico SSH y HTTP
sudo ufw allow ssh
sudo ufw allow http
sudo ufw status
# Ejemplo de reglas añadidas:
# 22/tcp                   ALLOW       Anywhere
# 80/tcp                   ALLOW       Anywhere

# Denegar toda conexión entrante de una IP concreta
sudo ufw deny from 192.168.1.100
sudo ufw reload
sudo ufw status
# La IP 192.168.1.100 no podrá conectarse a este equipo.

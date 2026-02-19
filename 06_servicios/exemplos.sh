#!/bin/bash
# Verificar estado del servicio SSH (debe estar instalado)
sudo systemctl status ssh
# Salida típica:
# Active: inactive (dead) / active (running)
# Main PID: ...

systemctl list-units --type=service


# Iniciar el servicio SSH y habilitar para que arranque con el sistema
sudo systemctl start ssh
sudo systemctl enable ssh

# Verificar estado tras iniciar
sudo systemctl status ssh
# Ahora debería decir Active: active (running)

# Reiniciar el servicio (útil después de cambiar su configuración)
sudo systemctl restart ssh

# Detener y deshabilitar el servicio
sudo systemctl stop ssh
sudo systemctl disable ssh

# Ver últimas entradas de logs del servicio SSH
sudo journalctl -u ssh -n 5
# Muestra las últimas 5 líneas del registro de SSH

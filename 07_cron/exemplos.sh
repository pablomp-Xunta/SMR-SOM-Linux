#!/bin/bash
# Crear un archivo temporal con la tarea programada (cada minuto)
echo "*/1 * * * * date >> /home/usuario/cron_ejemplo.log" > mi_cron
# Instalar la tarea desde el archivo
crontab mi_cron

# Añadir tarea al crontab
(crontab -l 2>/dev/null; echo "*/5 * * * * echo 'Hola' >> /tmp/prueba.log") | crontab -

# Verificar las tareas programadas actuales
crontab -l
# Debe verse la línea agregada con la expresión de tiempo y el comando.

# Esperar un minuto y revisar el archivo de log
sleep 65
cat /home/usuario/cron_ejemplo.log | head -n 3
# Ejemplo de salida:
# Tue Jan  2 12:00:00 UTC 2025
# Tue Jan  2 12:01:00 UTC 2025
# Tue Jan  2 12:02:00 UTC 2025

# Para eliminar la tarea, usar:
crontab -r

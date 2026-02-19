#!/bin/bash
# Navegar al directorio del usuario y listar su contenido detallado
cd ~
pwd
ls -la
# Ejemplo: muestra archivos y carpetas como Documents, Desktop, .bashrc, etc.

# Crear un nuevo directorio y varios archivos dentro
mkdir proyectos
touch proyectos/index.html proyectos/ejemplo.txt

# Listar dentro de 'proyectos'
ls proyectos
# Salida esperada:
# ejemplo.txt  index.html

# Copiar un archivo y renombrar otro
cp proyectos/index.html proyectos/index_backup.html
mv proyectos/ejemplo.txt proyectos/notas.txt

# Mostrar archivos actualizados en 'proyectos'
ls proyectos
# Salida esperada:
# index.html  index_backup.html  notas.txt

# Buscar archivos HTML en todo el sistema (requiere permisos si busca fuera del home)
find ~ -name "*.html"
# Puede listar rutas como /home/usuario/proyectos/index.html

# Crear un enlace simbólico a un archivo
ln -s proyectos/index.html enlace_index.html
ls -l enlace_index.html
# Salida esperada:
# lrwxrwxrwx 1 usuario usuario   19 Jan  1 00:00 enlace_index.html -> proyectos/index.html



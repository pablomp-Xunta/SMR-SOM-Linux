#!/bin/bash
# Carpeta base dentro del HOME del alumno
BASE=/buscaqueigualatopas
# Limpiar si existe
rm -rf "$BASE"
# Crear estructura
mkdir -p "$BASE"/{logs,docs,oculto,.hidden,deep/n1/n2}
# Crear archivos variados (para find -name)
touch "$BASE"/docs/{app.log,app1.log,APP.log,error.txt,erro.txt}
touch "$BASE"/logs/{system.log,system_error.log,debug.LOG}
touch "$BASE"/deep/n1/n2/ultimo.log
# Archivos ocultos
touch "$BASE"/.hidden/.oculto.log
touch "$BASE"/oculto/.segredo.txt
# Contenido para grep (con trampas)
echo "erro grave sistema" > "$BASE"/logs/system.log
echo "Error leve detectado" >> "$BASE"/logs/system.log
echo "usuario correcto" >> "$BASE"/logs/system.log
echo "ERROR CRITICO" > "$BASE"/logs/system_error.log
echo "todo correcto" > "$BASE"/docs/app.log
echo "erro menor" > "$BASE"/deep/n1/n2/ultimo.log
# Mensaje final
echo "Entorno creado en $BASE"

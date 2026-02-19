#!/bin/bash
# Solicita al usuario su nombre y saluda; luego muestra cada letra.

read -p "¿Cómo te llamas? " nombre

if [ -z "$nombre" ]; then
  echo "No ingresaste un nombre. Saliendo."
  exit 1
else
  echo "¡Hola, $nombre!"
fi

echo "Las letras de tu nombre son:"
# Iterar sobre cada caracter del nombre
for (( i=0; i<${#nombre}; i++ )); do
  echo "${nombre:$i:1}"
done

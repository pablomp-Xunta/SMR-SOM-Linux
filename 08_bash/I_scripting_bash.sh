#!/bin/bash
# Script simple
echo "Hola mundo"

# Variables
nombre="Ana"
echo "Hola $nombre"

# Condicional
if [ -f archivo.txt ]; then
    echo "Existe"
else
    echo "No existe"
fi

# Bucle
for i in {1..5}
do
    echo "Número $i"
done

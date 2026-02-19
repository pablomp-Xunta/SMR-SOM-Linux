#!/bin/bash
# Función que saluda un número de veces decreciente

saludos=3
saludar() {
  local veces=$1
  while [ $veces -gt 0 ]; do
    echo "¡Hola, $USER! Quedan $veces saludos."
    ((veces--))
  done
}

saludar $saludos

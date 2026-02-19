#!/bin/bash
# Flujo básico de uso de Git en terminal

mkdir -p ~/git_demo && cd ~/git_demo
git init

echo "# Proyecto de prueba" > README.md
git add README.md
git commit -m "Primer commit"

git status
git log --oneline

git branch nueva_rama
git checkout nueva_rama

echo "Cambio en rama" > archivo.txt
git add archivo.txt
git commit -m "Agregar archivo en nueva rama"

git checkout main
git merge nueva_rama

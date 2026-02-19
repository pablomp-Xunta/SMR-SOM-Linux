# Práctica: Uso básico de Git en Linux

## 1. Clonar un repositorio

```bash
git clone https://github.com/usuario/repositorio.git
cd repositorio
```

## 2. Crear un nuevo repositorio

```bash
mkdir mi_proyecto
cd mi_proyecto
git init
```

## 3. Añadir archivos y hacer commit

```bash
touch README.md
git add README.md
git commit -m "Primer commit"
```

## 4. Consultar el estado del repositorio

```bash
git status
```

## 5. Ver historial de commits

```bash
git log --oneline
```

## 6. Crear y cambiar de rama

```bash
git branch nueva_rama
git checkout nueva_rama
```

## 7. Fusionar ramas

```bash
git checkout main
git merge nueva_rama
```

## 8. Ver diferencias

```bash
git diff
```

## 9. Deshacer cambios

```bash
git restore archivo.txt
```

## 10. Eliminar archivos del control de versiones

```bash
git rm archivo.txt
git commit -m "Eliminar archivo"
```

![IES Castro da Uz](https://www.edu.xunta.gal/centros/iescastrodauz/system/files/zeropoint3_logo.jpg)

# Práctica de Comandos Linux

## 1. Crear entorno de trabajo:

```
mkdir practica_ls
cd practica_ls
touch a.txt b.txt .oculto
mkdir carpeta1 carpeta2
```

## 2. Ejecutar y comparar resultados:

```
ls
ls -l
ls -a
ls -la
ls -lh
ls -lisah
```

Explicar qué hace cada opción: -l, -a, -h, -i, -s

  > 
  > - `-l`: Información detallada
  > - `-a`: Incluye ocultos
  > - `-h`: Tamaño legible
  > - `-i`: Inodo
  > - `-s`: Tamaño en bloques
  > 

¿Por qué no aparece .oculto sin -a?

  >
  > **.oculto no aparece** porque empieza por `.`
  >

¿Qué diferencia hay entre -l y -lh?

  >
  > **-l vs -lh**: bytes vs formato legible
  >

## 3. Ordenación:

```
touch pequeno.txt
ls -lhS
ls -lSr
ls -lt
ls -ltr
```

Explicar qué hacen las opciones -S, -t y -r

  >
  > - `-S`: tamaño
  > - `-t`: fecha
  >  - `-r`: inverso
  > 
---

## 4. Navegación

Ejecutar y analizar:

```
pwd
cd -
pwd
cd .
pwd
cd ..
pwd
cd ~
cd ~/Descargas
```

¿Qué representa ., .. y ~? ¿Qué hace exactamente cd -?

  > 
  > - `.` actual
  > - `..` padre
  > - `~` home
  > - `cd -` vuelve al directorio anterior
  >

Probar:

```
pwd
pwd -P
pwd -L
```

Explicar la diferencia entre -P y -L.

  > 
  > `pwd -P`: ruta real  
  > `pwd -L`: ruta lógica
  >

---

## 4. Creación de directorios

Intentar:

```
mkdir prueba1/prueba2
```

Después ejecutar:

```
mkdir -p prueba1/prueba2
```

Explicar qué hace la opción -p. Consultar en el manual la opción -m.

  > 
  > `-p`: crea directorios intermedios  
  > `-m`: define permisos
  >

---

## 4. Copiar

Crear estructura:

```
mkdir origen
touch origen/archivo.txt
mkdir origen/sub
touch origen/sub/otro.txt
```

```
cp origen copia
cp -r origen copia
```

Explicar por qué es necesaria la opción -r.

  > 
  > `-r`: necesario para copiar directorios  
  >

```
cp -i origen/archivo.txt copia/
cp -rv origen nuevaCopia
```

  > 
  > `-i`: confirmación  
  > `-v`: verbose  
  >

Buscar en la ayuda y probar la opción -u.

  > 
  > `-u`: solo si es más reciente
  >

---

## 5. Mover y renombrar

Renombrar archivo:

```
mv archivo.txt nuevo.txt
```

Mover archivo a carpeta:

```
mv nuevo.txt carpeta/
```

Explicar la diferencia entre mover y renombrar.

  > 
  > Renombrar = mismo directorio  
  > Mover = cambia ubicación
  >

---

## 6. Borrado

Borrado interactivo:

```
rm -i archivo.txt
```

Borrado recursivo:

```
rm carpeta
rm -r carpeta
```

Consultar opción -f en el manual.

  > 
  > `-i`: confirmación  
  > `-r`: recursivo  
  > `-f`: forzado  
  > `rm -rf`: borra todo sin preguntar → peligroso
  >

Explicar qué hace rm -rf y por qué es peligroso.

---

## 7. Variables

Probar:

```
echo Hola
echo -n Hola
echo -e "Hola\nMundo"
```

Explicar qué hacen -n y -e.

  > 
  > `-n`: sin salto  
  > `-e`: interpreta escapes  
  >

```
echo $HOME
echo $HOSTNAME
echo "Estoy en $PWD"
```
  > 
  > Variables: `$HOME`, `$HOSTNAME`, `$PWD`
  > 

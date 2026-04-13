![IES Castro da Uz](https://www.edu.xunta.gal/centros/iescastrodauz/system/files/zeropoint3_logo.jpg)

# Práctica de Búsquedas Linux


## Creación do entorno de traballo

[Enlace ó código](https://raw.githubusercontent.com/pablomp-Xunta/SMR-SOM-Linux/refs/heads/main/solucionsClase/estructuraUNIX.sh)

---

## A. BÚSQUEDA POR NOMBRE (metacaracteres)

**1. Buscar todos los archivos con extensión `.log`.**

```bash
find . -name "*.log"
```

> Busca en el directorio actual y subdirectorios todos los archivos cuyo nombre termine en `.log`.

---

**2. Buscar todos los archivos `.log` cuyo nombre empiece por `app`.**

```bash
find . -name "app*.log"
```

> El `*` sustituye a cualquier cadena de caracteres (incluida la vacía) entre `app` y `.log`.

---

**3. Buscar archivos `.log` cuyo nombre tenga exactamente un carácter después de `app`.**

```bash
find . -name "app?.log"
```

> El `?` sustituye exactamente a un único carácter.

---

**4. Buscar archivos `.log` donde el carácter después de `app` sea un número.**

```bash
find . -name "app[0-9].log"
```

> Los corchetes `[0-9]` definen una clase de caracteres: cualquier dígito del 0 al 9.

---

**5. Buscar archivos `.log` que empiecen por `app` pero que no contengan la palabra `backup`.**

```bash
find . -name "app*.log" ! -name "*backup*"
```

> `!` niega la condición siguiente. Se excluyen los archivos cuyo nombre contenga `backup`.

---

**6. Buscar archivos cuyo nombre siga el patrón `fileX.txt` donde X es un único carácter.**

```bash
find . -name "file?.txt"
```

> El `?` representa exactamente un carácter cualquiera en la posición X.

---

**7. Buscar archivos `fileX.txt` donde X sea un número.**

```bash
find . -name "file[0-9].txt"
```

> La clase `[0-9]` restringe X a un único dígito.

---

**8. Buscar archivos `fileX.txt` donde X sea una letra.**

```bash
find . -name "file[a-zA-Z].txt"
```

> `[a-zA-Z]` cubre tanto letras minúsculas como mayúsculas.

---

**9. Buscar archivos `.csv` cuyo nombre empiece por `report`.**

```bash
find . -name "report*.csv"
```

> El `*` permite cualquier continuación del nombre tras `report`.

---

**10. Buscar archivos cuyo nombre contenga la palabra `final`.**

```bash
find . -name "*final*"
```

> Los `*` en ambos extremos permiten que `final` aparezca en cualquier posición del nombre.

---

**11. Buscar archivos temporales cuyo nombre siga el patrón `test_?.tmp`.**

```bash
find . -name "test_?.tmp"
```

> El `?` representa un único carácter cualquiera después de `test_`.

---

**12. Buscar archivos temporales donde después de `test_` haya una letra.**

```bash
find . -name "test_[a-zA-Z].tmp"
```

> La clase `[a-zA-Z]` restringe el carácter a letras del alfabeto.

---

**13. Buscar archivos temporales donde después de `test_` haya un número.**

```bash
find . -name "test_[0-9].tmp"
```

> La clase `[0-9]` restringe el carácter a un único dígito.

---

## B. BÚSQUEDA POR TIPO

**14. Listar todos los archivos regulares del entorno.**

```bash
find . -type f
```

> `-type f` filtra únicamente archivos regulares (no directorios ni enlaces).

---

**15. Listar todos los directorios.**

```bash
find . -type d
```

> `-type d` devuelve exclusivamente directorios.

---

**16. Identificar todos los enlaces simbólicos.**

```bash
find . -type l
```

> `-type l` devuelve únicamente los enlaces simbólicos (*symlinks*).

---

## C. ENLACES

**17. Encontrar todos los enlaces simbólicos existentes.**

```bash
find . -type l
```

> Equivalente al apartado anterior. Lista todos los symlinks del entorno.

---

**18. Identificar enlaces simbólicos que estén rotos.**

```bash
find . -xtype l
```

> `-xtype l` sigue el enlace: si el destino no existe, el tipo sigue siendo `l` → enlace roto.

Alternativa más explícita:

```bash
find . -type l ! -exec test -e {} \; -print
```

> Imprime los enlaces simbólicos cuyo destino no existe.

---

**19. Localizar archivos que tengan más de un enlace duro.**

```bash
find . -type f -links +1
```

> `-links +1` selecciona archivos con más de un enlace duro (contador de inodo > 1).

---

**21. Analizar qué ocurre al acceder a un archivo mediante un enlace simbólico que apunta a un fichero sin permisos.**

```bash
# Crear fichero sin permisos y symlink
touch destino.txt
chmod 000 destino.txt
ln -s destino.txt enlace_sinpermisos
cat enlace_sinpermisos
```

> El sistema sigue el enlace simbólico y aplica los permisos del fichero destino.
> El resultado es `Permission denied`, igual que si se intentara leer `destino.txt` directamente.

---

## D. PERMISOS

**22. Identificar archivos que no tienen permisos de lectura.**

```bash
find . -type f ! -readable
```

> `! -readable` selecciona archivos sobre los que el usuario actual no tiene permiso de lectura.

---

**23. Identificar archivos con permisos exactamente 600.**

```bash
find . -type f -perm 600
```

> `-perm 600` requiere que los permisos sean exactamente `rw-------`.

---

**24. Encontrar archivos que tengan permisos de ejecución.**

```bash
find . -type f -perm /111
```

> `/111` significa que al menos uno de los bits de ejecución (usuario, grupo u otros) está activo.

---

**25. Intentar acceder a archivos restringidos y explicar el resultado.**

```bash
cat archivo_sin_permisos.txt
```

> Si el archivo tiene permisos `000` o el usuario no tiene permiso de lectura, el sistema devuelve:
> `Permission denied`
> El kernel comprueba los bits de permiso antes de abrir el fichero.

---

**26. Determinar qué ocurre al acceder a un archivo sin permisos a través de un enlace simbólico.**

```bash
cat enlace_a_restringido
```

> El enlace simbólico no tiene permisos propios: el acceso se evalúa siempre sobre el fichero destino.
> El resultado es idéntico: `Permission denied`.


## E. BÚSQUEDAS DE CONTENIDO (GREP)

**28. Buscar líneas que contengan la palabra `ERROR` en los archivos de log.**

```bash
grep "ERROR" *.log
```

> Busca el literal `ERROR` (sensible a mayúsculas) en todos los `.log` del directorio actual.

---

**29. Buscar la palabra `error` sin distinguir entre mayúsculas y minúsculas.**

```bash
grep -i "error" *.log
```

> `-i` activa la búsqueda case-insensitive: `ERROR`, `Error`, `error`… son equivalentes.

---

**30. Buscar líneas que contengan `user` seguido de un número.**

```bash
grep "user[0-9]" *.log
```

> La expresión regular `[0-9]` exige un dígito inmediatamente después de `user`.

---

**31. Buscar líneas que contengan `admin` seguido de un número.**

```bash
grep "admin[0-9]" *.log
```

> Mismo patrón aplicado a `admin`.

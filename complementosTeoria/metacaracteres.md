# Metacaracteres en Bash y búsquedas con find/grep en Linux

## Resumen ejecutivo
Este apartado explica **cómo interpreta Bash** ciertos caracteres “especiales” (metacaracteres) y cómo aprovecharlos para **buscar archivos** con `find` y **buscar texto dentro de archivos** con `grep` en Debian/Ubuntu. Verás la diferencia clave entre **globbing** (comodines de la shell para *nombres de archivo*) y **expresiones regulares** (patrones para *texto*), además de cómo combinarlo todo con **pipes** y **redirecciones**. Se incluyen scripts `.sh` listos para ejecutar, ejercicios con soluciones y advertencias de seguridad/rendimiento (especialmente al borrar con `find -exec rm`). La referencia principal para detalles exactos son las páginas de manual: `man bash`, `man find` y `man grep`. citeturn4view2turn4view1turn4view0

## Metacaracteres y quoting en Bash
En Bash, antes de ejecutar un comando, la shell realiza **expansiones** sobre lo que escribes (por ejemplo, expansión de llaves `{}`, expansión de tilde `~`, expansión de variables `$`, sustitución de orden `$(...)`, etc.). El manual de Bash indica el **orden**: primero llaves y tilde, luego parámetros/variables y sustitución de orden, después división de palabras y finalmente expansión de nombres de ruta (globbing). Esto explica por qué comillar (quoting) o escapar caracteres cambia el resultado de un comando. citeturn14view1turn5view3

Bash define tres métodos de entrecomillado: **barra invertida** `\` (escape), **comillas simples** `'...'` y **comillas dobles** `"..."`. Las comillas simples preservan literalmente todo lo que contienen; las dobles preservan casi todo excepto `$`, ``` ` ``` y `\` (y `!` si hay expansión de historial), permitiendo expandir variables dentro. La barra invertida preserva el valor literal del carácter siguiente y también sirve para continuación de línea con `\<nueva-línea>`. citeturn5view2

### Tabla rápida de metacaracteres más comunes
| Metacaracter | Tipo | Qué hace (Bash) | Ejemplo seguro |
|---|---|---|---|
| `*` | globbing | Cualquier cadena en nombres de archivo | `ls *.log` citeturn6view0 |
| `?` | globbing | Un carácter cualquiera | `ls foto?.jpg` citeturn6view0 |
| `[...]` | globbing | Un carácter de una lista/rango/clase | `ls archivo[0-9].txt` citeturn6view0 |
| `{a,b}` / `{1..5}` | expansión | Genera cadenas (no requiere que existan) | `echo {1..3}` citeturn5view3turn14view0 |
| `~` | expansión | Expande a `$HOME` o home de usuario | `cd ~` citeturn14view0 |
| `$VAR` / `${VAR}` | expansión | Expansión de parámetros/variables (`$` “introduce” expansión) | `echo "$USER"` citeturn14view0 |
| `$(cmd)` / `` `cmd` `` | expansión | Sustitución de orden (mejor `$(...)`) | `fecha=$(date)` citeturn5view4turn14view2 |
| `|` | control | Pipe: stdout de cmd1 → stdin de cmd2 | `ls | grep txt` citeturn5view5turn2search14 |
| `|&` | control | Pipe incluyendo stderr (`2>&1 |`) | `cmd |& tee log` citeturn5view5turn6view0 |
| `>` | redirección | Redirige stdout (sobrescribe) | `echo hola > out.txt` citeturn6view0 |
| `>>` | redirección | Redirige stdout (añade) | `echo hola >> out.txt` citeturn6view0 |
| `<` | redirección | Redirige stdin desde archivo | `wc -l < out.txt` citeturn6view0 |
| `2>` | redirección | Redirige stderr | `cmd 2> errores.log` citeturn6view0 |
| `&>` / `&>>` | redirección | Redirige stdout+stderr (sobrescribe/añade) | `cmd &>> todo.log` citeturn6view0 |
| `;` | control | Separa comandos en una lista | `cmd1; cmd2` citeturn13view5 |
| `&&` | control | Ejecuta cmd2 si cmd1 devuelve 0 | `make && sudo make install` citeturn13view5 |
| `||` | control | Ejecuta cmd2 si cmd1 falla | `cmd || echo "falló"` citeturn13view5 |
| `( ... )` | control | Ejecuta lista en una subshell | `(cd /tmp; ls)` citeturn13view5 |
| `"..."` / `'...'` | quoting | Doble: expande `$`; simple: literal | `echo "$HOME"` citeturn5view2 |
| `\` | escape | Escapa el siguiente carácter | `echo \*` citeturn5view2turn6view0 |

**Consejo clave:** `*` en globbing **no es** `.*` en regex, y `?` en globbing **no es** `?` en regex. Para `grep`, los patrones suelen ir entre comillas para evitar que la shell los “toque” antes de tiempo. citeturn16view0turn16view2

## Buscar archivos con find
`find` recorre uno o varios puntos de inicio y evalúa una **expresión** compuesta por *pruebas*, *acciones* y *operadores*. Las pruebas devuelven verdadero/falso (p. ej. `-empty`), las acciones tienen efecto secundario (p. ej. `-print`), y los operadores unen subexpresiones (por ejemplo AND/OR; si no indicas operador, se asume AND). Si se usan paréntesis para forzar precedencia, normalmente hay que escaparlos o entrecomillarlos para que no los interprete la shell. citeturn4view1turn10view7

### Sintaxis mínima y predicados prácticos
- **Nombre**: `-name patrón` compara el **nombre base** (sin directorios) contra un patrón de shell; por ello no debe incluir `/`. citeturn11view4  
- **Tipo**: `-type` filtra por tipo (fichero, directorio, enlace, etc.). citeturn11view0  
- **Tiempo**: `-mtime n` compara por modificación en múltiplos de 24h (con redondeo). Se combina con `+n`, `-n` o `n` para “más de”, “menos de” o “exactamente”. citeturn10view2turn10view1turn11view4  
- **Tamaño**: `-size n[cwbkMG]` permite sufijos (bytes, KiB, MiB…) y compara con `+`/`-`. citeturn11view5turn10view2  
- **Permisos**: `-perm modo`, `-perm -modo` (todos los bits), `-perm /modo` (cualquiera). citeturn11view6  
- **Acción segura de salida**: `-print0` separa resultados con NUL para evitar problemas con espacios o saltos de línea. citeturn11view2  

### find, -print0 y xargs -0
Cuando vas a pasar resultados de `find` a otro comando, usar `-print` puede romperse con nombres raros (espacios, saltos de línea). La propia manpage de `find` recomienda el método más seguro `find ... -print0 | xargs -0 ...` y muestra el ejemplo para borrar archivos manejando correctamente esos casos. citeturn10view8turn11view2

`xargs` por defecto separa entradas por espacios o saltos de línea, lo que resulta problemático con nombres de archivo “raros”. Para estas situaciones, `xargs -0` hace que los elementos terminen en NUL y se recomienda alimentarlo con salida NUL-separada (por ejemplo, `find -print0`). citeturn15view0turn15view1

### find con -exec (y -exec ... {} +)
`-exec orden ;` ejecuta una orden por cada coincidencia sustituyendo `{}` por el archivo actual; `{}` y el `;` suelen necesitar escape o comillas para que no los interprete la shell. Existe una variante `-exec orden {} +` que **agrupa** muchos archivos en menos invocaciones (similar a `xargs`) y suele ser más eficiente. La manpage advierte de problemas de seguridad con `-exec` y recomienda valorar `-execdir` para mitigarlos. citeturn11view3turn10view8

## Buscar texto con grep y expresiones regulares
`grep` busca patrones en archivos y muestra las líneas que coinciden; los patrones suelen ir entre comillas cuando se usa desde una shell. Cuando no se da archivo, las búsquedas recursivas examinan el directorio de trabajo y las no recursivas leen stdin; y un archivo `-` significa stdin. Debian recomienda evitar `egrep/fgrep/rgrep` y usar `grep -E/-F/-r`. citeturn16view0turn2search2turn9view3

### Opciones esenciales (principiante-intermedio)
- `-i` ignora mayúsculas/minúsculas. citeturn9view0  
- `-r` busca recursivamente en directorios (y si no indicas ruta, busca en el directorio actual). citeturn4view0  
- `-n` antepone número de línea. citeturn9view2  
- `-E` usa regex extendidas (ERE). `-G` es el modo básico (BRE, por defecto). citeturn9view3  
- `-P` usa PCRE (estilo Perl); la manpage avisa de que puede ser “experimental” en combinación con `-z`. citeturn9view3turn7view3  
- `-o` muestra solo la parte coincidente (cada match en su línea). citeturn9view2  
- `-v` invierte la selección (líneas que NO coinciden). citeturn9view0  
- `-c` cuenta líneas coincidentes (en vez de imprimirlas). citeturn9view0turn8view5  

### Regex básicas y extendidas en grep
`grep` maneja sintaxis “básica” (BRE), “extendida” (ERE) y “perl” (PCRE). La documentación explica que en GNU grep BRE y ERE son notaciones diferentes para la misma “funcionalidad” general, aunque en otras implementaciones BRE suele ser menos potente. También detalla que en BRE, metacaracteres como `? + { } | ( )` pierden significado especial (se usan con backslash), mientras en ERE no hace falta escaparlos. citeturn7view7turn12view9turn9view3

Elementos de regex (lo más útil para empezar):
- `.` coincide con cualquier carácter (salvo casos particulares con binarios). citeturn12view8  
- **Clases y rangos**: `[abc]`, `[a-d]`, y clases POSIX como `[[:digit:]]`. Si el primer carácter es `^`, niega la clase. citeturn12view5  
- **Anclas**: `^` inicio de línea, `$` fin de línea. citeturn12view5  
- **Cuantificadores**: `? * + {n,m}`. citeturn7view1turn12view9  
- **Alternancia**: `expr1|expr2` (normalmente con `-E`). citeturn12view9turn9view3  
- **Grupos y retroreferencias**: agrupar con paréntesis y usar `\1`, `\2`… para referenciar subexpresiones previas. citeturn12view9turn7view1  

## Combinar pipes, redirecciones, find+grep y scripts prácticos
Una tubería conecta stdout de una orden con stdin de otra; `|&` incluye también stderr como abreviatura de `2>&1 |`. Las redirecciones permiten enviar stdout/stderr a ficheros; por ejemplo `&>archivo` equivale a `>archivo 2>&1`, y el orden de redirecciones importa (no es lo mismo `cmd >a 2>&1` que `cmd 2>&1 >a`). citeturn5view5turn6view0

```mermaid
flowchart LR
  A[Buscar con find] --> B[Filtrar/extraer con grep]
  B --> C[Reportar: redirecciones a fichero]
```

### Scripts `.sh` listos para ejecutar
Guárdalos como archivo, ejecuta `chmod +x script.sh` y luego `./script.sh`. Están diseñados para ser **didácticos** y **seguros** (con validación, variables entrecomilladas y manejo de nombres raros).

#### Script de demostración de metacaracteres y quoting
```bash
#!/usr/bin/env bash
set -euo pipefail

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

cd "$tmp"
touch "a.txt" "b.txt" "foto1.jpg" "foto2.jpg" "archivo 3.txt"

echo "[1] Globbing (*.txt):"
ls *.txt  # * se expande a nombres de archivo

echo "[2] Literal '*' usando escape:"
echo \*

echo "[3] Brace expansion (no requiere que existan):"
echo file_{A,B}_{1..3}.log

echo "[4] Diferencia entre comillas:"
echo "HOME con dobles: $HOME"
echo 'HOME con simples: $HOME'

echo "[5] Pipe y redirección:"
ls -la | grep -nE '\.txt$' > salida.txt
echo "Se creó salida.txt con las líneas .txt (usa grep -n y regex $)."
```
**Qué demuestra:** globbing, expansión de llaves, comillas, pipes y redirección a fichero. citeturn6view0turn5view2turn14view1turn12view5

#### Buscar archivos grandes (find -size)
```bash
#!/usr/bin/env bash
set -euo pipefail

dir="${1:-$HOME}"
min_mb="${2:-100}"

echo "Buscando ficheros > ${min_mb}M en: $dir"
# -size +nM: mayor que n MiB (find explica el sufijo M). 
find "$dir" -type f -size +"${min_mb}"M -print0 \
  | xargs -0 -r du -h \
  | sort -h | tail -n 20
```
**Resultado esperado:** lista (aprox.) de los 20 ficheros más grandes encontrados. citeturn11view5turn15view1turn11view2

#### Limpiar logs antiguos con modo “dry-run” (seguro)
```bash
#!/usr/bin/env bash
set -euo pipefail

dir="${1:-/var/log}"
days="${2:-30}"
run="${3:-DRY}"   # Cambia a RUN para borrar

echo "Directorio: $dir"
echo "Antigüedad: +$days días"
echo "Modo: $run (DRY no borra, RUN borra)"

# Primero listamos qué se borraría (prueba con -mtime y -name).
echo "Candidatos:"
find "$dir" -type f \( -name "*.log" -o -name "*.log.*" \) -mtime +"$days" -print0 \
  | xargs -0 -r printf '%s\n'

if [[ "$run" == "RUN" ]]; then
  echo "BORRANDO (usa -- para evitar que nombres con '-' se interpreten como opciones):"
  find "$dir" -type f \( -name "*.log" -o -name "*.log.*" \) -mtime +"$days" -print0 \
    | xargs -0 -r rm -v -- 
else
  echo "Dry-run terminado. Para borrar: ./limpiar_logs_antiguos.sh /var/log 30 RUN"
fi
```
**Resultado esperado:** en DRY solo lista; en RUN elimina y muestra cada borrado. citeturn10view2turn11view4turn11view2turn15view1turn4view3

#### Buscar cadenas en un proyecto de código (find + grep)
```bash
#!/usr/bin/env bash
set -euo pipefail

root="${1:-.}"
pattern="${2:-TODO}"

echo "Buscando '$pattern' en $root (ext: .sh .py .js .md)"
# -print0 + xargs -0 para nombres con espacios/saltos de línea.
find "$root" -type f \( -name "*.sh" -o -name "*.py" -o -name "*.js" -o -name "*.md" \) -print0 \
  | xargs -0 -r grep -nH -i -- "$pattern"
```
**Resultado esperado:** líneas coincidentes con número de línea y nombre de archivo. citeturn11view2turn9view0turn9view2turn16view0

#### Generar un informe de “eventos” (fecha/host/usuario) y filtrar con grep
```bash
#!/usr/bin/env bash
set -euo pipefail

out="${1:-informe_eventos.log}"
usuario="${USER:-$(whoami)}"
host="$(hostname)"
fecha="$(date -Is)"

{
  echo "== Informe de eventos =="
  echo "Fecha: $fecha"
  echo "Host:  $host"
  echo "User:  $usuario"
  echo
  echo "[INFO] sistema iniciado"
  echo "[WARN] espacio en disco bajo"
  echo "[ERROR] fallo de autenticación"
  echo "[INFO] tarea programada ejecutada"
} > "$out"

echo "Informe generado en: $out"
echo "Filtrando solo WARN/ERROR con grep -E:"
grep -nE '\[(WARN|ERROR)\]' "$out"
```
**Resultado esperado:** crea el log y muestra solo WARN/ERROR. citeturn6view0turn9view2turn12view9turn9view3

#### Resumen por archivo (contar coincidencias) con find + grep -c
```bash
#!/usr/bin/env bash
set -euo pipefail

root="${1:-.}"
needle="${2:-ERROR}"

echo "Archivo;coincidencias"
# Usamos un bucle con NUL para evitar problemas con nombres “raros”.
find "$root" -type f -name "*.log" -print0 | while IFS= read -r -d '' f; do
  c="$(grep -c -- "$needle" "$f" || true)"
  echo "$f;$c"
done
```
**Resultado esperado:** CSV simple “archivo;conteo” (útil para hojas de cálculo). citeturn11view2turn8view5turn16view0

## Ejercicios propuestos y soluciones
### Ejercicio de globbing y quoting
**Enunciado:** Crea en `/tmp` cinco ficheros `log_1.txt` … `log_5.txt` y escribe una línea en cada uno usando expansión de llaves. Luego lista solo los que terminan en `5.txt`.  
**Solución:**
```bash
mkdir -p /tmp/practica_meta && cd /tmp/practica_meta
for i in {1..5}; do echo "Linea $i" > "log_${i}.txt"; done
ls *5.txt
```
Expansión de llaves y su orden (antes que otras expansiones) es parte del comportamiento de Bash. citeturn14view1turn5view3

### Ejercicio de find por antigüedad y tamaño
**Enunciado:** Encuentra en tu `$HOME` ficheros de más de 10 MiB modificados hace más de 7 días.  
**Solución:**
```bash
find "$HOME" -type f -size +10M -mtime +7 -print
```
`-size` con sufijo y `-mtime` están definidos en la manpage. citeturn11view5turn11view4

### Ejercicio de grep con regex (anclas y clases)
**Enunciado:** En un archivo `informe_eventos.log`, extrae todas las líneas que terminen en “ejecutada” y además cuenten cuántas son.  
**Solución:**
```bash
grep -nE 'ejecutada$' informe_eventos.log
grep -cE 'ejecutada$' informe_eventos.log
```
Las anclas `^` y `$` y el conteo con `-c` están descritos en el manual. citeturn12view5turn8view5turn9view2turn9view3

### Ejercicio combinado find + grep (seguro con -print0)
**Enunciado:** Busca la palabra `TODO` (sin distinguir mayúsculas) en todos los `.sh` dentro del directorio actual y subdirectorios.  
**Solución:**
```bash
find . -type f -name "*.sh" -print0 | xargs -0 grep -nH -i -- "TODO"
```
`-print0`/`xargs -0` es el método recomendado para nombres con espacios o saltos de línea. citeturn11view2turn15view1turn9view0turn9view2

## Tablas comparativas y advertencias
### find vs locate
`find` busca recorriendo el sistema de archivos en “tiempo real”, mientras que `locate` (y alternativas modernas como `plocate`) busca en una **base de datos/índice** generado previamente (por `updatedb`). Esto hace que `locate/plocate` sea muy rápido, pero puede estar desactualizado si la base no se ha regenerado. Además, `locate` admite metacaracteres estilo shell (`* ? []`) y recomienda comillarlos para evitar expansión por la shell. citeturn18view1turn18view2turn4view5turn18view0

| Herramienta | Ventajas | Inconvenientes | Cuándo usar |
|---|---|---|---|
| `find` | Filtra por tipo, permisos, tamaño, tiempos; ejecuta acciones | Puede ser lento en árboles grandes | Análisis preciso y acciones (copiar/borrar/reportar) citeturn4view1turn11view3 |
| `locate` / `plocate` | Muy rápido (índice); búsqueda por nombre | Depende de `updatedb`/índice; puede no reflejar lo último | Encontrar rápidamente por nombre aproximado citeturn18view1turn18view0turn18view2 |

### grep vs rg (ripgrep)
`ripgrep (rg)` es un buscador recursivo de patrones orientado a proyectos: por defecto respeta reglas `.gitignore` y omite archivos ocultos/binarios, ofreciendo una experiencia muy cómoda para código. Se presenta como herramienta similar a `grep`, especialmente para búsquedas en árboles grandes de proyectos. citeturn4view4turn4view6

| Herramienta | Ventajas | Inconvenientes | Cuándo usar |
|---|---|---|---|
| `grep` | Ubicua (siempre está); muchas opciones; estándar | Recursivo y exclusiones más manuales | Sistemas mínimos, scripts portables, administración citeturn16view0turn4view0 |
| `rg` | Muy rápida en repos; respeta `.gitignore` por defecto | Puede no estar instalada por defecto | Proyectos de código grandes y búsquedas frecuentes citeturn4view4turn4view6 |

### Advertencias de seguridad y rendimiento
Usar `find`/`xargs` sobre archivos controlados por terceros puede abrir problemas serios, incluyendo escenarios de **elevación de privilegios** si el sistema ejecuta “find de mantenimiento” con permisos elevados. Por eso, hay que extremar cuidado con acciones destructivas (borrados) y con carreras (race conditions) entre listar archivos y operarlos posteriormente. citeturn4view3turn10view8

Buenas prácticas recomendadas:
- **Evita** `find ... -exec rm ...` sin “ensayo”: prueba primero con `-print` o `-ls`. La manpage recalca cuestiones de seguridad con `-exec` y sugiere `-execdir` como alternativa. citeturn11view3turn4view3  
- Para nombres con espacios/saltos de línea: usa `-print0` + `xargs -0` o un bucle leyendo NUL; `-print0` está pensado para esto y `xargs -0` también. citeturn11view2turn15view1  
- **Entrecomilla variables** siempre: `grep -- "$patron"` y `find "$dir"` para evitar interpretaciones inesperadas y “inyecciones” por caracteres especiales/espacios. La propia semántica de comillas y escapes en bash explica por qué. citeturn5view2turn16view0  

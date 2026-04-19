![IES Castro da Uz](https://www.edu.xunta.gal/centros/iescastrodauz/system/files/zeropoint3_logo.jpg)

# Práctica grep — Expresiones regulares

> Entorno creado por `crear_entorno_grepUNIX.sh` en el directorio `practica_grep/`.
> Estructura de ficheros:
> ```
> practica_grep/
> ├── personas.txt
> ├── formularios.txt
> ├── registros.log
> └── internacional.txt
> ```

[Script para a creación do entorno](https://raw.githubusercontent.com/pablomp-Xunta/SMR-SOM-Linux/refs/heads/main/solucionsClase/regex.sh)

---

## EJ 1 — Buscar todos los DNI válidos

Busca en `personas.txt` todas las líneas que contengan un DNI español válido.
Un DNI tiene 8 dígitos seguidos de una letra mayúscula (se excluyen I, O, U y Ñ).

```bash
grep -E "[0-9]{8}[ABCDEFGHJKLMNPQRSTVWXYZ]" practica_grep/personas.txt
```

> - `[0-9]{8}` — exactamente 8 dígitos consecutivos.
> - `[ABCDEFGHJKLMNPQRSTVWXYZ]` — clase de caracteres con las letras válidas del DNI (sin I, O, U, Ñ).
> - `-E` activa ERE (Extended Regular Expressions), necesario para `{8}`.

---

## EJ 2 — Extraer solo el número de DNI

Usando `-o`, extrae únicamente el valor del DNI (sin el resto de la línea) de todos los ficheros `.txt`.

```bash
grep -Eo "[0-9]{8}[ABCDEFGHJKLMNPQRSTVWXYZ]" practica_grep/*.txt
```

> - `-o` imprime solo la parte del texto que coincide con el patrón, no la línea completa.
> - `*.txt` aplica la búsqueda a todos los ficheros de texto del directorio a la vez.
> - La salida incluye el nombre del fichero de origen antes de cada coincidencia (comportamiento por defecto al pasar varios ficheros).

---

## EJ 3 — Detectar DNI con formato incorrecto

En `formularios.txt` hay registros con DNI malformados: menos de 8 dígitos, letra en minúscula o letra inválida.
Encuentra las líneas con campo `doc:` cuyo valor **no** cumple el formato estándar.

```bash
grep "doc:" practica_grep/formularios.txt | grep -Ev "doc: [0-9]{8}[ABCDEFGHJKLMNPQRSTVWXYZ]"
```

> - El primer `grep` filtra solo las líneas que tienen un campo `doc:`.
> - El segundo `grep -v` invierte la búsqueda: selecciona las que **no** coinciden con el patrón de DNI válido.
> - Casos que detecta: `9876543H` (solo 7 dígitos), `A1234567` (empieza por letra), `11001100K` (K no es válida... en realidad sí lo es — este DNI sería formalmente correcto, el entorno lo incluye como caso borde).

---

## EJ 4 — Buscar direcciones de email válidas

Busca en `personas.txt` líneas con un email de formato correcto (`usuario@dominio.tld`).
El usuario puede contener letras, números, `.`, `-`, `_`; el TLD debe tener al menos 2 letras.

```bash
grep -E "[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" practica_grep/personas.txt
```

> - `[a-zA-Z0-9._-]+` — parte local: uno o más caracteres alfanuméricos o `.`, `-`, `_`.
> - `@` — símbolo obligatorio.
> - `[a-zA-Z0-9.-]+` — dominio: letras, números, puntos y guiones.
> - `\.[a-zA-Z]{2,}` — punto obligatorio seguido de al menos 2 letras (TLD).
> - Excluye `elena.torres[arroba]gmail.com` porque no contiene el carácter `@` real.

---

## EJ 5 — Detectar emails sin dominio válido

En `formularios.txt` hay emails incorrectos: sin dominio, con corchetes en lugar de `@`, o sin `@`.
Filtra las líneas cuyo campo `contacto:` **no** contiene un email válido.

```bash
grep "contacto:" practica_grep/formularios.txt | grep -Ev "contacto: [a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"
```

> - El primer `grep` aísla las líneas con campo `contacto:`.
> - `-Ev` invierte: selecciona las que **no** tienen un email con formato válido.
> - Detecta: `no disponible`, `sofia.castro` (sin `@` ni dominio), y cualquier email malformado.

---

## EJ 6 — Emails solo del dominio `gmail.com`

Busca en todos los ficheros `.txt` emails del dominio `gmail.com`. Muestra el fichero de origen.

```bash
grep -EH "[a-zA-Z0-9._-]+@gmail\.com" practica_grep/*.txt
```

> - `-H` fuerza mostrar el nombre del fichero aunque solo se pase uno (con varios ficheros se muestra por defecto).
> - `gmail\.com` — el punto se escapa con `\` para que no actúe como metacarácter (cualquier carácter).
> - Encontrará `ana.garcia@gmail.com` en `personas.txt` y la referencia en `registros.log` si se incluyera, pero aquí se limita a `.txt`.

---

## EJ 7 — Extraer números de móvil españoles de `personas.txt`

Los móviles españoles empiezan por 6 o 7 y tienen 9 dígitos. Pueden aparecer con espacios, guiones o sin separadores.

```bash
grep -Eo "[67][0-9]{2}[ -]?[0-9]{3}[ -]?[0-9]{3}" practica_grep/personas.txt
```

> - `[67]` — primer dígito: 6 o 7.
> - `[0-9]{2}` — dos dígitos más (completan el primer bloque de 3).
> - `[ -]?` — separador opcional: espacio o guion.
> - Patrón repetido para los dos bloques siguientes de 3 dígitos.
> - `-o` extrae solo el número, sin el resto de la línea.

---

## EJ 8 — Móviles con prefijo internacional en `internacional.txt`

Busca móviles que incluyan prefijo `+34` o `0034` y extrae el número completo.

```bash
grep -Eo "(\+34|0034)[ -]?[67][0-9]{2}[ -]?[0-9]{3}[ -]?[0-9]{3}" practica_grep/internacional.txt
```

> - `(\+34|0034)` — alternancia ERE: acepta `+34` o `0034`. El `+` se escapa con `\` porque es metacarácter.
> - `[ -]?` — separador opcional entre el prefijo y el número.
> - El resto del patrón es el mismo que en el ejercicio anterior.

---

## EJ 9 — Contar líneas con móvil válido por fichero

Usa `-c` para contar cuántas líneas con un móvil válido hay en cada fichero `.txt`.

```bash
grep -Ec "[67][0-9]{2}[ -]?[0-9]{3}[ -]?[0-9]{3}" practica_grep/*.txt
```

> - `-c` devuelve el recuento de líneas coincidentes por fichero.
> - `-E` habilita ERE para `{n}`.
> - La salida tiene el formato `fichero:número`, una línea por fichero.

---

## EJ 10 — Líneas en `registros.log` con DNI, email y teléfono a la vez

Encuentra las líneas que contienen los tres tipos de datos simultáneamente, encadenando `grep` con pipes.

```bash
grep -E "[0-9]{8}[ABCDEFGHJKLMNPQRSTVWXYZ]" practica_grep/registros.log \
  | grep -E "[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" \
  | grep -E "[67][0-9]{8}"
```

> - Cada `grep` actúa como filtro adicional sobre la salida del anterior.
> - El primer `grep` selecciona líneas con DNI válido.
> - El segundo filtra de esas solo las que también tienen email válido.
> - El tercero filtra las que además contienen un teléfono de 9 dígitos empezando por 6 o 7 (sin separadores, como aparecen en el log: `tel=666000000`).
> - Resultado esperado: la línea del 15/01 12:45 con `DNI=45678901F`, `email=m.iglesias@univ.edu.es` y `tel=666000000`, y la del 15/01 13:00 con `DNI=44556677M`, `email=diego.morales@empresa.com` y `tel=699112233`.

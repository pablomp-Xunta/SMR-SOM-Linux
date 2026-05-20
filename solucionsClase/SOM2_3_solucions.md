![IES Castro da Uz](https://www.edu.xunta.gal/centros/iescastrodauz/system/files/zeropoint3_logo.jpg)

# Práctica SOM — Variable

> Comezo da práctica co usuario `usuario`.

---

## Parte 1 — Variables básicas

**1. Crear unha variable `nome` e mostrar o seu valor.**

```bash
nome="Pablo"
echo $nome
```

> `nome="Pablo"` asigna o valor `Pablo` á variable.
> `echo $nome` mostra o contido da variable por pantalla.

---

**2. Crear unha variable `idade` e usala nunha mensaxe.**

```bash
idade=30
echo "Teño $idade anos"
```

> As variables númericas non necesitan comiñas na asignación.
> Dentro de `"..."` o `$` expande o valor da variable.

---

**3. Sumar dúas variables numéricas.**

```bash
num1=5
num2=8
echo $((num1 + num2))
```

> `$(( ))` é a sintaxe de aritmética en Bash.
> O resultado da operación móstrase directamente por pantalla.

---

**4. Gardar unha ruta nunha variable e mostrala.**

```bash
ruta="/home/usuario/documentos"
echo $ruta
```

> As rutas con `/` deben ir entre comiñas para evitar problemas de interpretación.

---

**5. Crear unha variable baleira e comprobar o seu contido.**

```bash
vacia=""
echo "Contido: '$vacia'"
```

> Asignar `""` crea unha variable baleira.
> As comiñas simples dentro da mensaxe permiten ver claramente se hai contido ou non.

---

**6. Cambiar o valor dunha variable.**

```bash
cidade="Vigo"
echo $cidade
cidade="Madrid"
echo $cidade
```

> Unha variable pode ser reasignada simplemente escribindo `variable=novovalor`.
> Non se usa `$` na asignación, só na lectura.

---

## Parte 2 — Variables de entorno

**7. Mostrar o usuario actual.**

```bash
echo $USER
```

> `$USER` é unha variable de entorno que contén o nome do usuario da sesión activa.

---

**8. Mostrar as principais variables de entorno do sistema.**

```bash
echo $HOME
echo $PATH
echo $SHELL
```

> `$HOME` indica o directorio persoal do usuario.
> `$PATH` lista os directorios onde o sistema busca os executables.
> `$SHELL` mostra o intérprete de comandos en uso.

---

## Parte 3 — Variables con entrada e operacións

**9. Crear un arquivo usando o nome gardado nunha variable.**

```bash
arquivo="proba.txt"
touch $arquivo
```

> `touch` crea o arquivo se non existe.
> Usar unha variable permite reutilizar o nome en varios comandos sen repetilo.

---

**10. Ler o nome do usuario por teclado e saudalo.**

```bash
read -p "Introduce o teu nome: " nome
echo "Ola $nome"
```

> `read -p` mostra unha mensaxe de solicitude e garda o valor introducido na variable indicada.

---

**11. Ler dous números e mostrar suma, resta e multiplicación.**

```bash
read -p "Introduce o primeiro número: " n1
read -p "Introduce o segundo número: " n2
echo "Suma: $((n1 + n2))"
echo "Resta: $((n1 - n2))"
echo "Multiplicación: $((n1 * n2))"
```

> `$(( ))` permite realizar as catro operacións aritméticas básicas.
> Cada operación indícase co seu operador: `+`, `-`, `*`, `/`.

---

**12. Gardar unha frase con espazos nunha variable e mostrala.**

```bash
frase="Ola mundo Linux"
echo "$frase"
```

> Os valores con espazos deben ir entre comiñas dobres na asignación.
> Ao facer `echo`, tamén é recomendable usar `"$frase"` para preservar os espazos.

---

## Parte 4 — Substitución de comandos

**13. Gardar a data actual nunha variable e mostrala.**

```bash
data=$(date)
echo $data
```

> `$(comando)` executa o comando e garda a súa saída na variable.
> Esta sintaxe coñécese como substitución de comandos.

---

**14. Gardar o directorio actual nunha variable e mostralo.**

```bash
directorio=$(pwd)
echo $directorio
```

> `pwd` devolve a ruta do directorio de traballo actual.
> `$(pwd)` captura esa saída e almacénaa na variable `directorio`.

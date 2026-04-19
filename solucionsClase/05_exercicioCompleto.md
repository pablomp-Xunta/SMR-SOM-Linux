![IES Castro da Uz](https://www.edu.xunta.gal/centros/iescastrodauz/system/files/zeropoint3_logo.jpg)

# Práctica SOM4_5 — Solucións

> Comezo da práctica co usuario `user`.

---

## Parte 1 — Xestión de usuarios e grupos

**1. Crear o usuario co nome e iniciais do apelido (opcións `-m -s /bin/bash`).**

```bash
sudo useradd -m -s /bin/bash alumnoXX
```

> `-m` crea o directorio home automaticamente.
> `-s /bin/bash` asigna Bash como shell de inicio de sesión.

---

**2. Asignarlle contrasinal.**

```bash
sudo passwd alumnoXX
```

> O sistema pedirá o contrasinal dúas veces para confirmación.

---

**3. Darlle permisos de sudo.**

```bash
sudo usermod -aG sudo alumnoXX
```

> `-aG` engade o usuario ao grupo indicado sen eliminar os grupos existentes.

---

**4. Crear un grupo chamado `alumnado`.**

```bash
sudo groupadd alumnado
```

> Crea o grupo `alumnado` no sistema.

---

**5. Engadir o usuario ao grupo `alumnado`.**

```bash
sudo usermod -aG alumnado alumnoXX
```

---

**6. Verificar que o usuario pertence ao grupo `alumnado`.**

```bash
groups alumnoXX
```

> Mostra todos os grupos aos que pertence o usuario.

---

**7. Cambiar ao novo usuario.**

```bash
su - alumnoXX
```

> `su -` abre unha sesión completa co novo usuario, cargando o seu entorno (`$HOME`, `$PATH`, etc.).

> De agora en adiante, todo se realiza co usuario recén creado.

---

## Parte 2 — Estrutura de directorios e arquivos

**1. Crear a estrutura de directorios en `~/exame/`.**

```bash
mkdir -p ~/exame/{documentos,copias,oculto,logs}
```

> `-p` crea os directorios intermedios se non existen.
> As chaves `{}` permiten crear varios subdirectorios nun só comando.

Estrutura resultante:

```
~/exame/
├── documentos/
├── copias/
├── oculto/
└── logs/
```

---

**2. Crear os arquivos `documentos/nota.txt`, `documentos/lista.txt` e `logs/sistema.log`.**

```bash
touch ~/exame/documentos/nota.txt ~/exame/documentos/lista.txt ~/exame/logs/sistema.log
```

> `touch` crea arquivos baleiros se non existen, ou actualiza a data de modificación se xa existen.

---

**3. Engadir contido en `logs/sistema.log`.**

**a) Engadir `'usuario admin erro acceso'`:**

```bash
echo 'usuario admin erro acceso' >> ~/exame/logs/sistema.log
```

**b) Engadir `'usuario alumno login correcto'`:**

```bash
echo 'usuario alumno login correcto' >> ~/exame/logs/sistema.log
```

**c) Engadir `'erro grave sistema'`:**

```bash
echo 'erro grave sistema' >> ~/exame/logs/sistema.log
```

> `>>` engade ao final do arquivo sen sobreescribir o contido existente.

---

**4. Crear un arquivo oculto `oculto/.segredo.txt`.**

```bash
touch ~/exame/oculto/.segredo.txt
```

> Os arquivos que comezan por `.` son ocultos en Linux; non aparecen con `ls` sen a opción `-a`.

---

**5. Editar `nota.txt` con `nano` e escribir polo menos 5 liñas.**

```bash
nano ~/exame/documentos/nota.txt
```

> Escribir alomenos 5 liñas e gardar con `Ctrl+O`, saír con `Ctrl+X`.

**a) Mostrar as 3 primeiras liñas:**

```bash
head -3 ~/exame/documentos/nota.txt
```

> `head -n` mostra as primeiras `n` liñas do arquivo.

**b) Mostrar as 2 últimas:**

```bash
tail -2 ~/exame/documentos/nota.txt
```

> `tail -n` mostra as últimas `n` liñas do arquivo.

**c) Contar o número de liñas:**

```bash
wc -l ~/exame/documentos/nota.txt
```

> `wc -l` conta o número de saltos de liña no arquivo.

---

**6. Crear enlaces.**

**a) Enlace duro de `nota.txt` en `copias/`:**

```bash
ln ~/exame/documentos/nota.txt ~/exame/copias/nota.txt
```

> Un enlace duro apunta ao mesmo inodo que o arquivo orixinal. Calquera modificación reflíctese en ambos.

**b) Enlace simbólico de `lista.txt`:**

```bash
ln -s ~/exame/documentos/lista.txt ~/exame/copias/lista_enlace.txt
```

> `-s` crea un enlace simbólico (acceso directo) que apunta á ruta do arquivo orixinal.

**c) Comprobar o número de enlaces duros:**

```bash
ls -l ~/exame/documentos/nota.txt
```

> O terceiro campo numérico de `ls -l` indica o número de enlaces duros do inodo.

```bash
stat ~/exame/documentos/nota.txt
```

> O campo `Links:` de `stat` mostra o contador de enlaces duros de forma explícita.

---

**7. Copiar `nota.txt` a `copias/`.**

```bash
cp ~/exame/documentos/nota.txt ~/exame/copias/
```

> `cp` crea unha copia independente; non comparte inodo co orixinal.

---

**8. Mover `lista.txt` a `copias/`.**

```bash
mv ~/exame/documentos/lista.txt ~/exame/copias/
```

> `mv` desprazao ao novo directorio; a ruta orixinal deixa de existir.

---

**9. Renomear `lista.txt` a `novalista.txt`.**

```bash
mv ~/exame/copias/lista.txt ~/exame/copias/novalista.txt
```

> `mv` dentro do mesmo directorio equivale a renomear.

---

**10. Eliminar a carpeta `logs` e os seus arquivos.**

```bash
rm -r ~/exame/logs
```

> `-r` elimina o directorio e todo o seu contido de forma recursiva.

---

**11. Cambiar permisos de `nota.txt` a `rwxr-----`.**

```bash
chmod 740 ~/exame/documentos/nota.txt
```

> `7` = `rwx` (propietario), `4` = `r--` (grupo), `0` = `---` (outros).

---

**12. Cambiar propietario de `nota.txt` a `user:alumnado`.**

```bash
sudo chown user:alumnado ~/exame/documentos/nota.txt
```

> `chown usuario:grupo` cambia o propietario e o grupo do arquivo.

---

## Parte 3 — Buscas en `/buscaqueigualatopas`

> Entorno creado por script. Estrutura relevante:
>
> ```
> /buscaqueigualatopas/
> ├── docs/    → app.log  app1.log  APP.log  error.txt  erro.txt
> ├── logs/    → system.log  system_error.log  debug.LOG
> ├── oculto/  → .segredo.txt
> ├── .hidden/ → .oculto.log
> └── deep/n1/n2/ → ultimo.log
> ```
>
[Scriot para crear o entorno](https://raw.githubusercontent.com/pablomp-Xunta/SMR-SOM-Linux/refs/heads/main/solucionsClase/estructuraProcura.sh)

---

**1. Buscar todos os arquivos `.log`.**

```bash
find /buscaqueigualatopas -name "*.log"
```

> Busca de forma recursiva todos os arquivos cuxa extensión sexa `.log` (sensible a maiúsculas).
> Non atopará `debug.LOG` nin `.oculto.log` con este patrón exacto.

---

**2. Buscar todos os `.log` ignorando maiúsculas.**

```bash
find /buscaqueigualatopas -iname "*.log"
```

> `-iname` fai a comparación case-insensitive.
> Atopará `app.log`, `APP.log`, `debug.LOG`, `.oculto.log`, etc.

---

**3. Encontrar arquivos ocultos.**

```bash
find /buscaqueigualatopas -name ".*"
```

> Os arquivos ocultos en Linux comezan por `.`. O patrón `".*"` coincide con calquera nome que comece por punto.

Para incluír tamén directorios ocultos:

```bash
find /buscaqueigualatopas -name ".*" -ls
```

> `-ls` mostra información detallada (permisos, tamaño, inodo) de cada resultado.

---

**4. Buscar a palabra `"error"` en todos os logs.**

```bash
find /buscaqueigualatopas -iname "*.log" -exec grep -i "error" {} \;
```

> `-iname "*.log"` localiza os arquivos de log independentemente de maiúsculas.
> `grep -i "error"` busca o termo sen distinguir entre `Error`, `ERROR`, `erro`...

Para ver tamén o nome do arquivo en cada resultado:

```bash
find /buscaqueigualatopas -iname "*.log" -exec grep -il "error" {} \;
```

> `-l` mostra só o nome dos arquivos que conteñen a coincidencia.

---

**5. Contar cantas veces aparece `"error"`.**

```bash
grep -ri "error" /buscaqueigualatopas --include="*.log" | wc -l
```

> `grep -r` busca recursivamente; `-i` ignora maiúsculas.
> `wc -l` conta o número de liñas coincidentes (cada liña = unha aparición).

Para ver o reconto por arquivo:

```bash
grep -ric "error" /buscaqueigualatopas --include="*.log"
```

> `-c` mostra o número de liñas coincidentes en cada arquivo por separado.

---

**6. Atopar en que arquivo aparece `"erro menor"`.**

```bash
grep -rl "erro menor" /buscaqueigualatopas
```

> `-r` busca recursivamente en todos os subdirectorios.
> `-l` devolve só o nome do arquivo, non as liñas.
>
> Resultado esperado: `/buscaqueigualatopas/deep/n1/n2/ultimo.log`

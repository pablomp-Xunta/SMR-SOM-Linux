![IES Castro da Uz](https://www.edu.xunta.gal/centros/iescastrodauz/system/files/zeropoint3_logo.jpg)

# Práctica SOM — Xestión de Discos en Linux

> Engadir un disco virtual en VirtualBox, particionalo, formatealo e configurar o montaxe automático.

---

## Parte 1 — Consultar o estado actual dos discos

**1. Mostrar discos, particións e puntos de montaxe.**

```bash
lsblk
```

> Lista todos os discos e particións do sistema en formato árbore, incluíndo os puntos de montaxe activos.

---

**2. Información detallada de discos e particións.**

```bash
sudo fdisk -l
```

> Mostra o tamaño, tipo e estrutura de cada disco recoñecido polo sistema.

---

## Parte 2 — Engadir un novo disco virtual de 5 GB en VirtualBox

**1. Apagar a máquina virtual.**

**2. En VirtualBox, coa máquina apagada:**

- **Configuración** → **Almacenamento**
- Engadir disco duro
- Crear novo disco **VDI**
- Tamaño: **5 GB**

**3. Iniciar novamente a máquina virtual.**

---

## Parte 3 — Identificar o novo disco engadido

**1. Volver a comprobar os discos.**

```bash
lsblk
```

ou:

```bash
sudo fdisk -l
```

> O novo disco normalmente aparecerá como `/dev/sdb`, sen particións.

---

## Parte 4 — Crear unha táboa de particións GPT

> Podes usar `fdisk` ou `parted` indistintamente. Escolle unha das dúas opcións.

---

**Opción A — con `fdisk`**

`fdisk` é interactivo: abre un intérprete onde executas ordes unha a unha.

```bash
sudo fdisk /dev/sdb
```

Dentro do intérprete, escribe `g` para crear a táboa GPT:

```
g
```

> Crea unha nova táboa de particións de tipo GPT.

Garda os cambios e sae:

```
w
```

> `w` escribe os cambios no disco e pecha `fdisk`.

---

**Opción B — con `parted`**

`parted` permite executar operacións directamente desde a liña de comandos, sen intérprete interactivo.

```bash
sudo parted /dev/sdb mklabel gpt
```

> Os cambios aplícanse de inmediato; non é necesario gardar.

---

## Parte 5 — Crear unha partición usando todo o espazo

> Continúa coa mesma ferramenta que usaches na Parte 4.

---

**Opción A — con `fdisk`**

```bash
sudo fdisk /dev/sdb
```

Dentro do intérprete, escribe `n` para crear unha nova partición:

```
n
```

Acepta **todas as opcións por defecto** premendo `Enter` para:

- Número de partición
- Primeiro sector
- Último sector

> Usar os valores por defecto crea unha única partición que ocupa todo o disco.

Garda os cambios:

```
w
```

---

**Opción B — con `parted`**

```bash
sudo parted /dev/sdb mkpart primary ext4 0% 100%
```

> Crea unha partición primaria que ocupa o 100% do disco. Os cambios aplícanse ao instante.

---

**Comprobar o resultado:**

```bash
lsblk
```

> Debería aparecer `/dev/sdb1` como nova partición baixo `/dev/sdb`.

---

## Parte 6 — Crear un sistema de arquivos

**1. Formatear a partición en ext4.**

```bash
sudo mkfs.ext4 /dev/sdb1
```

> `mkfs.ext4` formatea a partición co sistema de arquivos ext4, o máis habitual en Linux.

---

## Parte 7 — Crear o punto de montaxe

**1. Crear o directorio.**

```bash
sudo mkdir /datos
```

> O punto de montaxe é o directorio do sistema onde quedará accesible o contido do disco.

**2. Comprobar que se creou.**

```bash
ls /
```

> `/datos` debería aparecer na lista de directorios raíz.

---

## Parte 8 — Montar a partición

**1. Montar manualmente.**

```bash
sudo mount /dev/sdb1 /datos
```

> Asocia a partición `/dev/sdb1` co directorio `/datos`. A partición queda accesible desde ese momento.

**2. Crear un arquivo de proba.**

```bash
sudo touch /datos/proba.txt
```

**3. Comprobar o acceso.**

```bash
ls /datos
```

> Deberían aparecer `lost+found` (creado polo formato ext4) e `proba.txt`.

---

## Parte 9 — Verificar o montaxe

**1. Ver puntos de montaxe e espazo dispoñible.**

```bash
df -h
```

> `-h` mostra os tamaños en formato lexible (GB, MB). `/datos` debería aparecer na lista.

**2. Filtrar o montaxe de `sdb1`.**

```bash
mount | grep sdb1
```

> Mostra a liña correspondente a `/dev/sdb1` cos detalles do montaxe activo.

---

## Parte 10 — Obter o UUID

**1. Mostrar o UUID de todas as particións.**

```bash
sudo blkid
```

> O UUID (Universally Unique Identifier) é un identificador único que non cambia aínda que o disco se mova a outro conector.

Exemplo de saída:

```
/dev/sdb1: UUID="2a3d4f5e-1234-5678-90ab-cdef12345678" TYPE="ext4"
```

> Copia o UUID de `/dev/sdb1`; necesitarase no seguinte paso.

---

## Parte 11 — Configurar o montaxe automático

**1. Editar o arquivo `/etc/fstab`.**

```bash
sudo nano /etc/fstab
```

**2. Engadir ao final do arquivo esta liña (co UUID real):**

```
UUID=2a3d4f5e-1234-5678-90ab-cdef12345678 /datos ext4 defaults 0 2
```

> Significado dos campos:
>
> | Campo | Valor | Descrición |
> |-------|-------|------------|
> | Dispositivo | `UUID=...` | Identificador único do disco |
> | Punto de montaxe | `/datos` | Directorio onde se monta |
> | Sistema de arquivos | `ext4` | Formato da partición |
> | Opcións | `defaults` | Opcións estándar de montaxe |
> | dump | `0` | Sen copia de seguridade con dump |
> | pass | `2` | Comprobación fsck no arranque (2 = non raíz) |

**3. Gardar e saír:** `Ctrl+O`, `Enter`, `Ctrl+X`.

---

## Parte 12 — Comprobar a configuración sen reiniciar

**1. Desmontar a partición.**

```bash
sudo umount /datos
```

> Desvincula a partición do directorio `/datos`.

**2. Montar todo o definido en `fstab`.**

```bash
sudo mount -a
```

> `-a` monta todas as entradas de `/etc/fstab` que non estean xa montadas. Serve para verificar que a liña engadida é correcta sen reiniciar.

**3. Verificar.**

```bash
df -h
```

> Se `/datos` aparece na lista, a configuración é correcta e o disco montarase automaticamente en cada arranque.

---

## `fdisk` vs `parted`

| Característica | `fdisk` | `parted` |
|----------------|---------|----------|
| Modo de uso | Interactivo (intérprete) | Interactivo ou liña única |
| Aplica cambios | Ao gardar con `w` | De inmediato |
| Soporte GPT | Si (versións recentes) | Si (soporte nativo) |
| Soporte MBR | Si | Si |
| Discos > 2 TB | Limitado (MBR) / Si (GPT) | Si |
| Scripting | Máis complexo | Máis sinxelo |
| Dispoñibilidade | Case sempre presente | Pode requirir instalación |

> `fdisk` é suficiente para a maioría das situacións en aula. `parted` é preferible para automatizar operacións ou traballar con discos grandes en contornos de produción.

---

## Resumo de comandos

| Comando | Descrición |
|---------|------------|
| `lsblk` | Lista discos e particións en formato árbore |
| `sudo fdisk -l` | Información detallada de todos os discos |
| `sudo fdisk /dev/sdb` | Abre o editor interactivo de particións |
| `sudo parted /dev/sdb mklabel gpt` | Crea táboa GPT con parted |
| `sudo parted /dev/sdb mkpart primary ext4 0% 100%` | Crea unha partición ocupando todo o disco |
| `sudo mkfs.ext4 /dev/sdb1` | Formatea unha partición en ext4 |
| `sudo mkdir /datos` | Crea o directorio de montaxe |
| `sudo mount /dev/sdb1 /datos` | Monta unha partición nun directorio |
| `sudo umount /datos` | Desmonta unha partición |
| `df -h` | Mostra espazo en disco e puntos de montaxe |
| `mount \| grep sdb1` | Filtra os montaxes activos |
| `sudo blkid` | Mostra UUID e tipo de cada partición |
| `sudo nano /etc/fstab` | Edita a configuración de montaxe automático |
| `sudo mount -a` | Monta todo o definido en `/etc/fstab` |

---

> **Nota:** Substitúe sempre o UUID do exemplo polo UUID real que obteñas con `sudo blkid` na túa máquina. Usar un UUID incorrecto en `/etc/fstab` pode impedir que o sistema arranque correctamente.

![IES Castro da Uz](https://www.edu.xunta.gal/centros/iescastrodauz/system/files/zeropoint3_logo.jpg)

# Práctica SOM — Scripts, Procesos, Servizos, Rede e Cron

> Comezo da práctica co usuario `user`.

---

## Parte 1 — Scripts executables

**1. Crear un script básico `hola.sh` que mostre información do sistema.**

```bash
#!/bin/bash
echo "Ola mundo"
date
whoami
```

> `#!/bin/bash` é o *shebang*: indica ao sistema que o intérprete que executará o script é Bash.
> `date` mostra a data e hora actuais; `whoami` mostra o usuario que executa o script.

---

**2. Dar permisos de execución ao script e comprobalos.**

```bash
chmod +x hola.sh
ls -l hola.sh
```

> `chmod +x` engade o permiso de execución para o propietario, o grupo e outros.
> `ls -l` permite verificar os permisos; unha saída típica é `-rwxr-xr-x`.

---

**3. Executar o script dende o directorio actual.**

```bash
./hola.sh
```

> `./` indica que o script está no directorio actual.
> Sen este prefixo, o sistema non buscaría o arquivo no directorio de traballo.

---

**4. Executar o script sen permisos de execución.**

```bash
bash hola.sh
```

> Pasando o script como argumento a `bash`, non é necesario que teña o bit de execución activado.

---

**5. Crear un script con unha variable simple.**

```bash
#!/bin/bash
NOME="Pablo"
echo "Ola $NOME"
```

> As variables en Bash asígnanse sen espazos ao redor do `=`.
> Dentro de `"..."` o `$` expande o valor da variable.

---

**6. Crear un script que lea o nome do usuario por teclado.**

```bash
#!/bin/bash
read -p "Introduce o teu nome: " nome
echo "Ola $nome"
```

> `read -p` mostra unha mensaxe de solicitude e garda o valor introducido na variable indicada.

---

**7. Crear un script con condición para comprobar se o usuario é root.**

```bash
#!/bin/bash
if [ "$USER" = "root" ]; then
    echo "Es root"
else
    echo "Non es root"
fi
```

> `if [ condición ]` avalía a expresión; `$USER` contén o nome do usuario activo.
> O bloque `else` execútase cando a condición non se cumpre; `fi` pecha a estrutura.

---

## Parte 2 — Script Bash para crear usuarios

**8. Crear o script `crear_usuario.sh`.**

```bash
#!/bin/bash

nome="PABLO"
equipo=$HOSTNAME
data=$(date)

echo "CREAR USUARIO $nome no PC $equipo"

sudo useradd -m -s /bin/bash $nome

echo "FIN - $data"
```

> `$HOSTNAME` é unha variable de entorno co nome do equipo.
> `$(date)` captura a saída do comando `date` e gárdaa na variable `data`.
> `-m` crea o directorio persoal do usuario automaticamente.
> `-s /bin/bash` asigna Bash como shell de inicio de sesión.

---

**9. Dar permisos de execución e executar o script.**

```bash
chmod +x crear_usuario.sh
./crear_usuario.sh
```

> É necesario activar o bit de execución antes de lanzar o script con `./`.

---

## Parte 3 — Procesos

**10. Ver todos os procesos do sistema.**

```bash
ps aux
```

> `ps aux` mostra todos os procesos activos con usuario, PID, uso de CPU e memoria.

---

**11. Buscar un proceso concreto.**

```bash
ps aux | grep ssh
```

> A saída de `ps aux` pásase a `grep` para filtrar só as liñas que conteñen `ssh`.

---

**12. Ver os procesos en tempo real.**

```bash
top
```

> `top` actualiza a lista de procesos cada poucos segundos. Pódese saír premendo `q`.
> Alternativamente, `htop` ofrece unha interface máis visual (instalar con `sudo apt install htop`).

---

**13. Executar un proceso en segundo plano e xestionalo.**

**a)** Lanzar un proceso en foreground e suspendelo:

```bash
sleep 100
```

> A terminal queda bloqueada mentres o proceso está en foreground.
> `Ctrl + Z` suspende o proceso e devolve o control ao terminal.

**b)** Ver os traballos suspendidos e envialo a background:

```bash
jobs
bg
```

> `jobs` lista os procesos suspendidos ou en background da sesión actual.
> `bg` retoma o último proceso suspendido en segundo plano.

**c)** Volver a traer o proceso a foreground:

```bash
fg
```

> `fg` retoma en foreground o traballo indicado (ou o último se non se especifica número).

**d)** Lanzar un proceso directamente en background:

```bash
sleep 100 &
```

> O `&` ao final do comando lanza o proceso en segundo plano sen bloquear o terminal.

---

**14. Obter o PID dun proceso e matalo.**

```bash
ps aux | grep sleep
kill PID
```

> `kill PID` envía o sinal `TERM` ao proceso para que remate limpiamente.
> Se non responde, usar `kill -9 PID` para forzar a terminación inmediata.

---

## Parte 4 — Servizos con systemd

**15. Instalar e comprobar o estado do servizo SSH.**

```bash
sudo apt update
sudo apt install openssh-server
systemctl status ssh
```

> `systemctl status` mostra se o servizo está activo, inactivo ou con erro, e as últimas liñas do log.

---

**16. Iniciar, parar e reiniciar o servizo SSH.**

```bash
sudo systemctl start ssh
sudo systemctl stop ssh
sudo systemctl restart ssh
```

> `start` arranca o servizo, `stop` párао e `restart` faino os dous seguidos.

---

**17. Activar e desactivar o inicio automático do servizo.**

```bash
sudo systemctl enable ssh
sudo systemctl disable ssh
systemctl is-enabled ssh
```

> `enable` fai que o servizo arrinque automaticamente con cada inicio do sistema.
> `is-enabled` confirma se está habilitado ou non sen necesidade de reiniciar.

---

**18. Ver portos abertos e conectarse por SSH.**

```bash
ss -tulnp
ip a
ssh alumno@192.168.1.50
```

> `ss -tulnp` mostra os portos en escoita; o porto 22 indica que SSH está activo.
> `ip a` mostra a IP da máquina para poder conectarse dende outro equipo.

---

**19. Limpar a pantalla do terminal.**

```bash
clear
```

> `clear` borra o contido visible do terminal e deixa o cursor na parte superior.

---

**20. Mostrar todos os servizos cargados polo sistema.**

```bash
sudo systemctl list-units --type=service --all
```

> `--type=service` filtra para mostrar só os servizos.
> `--all` inclúe tamén os servizos inactivos ou con erro, non só os activos.

## Parte 5 — Configuración de rede

**21. Ver as interfaces de rede dispoñibles.**

```bash
ip a
```

> `ip a` (abreviatura de `ip address`) lista todas as interfaces e as súas IPs asignadas.

---

**22. Configurar a rede con DHCP mediante `/etc/network/interfaces`.**

```bash
sudo nano /etc/network/interfaces
```

```
auto enp0s3
iface enp0s3 inet dhcp
```

> `auto enp0s3` fai que a interface se active ao arrancar.
> `inet dhcp` indica que a IP se obterá automaticamente dun servidor DHCP.

---

**23. Configurar unha IP estática.**

```
auto enp0s3
iface enp0s3 inet static
    address 192.168.1.100
    netmask 255.255.255.0
    gateway 192.168.1.1
    dns-nameservers 8.8.8.8
```

> `static` substitúe a `dhcp` para asignar unha IP fixa.
> `gateway` indica a porta de enlace predeterminada; `dns-nameservers` define o servidor DNS.

---

**24. Reiniciar a rede e comprobar conectividade.**

```bash
sudo systemctl restart networking
ping 8.8.8.8
ip route
```

> `ping` comproba que hai conectividade con Internet.
> `ip route` mostra a táboa de rutas para verificar o gateway configurado.

---

## Parte 7 — Cron: tarefas programadas

**25. Abrir o editor de tarefas programadas.**

```bash
crontab -e
```

> `crontab -e` abre o arquivo de tarefas do usuario no editor por defecto.
> O formato de cada liña é: `minuto hora día_mes mes día_semana comando`.

---

**26. Engadir tarefas programadas con distintas frecuencias.**

**a)** Executar cada minuto:

```bash
* * * * * echo "Ola" >> /tmp/ola.txt
```

> `* * * * *` en todos os campos significa "cada minuto de cada hora de cada día".
> `>>` redirixe a saída engadindo ao final do arquivo sen sobreescribilo.

**b)** Executar todos os días ás 14:30:

```bash
30 14 * * * /home/alumno/script.sh
```

> `30 14` indica o minuto 30 da hora 14; `* * *` significa todos os días, meses e días da semana.

**c)** Executar ao arrancar o sistema:

```bash
@reboot /home/alumno/inicio.sh
```

> `@reboot` é un atallo especial de cron que executa o comando cada vez que o sistema arrinca.

---

**27. Engadir a tarefa do script `tarea.sh` para executala todos os días ás 13:05.**

```bash
5 13 * * * root bash /home/user/tarea.sh
```

> `5 13` corresponde ás 13:05; `* * *` execútaa todos os días sen restrición de día ou mes.

---

**28. Crear o script `tarea.sh` para verificar que cron funciona.**

```bash
#!/bin/bash
echo "CRON FUNCIONANDO - $(date)"
```

> Cada execución rexistrará a data e hora actuais na saída configurada ou no log do sistema.

---

**29. Dar permisos de execución a `tarea.sh`.**

```bash
chmod +x /home/user/tarea.sh
```

> É necesario que o script teña permiso de execución para que cron poida lanzalo.

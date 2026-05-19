![IES Castro da Uz](https://www.edu.xunta.gal/centros/iescastrodauz/system/files/zeropoint3_logo.jpg)

# Despregamento dunha IA en Ubuntu Server con GPU NVIDIA

---

## Parte A — Instalar os drivers de NVIDIA

> Guía de referencia: [How to install NVIDIA drivers on Ubuntu Server](https://askubuntu.com/questions/1324784/how-to-install-nvidia-drivers-on-ubuntu-server)

---

**1. Eliminar calquera instalación previa.**

```bash
sudo apt-get purge nvidia*
sudo apt-get autoremove
```

> ⚠️ **Importante:** Este paso é imprescindible antes de calquera instalación nova para evitar conflitos.

---

**2. Descargar o driver de NVIDIA.**

```bash
cd ~/
wget http://us.download.nvidia.com/XFree86/Linux-x86_64/460.67/NVIDIA-Linux-x86_64-460.67.run
```

> Consultar a versión máis recente en [nvidia.com/drivers/unix](https://www.nvidia.com/es-es/drivers/unix/) e substituír o número de versión no comando anterior.

---

**3. Instalar as dependencias necesarias.**

```bash
sudo apt-get install build-essential gcc-multilib dkms
```

---

**4. Executar o instalador.**

```bash
cd ~/
sudo chmod +x NVIDIA-Linux-x86_64-460.67.run
sudo ./NVIDIA-Linux-x86_64-460.67.run
```

> ⚠️ **Importante:** É necesario instalar a versión MIT/GPL. Cos drivers propietarios, CUDA non funcionará correctamente. Ver [motivo](https://askubuntu.com/questions/1553084/nvidia-smi-displays-no-devices-were-found).

Durante a instalación pode aparecer o seguinte aviso, que se pode ignorar con seguridade:

```
WARNING: nvidia-installer was forced to guess the X library path '/usr/lib' and X module
path '/usr/lib/xorg/modules'; these paths were not queryable from the system. If X fails
to find the NVIDIA X driver module, please install the `pkg-config` utility and the X.Org
SDK/development package for your distribution and reinstall the driver.
```

---

**5. Comprobar a instalación.**

```bash
nvidia-smi
```

> Se a instalación foi correcta, o comando devolve información detallada da GPU detectada. A resolución de pantalla tamén se adaptará automaticamente.

---

## Parte B — Instalar CUDA e cuDNN

> Guía de referencia: [Install CUDA drivers (gist)](https://gist.github.com/denguir/b21aa66ae7fb1089655dd9de8351a202#install-cuda-drivers)
>
> As seguintes guías foron consultadas pero levaron a erros de instalación ou incompatibilidades cos drivers:
> - [Documentación oficial de NVIDIA](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/)
> - [CUDA Downloads](https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=24.04&target_type=deb_local)
> - [Ask Ubuntu](https://askubuntu.com/questions/1077061/how-do-i-install-nvidia-and-cuda-drivers-into-ubuntu)
> - [Medium – Julius Eric Tuliao](https://medium.com/@juliuserictuliao/documentation-installing-cuda-on-ubuntu-22-04-2c5c411df843)

---

**1. Instalar o CUDA toolkit.**

```bash
sudo apt update && sudo apt upgrade
sudo apt install nvidia-cuda-toolkit
```

---

**2. Comprobar a instalación de CUDA.**

```bash
nvcc --version
```

> Se a instalación foi correcta, devolve a versión do compilador CUDA instalado.

---

**3. Instalar cuDNN.**

```bash
sudo apt install ./<filename.deb>
sudo cp /var/cudnn-<something>.gpg /usr/share/keyrings/

sudo apt update
sudo apt install libcudnn8
sudo apt install libcudnn8-dev
sudo apt install libcudnn8-samples
```

> Substituír `<filename.deb>` e `<something>` polos nomes reais do paquete descargado desde o portal de NVIDIA.

---

## Parte C — Instalar Ollama

> Guía de referencia: [Documentación oficial de Ollama](https://docs.ollama.com/linux)

---

**1. Instalar Ollama.**

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

> O script de instalación detecta automaticamente se CUDA está dispoñible e configura Ollama para usar a GPU.

---

**2. Comprobar que o modelo usa a GPU.**

```bash
ollama ps
```

> Con algún modelo en execución, este comando mostra os recursos que está a empregar. Se CUDA foi detectado correctamente, aparecerá a GPU na columna correspondente.

---

## Parte D — Instalar Open WebUI

> Guía de referencia: [README do repositorio de Open WebUI](https://github.com/open-webui/open-webui)
>
> A interface desprégase e queda dispoñible no **porto 8080**.

---

**1. Lanzar o contedor de Open WebUI con Docker.**

```bash
docker run -d \
  --network=host \
  -e OLLAMA_BASE_URL=http://127.0.0.1:11434 \
  -v open-webui:/app/backend/data \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:main
```

> `--network=host` permite ao contedor comunicarse directamente con Ollama sen configuración adicional de rede.
> `--restart always` fai que o contedor se reinicie automaticamente co sistema.

---

**2. Configurar Ollama se o conector non funciona.**

Editar o arquivo de configuración do servizo:

```bash
sudo systemctl edit ollama
```

Engadir as seguintes liñas:

```ini
[Service]
Environment="OLLAMA_HOST=0.0.0.0"
```

Aplicar os cambios e reiniciar o servizo:

```bash
sudo systemctl daemon-reexec
sudo systemctl restart ollama
sudo ufw allow 11434/tcp
```

> `OLLAMA_HOST=0.0.0.0` fai que Ollama escoite en todas as interfaces de rede, non só en localhost.
> A regra de `ufw` abre o porto 11434 para permitir a comunicación co contedor de Open WebUI.

---

## Parte E — Ollama + Open WebUI: xestión e configuración

### E.1 — Liberar a memoria da GPU ao terminar o chat

Por defecto, Ollama mantén o modelo cargado en VRAM durante **5 minutos** tras a última petición (parámetro `keep_alive`). Isto acelera as respostas seguintes, pero ocupa a GPU innecesariamente cando rematamos de usar o chat.

**Opción 1 — Descarga inmediata por API (recomendada).**

Enviar unha petición co parámetro `keep_alive: 0` ao mesmo modelo que está en memoria:

```bash
curl http://localhost:11434/api/generate \
  -d '{"model": "llama3.2", "keep_alive": 0}'
```

> O nome do modelo debe coincidir exactamente co que está cargado. Pódese consultar con `ollama ps`.
> Se se indica un modelo diferente ao que está activo, o comando non terá efecto.

**Opción 2 — Parar o modelo dende a CLI.**

```bash
# Ver os modelos activos e o seu uso de recursos
ollama ps

# Parar un modelo concreto
ollama stop llama3.2

# Parar todos os modelos activos dunha vez
ollama stop $(ollama ps -q)
```

**Opción 3 — Configurar o tempo de descarga global.**

Modificar o tempo de espera por defecto a nivel de servizo:

```bash
sudo systemctl edit ollama
```

Engadir:

```ini
[Service]
Environment="OLLAMA_KEEP_ALIVE=0"
```

> Con `OLLAMA_KEEP_ALIVE=0` o modelo descárgase xusto ao rematar cada resposta.
> Con `OLLAMA_KEEP_ALIVE=-1` mantense en memoria indefinidamente (útil en producción con tráfico continuo).
> Con `OLLAMA_KEEP_ALIVE=10m` mantense 10 minutos (formato duración: `s`, `m`, `h`).

Aplicar os cambios:

```bash
sudo systemctl daemon-reexec
sudo systemctl restart ollama
```

**Verificar o estado da VRAM en calquera momento:**

```bash
nvidia-smi
```

---

### E.2 — Tuning: modificar os parámetros do modelo

Os parámetros controlan o comportamento e a creatividade das respostas. Pódense axustar a tres niveis: global (para todos os modelos), por modelo, ou por conversa.

**Dende Open WebUI — por conversa.**

Acceder ao panel de controis na esquina superior dereita da interface de chat (icona de axustes).

**Dende Open WebUI — por modelo (Admin Panel).**

Ir a `Admin Panel → Settings → Models`, seleccionar o modelo e editar os parámetros avanzados.

**Parámetros principais:**

| Parámetro | Descrición | Valores orientativos |
|---|---|---|
| `temperature` | Controla a aleatoriedade das respostas. Valores baixos dan respostas máis deterministas e precisas; valores altos, máis creativas e variadas. | `0.2`–`0.5` (factual) / `0.7`–`0.9` (creativo) |
| `top_p` | Limita a selección de tokens aos que xuntos suman a probabilidade indicada. Alternativa a `temperature`; recomendado non usar ambos á vez. | `0.9` (por defecto) |
| `top_k` | Limita a selección aos `k` tokens máis probables en cada paso. | `40`–`100` |
| `max_tokens` | Lonxitude máxima da resposta en tokens. | Aumentar para respostas longas ou razoamento complexo |
| `num_ctx` | Tamaño da ventá de contexto: canta conversa previa "recorda" o modelo. | `2048`–`8192` (segundo a VRAM dispoñible) |
| `frequency_penalty` | Penaliza a repetición de palabras xa usadas. | `0.0`–`1.0` |

> ⚠️ Reducir `num_ctx` á metade pode case duplicar o espazo libre en VRAM, o que permite cargar modelos máis grandes ou mellorar o rendemento.

**Dende un Modelfile (configuración permanente dun modelo personalizado).**

```bash
cat > Modelfile << 'EOF'
FROM llama3.2
PARAMETER temperature 0.3
PARAMETER num_ctx 4096
PARAMETER top_p 0.9
EOF

ollama create llama3.2-custom -f Modelfile
ollama run llama3.2-custom
```

---

### E.3 — Modelos con coñecemento local (RAG): como priorizar as fontes

Cando se usa RAG (*Retrieval-Augmented Generation*), o modelo pode responder baseándose en tres fontes distintas: os documentos locais subidos á base de coñecemento, o coñecemento interno do propio modelo, e a busca web en tempo real. Decidir o peso de cada fonte é clave para a calidade das respostas.

**Como funciona a recuperación en Open WebUI.**

Ao facer unha pregunta, o sistema busca nos documentos locais mediante dous métodos combinados (*búsqueda híbrida*):

- **Búsqueda vectorial (semántica):** atopa fragmentos conceptualmente similares á pregunta, aínda que non usen as mesmas palabras exactas.
- **Búsqueda BM25 (por palabras clave):** asegura que os termos exactos da consulta estean presentes nos resultados.

Os fragmentos máis relevantes inxéctanse automaticamente no contexto antes de que o modelo xere a resposta.

**Activar a búsqueda híbrida.**

En `Admin Panel → Settings → Documents`, activar a opción `Enable Hybrid Search`.

> Recomendable activar tamén un modelo de *reranking* (reordenación) para mellorar a precisión dos fragmentos recuperados.

**Escenarios e recomendación de fontes:**

| Escenario | Fonte prioritaria | Configuración recomendada |
|---|---|---|
| Documentos internos, datos privados, manuais propios | Base de coñecemento local | RAG activo, busca web desactivada |
| Información xeral ou conceptos ben coñecidos | Modelo (coñecemento interno) | Sen RAG, sen busca web |
| Noticias, datos actuais, información recente | Busca web | RAG opcional, busca web activada |
| Combinación de docs internos e contexto actual | Ambas | RAG activo + busca web activada |

**Activar ou desactivar a busca web por conversa.**

Na interface de chat, facer clic no icona de globo terráqueo para alternar a busca web. Con ela activa, o sistema combina información da base de coñecemento local e de internet na mesma resposta, con citas de cada fonte.

**Controlar o peso da información local mediante o system prompt.**

Engadir no *system prompt* do modelo instrucións explícitas sobre prioridade:

```
Responde SEMPRE priorizando a información dos documentos proporcionados.
Só usa o teu coñecemento interno se os documentos non conteñen a resposta.
Indica claramente cando a información provén dunha fonte ou da outra.
```

> Para documentos moi curtos ou que deben estar sempre presentes, usar o modo **Full Context** (inxección completa sen busca semántica): é máis lento pero garante que ningún fragmento relevante se perde.

---

## Parte F — Complementos de Open WebUI

### F.1 — Tools (Ferramentas)

**Definición.** As Tools son plugins en Python que amplían as capacidades do LLM durante a inferencia, permitíndolle executar accións no mundo real: consultar APIs externas, obter datos en tempo real, realizar cálculos, etc. O modelo decide de forma autónoma cando e como chamalas segundo a pregunta do usuario.

> As Tools viven en `Workspace → Tools` e os usuarios poden engadilas se teñen permiso. Requiren que o modelo soporte *Function Calling* ou *Tool Calling* (modelos como Llama 3, Mistral ou similares modernos).

**Para que serve.** Permiten ao modelo facer cousas que non podería facer só co seu coñecemento estático: consultar a hora actual, facer buscas web, ler datos dun servidor, xerar imaxes, ou chamar a calquera API REST.

**Exemplos:**

- `web_search` — realiza buscas en internet e devolve os resultados ao modelo.
- `get_current_time` — informa ao modelo da data e hora actual.
- `image_generation` — xera imaxes a partir dunha descrición textual.
- `code_interpreter` — executa fragmentos de código Python e devolve o resultado.
- `weather` — consulta a meteo en tempo real para unha localización dada.

**Engadir unha Tool dende a comunidade.**

En `Workspace → Tools`, facer clic en `+` e importar directamente desde a URL do repositorio comunitario de Open WebUI.

**Exemplos en Python.**

Cada Tool é unha clase Python con métodos anotados que o modelo pode chamar. Créanse en `Workspace → Tools → +`.

**Exemplo 1 — Data e hora actual.**

O modelo non sabe a data nin a hora reais. Esta tool permítelle consultala:

```python
from datetime import datetime

class Tools:
    def get_current_datetime(self) -> str:
        """
        Devolve a data e hora actual do servidor.
        Úsaa cando o usuario pregunte pola data, hora ou día da semana.
        """
        now = datetime.now()
        return now.strftime("Hoxe é %A, %d de %B de %Y. Son as %H:%M.")
```

> O docstring é o que le o modelo para decidir cando chamar á tool. Canto máis claro, mellor funciona a selección automática.

---

**Exemplo 2 — Consulta do tempo meteorolóxico.**

Obtén a temperatura e o estado do ceo para calquera cidade usando a API gratuíta de Open-Meteo (sen clave):

```python
import requests

class Tools:
    def get_weather(self, city: str) -> str:
        """
        Obtén o tempo actual dunha cidade.
        Úsaa cando o usuario pregunte polo tempo ou temperatura dalgunha localización.
        :param city: Nome da cidade (ex: 'A Coruña', 'Madrid').
        """
        # Primeiro obtemos as coordenadas da cidade
        geo_url = f"https://geocoding-api.open-meteo.com/v1/search?name={city}&count=1&language=es"
        geo = requests.get(geo_url).json()

        if not geo.get("results"):
            return f"Non atopei a cidade '{city}'."

        lat = geo["results"][0]["latitude"]
        lon = geo["results"][0]["longitude"]
        nome = geo["results"][0]["name"]

        # Despois consultamos o tempo
        meteo_url = (
            f"https://api.open-meteo.com/v1/forecast"
            f"?latitude={lat}&longitude={lon}"
            f"&current=temperature_2m,weathercode"
            f"&timezone=auto"
        )
        meteo = requests.get(meteo_url).json()
        temp = meteo["current"]["temperature_2m"]
        code = meteo["current"]["weathercode"]

        # Tradución simplificada dos códigos WMO
        estados = {
            0: "ceo despexado", 1: "case despexado", 2: "parcialmente nubrado",
            3: "cuberto", 45: "néboa", 51: "chuvisca lixeira", 61: "choiva lixeira",
            71: "neve lixeira", 80: "aguaceiros", 95: "tormenta"
        }
        estado = estados.get(code, f"código {code}")

        return f"En {nome}: {temp}°C, {estado}."
```

---

**Exemplo 3 — Calculadora de expresións matemáticas.**

Permite ao modelo resolver cálculos exactos sen depender da súa capacidade aritmética interna (que pode cometer erros):

```python
class Tools:
    def calculate(self, expression: str) -> str:
        """
        Evalúa unha expresión matemática e devolve o resultado exacto.
        Úsaa para calquera cálculo numérico: sumas, produtos, potencias, etc.
        :param expression: Expresión en Python (ex: '2 ** 10', '(3 + 5) * 4').
        """
        try:
            # Restrinximos eval a operacións matemáticas seguras
            allowed = {
                "__builtins__": {},
                "abs": abs, "round": round, "pow": pow,
                "min": min, "max": max,
            }
            result = eval(expression, allowed)
            return f"{expression} = {result}"
        except Exception as e:
            return f"Non puiden evaluar '{expression}': {e}"
```

> ⚠️ O uso de `eval` require restrición explícita do entorno de execución para evitar execución de código arbitrario, como se mostra no exemplo.

---

### F.2 — Prompts (Instrucións predefinidas)

**Definición.** Os Prompts son plantillas de instrucións gardadas que se poden reutilizar en calquera conversa. Permiten activar comportamentos específicos do modelo ou estandarizar o formato das respostas sen ter que reescribir as instrucións cada vez.

> Xestiónanse en `Workspace → Prompts`. Os campos entre corchetes `[como este]` son variables que se autoseleccionan con `Tab` para substituír rapidamente.

**Para que serve.** Aforrar tempo en tarefas repetitivas, garantir consistencia nas respostas, e adaptar o comportamento do modelo a contextos concretos sen modificar o modelo nin o seu system prompt permanente.

**Exemplos:**

- **Resumo executivo:** `Resume o seguinte texto en 5 puntos clave en formato de lista: [texto]`
- **Corrección de código:** `Revisa o seguinte código en [linguaxe] e explica os erros atopados: [código]`
- **Tradución técnica:** `Traduce ao galego o seguinte texto técnico mantendo a terminoloxía orixinal: [texto]`
- **Xeración de preguntas de exame:** `A partir do seguinte contido, xera 10 preguntas tipo test con 4 opcións cada unha: [contido]`

---

### F.3 — Functions (Funcións)

**Definición.** As Functions son plugins Python avanzados que modifican o comportamento da propia plataforma Open WebUI, non só do modelo. Existen tres tipos: **Pipe** (engade un modelo ou provedor novo), **Filter** (intercepta e transforma mensaxes entrantes ou saíntes), e **Action** (engade botóns personalizados na interface de chat).

> As Functions están en `Admin Panel → Functions` e só as xestionan os administradores. Poden importarse da comunidade ou escribirse en Python.

**Para que serve.** Permiten customizacións profundas da plataforma: conectar provedores de IA externos (Anthropic, Vertex AI, etc.), aplicar filtros de contido, traducir mensaxes automaticamente, ou engadir botóns que executen accións ao facer clic (exportar a PDF, enviar a Slack, etc.).

**Exemplos:**

- **Pipe:** conectar Claude de Anthropic ou Gemini de Google como modelos dispoñibles na interface.
- **Filter (inlet):** engadir automaticamente un prefixo de idioma a todas as mensaxes entrantes.
- **Filter (outlet):** censurar ou transformar as respostas antes de mostralas ao usuario.
- **Action:** botón "Copiar como Markdown" ou "Enviar a Notion" na barra de mensaxes.

**Exemplos en Python.**

Créanse en `Admin Panel → Functions → +`. Open WebUI detecta o tipo automaticamente segundo o nome da clase principal (`Pipe`, `Filter` ou `Action`).

---

**Exemplo 1 — Pipe: modelo personalizado con instrución de sistema fixo.**

Un Pipe aparece como un modelo máis na lista de modelos da interface. Neste caso créase un "Asistente SMR" que sempre responde en galego e con terminoloxía técnica de redes:

```python
from typing import Iterator, Union

class Pipe:
    class Valves:
        pass

    def __init__(self):
        self.id = "asistente-smr"
        self.name = "Asistente SMR (Galego)"

    def get_models(self):
        return [{"id": self.id, "name": self.name}]

    def pipe(self, body: dict) -> Union[str, Iterator]:
        # Inxectamos un system prompt fixo antes de calquera mensaxe do usuario
        system_msg = {
            "role": "system",
            "content": (
                "Es un asistente técnico especializado en Sistemas Microinformáticos e Redes. "
                "Responde sempre en galego, usando terminoloxía técnica precisa. "
                "Se o usuario fai preguntas alleas á informática, rediríxeo ao tema."
            )
        }
        messages = body.get("messages", [])
        body["messages"] = [system_msg] + messages

        # Delegamos a chamada ao modelo base configurado en Ollama
        import requests
        response = requests.post(
            "http://localhost:11434/api/chat",
            json={"model": "llama3.2", "messages": body["messages"], "stream": False}
        )
        return response.json()["message"]["content"]
```

---

**Exemplo 2 — Filter: rexistrar todas as preguntas dos usuarios nun log.**

Un Filter de tipo `inlet` intercepta cada mensaxe antes de chegar ao modelo. Aquí úsase para gardar un rexistro de todas as consultas con marca de tempo:

```python
from datetime import datetime

class Filter:
    class Valves:
        pass

    def inlet(self, body: dict, __user__: dict = {}) -> dict:
        """
        Execútase antes de cada petición ao modelo.
        Garda a consulta do usuario nun arquivo de log local.
        """
        messages = body.get("messages", [])
        last_user_msg = next(
            (m["content"] for m in reversed(messages) if m["role"] == "user"),
            ""
        )
        username = __user__.get("name", "descoñecido")
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

        with open("/app/backend/data/consultas.log", "a", encoding="utf-8") as f:
            f.write(f"[{timestamp}] {username}: {last_user_msg}\n")

        # Devolvemos o body sen modificar; só rexistramos
        return body
```

> O arquivo gárdase dentro do volume Docker de Open WebUI, polo que persiste entre reinicios do contedor.

---

**Exemplo 3 — Action: botón para exportar a resposta en formato Markdown.**

Unha Action engade un botón na barra de cada mensaxe do asistente. Ao premer, executa código Python. Neste caso copia a resposta cun encabezado de data para pegala noutro documento:

```python
from datetime import datetime

class Action:
    class Valves:
        pass

    async def action(
        self,
        body: dict,
        __event_emitter__=None,
    ) -> None:
        """
        Botón 'Exportar Markdown' na barra de mensaxes do asistente.
        Formatea a resposta con encabezado de data e envíaa de volta ao chat.
        """
        messages = body.get("messages", [])
        last_assistant_msg = next(
            (m["content"] for m in reversed(messages) if m["role"] == "assistant"),
            ""
        )

        timestamp = datetime.now().strftime("%d/%m/%Y %H:%M")
        exported = (
            f"## Resposta exportada — {timestamp}\n\n"
            f"{last_assistant_msg}\n\n"
            f"---\n*Xerado por Open WebUI*"
        )

        # Emitimos o resultado de volta ao chat como mensaxe nova
        if __event_emitter__:
            await __event_emitter__(
                {
                    "type": "message",
                    "data": {"content": f"**Vista previa Markdown:**\n\n{exported}"},
                }
            )
```

---

## Parte G — Outras funcións

### G.1 — Conexión por API

Open WebUI expón unha API REST compatible con OpenAI que permite integrar o sistema en aplicacións externas, scripts, pipelines CI/CD ou calquera ferramenta que soporte o estándar.

**1. Xerar a clave de API.**

En `Settings → Account → API Keys`, facer clic en `+` para crear unha nova clave. A clave só se mostra unha vez; gardar nun lugar seguro.

> Por defecto a xeración de claves de API está desactivada. O administrador debe habilitala en `Admin Panel → Settings → General → Enable API Keys`.

**2. Autenticarse nas peticións.**

```bash
# Listar os modelos dispoñibles
curl -H "Authorization: Bearer TUA_CLAVE_API" \
  http://localhost:8080/api/models

# Chat completion (compatible con OpenAI)
curl -X POST http://localhost:8080/api/chat/completions \
  -H "Authorization: Bearer TUA_CLAVE_API" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "llama3.2",
    "messages": [
      {"role": "user", "content": "Explica que é un inodo en Linux"}
    ]
  }'
```

> A API herda os permisos do usuario que xerou a clave. Se a clave se compromete, elimínase dende a interface e xérase unha nova sen necesidade de cambiar contrasinais.

**3. Usar con Python.**

```python
import requests

response = requests.post(
    "http://localhost:8080/api/chat/completions",
    headers={"Authorization": "Bearer TUA_CLAVE_API"},
    json={
        "model": "llama3.2",
        "messages": [{"role": "user", "content": "Ola!"}]
    }
)
print(response.json())
```

> A documentación completa dos endpoints está dispoñible en formato Swagger en `http://localhost:8080/docs` (require establecer a variable de entorno `ENV=dev` no contedor).

---

### G.2 — Validación de usuarios con LDAP

Open WebUI permite delegar a autenticación nun servidor LDAP ou Active Directory existente, de xeito que os usuarios se autentiquen coas súas credenciais corporativas sen necesidade de crear contas separadas.

**1. Configurar as variables de entorno.**

Engadir ao `docker run` ou ao `docker-compose.yml`:

```bash
docker run -d \
  --network=host \
  -e ENABLE_LDAP="true" \
  -e LDAP_SERVER_LABEL="Servidor LDAP" \
  -e LDAP_SERVER_HOST="192.168.1.10" \
  -e LDAP_SERVER_PORT=389 \
  -e LDAP_USE_TLS="false" \
  -e LDAP_APP_DN="cn=admin,dc=empresa,dc=local" \
  -e LDAP_APP_PASSWORD="contrasinal_admin" \
  -e LDAP_SEARCH_BASE="dc=empresa,dc=local" \
  -e LDAP_ATTRIBUTE_FOR_USERNAME="uid" \
  -e LDAP_ATTRIBUTE_FOR_MAIL="mail" \
  -e LDAP_SEARCH_FILTER="(objectClass=inetOrgPerson)" \
  -v open-webui:/app/backend/data \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:main
```

> Open WebUI le estas variables só no primeiro arranque. Os cambios posteriores deben facerse dende `Admin Panel → Settings`.

**2. Verificar a conectividade co servidor LDAP antes de configurar.**

```bash
ldapsearch -x -H ldap://192.168.1.10:389 \
  -D "cn=admin,dc=empresa,dc=local" \
  -w contrasinal_admin \
  -b "dc=empresa,dc=local" "(uid=usuario_proba)"
```

> Se o comando devolve a entrada do usuario, o servidor está accesible e a configuración é correcta.

**3. Primeiro acceso dun usuario LDAP.**

Ao autenticarse por primeira vez, créase automaticamente unha conta en Open WebUI co rol `User`. O administrador pode elevar o rol a `Admin` dende o panel de xestión de usuarios.

**Erros frecuentes:**

| Erro | Causa probable | Solución |
|---|---|---|
| `port must be an integer` | O porto está entre comiñas no `.env` | Eliminar as comiñas: `LDAP_SERVER_PORT=389` |
| `SSL: UNEXPECTED_EOF` | Conflito TLS | Verificar se o servidor usa LDAP (389) ou LDAPS (636) e axustar `LDAP_USE_TLS` |
| `err=49` no log do servidor | Credenciais de bind incorrectas | Revisar `LDAP_APP_DN` e `LDAP_APP_PASSWORD` |

---

### G.3 — Driver GreenBoost

**Que é GreenBoost.**

GreenBoost é un módulo do kernel Linux de código aberto (licenza GPLv2), desenvolvido de forma independente, que ten como obxectivo ampliar a memoria de vídeo dedicada (VRAM) das GPU NVIDIA discretas usando a RAM do sistema e almacenamento NVMe. Non substitúe os drivers oficiais de NVIDIA, senón que funciona de forma complementaria.

**Para que serve.**

Interceptando as chamadas de asignación de memoria CUDA mediante un shim `LD_PRELOAD` e mapeando páxinas de RAM do sistema como descritores DMA-BUF importables como memoria externa CUDA, GreenBoost expande de forma transparente a VRAM efectiva usando DDR e NVMe. Isto permite que GPU de consumo como a RTX 5070 (12 GB) executen modelos como `glm-4.7-flash:q8_0` (31,8 GB) sen cuantización que degrade a calidade nin penalizacións de rendemento polo offload á CPU.

**Arquitectura de tres niveis de memoria:**

| Nivel | Fonte | Velocidade | Uso |
|---|---|---|---|
| T1 | VRAM da GPU | ~336 GB/s | Pesos activos do modelo, capas de cálculo intensivo |
| T2 | RAM do sistema (DDR4) | ~32 GB/s vía PCIe 4.0 x16 | Caché KV, capas menos activas |
| T3 | NVMe SSD | Máis lento | Overflow, modelos moi grandes |

**Como funciona tecnicamente.**

O módulo do kernel (`greenboost.ko`) reserva páxinas DDR4 fixadas en memoria e expórtaas como descritores de arquivo DMA-BUF. A GPU impórtas como memoria externa CUDA vía `cudaImportExternalMemory`. Desde o punto de vista de CUDA, esas páxinas parecen memoria directamente accesible pola GPU; o movemento de datos xestiónase como transferencia DMA a través do bus PCIe sen copias intermedias por parte da CPU.

**Instalación (experimental).**

```bash
# Clonar o repositorio
git clone https://gitlab.com/ferranduarri/greenboost.git
cd greenboost

# Compilar e instalar o módulo do kernel
make
sudo make install
sudo modprobe greenboost

# Verificar o estado
cat /sys/class/greenboost/greenboost/pool_info

# Usar con Ollama inxectando o shim CUDA
LD_PRELOAD=/usr/local/lib/libgreenboost_cuda.so ollama serve
```

> ⚠️ **Proxecto experimental.** GreenBoost está en fase de desenvolvemento activo. Non se recomenda para entornos de producción. As velocidades de inferencia documentadas (10–25 tok/s nunha RTX 5070 con modelos de ~32 GB) non foron comparadas publicamente con métodos de offload á CPU como `llama.cpp`.

**Monitorización do uso de memoria.**

```bash
# Ver o uso de VRAM e RAM do sistema en tempo real
watch -n 1 cat /sys/class/greenboost/greenboost/pool_info

# Complementar con nvidia-smi para ver o uso de VRAM
nvidia-smi --query-gpu=memory.used,memory.free --format=csv -l 1
```

---

## Parte H — Monitorización con Grafana e Prometheus

> Guía de referencia: [How to Monitor an Ubuntu Server with Grafana and Prometheus](https://oastic.com/posts/how-to-monitor-an-ubuntu-server-with-grafana-and-prometheus/)

Grafana é unha ferramenta de visualización e análise de métricas de código aberto que permite crear dashboards interactivos para monitorizar o estado do servidor en tempo real: CPU, memoria RAM, disco, rede e uso da GPU. Prometheus actúa como motor de recollida e almacenamento das métricas, consultando periodicamente os exportadores instalados no sistema.

A arquitectura é a seguinte:

```
[Servidor Ubuntu]
  └── node_exporter (porto 9100)  →  expón métricas do sistema
  └── Prometheus     (porto 9090)  →  recolla e almacena as métricas
  └── Grafana        (porto 3000)  →  visualiza as métricas en dashboards
```

---

### H.1 — Instalar Grafana

**1. Instalar as dependencias previas.**

```bash
sudo apt install -y apt-transport-https software-properties-common wget
```

**2. Descargar e rexistrar a clave GPG do repositorio oficial.**

```bash
sudo wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key
```

**3. Engadir o repositorio estable de Grafana.**

```bash
echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" \
  | sudo tee -a /etc/apt/sources.list.d/grafana.list
```

> Para usar versións beta en lugar das estables, substituír `stable` por `beta` no comando anterior.

**4. Actualizar os repositorios e comprobar a orixe do paquete.**

```bash
sudo apt update
apt-cache policy grafana
```

> `apt-cache policy` permite verificar que Grafana se instalará dende o repositorio oficial e non dunha versión desactualizada dos repos de Ubuntu.

**5. Instalar Grafana.**

```bash
sudo apt install grafana
```

**6. Iniciar o servizo e habilitalo no arranque.**

```bash
sudo systemctl start grafana-server
sudo systemctl enable grafana-server.service
```

**7. Comprobar que o servizo está activo.**

```bash
sudo systemctl status grafana-server
```

> A saída debe mostrar `active (running)`. Grafana queda accesible no **porto 3000**.

---

### H.2 — Instalar Prometheus e Node Exporter

Prometheus recolle as métricas e `prometheus-node-exporter` expón as métricas do sistema operativo (CPU, RAM, disco, rede) para que Prometheus as poida consultar.

**1. Instalar ambos paquetes dun só comando.**

```bash
sudo apt install prometheus prometheus-node-exporter
```

**2. Verificar que os portos están escoitando.**

```bash
netstat -plunt
```

> Deben aparecer tres entradas activas:
> - Porto `9090` → Prometheus
> - Porto `9100` → Node Exporter
> - Porto `3000` → Grafana

**3. Comprobar a versión de Node Exporter instalada.**

```bash
prometheus-node-exporter --version
```

> É importante coñecer a versión porque o dashboard de Grafana que se importará máis adiante debe ser compatible co Node Exporter instalado. A versión mínima requirida é a `0.18` ou superior.

---

### H.3 — Acceder a Grafana e configurar a fonte de datos

**1. Acceder á interface web.**

Abrir un navegador e ir a:

```
http://<IP_DO_SERVIDOR>:3000
```

> As credenciais por defecto son `admin` / `admin`. O sistema pedirá cambiar o contrasinal no primeiro acceso.

**2. Engadir Prometheus como fonte de datos.**

Ir a `Connections → Data Sources → Add new data source` e seleccionar **Prometheus**.

No campo URL introducir:

```
http://localhost:9090
```

Facer clic en **Save & Test** para validar a conexión.

> Se a proba é correcta, aparecerá unha mensaxe de confirmación verde. Prometheus e Grafana están agora enlazados.

---

### H.4 — Crear o dashboard de monitorización

Grafana dispón dunha biblioteca pública de dashboards listos para usar. O dashboard recomendado para monitorización de servidores Ubuntu con Node Exporter é o **Node Exporter Full** (ID `1860`).

**1. Importar o dashboard.**

Ir a `Dashboards → New → Import` e introducir o ID:

```
1860
```

Seleccionar **Prometheus** como fonte de datos e facer clic en **Import**.

**2. Resultado.**

O dashboard mostra en tempo real as seguintes métricas do servidor:

| Métrica | Descrición |
|---|---|
| CPU Usage | Porcentaxe de uso por núcleo e total |
| Memory Usage | RAM usada, libre e en caché |
| Disk I/O | Operacións de lectura e escritura por segundo |
| Network Traffic | Ancho de banda entrante e saínte por interface |
| System Load | Carga media do sistema (1, 5 e 15 minutos) |
| Uptime | Tempo que leva o servidor en funcionamento |

> O dashboard actualízase automaticamente cada 30 segundos por defecto. O intervalo pódese axustar na esquina superior dereita da interface de Grafana.

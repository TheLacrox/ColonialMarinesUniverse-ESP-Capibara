# Despliegue Docker / Dokploy — Capibara Colonial Marines

Guía de operador para el servidor dedicado en contenedor. Complementa `AGENTS.md`
(contrato de agentes) y `CLAUDE.md`; no los sustituye.

## Ficheros

| Fichero | Papel |
| --- | --- |
| `Dockerfile` | Build multi-etapa (`sdk:10.0` → `runtime:10.0`) |
| `.dockerignore` | Exclusiones del contexto de build |
| `docker-compose.yml` | Servicio único, lo consume Dokploy directamente |
| `entrypoint.sh` | Overrides de CVar en runtime desde variables de entorno |
| `Docker/server_config.prod.toml` | Configuración de producción horneada en la imagen |
| `Resources/ConfigPresets/Capibara/capibara.toml` | Marca y comunidad Capibara |

Los seis son propiedad de este fork y aditivos respecto a upstream. **En un conflicto
de merge durante un `sync/upstream-*`, quedarse con los nuestros.**

## Precedencia de configuración

De más débil a más fuerte. Verificado en `Content.Server/Entry/EntryPoint.cs`
(`LoadConfigPresets`) y `RobustToolbox/Robust.Server/BaseServer.cs`.

| # | Fuente | Efecto |
| --- | --- | --- |
| 1 | `CVarDef.Create` en C# | default |
| 2 | `ContentLocalizationManager.Initialize()` → `OverrideDefault` | default |
| 3 | `/ConfigPresets/*.toml` nombrados en `config.presets` | **solo default** |
| 4 | `--config-file` (`Docker/server_config.prod.toml`) | **valor** |
| 5 | `ROBUST_CVARS` / `ROBUST_CVAR_*` (entorno) | valor |
| 6 | `--cvar` en `entrypoint.sh` | valor |

Los presets se cargan en `EntryPoint.Init()`, *después* del fichero de configuración,
pero solo escriben `DefaultValue`, así que nunca pisan los niveles 4/5/6.

**Regla de reparto:** marca y gameplay → preset (nivel 3). Overrides críticos de
despliegue → `server_config.prod.toml` (nivel 4). Valores por despliegue → entorno
(nivel 5/6).

`config.presets = "RMC14/rmc,Capibara/capibara"` carga primero el preset de producción
del fork y encima la superposición de Capibara, que gana en toda clave que redefina.
Mismo patrón que los overlays existentes `RMC14/alamo.toml` y `RMC14/ravager.toml`.

**No editar `Resources/ConfigPresets/RMC14/rmc.toml`.** Es un fichero de alto tráfico
upstream; meter marca de Capibara ahí garantiza conflicto en cada sync. Para eso existe
`Capibara/capibara.toml`.

### Español

`loc.culture_name = "es-ES"` está puesto **como valor** en
`Docker/server_config.prod.toml` (nivel 4), no solo como default de preset.
`Content.Shared/Localizations/ContentLocalizationManager.cs` ya lo pone por defecto,
pero eso es un `OverrideDefault` (nivel 2) y es lo primero que un sync con upstream
revertiría. Hay tres capas redundantes a propósito.

Depende de ICU: la imagen `mcr.microsoft.com/dotnet/runtime:10.0` (Debian) lo trae.
**Nunca** poner `DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1` ni cambiar a una etiqueta
`-alpine` sin añadir `icu-libs` — con globalización invariante la cultura resuelve pero
el formato de números, fechas y plurales se degrada en silencio.

## Dokploy

Aplicación tipo **Compose**, repo `TheLacrox/ColonialMarinesUniverse-ESP-Capibara`,
rama `master`, ruta `docker-compose.yml`.

### Variables de entorno

| Variable | Ejemplo | Nota |
| --- | --- | --- |
| `SS14_HOSTNAME` | `[ES] Capibara Colonial Marines [Español]` | Vacía → usa el valor del preset |
| `SS14_DOMAIN` | `cm.estacioncapibara.com` | Gobierna `hub.server_url` y `status.connectaddress`. Debe coincidir con el Domain de Dokploy |
| `SS14_PORT` | `1212` | Puerto **del host**. Acoplado a `status.connectaddress` |
| `SS14_HUB_ADVERTISE` | `false` en pruebas, `true` al lanzar | No anunciar al hub público hasta pasar el smoke test |
| `SS14_AUTH_MODE` | `1` | 0=opcional 1=requerido 2=desactivado. Servidor público → requerido |
| `SS14_HOST_USER` | `TheLacrox` | Concede host completo al entrar. Seguro **solo** con `auth.mode=1` |
| `ROBUST_CVARS` | `replay.auto_record=true` | Escape hatch para cualquier CVar, `clave=valor;clave=valor`. Sin rebuild |

### Dominio y Traefik

Añadir un Domain sobre `game-server`, puerto de contenedor **1212**, HTTPS +
Let's Encrypt. Traefik proxea `:443 → 1212/tcp`, que es el status/ACZ host. Eso es lo
que hace resoluble `ss14s://<dominio>` para el launcher.

### UDP — restricción dura

El protocolo de juego de SS14 es UDP y **Traefik no lo puede proxear**. El bloque
`ports:` de compose publica `1212/udp` directamente en el host; hay que abrirlo en el
firewall del VPS (`ufw allow 1212/udp`) y en el security group del proveedor.

TCP 1212 también se publica directo, lo que da un fallback sin TLS
(`ss14://host:1212`). Ábrelo también, o quítalo de `ports:` si quieres que Traefik sea
el único camino TCP.

Si algún día hay un segundo servidor SS14 en el mismo host, dale otro `SS14_PORT` — y
recuerda que `status.connectaddress` debe anunciar ese mismo puerto de host, no el 1212
interno. Están acoplados por diseño a través de `SS14_PORT`.

### Volumen

El volumen con nombre `ss14-data` montado en `/data` guarda `preferences.db` y `logs/`.

`RMC14/rmc.toml` activa `replay.auto_record = true`, lo que escribe un `.zip` por ronda
en `/data/done/` sin límite. `Capibara/capibara.toml` lo desactiva. Si lo reactivas por
`ROBUST_CVARS=replay.auto_record=true`, provisiona disco de sobra y purga `/data/done/`
periódicamente.

## Recursos del builder

| | |
| --- | --- |
| `Resources/` | ~1,1 GB (Maps 437 MB, Audio 347 MB, Textures 279 MB) |
| `bin/` + `obj/` durante el build | 4–6 GB |
| Caché NuGet | ~2 GB |
| **Disco libre necesario** | **~25 GB** en el data root de Docker |
| **RAM** | **8 GB recomendado; 4 GB + 8 GB de swap es el suelo** |
| Build en frío | 30–90 min |
| Imagen final | ~1,2–1,5 GB |

`Content.Packaging/ServerPackaging.cs` fija `/m` en duro en sus builds internos y
`Content.Packaging.csproj` activa `ServerGarbageCollection`; con poca RAM Roslyn muere
por OOM (exit 137, o un "the build stopped unexpectedly" sin más).

En un VPS de 4 GB, añadir swap antes del primer deploy:

```bash
fallocate -l 8G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile
```

**Cada deploy es un build en frío.** `Content.Packaging/Program.cs` hace `WipeBin()` y
`WipeRelease()` al arrancar, y `COPY . .` invalida la caché desde el primer `RUN`; no
hay capas incrementales posibles. La única caché útil es la de NuGet vía un
`RUN --mount=type=cache,target=/root/.nuget/packages` de BuildKit.

Alternativa a futuro: construir la imagen en GitHub Actions (runners de 16 GB) y que
Dokploy tire de una imagen ya construida en GHCR. Arregla a la vez el OOM y el build en
frío por deploy.

## Audio privado

`Resources/Audio/_CMU14/Private/` contiene **placeholders silenciosos**: 30 pistas de
cassette y 2 alarmas de ambiente. El audio real vive en el repo privado
`AU-14/ColonialMarinesAudio` y solo lo superpone `.github/workflows/publish.yml`, para
la entrada de matriz `client` y con `AUDIO_REPO_TOKEN`.

**Consecuencia:** un build Docker con `--hybrid-acz` no tiene ese token, así que el
`Content.Client.zip` embebido lleva los placeholders. Esas 32 pistas suenan en silencio.
Los 3196 ficheros de audio públicos van completos; nada más se ve afectado.

Ruta de overlay opcional, **no implementada**:

- Añadir `rsync` a la línea `apt-get` de la etapa de build.
- Antes del `RUN` de empaquetado, clonar `AU-14/ColonialMarinesAudio` con un PAT de solo
  lectura y hacer `rsync -a --delete` a `Resources/Audio/_CMU14/Private/`, replicando lo
  que hace el workflow.
- **Debe usar `RUN --mount=type=secret,id=audio_token`, nunca `ARG`.** Un build arg
  consumido en un `RUN` se recupera del historial de la imagen.
- Confirmar que tu versión de Dokploy soporta `--secret` antes de comprometerte; si no,
  construir en GitHub Actions, donde el token ya existe como secreto del repo.
- La imagen resultante **nunca** debe subirse a un registro público: el audio es privado
  por licencia.

## Verificación local

```bash
# 1. Contexto de build: el fichero que un .dockerignore ingenuo se comería
docker build --target build -t cmu14-ctx .
docker run --rm cmu14-ctx ls -l /src/Resources/Locale/en-US/entity-systems/bin/
#   -> debe listar bin-system.ftl

# 2. Imagen completa
docker build -t cmu14-capibara:local .

# 3. Arrancar SIN anunciar al hub y SIN dominio
SS14_HUB_ADVERTISE=false SS14_HOSTNAME="Capibara CM (local test)" docker compose up --build
```

Con el servidor arriba (el primer arranque tarda: carga de prototipos y mapas):

```bash
curl -s http://127.0.0.1:1212/status | jq .
#   -> "name" = SS14_HOSTNAME, soft_max_players 60

curl -s http://127.0.0.1:1212/info | jq '.build'
#   -> fork_id "capibara-colonial-marines"  (NO "custom", NO "cmu"), acz true

curl -s http://127.0.0.1:1212/info | jq '.links, .privacy_policy'
#   -> enlaces de Capibara; privacy_policy identifier "capibara-cm"

docker compose logs game-server | grep -i "config preset"
#   -> carga /ConfigPresets/RMC14/rmc.toml y DESPUÉS /ConfigPresets/Capibara/capibara.toml
docker compose logs game-server | grep -i "unregistered variable"
#   -> debe salir VACÍO

docker compose exec game-server ls -la /data     # preferences.db, logs/
docker compose exec game-server id               # uid=10001(ss14)
docker compose down                              # limpio dentro de stop_grace_period
```

Después, conectar con el launcher real a `ss14://127.0.0.1:1212`, confirmar la descarga
por ACZ y que la UI sale en español.

## Trampas conocidas

1. **`.dockerignore` y `**/bin/`.** Existe un fichero de locale rastreado en
   `Resources/Locale/en-US/entity-systems/bin/bin-system.ftl`. Un `**/bin/` sin el
   `!Resources/**` posterior lo deja fuera del contexto y la UI de papeleras renderiza
   claves Fluent en crudo, sin ningún error. Verificar con el paso 1 tras cualquier edición.
2. **CRLF en `entrypoint.sh`** → `exec /app/entrypoint.sh: no such file or directory`.
   Tres capas de defensa: `.gitattributes` (`* text=auto eol=lf`), `Tools/check_crlf.py`
   y el `sed -i 's/\r$//'` del Dockerfile. Mantener las tres.
3. **`Release` activa `TreatWarningsAsErrors`** (`MSBuild/Content.props`). El build Docker
   es Release, y `test-packaging.yml` solo cubre Release para `client` y `server-win-x64`;
   **`linux-x64` en Release solo lo compila el `publish.yml` manual**. Un warning
   específico de Linux rompería el build Docker sin aviso previo de CI. Si muere con un
   `CSxxxx`/`RAxxxx`, es esto, no Docker.
4. **`--hybrid-acz` impide el atajo de restore con RID.** No "optimizar" el `dotnet restore`
   del Dockerfile para igualar el de `publish.yml`: aquí también se compila el cliente, que
   es agnóstico al RID. Hay un comentario en el Dockerfile explicándolo.
5. **CVars `ARCHIVE` reescriben `/app/server_config.toml`** al apagar limpiamente. Inocuo
   —`/app` es efímero y se restaura desde la imagen en cada recreación— pero el fichero
   dentro de un contenedor de larga vida pierde los comentarios. No sacarlo con `docker cp`
   y tratarlo como fuente de verdad.
6. **Tamaño de imagen ~1,2–1,5 GB.** `RobustServerPackaging` solo excluye
   `Textures/Fonts/EngineFonts/Shaders/Midi` de los paquetes de servidor: Audio y Maps sí
   van. Y `--hybrid-acz` inyecta encima un `Content.Client.zip` que lleva Textures y Audio
   otra vez.
7. **`hub.tags` región.** `RMC14/rmc.toml` hereda `region:am_n_e` (Este de EE. UU., de
   rouny). `Capibara/capibara.toml` pone `region:eu_w`. Debe reflejar dónde está realmente
   el host de Dokploy — una región equivocada filtra el servidor fuera de las búsquedas de
   su propio público.
8. **`Tools/validate_agent_context.py` ya falla** en `master` por `CLAUDE.md`
   (`DUPLICATE_CONTEXTS`). Es preexistente y ajeno a Docker; no confundirlo con una
   regresión introducida por estos ficheros.

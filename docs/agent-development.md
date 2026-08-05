# Guía de desarrollo asistido por IA en CMU-14

Esta guía amplía el contrato operativo de `AGENTS.md`. Está dirigida a mantenedores y agentes que trabajan en este fork grande de Space Station 14. La regla raíz prevalece: inspeccionar el subsistema real antes de cambiarlo y validar el menor alcance que demuestre el comportamiento.

## 1. Cómo recibe contexto un agente

La fuente canónica es `AGENTS.md` en la raíz.

- Hermes usa un único tipo de contexto según prioridad. Este contrato portátil se verificó iniciando la sesión con el directorio efectivo exactamente en la raíz; no dependas de que una versión concreta busque `AGENTS.md` desde una subcarpeta. Por eso tampoco se duplican instrucciones en `.hermes.md`, `HERMES.md`, `CLAUDE.md`, `.cursorrules` o `.cursor/rules/*.mdc`.
- Los agentes GPT/Codex consumen `AGENTS.md` como contrato de repositorio.
- El proyecto fija un presupuesto conservador de 20 000 caracteres, compatible con el mínimo dinámico de Hermes; la instalación o el modelo pueden admitir un límite mayor.
- `Tools/validate_agent_context.py` comprueba que el contrato exista con el casing exacto, no esté sombreado, no tenga duplicados, use LF y conserve sus anclas operativas.
- `Tools/tests/test_validate_agent_context.py` prueba tanto el caso válido como contratos ausentes, sombreados, duplicados, incompletos o demasiado grandes.

Al cambiar estas instrucciones:

```bash
python3 -m unittest Tools.tests.test_validate_agent_context -v
python3 Tools/validate_agent_context.py
```

Después abre una sesión nueva de Hermes con el directorio de trabajo en la raíz del repositorio. Una sonda semántica mínima debe poder responder, sin pistas adicionales:

1. La validación rápida exacta es `python3 Tools/validate_agent_context.py`.
2. El primer límite generado listado es `Resources/Prototypes/_AU14/CustomConstruction/Generated/`.
3. `BuildChecker/git_helper.py` puede instalar hooks y actualizar submódulos.
4. Una funcionalidad CMU nueva va normalmente en `_CMU14`; una funcionalidad heredada permanece en la capa donde ya vive.

Si lanzas esa sonda desde la terminal embebida de otra sesión de Hermes, usa una shell limpia: las variables heredadas `HERMES_SESSION_*` y `TERMINAL_CWD` pueden conservar la plataforma o el directorio de la sesión padre. Comprueba que la sesión nueva registra este repositorio como workspace antes de interpretar un fallo como problema de `AGENTS.md`.

## 2. Linaje y modelo de propiedad

CMU-14 es un producto activo que deriva de RMC14/CM13 y RobustToolbox. El repositorio no es un upstream limpio ni un overlay aislado: combina árboles específicos y hooks inline.

| Capa | Significado práctico | Regla al editar |
| --- | --- | --- |
| `_CMU14` | Código y recursos propios de CMU | Destino preferido para funcionalidad nueva exclusivamente CMU. |
| `_RMC14` | Dominio heredado de RMC14, todavía mantenido | Extender en su ubicación actual; evitar mover o renombrar por estética. |
| `_AU14` / `AU14` | Dominio heredado de AU14, incluida construcción personalizada y mapas | Leer documentación específica y conservar sus contratos de persistencia/datos. |
| Sin prefijo | SS14/vanilla y puntos de integración | Hacer hooks mínimos; usar los marcadores de la capa local ya presentes. |
| `RobustToolbox`, `RSI.NET` | Submódulos fijados | No editar ni avanzar el gitlink durante una tarea de contenido normal. |

Los marcadores inline (`// RMC14`, `// AU14`, `// CMU14`, con variantes `start`/`end`) son parte de la estrategia para sobrevivir sincronizaciones. No deben borrarse con un formateo o refactor global.

### 2.1. Flujo Git unidireccional del fork

El fork público de trabajo es `TheLacrox/ColonialMarinesUniverse-ESP-Capibara`; su repositorio original es `AU-14/ColonialMarinesUniverse`. Ambos usan actualmente `master`. Los nombres locales de remotos son convenciones, no garantías: empieza siempre con `git remote -v` y comprueba URLs antes de obtener o publicar cambios.

El repositorio original es una fuente de cambios entrantes, no un destino de contribuciones. El flujo autorizado es exclusivamente `upstream → fork`: se obtienen cambios del original, se integran y resuelven dentro de una rama del fork, y se publican únicamente en el fork.

Queda prohibido crear, preparar, sugerir o abrir pull requests dirigidos a upstream. Esto incluye interfaces web, `gh pr create`, APIs, ramas preparadas con ese propósito y recomendaciones de “contribuir el cambio de vuelta”. Queda prohibido hacer push a cualquier rama o remoto de upstream. Todo trabajo colaborativo se publica y revisa exclusivamente dentro del fork.

Configuración inicial recomendada, después de verificar que el remoto no exista ya:

```bash
git remote -v
git remote add upstream https://github.com/AU-14/ColonialMarinesUniverse.git
git remote set-url --push upstream DISABLED
git fetch upstream --prune --tags
```

`origin/master` es la rama estable traducida del fork; `upstream/master` representa el original y es de solo lectura. El trabajo ordinario usa ramas cortas del fork (`translate/*`, `fix/*`, `feat/*`). Una sincronización usa una rama temporal creada desde el `master` limpio del fork:

```bash
git fetch origin --prune
git fetch upstream --prune --tags
git switch master
git pull --ff-only origin master
git switch -c sync/upstream-<fecha-o-version>
git merge --no-ff upstream/master
```

Resuelve conflictos preservando la funcionalidad nueva de upstream y las traducciones/adaptaciones locales deliberadas; no elijas `ours` o `theirs` globalmente. Actualiza submódulos si cambiaron sus gitlinks, ejecuta la escalera de validación pertinente y publica la rama únicamente en `origin`:

```bash
git submodule update --init --recursive
git push -u origin sync/upstream-<fecha-o-version>
```

El PR de sincronización se abre dentro de `TheLacrox/ColonialMarinesUniverse-ESP-Capibara`, con base `master` del mismo fork. Intégralo con merge commit, no con squash, para conservar la ascendencia de upstream y reducir conflictos repetidos. Los PRs ordinarios de traducción o fixes sí pueden usar squash. No rebasees ni reescribas un `master` compartido, no hagas `reset --hard` a `upstream/master` y no uses cherry-picks como mecanismo habitual de sincronización.

### Corte vertical de referencia: panel del brazalete Yautja

Esta funcionalidad muestra cómo seguir una acción desde datos hasta autoridad y UI:

- Contrato de red/UI: `Content.Shared/_CMU14/Yautja/YautjaActions.cs` define `YautjaBracerUIKey`, `YautjaBracerPanelState` y `YautjaBracerPanelCommandMsg`.
- Autoridad: `Content.Server/_CMU14/Yautja/YautjaBracerMenuSystem.cs` recibe el mensaje, vuelve a comprobar `CanUseMenu`, aplica el comando y publica el estado.
- Cliente: `Content.Client/_CMU14/Yautja/YautjaBracerBui.cs` y `YautjaBracerWindow.xaml.cs` presentan el estado y envían intención, no autoridad.
- Prototipo: `Resources/Prototypes/_CMU14/Threats/Yautja/Equipment/devices.yml` agrega el componente y la BUI al objeto.
- Localización: `Resources/Locale/en-US/_CMU14/yautja/yautja.ftl` contiene las claves visibles.

Al tocar una funcionalidad parecida, rastrea las cinco superficies. Cambiar solo el YAML o solo el cliente suele dejar contratos incoherentes.

## 3. Arquitectura de ejecución

### `Content.Shared`

Contiene datos y comportamiento que deben ser compatibles entre procesos: componentes, eventos, mensajes serializables, lógica predicha y contratos de sistemas. Los tipos de red deben tener atributos de serialización compatibles y no contener información reservada al servidor.

### `Content.Server`

Es la autoridad. Valida permisos, distancia, estado, coste y reglas incluso cuando el cliente ya los comprobó para UX. También posee administración, persistencia y migraciones. Una BUI o mensaje de red nunca es una prueba de autorización.

### `Content.Client`

Contiene UI, XAML, render, audio local, overlays y controles. Debe mostrar estado replicado y enviar intenciones. Evita introducir decisiones de juego que un cliente modificado pueda falsificar.

### `Resources`

Los recursos se cargan como un grafo:

- YAML declara prototipos y componentes.
- FTL proporciona texto localizado.
- RSI/texturas/audio satisfacen paths lógicos sensibles a casing.
- Los mapas serializan IDs de prototipos y versiones del motor.
- Las pruebas de prototipos y el linter cargan cliente y servidor, por lo que una referencia rota puede fallar lejos del archivo editado.

### Dominios con documentación propia

- Medicina CMU: leer `docs/medical-architecture.md` antes de modificar el agregado médico, sus revisiones o sus proyecciones de red.
- Construcción AU14: leer `Content.Server/_AU14/Construction/CustomConstruction/DATABASE_PERSISTENCE.md` antes de tocar editores, persistencia o YAML generado.

## 4. Preparación segura del checkout

El SDK fijado es .NET 10 (`global.json`: `10.0.100`, con `latestFeature`). Inicializa todos los submódulos porque RobustToolbox tiene submódulos propios:

```bash
git submodule update --init --recursive
dotnet restore SpaceStation14.slnx
```

En Windows, los comandos de esta guía se muestran para Git Bash. Los scripts `.bat` son equivalentes de arranque y los `.ps1` usan PowerShell. Los paths de recursos deben conservar `/` y el casing aunque el filesystem local no los distinga.

### Comandos con efectos laterales

No uses estos comandos como simples comprobaciones:

| Herramienta | Efecto relevante |
| --- | --- |
| `RUN_THIS.py` / `BuildChecker/git_helper.py` | Comprueba que sea un checkout Git, instala/reemplaza hooks y actualiza submódulos. |
| Build de solución `Debug`/`DebugOpt` | Incluye `BuildChecker` y por tanto puede disparar los efectos anteriores. |
| `Tools/sync_audio_placeholders.py` | Crea/reemplaza/elimina placeholders en el repo público según un repo privado hermano. |
| `Content.Tools` como merge driver | Reescribe el archivo “ours” de un mapa durante el merge. |
| `Content.Scripts` | Importa o reescribe RSI/texturas/metadatos según el subprograma. |
| `Content.MapRenderer` | Genera imágenes/JSON de mapas. |
| Comandos de guardado de mapa/Z-level | Serializan mapas completos; pueden producir diffs masivos. |
| Packaging | Limpia y escribe `release/`; publicación además usa tokens y audio privado. |

Para una comprobación integral local sin ejecutar BuildChecker, la solución excluye ese proyecto en `Release`:

```bash
dotnet build SpaceStation14.slnx --configuration Release --no-restore /m
```

## 5. Escalera de validación

No ejecutes toda la CI para un comentario; tampoco cierres un cambio transversal con un único build de proyecto. Elige por alcance.

### Nivel 0: contrato y diff

Siempre al tocar infraestructura de agente y al final de cualquier tarea:

```bash
python3 -m unittest Tools.tests.test_validate_agent_context -v
python3 Tools/validate_agent_context.py
python3 Tools/check_crlf.py
git diff --check
git status --short
```

`Tools/check_crlf.py` consulta el índice de Git; al revisar archivos todavía untracked, comprueba también su encoding/EOL antes de incorporarlos.

### Nivel 1: proyecto propietario

Después de un restore válido:

```bash
dotnet build Content.Shared/Content.Shared.csproj -c DebugOpt --no-restore
dotnet build Content.Server/Content.Server.csproj -c DebugOpt --no-restore
dotnet build Content.Client/Content.Client.csproj -c DebugOpt --no-restore
```

Ejecuta solo los proyectos afectados. Server y Client referencian Shared, pero un cambio a contratos compartidos suele justificar ambos para detectar usos específicos.

### Nivel 2: unit tests

```bash
dotnet test Content.Tests/Content.Tests.csproj -c DebugOpt --no-restore -- NUnit.ConsoleOut=0
```

Para una prueba concreta, añade un filtro NUnit/.NET por nombre completo. No combines `--no-build` con artefactos de otra configuración o anteriores al diff final.

### Nivel 3: YAML y prototipos

```bash
dotnet build Content.YAMLLinter/Content.YAMLLinter.csproj -c DebugOpt --no-restore
dotnet run --project Content.YAMLLinter/Content.YAMLLinter.csproj -c DebugOpt --no-build --no-restore
```

El linter realiza validación de serialización, IDs y referencias con recursos cargados. Para cambios de prototipos/localización añade integración filtrada, por ejemplo al namespace de prototipos o localización:

```bash
dotnet test Content.IntegrationTests/Content.IntegrationTests.csproj -c DebugOpt --no-restore \
  --filter 'FullyQualifiedName~Content.IntegrationTests.Tests.PrototypeTests' -- \
  NUnit.ConsoleOut=0 NUnit.MapWarningTo=Failed
```

Sustituye el filtro por la clase/namespace que cubra el cambio. No presentes ese filtro como suite completa.

### Nivel 4: mapas

Instala las dependencias Python del schema validator en un entorno aislado si aún no existen:

```bash
python3 -m pip install yamale -r .github/Schemas/mapfile_requirements.txt
python3 .github/scripts/validate_yamale.py \
  --schema RobustToolbox/Schemas/mapfile.yml \
  --path-pattern '.*Resources/Maps/.*' \
  --validators RobustToolbox/Schemas/mapfile_validators.py
```

Compila una vez el map checker Rust y ejecútalo para cada árbol afectado:

```bash
cargo build --release --manifest-path .github/map_checker/Cargo.toml
.github/map_checker/target/release/map_checker \
  -c .github/map_checker/matchers.yml \
  -m Resources/Maps/_CMU14
```

Los otros árboles admitidos son `_RMC14` y `_AU14`. Para cambios globales reproduce los tres, como `.github/workflows/mapchecker.yml`. Añade las pruebas de carga/atmósfera de mapas que correspondan; `Content.IntegrationTests/_CMU14/Maps/RotationMapAtmosphereTest.cs` es una prueba específica CMU.

Los mapas YAML no son YAML común: `.gitattributes` asigna `merge=mapping-merge-driver` y `Tools/mapping-merge-driver.sh` llama a `Content.Tools`. Resuelve conflictos con ese flujo o con el editor de mapas, no con ordenación/formateo indiscriminado.

### Nivel 5: assets y atribuciones

Para cualquier `.rsi` cambiado, instala las dependencias en un entorno aislado y valida todo `Resources` como CI:

```bash
python3 -m pip install pillow jsonschema
python3 RobustToolbox/Schemas/validate_rsis.py Resources/
```

Si se cambian archivos `attributions.yml`/`attributions.yaml`:

```bash
python3 -m pip install yamale -r .github/Schemas/rga_requirements.txt
python3 .github/scripts/validate_yamale.py \
  --schema .github/Schemas/rga.yml \
  --path-pattern '.*attributions.ya?ml$' \
  --validators .github/Schemas/rga_validators.py
```

Además de validación estática, inspecciona visualmente estados, direcciones, tamaños y transparencias de sprites.

### Nivel 6: integración y solución

Prueba focalizada:

```bash
dotnet test Content.IntegrationTests/Content.IntegrationTests.csproj -c DebugOpt --no-restore \
  --filter 'FullyQualifiedName~NombreCompleto' -- \
  NUnit.ConsoleOut=0 NUnit.MapWarningTo=Failed
```

La CI divide la suite en grupos porque la ejecución total es costosa. Usa los filtros de `.github/workflows/ci.yml` para reproducir el shard afectado y reserva la suite completa para cambios transversales.

Build integral seguro:

```bash
dotnet build SpaceStation14.slnx -c Release --no-restore /m
```

La CI usa `DebugOpt` y `WarningLevel=0`, pero ese build local incluye BuildChecker. Si hace falta reproducirlo exactamente, documenta que se autorizan sus cambios de hooks/submódulos y revisa el estado posterior.

### Nivel 7: packaging

Para el cliente:

```bash
dotnet restore
dotnet build Content.Packaging -c Release --no-restore /m
dotnet run --project Content.Packaging -c Release --no-build --no-restore -- client --no-restore
```

Para servidor Windows x64:

```bash
dotnet restore --runtime win-x64 /p:TargetOs=Windows
dotnet build Content.Packaging -c Release --no-restore /m
dotnet run --project Content.Packaging -c Release --no-build --no-restore -- \
  server --platform win-x64 --no-restore
```

Estos comandos reproducen `.github/workflows/test-packaging.yml` y escriben en `release/`. Verifica los ZIP reales; no confundas un build de `Content.Packaging` con un paquete generado.

## 6. Reglas de recursos y localización

### Prototipos

- Mantén el prefijo y la carpeta del dominio existente.
- Busca todas las referencias del ID antes de renombrarlo.
- No añadas una entrada a `Resources/migration.yml` salvo que sea una migración de ID de entidad al cargar mapas.
- Un nombre/descripción puede provenir de `ent-<PrototypeId>` en FTL; no dupliques texto muerto en YAML si el patrón local usa la clave generada.

### Localización

El corpus completo actual es `en-US`; `_CMU14` contiene las claves propias. `nl-NL` y `ru-RU` no constituyen traducciones completas. Una iniciativa española debe crear/configurar una locale coherente y auditar cobertura; no debe convertir `en-US` en una mezcla de idiomas.

Comprueba siempre:

- clave declarada y todos sus usos `Loc.GetString`/prototipos;
- argumentos Fluent con el mismo nombre que el código;
- ausencia de claves huérfanas o duplicadas en el dominio cambiado;
- UI visible, no solo sintaxis FTL.

### Audio privado

`Resources/Audio/_CMU14/Private/README.md` define placeholders públicos. Los workflows de publicación clonan `ColonialMarinesAudio` y superponen archivos reales. Si el repositorio privado no está disponible, informa el límite; no sintetices ni copies audio con licencia desconocida.

### Construcción personalizada

`Resources/Prototypes/_AU14/CustomConstruction/Generated/` puede ser escrito por editores en juego y replicado en base de datos. Es una frontera de doble persistencia: un diff YAML aislado puede no representar el estado operativo. Lee la documentación específica y prueba creación/carga/eliminación según el caso.

## 7. Cierre de una tarea de agente

Antes de reportar éxito:

1. Relee el pedido y enumera cada requisito cubierto.
2. Confirma que ninguna modificación preexistente fue revertida.
3. Revisa `git diff --stat`, `git diff --check`, `git diff` y archivos untracked.
4. Ejecuta los niveles de validación que exige el alcance y registra el resultado real.
5. Detén clientes, servidores, watchers y procesos auxiliares.
6. Comprueba que submódulos y gitlinks no cambiaron.
7. Explica con precisión cualquier prueba omitida y el bloqueo; nunca inventes salida.
8. No hagas commit o push salvo que el mantenedor lo haya solicitado.

Esta guía describe el checkout actual. Cuando cambien `global.json`, workflows, estructura de capas o herramientas mutantes, actualiza primero `AGENTS.md`, esta guía y las pruebas del validador en el mismo cambio.

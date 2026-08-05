# CMU-14: contrato operativo para agentes

Este repositorio contiene CMU-14, un juego multijugador ambientado en el universo Alien. CMU deriva de RMC14/CM13 y usa el motor RobustToolbox. Estas instrucciones son el contrato portátil para Hermes, Codex/GPT y otros agentes de código.

`AGENTS.md` es la única fuente de contexto de agente en la raíz. No añadas `.hermes.md`, `HERMES.md`, `CLAUDE.md`, `.cursorrules` ni reglas en `.cursor/rules/*.mdc`: Hermes carga el primer tipo por prioridad y esas copias podrían ocultar o divergir de este contrato. Mantén los detalles ampliados en `docs/agent-development.md`.

## Inicio y comandos canónicos

Trabaja siempre desde la raíz del repositorio. Antes de editar, registra `git status --short --branch`, la rama y los cambios preexistentes. No limpies ni restaures cambios que no hayas creado.

Requisitos reales:

- Git con submódulos recursivos.
- SDK .NET `10.0.100` compatible con `rollForward: latestFeature`, según `global.json`.
- Python 3 para los guardas del repositorio.
- Rust/Cargo solamente para el verificador específico de mapas.

Primera preparación de un checkout:

```bash
git submodule update --init --recursive
dotnet restore SpaceStation14.slnx
```

Comprobación rápida y no mutante del contexto de agentes:

```bash
python3 Tools/validate_agent_context.py
```

Prueba del validador y guardas generales:

```bash
python3 -m unittest Tools.tests.test_validate_agent_context -v
python3 Tools/check_crlf.py
git diff --check
```

Para compilar durante una tarea, usa el proyecto propietario más estrecho y la configuración `DebugOpt`; por ejemplo:

```bash
dotnet build Content.Shared/Content.Shared.csproj --configuration DebugOpt --no-restore
dotnet build Content.Server/Content.Server.csproj --configuration DebugOpt --no-restore
dotnet build Content.Client/Content.Client.csproj --configuration DebugOpt --no-restore
```

No ejecutes `RUN_THIS.py`, `BuildChecker/git_helper.py` ni un build local de la solución en `Debug`/`DebugOpt` solo para “comprobar”. `BuildChecker/git_helper.py` instala/reemplaza hooks de Git y actualiza submódulos. La solución excluye `BuildChecker` en `Release`; el build integral no mutante es:

```bash
dotnet build SpaceStation14.slnx --configuration Release --no-restore /m
```

Los scripts `runclient*` y `runserver*` arrancan procesos persistentes. Úsalos solo para una prueba de ejecución solicitada, verifica una señal real de arranque y detén todos los procesos al terminar.

## Flujo Git unidireccional del fork

Este fork existe principalmente para traducción/localización y adaptaciones propias. El repositorio original `AU-14/ColonialMarinesUniverse` se usa exclusivamente como fuente de cambios entrantes. El flujo autorizado es únicamente `upstream → fork`.

- Antes de operar con remotos, ejecuta `git remote -v`; no presupongas que `origin` o `upstream` apuntan al repositorio esperado.
- Trae cambios del original mediante `fetch` y una rama temporal `sync/upstream-*`; integra y resuelve conflictos localmente, valida el resultado y publícalo solo en el fork.
- Nunca crees, prepares, sugieras ni abras un pull request desde este fork hacia upstream.
- Nunca hagas push a ramas o remotos de upstream.
- Todas las ramas, commits, pushes y pull requests de trabajo deben permanecer dentro del fork.
- Una petición de sincronización significa incorporar upstream al fork; nunca implica contribuir, publicar ni proponer cambios en el repositorio original.

## Arquitectura y propiedad

El lenguaje de contenido es C# 14 con nullable habilitado. Respeta `.editorconfig`: UTF-8, LF salvo scripts de Windows, cuatro espacios en C# y dos en YAML/XML/JSON/proyectos.

Capas de ejecución:

- `Content.Shared`: contratos compartidos, componentes y eventos serializados, lógica predicha y comportamiento que deben conocer cliente y servidor. No pongas aquí secretos ni estado exclusivamente autoritativo.
- `Content.Server`: autoridad de juego, persistencia, administración y mutaciones que el cliente no debe decidir.
- `Content.Client`: UI/XAML, renderizado, overlays, entrada y presentación; no confíes en el cliente para validar acciones.
- `Resources`: prototipos YAML, mapas, Fluent (`.ftl`), texturas, audio y configuración consumida en ejecución.
- `Content.Tests`: pruebas unitarias de contenido.
- `Content.IntegrationTests`: pruebas con instancias reales de cliente/servidor y recursos; pueden tardar mucho y su suite global tiene límite de 45 minutos.
- `Content.YAMLLinter`: valida prototipos cargando tanto cliente como servidor.
- `RobustToolbox` y `RSI.NET`: submódulos fijados. No edites su contenido ni avances sus gitlinks salvo que la tarea lo exija explícitamente.

Propiedad del fork:

- `_CMU14` es la capa propia de CMU en `Content.Server`, `Content.Shared`, `Content.Client`, `Content.IntegrationTests` y los árboles equivalentes de `Resources`.
- `_RMC14`, `_AU14` y `AU14` son capas heredadas pero activamente mantenidas. Conserva una funcionalidad existente en su árbol y namespace actuales; no la muevas a `_CMU14` solo por tocarla.
- Coloca una funcionalidad nueva y exclusivamente CMU en `_CMU14`. Si necesita engancharse a un archivo vanilla o heredado, deja el hook mínimo y sigue el estilo cercano de marcadores, normalmente `// CMU14`, `// CMU14 start` y `// CMU14 end`.
- No deduzcas la propiedad únicamente por el prefijo de un ID: rastrea código, prototipo, localización, asset y pruebas antes de decidir dónde cambiarlo.

Flujo habitual de una funcionalidad: contrato/componente/evento en `Content.Shared/_CMU14`, autoridad en `Content.Server/_CMU14`, presentación en `Content.Client/_CMU14`, y datos en `Resources/Prototypes/_CMU14` más `Resources/Locale/en-US/_CMU14`. Usa las implementaciones Yautja como corte vertical representativo. Para cambios médicos, `docs/medical-architecture.md` es obligatorio: mantiene índice corporal y estado crudo en servidor, separa revisiones estructurales/médicas y limita las proyecciones de red.

## Límites generados y externos

Trata estas fronteras de forma explícita:

1. `Resources/Prototypes/_AU14/CustomConstruction/Generated/` contiene YAML producido por editores dentro del juego y respaldado también en base de datos. No lo uses como destino normal de contenido nuevo ni ejecutes editores para regenerarlo por inspección. Si la tarea lo toca, lee `Content.Server/_AU14/Construction/CustomConstruction/DATABASE_PERSISTENCE.md` y revisa archivos y persistencia.
2. `Resources/Audio/_CMU14/Private/` contiene placeholders silenciosos. Los audios reales viven en el repositorio privado hermano `ColonialMarinesAudio` y el workflow de publicación los superpone. `Tools/sync_audio_placeholders.py` crea, reemplaza y elimina archivos; ejecútalo solo para una sincronización de audio solicitada y nunca inventes contenido privado ausente.
3. `Resources/MapImages/`, `bin/`, `obj/`, `artifacts/`, `release/` y la salida de DocFX son generados/ignorados; no los presentes como cambios fuente.
4. Los comandos de guardado de mapas y Z-levels, `Content.Tools` como merge driver, `Content.MapRenderer`, `Content.Scripts` (metafixer, door splitter, importadores) y los scripts de changelog/patrons pueden escribir o reescribir archivos. Inspecciona su implementación y destino antes de ejecutarlos.
5. `Resources/migration.yml` solo remapea IDs de prototipos de entidad al cargar mapas. No es una tabla universal para referencias de prototipos ni una orden para reemplazos masivos.
6. Las migraciones EF Core de servidor tienen variantes SQLite y PostgreSQL. Usa `Content.Server.Database/add-migration.sh` o su equivalente de Windows para generar ambas; no edites a mano snapshots/designers ni dejes un solo proveedor actualizado.
7. El packaging real escribe ZIP en `release/` y puede incorporar el overlay privado de audio en CI. No publiques, subas artefactos ni ejecutes scripts que requieran tokens salvo petición expresa.

Los paths de recursos son lógicos, con `/` inicial en C#, y sensibles a mayúsculas/minúsculas aunque Windows no lo sea. Conserva exactamente `_CMU14`, `_RMC14` y `_AU14`. Cada RSI debe mantener `meta.json`; respeta licencia, copyright y atribuciones del asset en vez de copiarlos por suposición.

La localización completa actual está en `Resources/Locale/en-US`; las otras carpetas de idioma son testimoniales, no traducciones completas. Coloca claves CMU inglesas siguiendo `Resources/Locale/en-US/_CMU14`. Si una tarea pide español, no mezcles texto español dentro de `en-US`: define primero el alcance/configuración de una locale española y verificala de extremo a extremo.

## Disciplina de cambios

- Lee definiciones, usos, archivos vecinos, proyecto propietario y workflow relevante antes de editar. No inventes símbolos, IDs de prototipo, loc keys, rutas de assets ni dependencias.
- Mantén el diff mínimo. No hagas refactors, renombres, formateos globales ni migraciones de carpetas que la tarea no requiera.
- Para un bug, reproduce con una prueba y comprueba rutas hermanas con el mismo patrón; corrige la clase del fallo, no solo un ejemplo.
- Conserva autoridad de servidor, predicción compartida y presentación cliente como límites distintos. Todo mensaje de UI que muta estado debe revalidarse en servidor.
- No leas ni muestres secretos. No toques `.envrc`, credenciales, tokens ni repositorios privados sin autorización explícita.
- No hagas `git reset --hard`, `git clean`, restores globales ni sobrescribas trabajo concurrente. No hagas stage, commit, push, merge o rebase salvo petición explícita.
- No actualices gitlinks de submódulos por accidente. Después de builds/generadores, inspecciona `git status --short` y clasifica cada cambio.
- Comunícate con el mantenedor en el idioma de su solicitud. Mantén identificadores, APIs, loc keys y términos técnicos canónicos en inglés.

## Verificación por tipo de cambio

Ejecuta primero la comprobación más estrecha y termina con los guardas generales. Un comando con `--no-build` solo es válido después de compilar el mismo proyecto y la misma configuración en el árbol final.

- Solo infraestructura de agentes: las dos órdenes de Python de la sección inicial, `git diff --check` y la prueba de descubrimiento de contexto de Hermes.
- C# compartido/servidor/cliente: build del `.csproj` propietario en `DebugOpt`; añade `Content.Tests` o una prueba de integración filtrada que cubra el comportamiento.
- Unit tests:

  ```bash
  dotnet test Content.Tests/Content.Tests.csproj --configuration DebugOpt --no-restore -- NUnit.ConsoleOut=0
  ```

- Integración focalizada:

  ```bash
  dotnet test Content.IntegrationTests/Content.IntegrationTests.csproj --configuration DebugOpt --no-restore --filter 'FullyQualifiedName~NombreDeLaPrueba' -- NUnit.ConsoleOut=0 NUnit.MapWarningTo=Failed
  ```

- Prototipos/YAML/FTL: compila y ejecuta el linter, y añade la prueba de integración de prototipos/localización que corresponda:

  ```bash
  dotnet build Content.YAMLLinter/Content.YAMLLinter.csproj --configuration DebugOpt --no-restore
  dotnet run --project Content.YAMLLinter/Content.YAMLLinter.csproj --configuration DebugOpt --no-build --no-restore
  ```

- Mapas: ejecuta el map checker para el árbol modificado, la validación de esquema y la prueba de carga/atmósfera pertinente. El workflow cubre `_RMC14`, `_CMU14` y `_AU14`; no compruebes solo un mapa de ejemplo si el cambio es global.
- RSI/texturas: valida todos los RSI afectados con `RobustToolbox/Schemas/validate_rsis.py` y revisa visualmente sprites/estados relevantes.
- Base de datos: genera y prueba ambos proveedores; inspecciona migraciones y snapshots producidos.
- Packaging: reproduce la secuencia `restore` → build de `Content.Packaging` en `Release` → comando `client` o `server --platform ...` usada en `.github/workflows/test-packaging.yml`.
- Cambio transversal o cierre de una tarea grande: ejecuta el build integral `Release`, las suites relevantes y cualquier validador condicional de CI que dispararía el diff.

Antes de declarar terminado: confirma códigos de salida cero, detén procesos iniciados, revisa cambios tracked y untracked, ejecuta `python3 Tools/check_crlf.py` y `git diff --check`, y explica cualquier verificación no ejecutada. No confundas progreso parcial de un build con éxito.

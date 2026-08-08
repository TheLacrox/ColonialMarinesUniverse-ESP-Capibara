# Estado de la traducción es-ES y cómo continuarla

Última medición: 2026-08-08, rama `translate/es-vanilla-prototypes`.

Este documento existe para que una sesión futura no tenga que redescubrir dónde
está el trabajo ni cómo se hizo. `AGENTS.md` sigue siendo el contrato operativo;
esto sólo describe el estado del corpus español.

## Cómo medir el estado real

```bash
python3 Tools/validate_spanish_locale.py --require-complete    # estructura .ftl + cobertura
python3 Tools/validate_spanish_guidebook.py --require-complete  # espejo XML del Guidebook
python3 Tools/audit_spanish_visible_yaml.py                     # literales visibles en YAML
python3 -m unittest Tools.tests.test_validate_spanish_locale \
                    Tools.tests.test_audit_spanish_visible_yaml \
                    Tools.tests.test_validate_spanish_guidebook -v
```

Ninguno está en CI. Los tres deben salir con código 0.

**Trampa histórica:** `audit_spanish_visible_yaml.py` tenía por defecto
`DEFAULT_OWNERS = ("_CMU14", "_AU14", "_RMC14")`, así que ignoraba todo el corpus
vanilla y reportaba `Unlocalized: 0` mientras quedaban 12.057 literales sin
traducir. Ahora audita los 51 directorios por defecto. Si alguna vez ves un cero
perfecto, comprueba el alcance antes de creértelo.

## Qué está cubierto

| Superficie | Estado |
|---|---|
| `Resources/Locale/es-ES/**/*.ftl` | 1527 rutas emparejadas + 19 declaradas en `intentional-fallbacks.txt`. Cobertura total de archivo |
| `Resources/Prototypes/**` (los 51 directorios) | 38.199 / 38.340 literales visibles cubiertos · 0 campos de entidad heredados pendientes |
| `Resources/ServerInfo/es-ES/Guidebook/` | 338 / 338 documentos espejados |
| `Resources/ServerInfo/es-ES/{Gameplay,Sandbox}.txt` | traducidos, con el hook de cultura en `RulesAndInfoWindow.cs` |

## Qué queda

### 1. Los 141 literales restantes

```bash
python3 Tools/audit_spanish_visible_yaml.py --json --output /tmp/audit.json
```

| Grupo | N | Bloqueo |
|---|---|---|
| `constructionGraph`, `RandomPlantMutationList`, `listing`, `palette`, `jukebox`, `construction`, `material` | 91 | `validate_spanish_locale.py` **no reconoce** esos patrones de override. Hay que extender `validate_prototype_override()` antes de poder traducirlos |
| Componentes `ItemSlots`, `NavMapBeacon`, `FaxMachine` | 24 | Van por el mecanismo hash `cmu-yaml-*` en `_CMU14/yaml-literal-overrides.ftl`, no por `ent-` |
| Alertas `Debug1..6` | 12 | Texto de depuración, no visible al jugador. Ignorar |
| `id: *checkerboard` y 4 más | 5 | Falso positivo: son alias de ancla YAML, no IDs. El extractor por regex del audit los confunde |
| `BorgTransponder`, `PresetIdCard`, referencias a IDs de objetivo | 9 | Requieren cableado C# o son nombres propios |

### 2. Decisiones editoriales pendientes

- **`_AU14/radio-channels.ftl`** — 31 códigos de radio de 4 caracteres sin hispanizar
  (`HICMD`, `MILP`, `CLNY`, `AUXY`) mientras `_RMC14/radio-channels.ftl` sí usa
  palabras (`Alto Mando`, `PM`, `CTA`). El origen en-US también difiere de estilo
  entre ambos, así que puede ser deliberado por facción. Si se uniforma
  manteniendo 4 caracteres: `MILP`→`POLM`, `HICMD`→`ALTMD`, `CLNY`→`COLN`,
  `AUXY`→`AUXL`.
- **Disparadores de `chatsan`** — `_AU14/chat/chatsan.ftl` y
  `speech/speech-chatsan.ftl` ya tienen los reemplazos en español; sólo las
  palabras disparadoras siguen en inglés (`omg`, `wtf`, `brb`), por diseño: el
  jugador teclea jerga inglesa. Algunas ya se hispanizaron (`pa`→`para`,
  `aunq`→`aunque`). Hispanizar el resto significa dejar de sanear la jerga
  inglesa, y no se pueden **añadir** IDs sin romper la paridad Fluent: sólo
  sustituir valores.

### 3. Superficie sin medir

Literales C# pasados directamente a popups y mensajes sin `Loc.GetString`. Sólo
se verificaron atributos XAML (`Text`, `Title`, `ToolTip`, `Placeholder`), que
dieron 0. No hay afirmación en ninguna dirección sobre el resto del C#.

### 4. Defecto preexistente, no relacionado con la traducción

Un arranque de servidor emite **2.017 `[ERRO] loc: Error extracting`** sobre
**1.219 IDs `ent-` únicos** que no resuelven, en los overrides `_RMC14`/`_CMU14`.
Es anterior a este trabajo. Para listarlos:

```bash
dotnet run --project Content.Server -c DebugOpt --no-build 2>&1 \
  | grep -o 'Error extracting `"[^"]*"' | sort -u
```

### 5. Drift de sincronización con upstream

Es el frente permanente. Cada merge de `AU-14/ColonialMarinesUniverse` trae
rutas en-US nuevas, prototipos `ent-` nuevos y literales YAML nuevos. Los tres
validadores con `--require-complete` lo detectan; conviene ejecutarlos como paso
fijo tras cada sync.

## Cómo se hizo la campaña vanilla (repetible)

8.936 entidades, 12.514 cadenas únicas. El patrón que funcionó:

1. **Extraer y deduplicar.** Los 31.962 registros del audit colapsan a 12.514
   cadenas inglesas distintas, porque los campos heredados repiten el texto del
   padre. Se traduce cada cadena una vez y se rellena cada uso desde ese glosario.
2. **Separar IDs de prosa.** Un script genera `ent-<Id>`, los atributos, el
   agrupamiento en ficheros y el puente sintético `.desc = { "" }`. Los
   subagentes de traducción **sólo** devuelven `{inglés: español}`. Así ningún
   agente puede romper un identificador de prototipo.
3. **Lotes por tipo de campo**, no por dominio, para que cada agente trabaje en
   un registro uniforme: `name` en minúscula inicial, `desc` con tuteo y `¡¿`,
   `suffix` como etiqueta corta conservando la coma jerárquica.
4. **Verificar antes de generar**: paridad de claves byte a byte, marcado y
   placeables intactos, sin saltos de línea reales.

Trampas encontradas:

- El `\n` **literal de dos caracteres** aparece en muchas descripciones. Los
  agentes tienden a convertirlo en salto real o a duplicar la barra. Hay que
  avisarlo explícitamente en el prompt y normalizarlo después.
- Un `ent-<Id>` debe ser identificador Fluent válido (`[A-Za-z0-9_-]+`).
- Si una entidad lleva `.suffix` pero no tiene descripción efectiva, hace falta
  `.desc = { "" }` o `CalcEntityLoc` descarta el sufijo.
- Los IDs de mensaje deben ser únicos en **todo** el locale, no sólo por fichero.

## Convenciones de traducción

Extraídas del corpus y aplicadas en toda la campaña. Están recogidas en detalle
en los prompts de la campaña; el resumen operativo:

- Nombres de entidad en **minúscula inicial** salvo nombre propio, marca o sigla:
  el motor capitaliza al mostrar.
- Descripciones con tuteo, `¡`/`¿` de apertura, comillas `«»`, elipsis `...`.
- Sufijos muy breves, sin punto final, conservando la estructura de comas
  (`Solars, West` → `Solares, oeste`).
- Se dejan en inglés: siglas de organización y tácticas, códigos de rango y
  puesto (`RFN`, `SL`, `SO`), designaciones de modelo y calibres, nombres propios
  de nave, lugar y marca, y acuñaciones (`Yautja`, `smartgun`).
- Glosario fijo: `dropship` → nave de descenso · `hive` → colmena ·
  `squad` → escuadra · `fireteam` → equipo de fuego · `bracer` → brazalete ·
  `FOB` → base de operaciones · `Medbay` → centro médico · `steel` → metal ·
  `plasteel` → plastiacero · `phoron` → forón · `overwatch` → supervisión ·
  `Provost` → Preboste.

## Nota sobre el Guidebook

`Resources/ServerInfo/es-ES/Guidebook/` está al 338/338, pero **38 de esos
documentos no son alcanzables en juego**: los `guideEntry` de
`Resources/Prototypes/_RMC14/Guidebook/marine_law.yml` están comentados y el
propio fichero remite al árbol AU14 UCMJ como sustituto. Los 300 restantes sí
están registrados y son los que ve el jugador. Las traducciones legadas quedan
listas por si se reactiva ese árbol.

# SPDX-License-Identifier: AGPL-3.0-only
# Copyright (c) 2026 wray-git
# SPDX-License-Identifier: AGPL-3.0-only
## In-game construction menu editor (world right-click > Construction)

verb-categories-construction = Construcción

construction-category-au14-custom = Personalizado

construction-menu-verb-add = Añadir al menú de construcción
construction-menu-verb-add-message = Añade este objeto de forma permanente al menú de construcción (se aplicará tras el próximo reinicio).
construction-menu-verb-remove = Eliminar del menú de construcción
construction-menu-verb-remove-message = Elimina este objeto del menú de construcción (se aplicará tras el próximo reinicio).
construction-menu-verb-change-recipe = Cambiar receta
construction-menu-verb-change-recipe-message = Cambia la lista de aparición, la categoría o la receta de este objeto del menú (se aplicará tras el próximo reinicio).
construction-menu-verb-change-recipe-disabled = Este objeto no está en el menú de construcción. Añádelo primero.

## Add / Change dialogs

construction-menu-dialog-add-title = Añadir { $item } al menú de construcción
construction-menu-dialog-change-title = Cambiar receta — { $item }
construction-menu-dialog-spawnlist = Lista de aparición (predeterminada: { $default })
construction-menu-dialog-category = Categoría (predeterminada: { $default })
construction-menu-dialog-recipe = Receta, p. ej., { $example } (Material:Amount, separa los pasos con >; herramientas: weld/wrench/screw/pry/cut)
construction-menu-dialog-spawnlist-current = Lista de aparición (actual: { $current })
construction-menu-dialog-category-current = Categoría (actual: { $current })
construction-menu-dialog-recipe-current = Receta (actual: { $current })

## Result popups

construction-menu-verb-added = Se añadió { $item } a «{ $category }». Receta: { $recipe }. Se aplicará tras el próximo reinicio.
construction-menu-verb-recipe-changed = Se actualizó { $item }. Receta: { $recipe }. Se aplicará tras el próximo reinicio.
construction-menu-verb-removed = Se eliminó { $item } del menú de construcción. Se aplicará tras el próximo reinicio.

## Editor window

construction-editor-title = Editor del menú de construcción
construction-editor-title-add = Añadir al menú de construcción
construction-editor-title-edit = Cambiar receta
construction-editor-spawnlist = Lista de aparición
construction-editor-category = Categoría
construction-editor-new-spawnlist = Nombre de la nueva lista de aparición…
construction-editor-new-category = Nombre de la nueva categoría…
construction-editor-add-new = Añadir nueva…
construction-editor-confirm = Confirmar
construction-editor-material-custom = Personalizado…
construction-editor-material-notfound = No se encontró el material «{ $material }»; elige uno válido.
construction-editor-steps = Pasos de la receta
construction-editor-material = Id. de pila personalizada (p. ej., Steel)
construction-editor-amount = Cant.
construction-editor-doafter = s
construction-editor-add-material = + Material
construction-editor-add-tool = + Herramienta
construction-editor-remove-step = Eliminar último
construction-editor-clear-steps = Borrar
construction-editor-ok = Guardar (próximo reinicio)
construction-editor-cancel = Cancelar
construction-editor-health = Salud
construction-editor-health-placeholder = en blanco = heredar
construction-editor-danger = Zona peligrosa: eliminación masiva
construction-editor-remove-include-all = Incluir TODAS las entidades de esta lista de aparición/categoría
construction-editor-remove-group = Eliminar lista de aparición/categoría
construction-editor-remove-confirm = Confirmar eliminación
construction-editor-remove-need-check = Marca primero «Incluir todas las entidades» para confirmar esta acción destructiva.
construction-editor-remove-warning = ADVERTENCIA: elimina permanentemente TODAS las recetas de { $spawnlist } / { $category }. Espera 3 segundos...
construction-editor-remove-ready = Listo: haz clic en Confirmar para eliminar permanentemente todas las recetas de { $spawnlist } / { $category }.
construction-menu-group-removed = Se eliminaron { $count } recetas de { $spawnlist } / { $category }. Se aplicará tras el próximo reinicio.
construction-editor-step-material = { $amount } x { $material } ({ $sec } s)
construction-editor-step-tool = Herramienta: { $tool } ({ $sec } s)

## Deconstruction steps (structures only)

construction-editor-deconstruct-steps = Pasos de desmontaje (estructuras; predeterminado: palanca)
construction-editor-add-deconstruct-tool = + Herramienta
construction-editor-pick-deconstruct-entity-tool = + Herramienta personalizada…
construction-editor-remove-deconstruct-step = Eliminar último
construction-editor-clear-deconstruct-steps = Borrar

construction-menu-verb-add-failed = No se pudo añadir el objeto al menú de construcción.
construction-menu-verb-remove-failed = No se pudo eliminar el objeto del menú de construcción.
construction-menu-verb-bad-recipe = No se pudo interpretar esa receta. Usa, por ejemplo, «Steel:4 > weld > Steel:2».

construction-menu-verb-invalid = No se puede guardar la receta: { $reason }
construction-menu-invalid-no-steps = la receta necesita al menos un paso de material.
construction-menu-invalid-tool = los pasos de herramientas («{ $tool }») aún no son compatibles; usa solo pasos de materiales. (El proceso de construcción no puede exigir herramientas sin bloquearse).
construction-menu-invalid-tool-item = los pasos de herramientas («{ $tool }») no son compatibles con objetos sostenidos en la mano; solo funcionan con estructuras. Elimina el paso de herramienta o elige una estructura.
construction-menu-invalid-material = el material «{ $material }» no es apto para construir. Usa un material de CM (p. ej., CMSteel, CMPlasteel, CMGlass, CMGlassReinforced, RMCWood o RMCPlastic).
construction-menu-invalid-entity = la entidad «{ $entity }» no existe. Elige un prototipo real en el selector.
construction-menu-invalid-deconstruct-material = los pasos de desmontaje solo pueden usar herramientas (p. ej., crowbar o welder); no puedes introducir materiales para desmontar algo. Elimina el paso de material.

## Custom material/tool selector + editor additions

construction-editor-pick-entity-material = + Material personalizado…
construction-editor-pick-entity-tool = + Herramienta personalizada (no se consume)…
construction-editor-step-entity-material = { $amount } x { $entity } ({ $sec } s)
construction-editor-step-entity-tool = Herramienta (se conserva): { $entity } ({ $sec } s)
construction-selector-title = Selecciona una entidad
construction-selector-search = Buscar entidades…
construction-selector-select = Seleccionar

## Utilities → Admin Tools

gmod-construction-menu-admin-tools = Herramientas de administración
gmod-construction-menu-items-editor = Editor de objetos de construcción
gmod-construction-menu-tiles-editor = Editor de casillas
gmod-construction-menu-lathe-editor = Editor de tornos
gmod-construction-menu-zlevel-toggles = Opciones de nivel Z
gmod-construction-menu-spawnlist-delete = Eliminar lista de aparición
construction-menu-editor-not-admin = No eres administrador; el editor no se abrirá.

## Spawnlist Delete tool (Admin Tools → Delete Spawnlist)

construction-spawnlist-delete-title = Eliminar lista de aparición
construction-spawnlist-delete-pick = Lista de aparición que eliminar (con su número de recetas):
construction-spawnlist-delete-option = { $spawnlist } ({ $count } recetas)
construction-spawnlist-delete-none = No hay listas de aparición con recetas generadas.
construction-spawnlist-delete-arm = Eliminar…
construction-spawnlist-delete-confirm = CONFIRMAR ELIMINACIÓN
construction-spawnlist-delete-warning = Esto elimina TODAS las recetas generadas de «{ $spawnlist }». La confirmación se desbloqueará en breve…
construction-spawnlist-delete-ready = Listo: al confirmar se eliminará «{ $spawnlist }» y todas sus recetas.
construction-menu-spawnlist-deleted = Se eliminó la lista de aparición «{ $spawnlist }» ({ $count } recetas eliminadas).
construction-spawnlist-delete-pick-category = Ámbito (elimina una categoría o toda la lista de aparición):
construction-spawnlist-delete-category-all = Toda la lista de aparición (todas las categorías)
construction-spawnlist-delete-category-option = { $category } ({ $count } recetas)
construction-spawnlist-delete-category-warning = Esto elimina TODAS las recetas generadas de la categoría «{ $category }» de «{ $spawnlist }». La confirmación se desbloqueará en breve…
construction-spawnlist-delete-category-ready = Listo: al confirmar se eliminará la categoría «{ $category }» de «{ $spawnlist }» y todas sus recetas.
construction-menu-spawnlist-category-deleted = Se eliminó la categoría «{ $category }» de la lista de aparición «{ $spawnlist }» ({ $count } recetas eliminadas).

## DB save preview (human-in-the-loop confirm before any Save writes files/database rows)

construction-db-preview-title = Confirmar guardado: cambios pendientes
construction-db-preview-summary = { $kind }: { $planned } escritura(s) planificadas, { $rejected } rechazadas. Revisa los cambios y confirma.
construction-db-preview-confirm = Confirmar guardado
construction-db-preview-cancel = Cancelar
construction-db-preview-kind-entry = Entrada de construcción
construction-db-preview-kind-mass = Entidades en masa
construction-db-preview-kind-mass-tiles = Casillas en masa

## Utilities → INSFOR

gmod-construction-menu-insfor = INSFOR
gmod-construction-menu-insfor-editor = Editor de INSFOR
gmod-construction-menu-insfor-custom-editor = Editor personalizado de INSFOR

## In-menu detail panel: Change Recipe / Remove Item (admins; works for vanilla recipes too)

gmod-construction-menu-change-recipe = Cambiar receta
gmod-construction-menu-remove-item = Eliminar objeto
construction-menu-recipe-hidden = Se eliminó «{ $recipe }» del menú de construcción. Se aplicará por completo tras el próximo reinicio.
construction-menu-recipe-already-hidden = «{ $recipe }» ya está eliminado del menú de construcción.
construction-menu-recipe-hide-failed = No se pudo eliminar esa receta del menú de construcción.

## Recipe chooser (entity already has recipes)

construction-chooser-title = Recetas de este objeto
construction-chooser-entry = { $spawnlist } / { $category }
construction-chooser-change = Cambiar
construction-chooser-remove = Eliminar
construction-chooser-add-new = Añadir receta nueva
construction-menu-verb-no-resources = No se puede editar el menú de construcción: no se encontró ningún directorio Resources con permisos de escritura.

## Tiles editor

construction-tile-editor-title = Añadir casilla al menú de construcción
construction-tile-editor-tile = Casilla
construction-tile-editor-search = Buscar casillas...
construction-tile-editor-main-category = Categoría principal
construction-tile-editor-page-zlevel = Nivel Z (experimental)
construction-tile-editor-page-spawnlists = Listas de aparición
construction-tile-editor-spawnlist = Lista de aparición (solo en la página Listas de aparición)
construction-tile-editor-category = Categoría
construction-tile-editor-material = Material
construction-tile-editor-amount = Coste (láminas)
construction-tile-editor-selected = Casilla seleccionada: { $tile }
construction-tile-editor-none = (ninguna casilla seleccionada)
construction-tile-editor-save = Guardar (próximo reinicio)
construction-tile-editor-cancel = Cancelar
construction-menu-tile-invalid-tile = La casilla «{ $tile }» no es válida. Elige una de la lista.
construction-menu-tile-added = Se añadió la casilla { $tile } a «{ $category }». Se aplicará tras el próximo reinicio.

## Lathe editor

construction-lathe-editor-title = Añadir receta de torno
construction-lathe-editor-lathe = Torno
construction-lathe-editor-autolathe = Autotorno
construction-lathe-editor-armylathe = Torno militar
construction-lathe-editor-pick-item = Elegir objeto que imprimir...
construction-lathe-editor-selected = Objeto: { $item }
construction-lathe-editor-none = (ningún objeto seleccionado)
construction-lathe-editor-steel = Coste de acero
construction-lathe-editor-glass = Coste de vidrio
construction-lathe-editor-plastic = Coste de plástico
construction-lathe-editor-time = Tiempo de impresión (s)
construction-lathe-editor-save = Guardar (próximo reinicio)
construction-lathe-editor-cancel = Cancelar
construction-menu-lathe-invalid-cost = Establece al menos un coste de material (acero / vidrio / plástico).
construction-menu-lathe-added = Se añadió { $item } a { $lathe }. Se aplicará tras el próximo reinicio.
construction-menu-lathe-removed = Se eliminó la receta de torno { $recipe }. Se aplicará tras el próximo reinicio.
construction-lathe-editor-existing = Recetas añadidas existentes (haz clic para eliminar)
construction-lathe-editor-remove = Eliminar

# Mass Entity Editor (Admin Tools): batch-add many entities under one recipe
gmod-construction-menu-mass-editor = Editor de entidades en masa
construction-mass-selector-title = Editor de entidades en masa: seleccionar entidades
construction-mass-selector-parent-search = Buscar prototipos padre...
construction-mass-selector-parent-all = Todos los padres
construction-mass-selector-select-all = Seleccionar todo lo mostrado
construction-mass-selector-clear = Borrar
construction-mass-selector-confirm = Continuar
construction-mass-selector-count = Seleccionadas: {$count}
construction-menu-mass-item-name = {$count} entidades seleccionadas
construction-menu-mass-none = Ninguna de las entidades seleccionadas es válida.
construction-menu-mass-added = Se añadieron {$added} objetos a {$category} ({$recipe}).
construction-menu-mass-partial = Se añadieron {$added} objetos; {$failed} fallaron ({$reason}).

# Mass Entity Editor - Tiles mode
construction-mass-selector-tiles = Casillas
construction-mass-tiles-title = Receta de casillas en masa ({$count} casillas)
construction-menu-mass-tiles-added = Se añadieron {$added} casillas a {$category}.

# Z-Sync Lists (Admin Tools): which walls mirror across z-levels as map borders
gmod-construction-menu-zsync-lists = Listas de sincronización Z
au-zsync-title = Listas de sincronización Z: reflejo de bordes multinivel
au-zsync-browser-header = Todas las entidades (selecciona y añade a una lista)
au-zsync-lists-header = Listas actuales
au-zsync-whitelist = Lista blanca (se refleja entre niveles Z)
au-zsync-blacklist = Lista negra (nunca se refleja; prevalece sobre la lista blanca)
au-zsync-add-whitelist = Añadir a la lista blanca
au-zsync-add-blacklist = Añadir a la lista negra
au-zsync-pick-whitelist = Elegir entidad -> Lista blanca
au-zsync-pick-blacklist = Elegir entidad -> Lista negra
au-zsync-remove-selected = Eliminar seleccionadas
au-zsync-changed = Se actualizó la {$list} de sincronización Z ({$count} cambios).
au-zsync-picked = Se añadió {$proto} a la {$list} de sincronización Z.
au-zsync-pick-instruction = Haz clic en una entidad de la ronda para añadir su prototipo a la lista de sincronización Z seleccionada. Haz clic derecho para cancelar.
au-zsync-pick-no-entity = No hay ninguna entidad bajo el cursor.
au-zsync-pick-cancelled = Se canceló la selección de entidad para sincronización Z.
au-zsync-scope-button = Ámbito: {$scope}
au-zsync-scope-global = Global (todos los mapas)
au-zsync-scope-maps = {$count} mapa(s)
au-zsync-scope-header = Editar ámbito
au-zsync-scope-global-button = Global
au-zsync-scope-info = Editando la sincronización Z para: {$scope}
au-zsync-move-to-whitelist = Mover seleccionadas a la lista blanca
au-zsync-move-to-blacklist = Mover seleccionadas a la lista negra
au-zsync-conflict-title = Ya está en la lista opuesta
au-zsync-conflict-text = Estas entidades ya están en la {$list}. Confirmar las mueve; Ignorar solo añade las demás.
au-zsync-confirm = Confirmar
au-zsync-ignore = Ignorar

# Tool Permissions (Admin Tools): Host-only per-ckey grants for the editor tools
gmod-construction-menu-tool-permissions = Permisos de herramientas
au14-toolperm-title = Permisos de herramientas: acceso al editor por ckey
au14-toolperm-grant-header = Conceder una herramienta (el ckey funciona aunque el jugador esté desconectado)
au14-toolperm-ckey-placeholder = ckey...
au14-toolperm-grant = Conceder
au14-toolperm-users-header = Usuarios con permisos (haz clic en un ckey para ampliarlo)
au14-toolperm-none = Todavía nadie tiene permisos de herramientas.
au14-toolperm-remove = Eliminar
au14-toolperm-tool-construction = Editor de objetos de construcción
au14-toolperm-tool-mass = Editor de entidades en masa
au14-toolperm-tool-tiles = Editor de casillas
au14-toolperm-tool-lathe = Editor de tornos
au14-toolperm-tool-zleveltoggles = Opciones de nivel Z
au14-toolperm-tool-zsync = Listas de sincronización Z
au14-toolperm-tool-insfor = Editor de INSFOR
au14-toolperm-tool-spawnlistdelete = Eliminación de listas de aparición




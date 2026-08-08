# SPDX-License-Identifier: AGPL-3.0-only
# Copyright (c) 2026 wray-git
# SPDX-License-Identifier: AGPL-3.0-only
# Examine line shown on any entity a player constructed.
construction-player-built-examine = Construido por [color=cyan]{ $name }[/color].

# Build-partner verbs (right-click another player).
build-partner-add-verb = Añadir como socio de construcción
build-partner-remove-verb = Eliminar socio de construcción
build-partner-added = { $name } ya puede incluir tus construcciones en sus archivos guardados.
build-partner-removed = { $name } ya no puede incluir tus construcciones en sus archivos guardados.

# Saving builds.
saved-build-success = Se guardó la construcción «{ $name }» ({ $count } entidades, { $tiles } casillas).
saved-build-error-no-name = Primero debes dar un nombre a la construcción.
saved-build-error-empty = La selección no contiene nada construido por ti ni por un socio.
saved-build-error-serialize = No se pudo serializar esa construcción.
saved-build-error-write = No se pudo escribir el archivo de la construcción.

# Build-save selection panel (client).
saved-build-window-title = Guardar una construcción
saved-build-window-range = Alcance
saved-build-window-size = Selección: { $size }x{ $size } casillas
saved-build-window-append = Añadir alcance
saved-build-window-clear = Borrar
saved-build-window-selected = Resaltado: { $count } entidades, { $tiles } casillas
saved-build-window-multiz-help = El guardado multinivel Z es experimental:
    - Las construcciones multinivel Z solo funcionan al usar «Colocar en el origen».
    - Coloca la construcción original una vez en cada nivel Z: construye un nivel, pasa al siguiente y vuelve a usar «Colocar en el origen».
    - Para obtener la máxima estabilidad, crea un archivo guardado por separado para cada nivel Z.
saved-build-window-name = Nombre de la construcción…
saved-build-window-save = Guardar construcción
saved-build-window-open-folder = Abrir carpeta de construcciones guardadas
saved-build-window-include-tiles = Guardar casillas
saved-build-window-include-multiz = Capturar otros niveles Z (superiores/inferiores)

# Saved Builds spawnlist in the construction menu.
gmod-construction-menu-saved-builds = Construcciones guardadas
saved-build-card = { $name }  ({ $author } · { $count })
saved-build-detail-desc = Por { $author }
    { $count } entidades · { $source }
saved-build-none = Aún no hay construcciones guardadas. Usa la herramienta de guardado para crear una.
saved-build-place-button = Colocar construcción
saved-build-placed = Construcción colocada ({ $count } piezas).
saved-build-error-load = No se pudo cargar esa construcción guardada.
saved-build-error-nogrid = Solo puedes colocar una construcción sobre una cuadrícula.
saved-build-error-noorigin = La ubicación original de esta construcción ya no existe.
saved-build-error-notadmin = Solo los administradores pueden colocar una construcción al instante. Constrúyela con fantasmas de construcción.
saved-build-place-original-button = Colocar en el origen
saved-build-ghosts-placed = Se colocaron { $count } fantasmas de construcción. Constrúyelos con materiales.

# Saved-build management (delete + open folder).
gmod-construction-menu-delete-build = Eliminar construcción
gmod-construction-menu-open-build-folder = Abrir carpeta de construcciones
saved-build-deleted = Se eliminó esa construcción guardada.
saved-build-error-delete = No se pudo eliminar esa construcción guardada.
saved-build-error-delete-notyours = Solo puedes eliminar las construcciones que hayas guardado. (Los administradores pueden eliminar cualquiera).

# Build-mode dropdown at the top of the construction menu.
gmod-construction-menu-mode-admin = Construcción: administrador (instantánea)
gmod-construction-menu-mode-player = Construcción: jugador (fantasmas)
gmod-construction-menu-mode-mapper = Construcción: mapeador (cualquier entidad)

# Build partners window (the "Partners" button).
build-partner-window-title = Socios de construcción
build-partner-window-desc = Añade a un jugador para permitirle incluir TUS objetos construidos en sus construcciones guardadas.
build-partner-window-empty = No hay otros jugadores conectados.
build-partner-window-add = Añadir
build-partner-window-remove = Eliminar
build-partner-window-clear-all = Borrar todos los socios
build-partner-granted-to-you = { $name } te ha añadido como socio de construcción; ahora puedes guardar sus construcciones.
build-partner-revoked-from-you = { $name } te ha eliminado como socio de construcción.

# Saved-build window extra option (mapper mode) + detail-panel rename/delete.
saved-build-window-include-loose = Incluir objetos sueltos
gmod-construction-menu-rename-build = Cambiar nombre
gmod-construction-menu-delete-build-confirm = ¿Confirmar eliminación?

# Placement controls hint (top-left).
saved-build-controls-mode-admin = Modo: administrador (instantáneo y gratis)
saved-build-controls-mode-player = Modo: construcción (fantasmas + materiales)
saved-build-controls-gridalign = Alt (alternar): alineado con cuadrícula ({ $state })
saved-build-controls-rotate = { $key }: girar
saved-build-controls-place = Clic izquierdo: colocar
saved-build-controls-cancel = Clic derecho: cancelar

# Multi-z placement
saved-build-z-skipped = No se pudieron colocar {$count} entidades porque aquí no se pudo crear su nivel Z.


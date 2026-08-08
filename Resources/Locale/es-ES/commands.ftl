### Localization for engine console commands

cmd-hint-float = [número decimal]

## generic command errors

cmd-invalid-arg-number-error = Número de argumentos no válido.

cmd-parse-failure-integer = {$arg} no es un entero válido.
cmd-parse-failure-float = {$arg} no es un número decimal válido.
cmd-parse-failure-bool = {$arg} no es un booleano válido.
cmd-parse-failure-uid = {$arg} no es un UID de entidad válido.
cmd-parse-failure-mapid = {$arg} no es un ID de mapa válido.
cmd-parse-failure-enum = {$arg} no es un valor de la enumeración {$enum}.
cmd-parse-failure-grid = {$arg} no es una cuadrícula válida.
cmd-parse-failure-cultureinfo = "{$arg}" no es un CultureInfo válido.
cmd-parse-failure-entity-exist = El UID {$arg} no corresponde a ninguna entidad existente.
cmd-parse-failure-session = No hay ninguna sesión con el nombre de usuario {$username}.

cmd-error-file-not-found = No se encontró el archivo: {$file}.
cmd-error-dir-not-found = No se encontró el directorio: {$dir}.

cmd-failure-no-attached-entity = No hay ninguna entidad vinculada a esta consola.

## 'help' command
cmd-help-desc = Muestra ayuda general o el texto de ayuda de un comando concreto.
cmd-help-help = Uso: {$command} [nombre del comando]
    Si no se indica un nombre de comando, muestra la ayuda general. Si se indica uno, muestra la ayuda de ese comando.

cmd-help-no-args = Para ver la ayuda de un comando concreto, escribe «help <comando>». Para enumerar todos los comandos disponibles, escribe «list». Para buscar comandos, usa «list <filtro>».
cmd-help-unknown = Comando desconocido: { $command }
cmd-help-top = { $command } - { $description }
cmd-help-invalid-args = Cantidad de argumentos no válida.
cmd-help-arg-cmdname = [nombre del comando]

## 'cvar' command
cmd-cvar-desc = Obtiene o establece una CVar.
cmd-cvar-help = Uso: {$command} <nombre | ?> [valor]
    Si se proporciona un valor, se analiza y se guarda como nuevo valor de la CVar.
    De lo contrario, se muestra el valor actual de la CVar.
    Usa «cvar ?» para obtener una lista de todas las CVar registradas.

cmd-cvar-invalid-args = Debes proporcionar exactamente uno o dos argumentos.
cmd-cvar-not-registered = La CVar «{ $cvar }» no está registrada. Usa «cvar ?» para obtener una lista de todas las CVar registradas.
cmd-cvar-parse-error = El valor introducido tiene un formato incorrecto para el tipo { $type }.
cmd-cvar-compl-list = Enumerar las CVar disponibles
cmd-cvar-arg-name = <nombre | ?>
cmd-cvar-value-hidden = <valor oculto>

## 'cvar_subs' command
cmd-cvar_subs-desc = Enumera las suscripciones OnValueChanged de una CVar.
cmd-cvar_subs-help = Uso: {$command} <nombre>

cmd-cvar_subs-invalid-args = Debes proporcionar exactamente un argumento.
cmd-cvar_subs-arg-name = <nombre>

## 'list' command
cmd-list-desc = Enumera los comandos disponibles, con un filtro de búsqueda opcional.
cmd-list-help = Uso: {$command} [filtro]
    Enumera todos los comandos disponibles. Si se proporciona un argumento, se usará para filtrar los comandos por nombre.

cmd-list-heading = LADO NOMBRE          DESCRIPCIÓN{"\u000A"}-------------------------{"\u000A"}

cmd-list-arg-filter = [filtro]

## '>' command, aka remote exec
cmd-remoteexec-desc = Ejecuta comandos en el servidor.
cmd-remoteexec-help = Uso: > <comando> [argumento] [argumento] [argumento...]
    Ejecuta un comando en el servidor. Esto es necesario si existe un comando con el mismo nombre en el cliente, ya que ejecutarlo sin más daría prioridad al comando del cliente.

## 'gc' command
cmd-gc-desc = Ejecuta el GC (recolector de basura).
cmd-gc-help = Uso: {$command} [generación]
    Usa GC.Collect() para ejecutar el recolector de basura.
    Si se proporciona un argumento, se interpreta como un número de generación del GC y se usa GC.Collect(int).
    Usa el comando «gfc» para realizar un GC completo que compacte el LOH.
cmd-gc-failed-parse = No se pudo interpretar el argumento.
cmd-gc-arg-generation = [generación]

## 'gcf' command
cmd-gcf-desc = Ejecuta un GC completo, compactando el LOH y todo lo demás.
cmd-gcf-help = Uso: {$command}
    Ejecuta un GC.Collect(2, GCCollectionMode.Forced, true, true) completo y compacta también el LOH.
    Es probable que el programa se bloquee durante cientos de milisegundos; tenlo en cuenta.

## 'gc_mode' command
cmd-gc_mode-desc = Cambia o consulta el modo de latencia del GC.
cmd-gc_mode-help = Uso: {$command} [tipo]
    Si no se proporciona ningún argumento, devuelve el modo de latencia actual del GC.
    Si se proporciona un argumento, se interpreta como GCLatencyMode y se establece como modo de latencia del GC.

cmd-gc_mode-current = modo de latencia actual del GC: { $prevMode }
cmd-gc_mode-possible = modos posibles:
cmd-gc_mode-option = - { $mode }
cmd-gc_mode-unknown = modo de latencia del GC desconocido: { $arg }
cmd-gc_mode-attempt = intentando cambiar el modo de latencia del GC: { $prevMode } -> { $mode }
cmd-gc_mode-result = modo de latencia del GC resultante: { $mode }
cmd-gc_mode-arg-type = [tipo]

## 'mem' command
cmd-mem-desc = Muestra información sobre la memoria administrada.
cmd-mem-help = Uso: {$command}

cmd-mem-report = Tamaño del montón: { TOSTRING($heapSize, "N0") }
    Total asignado: { TOSTRING($totalAllocated, "N0") }

## 'physics' command
cmd-physics-overlay = {$overlay} no es una superposición reconocida.

## 'lsasm' command
cmd-lsasm-desc = Enumera los ensamblados cargados por contexto de carga.
cmd-lsasm-help = Uso: lsasm

## 'exec' command
cmd-exec-desc = Ejecuta un archivo de script desde los datos de usuario modificables del juego.
cmd-exec-help = Uso: {$command} <nombre de archivo>
    Cada línea del archivo se ejecuta como un único comando, salvo que empiece por #.

cmd-exec-arg-filename = <nombre de archivo>

## 'dump_net_comps' command
cmd-dump_net_comps-desc = Muestra la tabla de componentes de red.
cmd-dump_net_comps-help = Uso: {$command}

cmd-dump_net_comps-error-writeable = El registro aún se puede modificar; no se han generado los ID de red.
cmd-dump_net_comps-header = Registros de componentes de red:

## 'dump_event_tables' command
cmd-dump_event_tables-desc = Muestra las tablas de eventos dirigidos de una entidad.
cmd-dump_event_tables-help = Uso: {$command} <UID de entidad>

cmd-dump_event_tables-missing-arg-entity = Falta el argumento de la entidad.
cmd-dump_event_tables-error-entity = Entidad no válida.
cmd-dump_event_tables-arg-entity = <UID de entidad>

## 'monitor' command
cmd-monitor-desc = Activa o desactiva un monitor de depuración en el menú F3.
cmd-monitor-help = Uso: {$command} <nombre>
    Los monitores posibles son: { $monitors }
    También puedes usar los valores especiales "-all" y "+all" para ocultar o mostrar todos los monitores, respectivamente.

cmd-monitor-arg-monitor = <monitor>
cmd-monitor-invalid-name = Nombre de monitor no válido.
cmd-monitor-arg-count = Falta el argumento del monitor.
cmd-monitor-minus-all-hint = Oculta todos los monitores.
cmd-monitor-plus-all-hint = Muestra todos los monitores.


## 'setambientlight' command
cmd-set-ambient-light-desc = Permite establecer la luz ambiental del mapa indicado, en sRGB.
cmd-set-ambient-light-help = Uso: {$command} [ID de mapa] [r g b a]
cmd-set-ambient-light-parse = No se pudieron interpretar los argumentos como valores byte de un color.

## Mapping commands

cmd-savemap-desc = Serializa un mapa en el disco. No guardará un mapa posterior a la inicialización salvo que se fuerce.
cmd-savemap-help = Uso: {$command} <ID de mapa> <ruta> [forzar]
cmd-savemap-not-exist = El mapa de destino no existe.
cmd-savemap-init-warning = Se intentó guardar un mapa posterior a la inicialización sin forzar el guardado.
cmd-savemap-attempt = Intentando guardar el mapa {$mapId} en {$path}.
cmd-savemap-success = El mapa se ha guardado correctamente.
cmd-savemap-error = ¡No se pudo guardar el mapa! Consulta el registro del servidor para obtener más información.
cmd-hint-savemap-id = <ID de mapa>
cmd-hint-savemap-path = <ruta>
cmd-hint-savemap-force = [booleano]

cmd-loadmap-desc = Carga en el juego un mapa desde el disco.
cmd-loadmap-help = Uso: {$command} <ID de mapa> <ruta> [x] [y] [rotación] [UID coherentes]
cmd-loadmap-nullspace = No puedes cargar contenido en el mapa 0.
cmd-loadmap-exists = El mapa {$mapId} ya existe.
cmd-loadmap-success = El mapa {$mapId} se ha cargado desde {$path}.
cmd-loadmap-error = Se produjo un error al cargar el mapa desde {$path}.
cmd-hint-loadmap-x-position = [posición-x]
cmd-hint-loadmap-y-position = [posición-y]
cmd-hint-loadmap-rotation = [rotación]
cmd-hint-loadmap-uids = [UID coherentes]

cmd-hint-savebp-id = <ID de entidad de cuadrícula>

## 'flushcookies' command
# Note: the flushcookies command is from Robust.Client.WebView, it's not in the main engine code.

cmd-flushcookies-desc = Vuelca al disco el almacenamiento de cookies de CEF.
cmd-flushcookies-help = Uso: {$command}
    Esto garantiza que las cookies se guarden correctamente en el disco si se produce un cierre inesperado.
    Ten en cuenta que la operación en sí es asíncrona.

cmd-ldrsc-desc = Guarda un recurso en la caché de antemano.
cmd-ldrsc-help = Uso: {$command} <ruta> <tipo>

cmd-rldrsc-desc = Recarga un recurso.
cmd-rldrsc-help = Uso: {$command} <ruta> <tipo>

cmd-gridtc-desc = Obtiene el número de baldosas de una cuadrícula.
cmd-gridtc-help = Uso: {$command} <ID de cuadrícula>


# Client-side commands
cmd-guidump-desc = Vuelca el árbol de la interfaz gráfica en /guidump.txt dentro de los datos de usuario.
cmd-guidump-help = Uso: {$command}

cmd-uitest-desc = Abre una ventana ficticia para probar la interfaz.
cmd-uitest-help = Uso: {$command}

## 'uitest2' command
cmd-uitest2-desc = Abre una ventana del sistema para probar controles de la interfaz.
cmd-uitest2-help = Uso: {$command} <pestaña>
cmd-uitest2-arg-tab = <pestaña>
cmd-uitest2-error-args = Se esperaba como máximo un argumento.
cmd-uitest2-error-tab = Pestaña no válida: «{$value}».
cmd-uitest2-title = UITest2


cmd-setclipboard-desc = Establece el contenido del portapapeles del sistema.
cmd-setclipboard-help = Uso: {$command} <texto>

cmd-getclipboard-desc = Obtiene el contenido del portapapeles del sistema.
cmd-getclipboard-help = Uso: {$command}

cmd-togglelight-desc = Activa o desactiva el renderizado de la iluminación.
cmd-togglelight-help = Uso: {$command}

cmd-togglefov-desc = Activa o desactiva el campo de visión del cliente.
cmd-togglefov-help = Uso: {$command}

cmd-togglehardfov-desc = Activa o desactiva el campo de visión estricto del cliente (para depurar space-station-14#2353).
cmd-togglehardfov-help = Uso: {$command}

cmd-toggleshadows-desc = Activa o desactiva el renderizado de sombras.
cmd-toggleshadows-help = Uso: {$command}

cmd-togglelightbuf-desc = Activa o desactiva el renderizado de la iluminación. Incluye las sombras, pero no el campo de visión.
cmd-togglelightbuf-help = Uso: {$command}

cmd-chunkinfo-desc = Obtiene información sobre el bloque situado bajo el cursor del ratón.
cmd-chunkinfo-help = Uso: {$command}

cmd-rldshader-desc = Recarga todos los sombreadores.
cmd-rldshader-help = Uso: {$command}

cmd-cldbglyr-desc = Activa o desactiva las capas de depuración del campo de visión y la iluminación.
cmd-cldbglyr-help= Uso: {$command} <capa>: activa o desactiva <capa>
    cldbglyr: desactiva todas las capas

cmd-key-info-desc = Obtiene información de una tecla.
cmd-key-info-help = Uso: {$command} <tecla>

## 'bind' command
cmd-bind-desc = Vincula una combinación de teclas a un comando de entrada.
cmd-bind-help = Uso: {$command} { cmd-bind-arg-key } { cmd-bind-arg-mode } { cmd-bind-arg-command }
    Ten en cuenta que esto NO guarda automáticamente las vinculaciones.
    Usa el comando «svbind» para guardar la configuración de las vinculaciones.

cmd-bind-arg-key = <nombre de tecla>
cmd-bind-arg-mode = <modo de vinculación>
cmd-bind-arg-command = <comando de entrada>

cmd-net-draw-interp-desc = Activa o desactiva el dibujo de depuración de la interpolación de red.
cmd-net-draw-interp-help = Uso: {$command}

cmd-net-watch-ent-desc = Vuelca en la consola todas las actualizaciones de red de un ID de entidad.
cmd-net-watch-ent-help = Uso: {$command} <0|UID de entidad>

cmd-net-refresh-desc = Solicita un estado completo del servidor.
cmd-net-refresh-help = Uso: {$command}

cmd-net-entity-report-desc = Activa o desactiva el panel de informe de entidades de red.
cmd-net-entity-report-help = Uso: {$command}

cmd-fill-desc = Llena la consola para realizar pruebas de depuración.
cmd-fill-help = Uso: {$command}
                Llena la consola de texto sin sentido para depurar.

cmd-cls-desc = Limpia la consola.
cmd-cls-help = Uso: {$command}
               Borra todos los mensajes de la consola de depuración.

cmd-sendgarbage-desc = Envía basura al servidor.
cmd-sendgarbage-help = Uso: {$command}
                       El servidor responderá con «no u».

cmd-loadgrid-desc = Carga una cuadrícula desde un archivo en un mapa existente.
cmd-loadgrid-help = Uso: {$command} <ID de mapa> <ruta> [x y] [rotación] [guardar UID]

cmd-loc-desc = Muestra en la consola la ubicación absoluta de la entidad del jugador.
cmd-loc-help = Uso: {$command}

cmd-tpgrid-desc = Teletransporta una cuadrícula a una ubicación nueva.
cmd-tpgrid-help = Uso: {$command} <ID de cuadrícula> <X> <Y> [<ID de mapa>]

cmd-rmgrid-desc = Elimina una cuadrícula de un mapa. No puedes eliminar la cuadrícula predeterminada.
cmd-rmgrid-help = Uso: {$command} <ID de cuadrícula>

cmd-mapinit-desc = Ejecuta la inicialización de mapa en un mapa.
cmd-mapinit-help = Uso: {$command} <ID de mapa>

cmd-lsmap-desc = Enumera los mapas.
cmd-lsmap-help = Uso: {$command}

cmd-lsgrid-desc = Enumera las cuadrículas.
cmd-lsgrid-help = Uso: {$command}

cmd-addmap-desc = Añade al turno un mapa vacío nuevo. Si el ID de mapa ya existe, este comando no hace nada.
cmd-addmap-help = Uso: {$command} <ID de mapa> [pre-init]

cmd-rmmap-desc = Elimina un mapa del mundo. No puedes eliminar el espacio nulo.
cmd-rmmap-help = Uso: {$command} <ID de mapa>

cmd-pausemap-desc = Pausa un mapa y todo el procesamiento de simulación que contiene.
cmd-pausemap-help = Uso: pausemap <ID de mapa>

cmd-unpausemap-desc = Reanuda un mapa y todo el procesamiento de simulación que contiene.
cmd-unpausemap-help = Uso: unpausemap <ID de mapa>

cmd-querymappaused-desc = Comprueba si un mapa está en pausa.
cmd-querymappaused-help = Uso: querymappaused <ID de mapa>

cmd-savegrid-desc = Serializa una cuadrícula en el disco.
cmd-savegrid-help = Uso: {$command} <ID de cuadrícula> <ruta>

cmd-testbed-desc = Carga un banco de pruebas de física en el mapa indicado.
cmd-testbed-help = Uso: {$command} <ID de mapa> <prueba>

## 'flushcookies' command
# Note: the flushcookies command is from Robust.Client.WebView, it's not in the main engine code.

## 'addcomp' command
cmd-addcomp-desc = Añade un componente a una entidad.
cmd-addcomp-help = Uso: {$command} <UID> <nombre del componente>
cmd-addcompc-desc = Añade un componente a una entidad en el cliente.
cmd-addcompc-help = Uso: {$command} <UID> <nombre del componente>

## 'rmcomp' command
cmd-rmcomp-desc = Elimina un componente de una entidad.
cmd-rmcomp-help = Uso: {$command} <UID> <nombre del componente>
cmd-rmcompc-desc = Elimina un componente de una entidad en el cliente.
cmd-rmcompc-help = Uso: {$command} <UID> <nombre del componente>

## 'addview' command
cmd-addview-desc = Permite suscribirte a la vista de una entidad con fines de depuración.
cmd-addview-help = Uso: {$command} <UID de entidad>
cmd-addviewc-desc = Permite suscribirte a la vista de una entidad con fines de depuración.
cmd-addviewc-help = Uso: {$command} <UID de entidad>

## 'removeview' command
cmd-removeview-desc = Permite cancelar tu suscripción a la vista de una entidad con fines de depuración.
cmd-removeview-help = Uso: {$command} <UID de entidad>

## 'loglevel' command
cmd-loglevel-desc = Cambia el nivel de registro de un sawmill determinado.
cmd-loglevel-help = Uso: {$command} <canal de registro> <nivel>
      canal de registro: canal etiquetado que genera mensajes de registro. Se modificará su nivel.
      nivel: nivel de registro. Debe coincidir con uno de los valores de la enumeración LogLevel.

cmd-testlog-desc = Escribe un registro de prueba en un sawmill.
cmd-testlog-help = Uso: {$command} <canal de registro> <nivel> <mensaje>
    canal de registro: canal etiquetado que genera el mensaje de registro.
    nivel: nivel de registro. Debe coincidir con uno de los valores de la enumeración LogLevel.
    mensaje: mensaje que se registrará. Enciérralo entre comillas dobles si quieres usar espacios.

## 'vv' command
cmd-vv-desc = Abre Ver variables.
cmd-vv-help = Uso: {$command} <ID de entidad|nombre de interfaz IoC|nombre de interfaz SIoC>

## 'showvelocities' command
cmd-showvelocities-desc = Muestra tus velocidades angular y lineal.
cmd-showvelocities-help = Uso: {$command}

## 'setinputcontext' command
cmd-setinputcontext-desc = Establece el contexto de entrada activo.
cmd-setinputcontext-help = Uso: {$command} <contexto>

## 'forall' command
cmd-forall-desc = Ejecuta un comando sobre todas las entidades que tengan un componente determinado.
cmd-forall-help = Uso: {$command} <consulta bql> do <comando...>

## 'delete' command
cmd-delete-desc = Elimina la entidad con el ID indicado.
cmd-delete-help = Uso: {$command} <UID de entidad>

# System commands
cmd-showtime-desc = Muestra la hora del servidor.
cmd-showtime-help = Uso: {$command}

cmd-restart-desc = Reinicia el servidor de forma segura (no solo el turno).
cmd-restart-help = Uso: {$command}

cmd-shutdown-desc = Apaga el servidor de forma segura.
cmd-shutdown-help = Uso: {$command}

cmd-saveconfig-desc = Guarda la configuración del servidor en el archivo de configuración.
cmd-saveconfig-help = Uso: {$command}

cmd-netaudit-desc = Muestra información sobre la seguridad de NetMsg.
cmd-netaudit-help = Uso: {$command}

# Player commands
cmd-tp-desc = Teletransporta a un jugador a cualquier lugar del turno.
cmd-tp-help = Uso: {$command} <x> <y> [<ID de mapa>]

cmd-tpto-desc = Teletransporta al jugador actual o a los jugadores o entidades indicados hasta la ubicación del primer jugador o entidad.
cmd-tpto-help = Uso: {$command} <nombre de usuario|UID> [nombre de usuario|entidad de red]...
cmd-tpto-destination-hint = destino (entidad de red o nombre de usuario)
cmd-tpto-victim-hint = entidad que se teletransportará (entidad de red o nombre de usuario)
cmd-tpto-parse-error = No se puede resolver la entidad o el jugador: {$str}

cmd-listplayers-desc = Enumera todos los jugadores conectados actualmente.
cmd-listplayers-help = Uso: {$command}

cmd-kick-desc = Expulsa del servidor a un jugador conectado y lo desconecta.
cmd-kick-help = Uso: {$command} <índice del jugador> [<motivo>]

# Spin command
cmd-spin-desc = Hace girar una entidad. De forma predeterminada, se usa la entidad superior del jugador vinculado.
cmd-spin-help = Uso: {$command} <velocidad> [resistencia] [UID de entidad]

# Localization command
cmd-rldloc-desc = Recarga la localización (cliente y servidor).
cmd-rldloc-help = Uso: {$command}

# Debug entity controls
cmd-spawn-desc = Genera una entidad de un tipo concreto.
cmd-spawn-help = Uso: {$command} <prototipo> | {$command} <prototipo> <ID relativo de entidad> | {$command} <prototipo> <x> <y>
cmd-cspawn-desc = Genera a tus pies una entidad de un tipo concreto en el cliente.
cmd-cspawn-help = Uso: {$command} <tipo de entidad>

cmd-dumpentities-desc = Vuelca la lista de entidades.
cmd-dumpentities-help = Uso: {$command}
                        Vuelca una lista con los UID y prototipos de las entidades.

cmd-getcomponentregistration-desc = Obtiene información sobre el registro de componentes.
cmd-getcomponentregistration-help = Uso: {$command} <nombre del componente>

cmd-showrays-desc = Activa o desactiva el dibujo de depuración de los rayos físicos. Debe proporcionarse un entero para <duración del rayo>.
cmd-showrays-help = Uso: {$command} <duración del rayo>

cmd-disconnect-desc = Se desconecta inmediatamente del servidor y vuelve al menú principal.
cmd-disconnect-help = Uso: {$command}

cmd-entfo-desc = Muestra un diagnóstico detallado de una entidad.
cmd-entfo-help = Uso: {$command} <UID de entidad>
    El UID de la entidad puede llevar el prefijo «c» para convertirlo en el UID de una entidad del cliente.

cmd-fuck-desc = Lanza una excepción.
cmd-fuck-help = Uso: {$command}

cmd-showpos-desc = Muestra la posición de todas las entidades en pantalla.
cmd-showpos-help = Uso: {$command}

cmd-showrot-desc = Muestra la rotación de todas las entidades en pantalla.
cmd-showrot-help = Uso: {$command}

cmd-showvel-desc = Muestra la velocidad local de todas las entidades en pantalla.
cmd-showvel-help = Uso: {$command}

cmd-showangvel-desc = Muestra la velocidad angular de todas las entidades en pantalla.
cmd-showangvel-help = Uso: {$command}

cmd-sggcell-desc = Enumera las entidades de una celda de la cuadrícula de ajuste.
cmd-sggcell-help = Uso: {$command} <ID de cuadrícula> <vector2i>\nEl parámetro vector2i tiene el formato x<int>,y<int>.

cmd-overrideplayername-desc = Cambia el nombre usado al intentar conectarse al servidor.
cmd-overrideplayername-help = Uso: {$command} <nombre>

cmd-showanchored-desc = Muestra las entidades ancladas en una baldosa concreta.
cmd-showanchored-help = Uso: {$command}

cmd-dmetamem-desc = Vuelca los miembros de un tipo en un formato apto para el archivo de configuración del entorno aislado.
cmd-dmetamem-help = Uso: {$command} <tipo>

cmd-launchauth-desc = Carga los tokens de autenticación desde los datos del lanzador para facilitar las pruebas en servidores activos.
cmd-launchauth-help = Uso: {$command} <nombre de cuenta>

cmd-lightbb-desc = Activa o desactiva la visualización de los cuadros delimitadores de las luces.
cmd-lightbb-help = Uso: {$command}

cmd-monitorinfo-desc = Muestra información de los monitores.
cmd-monitorinfo-help = Uso: {$command} <ID>

cmd-setmonitor-desc = Establece el monitor.
cmd-setmonitor-help = Uso: {$command} <ID>

cmd-physics-desc = Muestra una superposición de depuración de física. El argumento proporcionado especifica la superposición.
cmd-physics-help = Uso: {$command} <aabbs / com / contactnormals / contactpoints / distance / joints / shapeinfo / shapes>

cmd-hardquit-desc = Cierra el cliente del juego al instante.
cmd-hardquit-help = Uso: {$command}
                    Cierra el cliente del juego al instante sin dejar rastro ni despedirse del servidor.

cmd-quit-desc = Cierra el cliente del juego de forma segura.
cmd-quit-help = Uso: {$command}
                Cierra correctamente el cliente del juego, informa al servidor conectado y realiza las demás tareas necesarias.

cmd-csi-desc = Abre una consola interactiva de C#.
cmd-csi-help = Uso: {$command}

cmd-scsi-desc = Abre una consola interactiva de C# en el servidor.
cmd-scsi-help = Uso: {$command}

cmd-watch-desc = Abre una ventana para observar variables.
cmd-watch-help = Uso: {$command}

cmd-showspritebb-desc = Activa o desactiva la visualización de los límites de los sprites.
cmd-showspritebb-help = Uso: {$command}

cmd-togglelookup-desc = Muestra u oculta mediante una superposición los límites de entitylookup.
cmd-togglelookup-help = Uso: {$command}

cmd-net_entityreport-desc = Activa o desactiva el panel de informe de entidades de red.
cmd-net_entityreport-help = Uso: {$command}

cmd-net_refresh-desc = Solicita un estado completo del servidor.
cmd-net_refresh-help = Uso: {$command}

cmd-net_graph-desc = Activa o desactiva el panel de estadísticas de red.
cmd-net_graph-help = Uso: {$command}

cmd-net_watchent-desc = Vuelca en la consola todas las actualizaciones de red de un ID de entidad.
cmd-net_watchent-help = Uso: {$command} <0|UID de entidad>

cmd-net_draw_interp-desc = Activa o desactiva el dibujo de depuración de la interpolación de red.
cmd-net_draw_interp-help = Uso: {$command} <0|UID de entidad>

cmd-vram-desc = Muestra estadísticas sobre el uso de memoria de vídeo del juego.
cmd-vram-help = Uso: {$command}

cmd-showislands-desc = Muestra los cuerpos físicos que intervienen actualmente en cada isla física.
cmd-showislands-help = Uso: {$command}

cmd-showgridnodes-desc = Muestra los nodos utilizados para dividir cuadrículas.
cmd-showgridnodes-help = Uso: {$command}

cmd-profsnap-desc = Crea una instantánea de perfilado.
cmd-profsnap-help = Uso: {$command}

cmd-devwindow-desc = Ventana de desarrollo.
cmd-devwindow-help = Uso: {$command}

cmd-scene-desc = Cambia inmediatamente la escena o el estado de la interfaz.
cmd-scene-help = Uso: {$command} <nombre de clase>

cmd-szr_stats-desc = Informa de las estadísticas del serializador.
cmd-szr_stats-help = Uso: {$command}

cmd-hwid-desc = Devuelve el HWID (identificador de hardware) actual.
cmd-hwid-help = Uso: {$command}

cmd-vvread-desc = Recupera el valor de una ruta mediante VV (Ver variables).
cmd-vvread-help = Uso: {$command} <ruta>

cmd-vvwrite-desc = Modifica el valor de una ruta mediante VV (Ver variables).
cmd-vvwrite-help = Uso: {$command} <ruta>

cmd-vvinvoke-desc = Invoca o llama a una ruta con argumentos mediante VV.
cmd-vvinvoke-help = Uso: {$command} <ruta> [argumentos...]

cmd-dump_dependency_injectors-desc = Vuelca la caché de inyectores de dependencias de IoCManager.
cmd-dump_dependency_injectors-help = Uso: {$command}
cmd-dump_dependency_injectors-total-count = Recuento total: { $total }

cmd-dump_netserializer_type_map-desc = Vuelca el mapa de tipos y el hash del serializador de NetSerializer.
cmd-dump_netserializer_type_map-help = Uso: {$command}

cmd-hub_advertise_now-desc = Anuncia el servidor inmediatamente en el concentrador maestro.
cmd-hub_advertise_now-help = Uso: {$command}

cmd-echo-desc = Repite los argumentos en la consola.
cmd-echo-help = Uso: {$command} "<mensaje>"

## 'vfs_ls' command
cmd-vfs_ls-desc = Enumera el contenido de un directorio del VFS.
cmd-vfs_ls-help = Uso: {$command} <ruta>
    Ejemplo:
    vfs_list /Assemblies

cmd-vfs_ls-err-args = Se necesita exactamente 1 argumento.
cmd-vfs_ls-hint-path = <ruta>

cmd-reloadtiletextures-desc = Recarga el atlas de texturas de las baldosas para permitir la recarga en caliente de sus sprites.
cmd-reloadtiletextures-help = Uso: {$command}

cmd-audio_length-desc = Muestra la duración de un archivo de audio.
cmd-audio_length-help = Uso: {$command} { cmd-audio_length-arg-file-name }
cmd-audio_length-arg-file-name = <nombre del archivo>

## PVS
cmd-pvs-override-info-desc = Muestra información sobre cualquier anulación de PVS asociada a una entidad.
cmd-pvs-override-info-empty = La entidad {$nuid} no tiene anulaciones de PVS.
cmd-pvs-override-info-global = La entidad {$nuid} tiene una anulación global.
cmd-pvs-override-info-clients = La entidad {$nuid} tiene una anulación de sesión para {$clients}.

cmd-localization_set_culture-desc = Establece la cultura predeterminada del gestor de localización del cliente.
cmd-localization_set_culture-help = Uso: {$command} <nombre de cultura>
cmd-localization_set_culture-culture-name = <nombre de cultura>
cmd-localization_set_culture-changed = La localización ha cambiado a { $code } ({ $nativeName } / { $englishName }).

cmd-addmap-hint-2 = ejecutar inicialización del mapa [true / false]

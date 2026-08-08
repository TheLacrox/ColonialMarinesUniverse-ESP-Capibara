# Pantalla de carga

replay-loading = Cargando ({$cur}/{$total})
replay-loading-reading = Leyendo archivos
replay-loading-processing = Procesando archivos
replay-loading-spawning = Creando entidades
replay-loading-initializing = Inicializando entidades
replay-loading-starting= Iniciando entidades
replay-loading-failed = No se pudo cargar la repetición. Error:
                        {$reason}
replay-loading-retry = Intentar cargar con mayor tolerancia a excepciones. ¡PUEDE PROVOCAR ERRORES!
replay-loading-cancel = Cancelar

# Menú principal
replay-menu-subtext = Cliente de repeticiones
replay-menu-load = Cargar repetición seleccionada
replay-menu-select = Seleccionar una repetición
replay-menu-open = Abrir carpeta de repeticiones
replay-menu-none = No se encontraron repeticiones.

# Cuadro de información del menú principal
replay-info-title = Información de la repetición
replay-info-none-selected = No hay ninguna repetición seleccionada
replay-info-invalid = [color=red]La repetición seleccionada no es válida[/color]
replay-info-info = {"["}color=gray]Selección:[/color]  {$name} ({$file})
                   {"["}color=gray]Hora:[/color]   {$time}
                   {"["}color=gray]ID de ronda:[/color]   {$roundId}
                   {"["}color=gray]Duración:[/color]   {$duration}
                   {"["}color=gray]ID del fork:[/color]   {$forkId}
                   {"["}color=gray]Versión:[/color]   {$version}
                   {"["}color=gray]Motor:[/color]   {$engVersion}
                   {"["}color=gray]Hash de tipos:[/color]   {$hash}
                   {"["}color=gray]Hash de componentes:[/color]   {$compHash}

# Ventana de selección de repeticiones
replay-menu-select-title = Seleccionar repetición

# Verbos relacionados con las repeticiones
replay-verb-spectate = Observar

# Comando
cmd-replay-spectate-help = replay_spectate [entidad opcional]
cmd-replay-spectate-desc = Vincula o desvincula al jugador local de un uid de entidad determinado.
cmd-replay-spectate-hint = UID de entidad opcional

cmd-replay-toggleui-desc = Alterna la interfaz de control de repeticiones.

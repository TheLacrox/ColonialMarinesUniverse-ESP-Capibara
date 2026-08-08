device-pda-slot-component-slot-name-cartridge = Cartucho

default-program-name = Programa
notekeeper-program-name = Bloc de notas
nano-task-program-name = NanoTask
news-read-program-name = Noticias de la estación

crew-manifest-program-name = Manifiesto de la tripulación
crew-manifest-cartridge-loading = Cargando...

net-probe-program-name = NetProbe
net-probe-scan = ¡Se escaneó {$device}!
net-probe-label-name = Nombre
net-probe-label-address = Dirección
net-probe-label-frequency = Frecuencia
net-probe-label-network = Red

log-probe-program-name = LogProbe
log-probe-scan = ¡Se descargaron los registros de {$device}!
log-probe-label-time = Hora
log-probe-label-accessor = Accedido por
log-probe-label-number = n.º
log-probe-print-button = Imprimir registros
log-probe-printout-device = Dispositivo escaneado: {$name}
log-probe-printout-header = Registros más recientes:
log-probe-printout-entry = n.º {$number} / {$time} / {$accessor}

astro-nav-program-name = AstroNav

med-tek-program-name = MedTek

# Cartucho NanoTask

nano-task-ui-heading-high-priority-tasks =
    { $amount ->
        [zero] No hay tareas de prioridad alta
        [one] 1 tarea de prioridad alta
       *[other] {$amount} tareas de prioridad alta
    }
nano-task-ui-heading-medium-priority-tasks =
    { $amount ->
        [zero] No hay tareas de prioridad media
        [one] 1 tarea de prioridad media
       *[other] {$amount} tareas de prioridad media
    }
nano-task-ui-heading-low-priority-tasks =
    { $amount ->
        [zero] No hay tareas de prioridad baja
        [one] 1 tarea de prioridad baja
       *[other] {$amount} tareas de prioridad baja
    }
nano-task-ui-done = Hecha
nano-task-ui-revert-done = Deshacer
nano-task-ui-priority-low = Baja
nano-task-ui-priority-medium = Media
nano-task-ui-priority-high = Alta
nano-task-ui-cancel = Cancelar
nano-task-ui-print = Imprimir
nano-task-ui-delete = Eliminar
nano-task-ui-save = Guardar
nano-task-ui-new-task = Nueva tarea
nano-task-ui-description-label = Descripción:
nano-task-ui-description-placeholder = Consigue algo importante
nano-task-ui-requester-label = Solicitante:
nano-task-ui-requester-placeholder = Juan Nanotrasen
nano-task-ui-item-title = Editar tarea
nano-task-printed-description = [bold]Descripción[/bold]: {$description}
nano-task-printed-requester = [bold]Solicitante[/bold]: {$requester}
nano-task-printed-high-priority = [bold]Prioridad[/bold]: [color=red]Alta[/color]
nano-task-printed-medium-priority = [bold]Prioridad[/bold]: Media
nano-task-printed-low-priority = [bold]Prioridad[/bold]: Baja

# Cartucho de lista de personas buscadas
wanted-list-program-name = Personas buscadas
wanted-list-label-no-records = Todo en orden, vaquero
wanted-list-search-placeholder = Buscar por nombre y estado

wanted-list-age-label = [color=darkgray]Edad:[/color] [color=white]{$age}[/color]
wanted-list-job-label = [color=darkgray]Puesto:[/color] [color=white]{$job}[/color]
wanted-list-species-label = [color=darkgray]Especie:[/color] [color=white]{$species}[/color]
wanted-list-gender-label = [color=darkgray]Género:[/color] [color=white]{$gender}[/color]

wanted-list-reason-label = [color=darkgray]Motivo:[/color] [color=white]{$reason}[/color]
wanted-list-unknown-reason-label = motivo desconocido

wanted-list-initiator-label = [color=darkgray]Iniciador:[/color] [color=white]{$initiator}[/color]
wanted-list-unknown-initiator-label = iniciador desconocido

wanted-list-status-label = [color=darkgray]Estado:[/color] {$status ->
        [suspected] [color=yellow]sospechoso[/color]
        [wanted] [color=red]en busca y captura[/color]
        [detained] [color=#b18644]detenido[/color]
        [paroled] [color=green]libertad condicional[/color]
        [discharged] [color=green]puesto en libertad[/color]
        *[other] ninguno
    }

wanted-list-history-table-time-col = Hora
wanted-list-history-table-reason-col = Delito
wanted-list-history-table-initiator-col = Iniciador

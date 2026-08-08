# Playback Commands

cmd-replay-play-desc = Reanuda la reproducción de la repetición.
cmd-replay-play-help = replay_play

cmd-replay-pause-desc = Pausa la reproducción de la repetición.
cmd-replay-pause-help = replay_pause

cmd-replay-toggle-desc = Reanuda o pausa la reproducción de la repetición.
cmd-replay-toggle-help = replay_toggle

cmd-replay-toggle-screenshot-mode-desc = Activa o desactiva el modo de captura de pantalla para las repeticiones, ocultando el control de la repetición.
cmd-replay-toggle-screenshot-mode-help = replay_toggle_screenshot_mode

cmd-replay-stop-desc = Detiene y descarga una repetición.
cmd-replay-stop-help = replay_stop

cmd-replay-load-desc = Carga e inicia una repetición.
cmd-replay-load-help = replay_load <carpeta de la repetición>
cmd-replay-load-hint = Carpeta de la repetición

cmd-replay-skip-desc = Avanza o retrocede en el tiempo.
cmd-replay-skip-help = replay_skip <tick o intervalo de tiempo>
cmd-replay-skip-hint = Ticks o intervalo de tiempo (HH:MM:SS).

cmd-replay-set-time-desc = Salta hacia delante o atrás hasta un momento concreto.
cmd-replay-set-time-help = replay_set <tick o tiempo>
cmd-replay-set-time-hint = Tick o intervalo de tiempo (HH:MM:SS), empezando desde

cmd-replay-error-time = "{$time}" no es un entero ni un intervalo de tiempo.
cmd-replay-error-args = Número de argumentos incorrecto.
cmd-replay-error-no-replay = No se está reproduciendo ninguna repetición.
cmd-replay-error-already-loaded = Ya hay una repetición cargada.
cmd-replay-error-run-level = No puedes cargar una repetición mientras estás conectado a un servidor.

# Recording commands

cmd-replay-recording-start-desc = Inicia la grabación de una repetición, opcionalmente con un límite de tiempo.
cmd-replay-recording-start-help = Uso: replay_recording_start [nombre] [sobrescribir] [límite de tiempo]
cmd-replay-recording-start-success = Se ha iniciado la grabación de una repetición.
cmd-replay-recording-start-already-recording = Ya se está grabando una repetición.
cmd-replay-recording-start-error = Se produjo un error al intentar iniciar la grabación.
cmd-replay-recording-start-hint-time = [límite de tiempo (minutos)]
cmd-replay-recording-start-hint-name = [nombre]
cmd-replay-recording-start-hint-overwrite = [sobrescribir (booleano)]

cmd-replay-recording-stop-desc = Detiene la grabación de una repetición.
cmd-replay-recording-stop-help = Uso: replay_recording_stop
cmd-replay-recording-stop-success = Se ha detenido la grabación de la repetición.
cmd-replay-recording-stop-not-recording = No se está grabando ninguna repetición.

cmd-replay-recording-stats-desc = Muestra información sobre la grabación actual de la repetición.
cmd-replay-recording-stats-help = Uso: replay_recording_stats
cmd-replay-recording-stats-result = Duración: {$time} min, ticks: {$ticks}, tamaño: {$size} MB, tasa: {$rate} MB/min.


# Time Control UI
replay-time-box-scrubbing-label = Desplazamiento dinámico
replay-time-box-replay-time-label = Tiempo de grabación: {$current} / {$end}  ({$percentage} %)
replay-time-box-server-time-label = Tiempo del servidor: {$current} / {$end}
replay-time-box-index-label = Índice: {$current} / {$total}
replay-time-box-tick-label = Tick: {$current} / {$total}

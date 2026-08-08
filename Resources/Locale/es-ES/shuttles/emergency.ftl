# Comandos
## Retrasar el final de la ronda por el transbordador
cmd-delayroundend-desc = Detiene el temporizador que termina la ronda cuando el transbordador de emergencia sale del hiperespacio.
cmd-delayroundend-help = Uso: delayroundend
emergency-shuttle-command-round-yes = Se ha retrasado la ronda.
emergency-shuttle-command-round-no = No se pudo retrasar el final de la ronda.

## Acoplar el transbordador de emergencia
cmd-dockemergencyshuttle-desc = Llama al transbordador de emergencia y lo acopla a la estación... si es posible.
cmd-dockemergencyshuttle-help = Uso: dockemergencyshuttle

## Lanzar el transbordador de emergencia
cmd-launchemergencyshuttle-desc = Adelanta la salida del transbordador de emergencia si es posible.
cmd-launchemergencyshuttle-help = Uso: launchemergencyshuttle

# Transbordador de emergencia
emergency-shuttle-left = El transbordador de emergencia ha abandonado la estación. Tiempo estimado hasta su llegada a CentComm: {$transitTime} segundos.
emergency-shuttle-launch-time = El transbordador de emergencia partirá en {$consoleAccumulator} segundos.
emergency-shuttle-docked = El transbordador de emergencia se ha acoplado {$direction} de la estación, {$location}. Partirá en {$time} segundos.{$extended}
emergency-shuttle-good-luck = El transbordador de emergencia no puede encontrar la estación. Buena suerte.
emergency-shuttle-nearby = El transbordador de emergencia no puede encontrar un puerto de acoplamiento válido. Ha aparecido {$direction} de la estación, {$location}. Partirá en {$time} segundos.{$extended}
emergency-shuttle-extended = {" "}La salida se ha retrasado debido a circunstancias inoportunas.

# Mensajes de la consola del transbordador de emergencia
emergency-shuttle-console-no-early-launches = La salida anticipada está desactivada
emergency-shuttle-console-auth-left = Faltan {$remaining} autorizaciones para adelantar la salida del transbordador.
emergency-shuttle-console-auth-revoked = Se revocó una autorización de salida anticipada; faltan {$remaining} autorizaciones.
emergency-shuttle-console-denied = Acceso denegado

# Interfaz
emergency-shuttle-console-window-title = Consola del transbordador de emergencia
emergency-shuttle-ui-engines = MOTORES:
emergency-shuttle-ui-idle = En espera
emergency-shuttle-ui-repeal-all = Revocar todas
emergency-shuttle-ui-early-authorize = Autorizar salida anticipada
emergency-shuttle-ui-authorize = AUTORIZAR
emergency-shuttle-ui-repeal = REVOCAR
emergency-shuttle-ui-authorizations = Autorizaciones
emergency-shuttle-ui-remaining = Restantes: {$remaining}

# Nombres de mapas
map-name-centcomm = Mando Central
map-name-terminal = Terminal de llegadas

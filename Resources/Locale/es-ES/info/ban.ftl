# ban
cmd-ban-desc = Veta a una persona
cmd-ban-help = Uso: ban <nombre o ID de usuario> <motivo> [duración en minutos; omítela o usa 0 para un veto permanente]
cmd-ban-player = No se encontró ningún jugador con ese nombre.
cmd-ban-invalid-minutes = ¡{$minutes} no es una cantidad de minutos válida!
cmd-ban-invalid-severity = ¡{$severity} no es un nivel de gravedad válido!
cmd-ban-invalid-arguments = Cantidad de argumentos no válida
cmd-ban-hint = <nombre o ID de usuario>
cmd-ban-hint-reason = <motivo>
cmd-ban-hint-duration = [duración]
cmd-ban-hint-severity = [gravedad]

cmd-ban-hint-duration-1 = Permanente
cmd-ban-hint-duration-2 = 1 día
cmd-ban-hint-duration-3 = 3 días
cmd-ban-hint-duration-4 = 1 semana
cmd-ban-hint-duration-5 = 2 semanas
cmd-ban-hint-duration-6 = 1 mes

# Panel de vetos
cmd-banpanel-desc = Abre el panel de vetos
cmd-banpanel-help = Uso: banpanel [nombre o GUID de usuario]
cmd-banpanel-server = No se puede usar desde la consola del servidor
cmd-banpanel-player-err = No se encontró al jugador especificado

# listbans
cmd-banlist-desc = Enumera los vetos activos de un usuario.
cmd-banlist-help = Uso: banlist <nombre o ID de usuario>
cmd-banlist-empty = No se encontraron vetos activos para {$user}
cmd-banlist-hint = <nombre o ID de usuario>

cmd-ban_exemption_update-desc = Establece una exención para un tipo de veto de un jugador.
cmd-ban_exemption_update-help = Uso: ban_exemption_update <jugador> <marca> [<marca> [...]]
    Especifica varias marcas para conceder al jugador varias exenciones de veto.
    Para eliminar todas las exenciones, ejecuta este comando y proporciona "None" como única marca.

cmd-ban_exemption_update-nargs = Se esperaban al menos 2 argumentos
cmd-ban_exemption_update-locate = No se encontró al jugador «{$player}».
cmd-ban_exemption_update-invalid-flag = La marca «{$flag}» no es válida.
cmd-ban_exemption_update-success = Se actualizaron las marcas de exención de vetos de «{$player}» ({$uid}).
cmd-ban_exemption_update-arg-player = <jugador>
cmd-ban_exemption_update-arg-flag = <marca>

cmd-ban_exemption_get-desc = Muestra las exenciones de veto de un jugador determinado.
cmd-ban_exemption_get-help = Uso: ban_exemption_get <jugador>

cmd-ban_exemption_get-nargs = Se esperaba exactamente 1 argumento
cmd-ban_exemption_get-none = El usuario no está exento de ningún veto.
cmd-ban_exemption_get-show = El usuario está exento de las siguientes marcas de veto: {$flags}.
cmd-ban_exemption_get-arg-player = <jugador>

# Panel de vetos
ban-panel-title = Panel de vetos
ban-panel-player = Jugador
ban-panel-ip = IP
ban-panel-hwid = HWID
ban-panel-reason = Motivo
ban-panel-last-conn = ¿Usar la IP y el HWID de la última conexión?
ban-panel-submit = Vetar
ban-panel-confirm = ¿Seguro?
ban-panel-tabs-basic = Información básica
ban-panel-tabs-reason = Motivo
ban-panel-tabs-players = Lista de jugadores
ban-panel-tabs-role = Información del veto de rol
ban-panel-no-data = Debes proporcionar un usuario, una IP o un HWID que vetar
ban-panel-invalid-ip = No se pudo interpretar la dirección IP. Inténtalo de nuevo
ban-panel-select = Seleccionar tipo
ban-panel-server = Veto del servidor
ban-panel-role = Veto de rol
ban-panel-minutes = Minutos
ban-panel-hours = Horas
ban-panel-days = Días
ban-panel-weeks = Semanas
ban-panel-months = Meses
ban-panel-years = Años
ban-panel-permanent = Permanente
ban-panel-ip-hwid-tooltip = Déjalo vacío y marca la casilla inferior para usar los datos de la última conexión
ban-panel-severity = Gravedad:
ban-panel-erase = Borrar los mensajes del chat y retirar al jugador de la ronda

# Cadena de veto
server-ban-string = {$admin} creó un veto del servidor de gravedad {$severity} que caduca {$expires} para [{$name}, {$ip}, {$hwid}], con el motivo: {$reason}
server-ban-string-no-pii = {$admin} creó un veto del servidor de gravedad {$severity} que caduca {$expires} para {$name}, con el motivo: {$reason}
server-ban-string-never = nunca

# Expulsión al vetar
ban-kick-reason = Se te ha vetado

parse-minutes-fail = No se pudo interpretar «{$minutes}» como minutos
parse-session-fail = No se encontró una sesión para «{$username}»

## Comandos de tiempo de rol

# - playtime_addoverall
cmd-playtime_addoverall-desc = Añade los minutos indicados al tiempo total de juego de un jugador
cmd-playtime_addoverall-help = Uso: {$command} <nombre de usuario> <minutos>
cmd-playtime_addoverall-succeed = El tiempo total de {$username} aumentó a {TOSTRING($time, "dddd\\:hh\\:mm")}
cmd-playtime_addoverall-arg-user = <nombre de usuario>
cmd-playtime_addoverall-arg-minutes = <minutos>
cmd-playtime_addoverall-error-args = Se esperaban exactamente dos argumentos

# - playtime_addrole
cmd-playtime_addrole-desc = Añade los minutos indicados al tiempo de juego de un rol
cmd-playtime_addrole-help = Uso: {$command} <nombre de usuario> <rol> <minutos>
cmd-playtime_addrole-succeed = El tiempo del rol de {$username} / \\'{$role}\\' aumentó a {TOSTRING($time, "dddd\\:hh\\:mm")}
cmd-playtime_addrole-arg-user = <nombre de usuario>
cmd-playtime_addrole-arg-role = <rol>
cmd-playtime_addrole-arg-minutes = <minutos>
cmd-playtime_addrole-error-args = Se esperaban exactamente tres argumentos

# - playtime_getoverall
cmd-playtime_getoverall-desc = Obtiene el tiempo total de juego de un jugador
cmd-playtime_getoverall-help = Uso: {$command} <nombre de usuario>
cmd-playtime_getoverall-success = El tiempo total de {$username} es {TOSTRING($time, "dddd\\:hh\\:mm")}.
cmd-playtime_getoverall-arg-user = <nombre de usuario>
cmd-playtime_getoverall-error-args = Se esperaba exactamente un argumento

# - GetRoleTimer
cmd-playtime_getrole-desc = Obtiene todos los contadores de rol de un jugador o uno concreto
cmd-playtime_getrole-help = Uso: {$command} <nombre de usuario> [rol]
cmd-playtime_getrole-no = No se encontraron contadores de rol
cmd-playtime_getrole-role = Rol: {$role}; tiempo de juego: {$time}
cmd-playtime_getrole-overall = El tiempo total de juego es {$time}
cmd-playtime_getrole-succeed = El tiempo de juego de {$username} es {TOSTRING($time, "dddd\\:hh\\:mm")}.
cmd-playtime_getrole-arg-user = <nombre de usuario>
cmd-playtime_getrole-arg-role = <rol|'Overall'>
cmd-playtime_getrole-error-args = Se esperaban uno o dos argumentos

# - playtime_save
cmd-playtime_save-desc = Guarda en la base de datos los tiempos de juego del jugador
cmd-playtime_save-help = Uso: {$command} <nombre de usuario>
cmd-playtime_save-succeed = Se guardó el tiempo de juego de {$username}
cmd-playtime_save-arg-user = <nombre de usuario>
cmd-playtime_save-error-args = Se esperaba exactamente un argumento

## Comando 'playtime_flush'

cmd-playtime_flush-desc = Vuelca los contadores activos al almacenamiento del seguimiento de tiempo.
cmd-playtime_flush-help = Uso: {$command} [nombre de usuario]
    Solo realiza el volcado al almacenamiento interno; no escribe inmediatamente en la base de datos.
    Si se proporciona un usuario, solo se vuelca el suyo.

cmd-playtime_flush-error-args = Se esperaban cero o un argumento
cmd-playtime_flush-arg-user = [nombre de usuario]

### Localización del comando de veto de rol

cmd-roleban-desc = Impide que un jugador acceda a un rol
cmd-roleban-help = Uso: roleban <nombre o ID de usuario> <puesto> <motivo> [duración en minutos; omitir o usar 0 para un veto permanente]

## Sugerencias para completar argumentos
cmd-roleban-hint-1 = <nombre o ID de usuario>
cmd-roleban-hint-2 = <puesto>
cmd-roleban-hint-3 = <motivo>
cmd-roleban-hint-4 = [duración en minutos; omitir o usar 0 para un veto permanente]
cmd-roleban-hint-5 = [gravedad]

cmd-roleban-hint-duration-1 = Permanente
cmd-roleban-hint-duration-2 = 1 día
cmd-roleban-hint-duration-3 = 3 días
cmd-roleban-hint-duration-4 = 1 semana
cmd-roleban-hint-duration-5 = 2 semanas
cmd-roleban-hint-duration-6 = 1 mes


### Localización del comando que retira el veto de rol

cmd-roleunban-desc = Perdona el veto de rol de un jugador
cmd-roleunban-help = Uso: roleunban <ID de veto de rol>
cmd-roleunban-unable-to-parse-id = No se pudo interpretar {$id} como un número entero de ID de veto.
                                   {$help}

## Sugerencias para completar argumentos
cmd-roleunban-hint-1 = <ID de veto de rol>


### Localización del comando que enumera vetos de rol

cmd-rolebanlist-desc = Enumera los vetos de rol del usuario
cmd-rolebanlist-help = Uso: <nombre o ID de usuario> [incluir vetos retirados]

## Sugerencias para completar argumentos
cmd-rolebanlist-hint-1 = <nombre o ID de usuario>
cmd-rolebanlist-hint-2 = [incluir vetos retirados]


cmd-roleban-minutes-parse = {$time} no es una cantidad de minutos válida.\n{$help}
cmd-roleban-severity-parse = ${severity} no es una gravedad válida\n{$help}.
cmd-roleban-arg-count = La cantidad de argumentos no es válida.
cmd-roleban-job-parse = El puesto {$job} no existe.
cmd-roleban-name-parse = No se encontró ningún jugador con ese nombre.
cmd-roleban-existing = {$target} ya tiene un veto para el rol {$role}.
cmd-roleban-success = Se impidió que {$target} accediera a {$role} por el motivo {$reason} {$length}.

cmd-roleban-inf = de forma permanente
cmd-roleban-until =  hasta {$expires}

# Vetos de departamentos
cmd-departmentban-desc = Impide que un jugador acceda a los roles que componen un departamento
cmd-departmentban-help = Uso: departmentban <nombre o ID de usuario> <departamento> <motivo> [duración en minutos; omitir o usar 0 para un veto permanente]

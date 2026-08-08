cm-gun-unskilled = No parece que sepas usar {THE($gun)}
cm-gun-no-ammo-message = ¡No te queda munición!
cm-gun-use-delay = ¡Debes esperar {$seconds} segundos antes de volver a disparar!
cm-gun-pump-examine = [bold]Pulsa la tecla de [color=cyan]acción única[/color] (barra espaciadora de forma predeterminada) para accionar la corredera antes de disparar.[/bold]
cm-gun-pump-first-with = ¡Primero debes accionar el arma con {$key}!
cm-gun-pump-first = ¡Primero debes accionar el arma!

rmc-sharp-examine = [bold]Pulsa la tecla de [color=cyan]acción única[/color] (barra espaciadora de forma predeterminada) para alternar el retardo de detonación al impactar directamente de los dardos explosivos e incendiarios. Retardo actual: [color=yellow]{TOSTRING($seconds, "F1")} segundos[/color].[/bold]
rmc-sharp-toggle-delay = Ajustas el retardo de detonación al impactar directamente de {THE($gun)} a {TOSTRING($seconds, "F1")} segundos.

rmc-vulture-unbraced-user = ¡El retroceso de {THE($gun)} te sacude al no tener desplegado el bípode!
rmc-vulture-unbraced-others = ¡{CAPITALIZE(THE($user))} sale despedido por el retroceso de {THE($gun)}!
rmc-vulture-bipod-required = Debes desplegar el bípode de {THE($gun)} antes de usar su mira.
rmc-vulture-spotter-scope-slot = mira de observador M707
rmc-vulture-spotter-insert-scope = Montar mira
rmc-vulture-spotter-eject-scope = Retirar mira
rmc-vulture-spotter-scope-only = Solo cabe una mira de observador M707 en el trípode.
rmc-vulture-must-scope = Debes mirar por la mira del M707 Vulture para ajustarla.
rmc-vulture-breath-cooldown = Debes recobrar el aliento antes de volver a estabilizar la mira.

rmc-breech-loaded-open-shoot-attempt = ¡Primero debes cerrar la recámara!
rmc-breech-loaded-not-ready-to-shoot = ¡Primero debes abrir y cerrar la recámara!
rmc-breech-loaded-closed-load-attempt = ¡Primero debes abrir la recámara!
rmc-breech-loaded-closed-extract-attempt = ¡Primero debes abrir la recámara!
rmc-breech-loaded-toggle-attempt-cooldown = ¡Debes esperar antes de volver a {$action} la recámara!
rmc-breech-loaded-open = abrir
rmc-breech-loaded-close = cerrar

rmc-wield-use-delay = ¡Debes esperar {$seconds} segundos antes de empuñar {THE($wieldable)}!
rmc-shoot-use-delay = ¡Debes esperar {$seconds} segundos antes de disparar {THE($wieldable)}!

rmc-shoot-harness-required = Se necesita un arnés
rmc-wear-smart-gun-required = Debes llevar equipada tu arma inteligente para ponerte esto.
rmc-gun-arc-blocked = No puedes disparar fuera del arco de tiro del arma.

rmc-shoot-id-lock-unauthorized = Gatillo bloqueado. Usuario no autorizado.
rmc-id-lock-unauthorized = Acción denegada. Usuario no autorizado.
rmc-id-lock-authorization = Recoges {$gun} y te registras como su propietario.
rmc-id-lock-authorization-combat = {$gun} pita y te registra como su propietario.
rmc-id-lock-toggle-lock = {$action} el bloqueo de identificación de {$gun}.

rmc-id-lock-color-unauthorized = rojo
rmc-id-lock-color-authorized = verde amarillento
rmc-id-lock-toggle-on = Bloqueas
rmc-id-lock-toggle-off = Desbloqueas

rmc-iff-toggle = {$action} el IFF de {$gun}.
rmc-iff-toggle-off = Desactivas
rmc-iff-toggle-on = Activas

rmc-revolver-spin = Haces girar el tambor.

rmc-examine-text-weapon-accuracy = El multiplicador de precisión actual es [color={$colour}]{TOSTRING($accuracy, "F2")}[/color].

rmc-examine-text-scatter-max = La dispersión máxima actual es de [color={$colour}]{TOSTRING($scatter, "F1")}[/color] grados.
rmc-examine-text-scatter-min = La dispersión mínima actual es de [color={$colour}]{TOSTRING($scatter, "F1")}[/color] grados.
rmc-examine-text-shots-to-max-scatter = Se necesitan [color={$colour}]{$shots}[/color] disparos para alcanzar la dispersión máxima.
rmc-examine-text-iff = [color=cyan]¡Esta arma ignorará a los aliados y disparará a través de ellos![/color]
rmc-examine-text-iff-prevent-friendly-fire = [color=cyan]Esta arma no disparará si hay aliados en la línea de fuego.[/color]
rmc-iff-friendly-in-line = Bloqueo del IFF: hay un aliado en la línea de fuego.
rmc-examine-text-id-lock-no-user = [color=chartreuse]No está registrada. Recógela para registrarte como propietario.[/color]
rmc-examine-text-id-lock = [color=chartreuse]Está registrada a nombre de [/color][color={$color}]{$name}[/color][color=chartreuse].[/color]
rmc-examine-text-id-lock-unlocked = [color=chartreuse]Está registrada a nombre de [/color][color={$color}]{$name}[/color][color=chartreuse], pero sus restricciones de disparo están desbloqueadas.[/color]
rmc-examine-text-execute = [color=red]¡Con la habilidad adecuada, esta arma puede usarse para ejecutar personas![/color]

rmc-gun-rack-examine = [bold]Pulsa la tecla de [color=cyan]acción única[/color] (barra espaciadora de forma predeterminada) para montar el arma antes de disparar.[/bold]
rmc-gun-rack-first-with = ¡Primero debes montar el arma con {$key}!
rmc-gun-rack-first = ¡Primero debes montar el arma!

rmc-assisted-reload-fail-angle = ¡Debes situarte detrás de {$target} para recargar {POSS-ADJ($target)} arma!
rmc-assisted-reload-fail-full = {CAPITALIZE(POSS-ADJ($target))} {$weapon} ya está cargada.
rmc-assisted-reload-fail-mismatch = ¡{$ammo} no puede cargarse en {$weapon}!
rmc-assisted-reload-start-user = ¡Empiezas a recargar {$weapon} de {$target}! No te muevas...
rmc-assisted-reload-start-target = ¡{$reloader} empieza a recargar tu {$weapon} con {$ammo}! No te muevas...

rmc-gun-stacks-hit-single = ¡En el blanco!
rmc-gun-stacks-hit-multiple = ¡En el blanco! ¡{$hits} impactos seguidos!
rmc-gun-stacks-reset = {$weapon} pita al perder sus datos de puntería y vuelve al procedimiento de disparo normal.

rmc-gun-shoot-air-self = ¡DISPARAS { CAPITALIZE($weapon) } AL AIRE!
rmc-gun-shoot-air-other = ¡{ CAPITALIZE(THE($user)) } DISPARA { CAPITALIZE(THE($weapon)) } AL AIRE!
rmc-gun-shoot-air-blocked = El techo que tienes encima es demasiado denso.
rmc-gun-shoot-air-examine = [bold]Pulsa la tecla de [color=cyan]acción única[/color] (barra espaciadora de forma predeterminada){$harm ->
    [true] {" mientras estás en modo de daño"}
    *[false] {""}
    } para disparar al aire.[/bold]

rmc-flare-gun-examine = La última bengala de señal disparada tiene la designación: [color=#ad3b98][bold]{$id}[/bold][/color]

expendable-light-starshell-ash-empty-name = ceniza de proyectil estelar apagado
expendable-light-starshell-ash-empty-desc = Restos consumidos de un proyectil estelar

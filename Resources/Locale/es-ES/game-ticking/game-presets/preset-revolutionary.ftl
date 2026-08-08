## Líder revolucionario

roles-antag-rev-head-name = Líder revolucionario
roles-antag-rev-head-objective = Tu objetivo es tomar el control de la estación convirtiendo gente a tu causa y eliminando a todo el personal de Mando de la estación.

head-rev-role-greeting =
    Eres líder de la revolución.
    Debes deshacerte de todo el Mando de la estación mediante conversión, muerte o encarcelamiento.
    El Sindicato te ha proporcionado una flash que convierte a la tripulación a tu causa.
    Ten cuidado: no funcionará con quienes tengan un escudo mental o lleven protección ocular.
    ¡Viva la revolución!

head-rev-briefing =
    Usa flashes para convertir gente a tu causa.
    Deshazte de todos los jefes o conviértelos para tomar el control de la estación.

head-rev-break-mindshield = ¡El escudo mental ha sido destruido!

## Revolucionario

roles-antag-rev-name = Revolucionario
roles-antag-rev-objective = Tu objetivo es proteger y obedecer a los líderes revolucionarios, además de deshacerte de todo el personal de Mando de la estación o convertirlo.

rev-break-control = ¡{$name} ha recordado cuál es su verdadera lealtad!

rev-role-greeting =
    Eres revolucionario.
    Debes tomar el control de la estación y proteger a los líderes revolucionarios.
    Deshazte de todo el personal de Mando o conviértelo.
    ¡Viva la revolución!

rev-briefing = Ayuda a tus líderes revolucionarios a deshacerse de todos los jefes para tomar el control de la estación.

## General

rev-title = Revolucionarios
rev-description = Hay revolucionarios entre nosotros.

rev-not-enough-ready-players = No hay suficientes jugadores preparados. Había {$readyPlayersCount} jugadores preparados de los {$minimumPlayers} necesarios. No se puede iniciar una Revolución.
rev-no-one-ready = ¡No hay ningún jugador preparado! No se puede iniciar una Revolución.
rev-no-heads = No se pudo seleccionar ningún líder revolucionario. No se puede iniciar una Revolución.

rev-won = Los líderes revolucionarios sobrevivieron y tomaron el control de la estación.

rev-lost = El Mando sobrevivió y mató a todos los líderes revolucionarios.

rev-stalemate = Todos los líderes revolucionarios y todo el Mando murieron. Es un empate.

rev-reverse-stalemate = Tanto el Mando como los líderes revolucionarios sobrevivieron.

rev-headrev-count = {$initialCount ->
    [one] Había un líder revolucionario:
    *[other] Había {$initialCount} líderes revolucionarios:
}

rev-headrev-name-user = [color=#5e9cff]{$name}[/color] ([color=gray]{$username}[/color]) convirtió a {$count} {$count ->
    [one] persona
    *[other] personas
}

rev-headrev-name = [color=#5e9cff]{$name}[/color] convirtió a {$count} {$count ->
    [one] persona
    *[other] personas
}

## Ventana de desconversión

rev-deconverted-title = ¡Desconvertido!
rev-deconverted-text =
    La revolución ha terminado porque ha muerto el último líder revolucionario.

    Ya no eres revolucionario, así que pórtate bien.
rev-deconverted-confirm = Confirmar

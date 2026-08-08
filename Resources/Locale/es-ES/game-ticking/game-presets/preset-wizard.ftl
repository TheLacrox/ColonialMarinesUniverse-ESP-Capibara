## Superviviente

roles-antag-survivor-name = Superviviente
# Es una referencia a Halo
roles-antag-survivor-objective = Objetivo actual: sobrevivir

survivor-role-greeting =
    Eres superviviente.
    Por encima de todo, debes regresar con vida al Mando Central.
    Reúne toda la potencia de fuego necesaria para garantizar tu supervivencia.
    No confíes en nadie.

survivor-round-end-dead-count =
{
    $deadCount ->
        [one] Murió [color=red]{$deadCount}[/color] superviviente.
        *[other] Murieron [color=red]{$deadCount}[/color] supervivientes.
}

survivor-round-end-alive-count =
{
    $aliveCount ->
        [one] [color=yellow]{$aliveCount}[/color] superviviente quedó abandonado en la estación.
        *[other] [color=yellow]{$aliveCount}[/color] supervivientes quedaron abandonados en la estación.
}

survivor-round-end-alive-on-shuttle-count =
{
    $aliveCount ->
        [one] [color=green]{$aliveCount}[/color] superviviente logró salir con vida.
        *[other] [color=green]{$aliveCount}[/color] supervivientes lograron salir con vida.
}

## Mago

objective-issuer-swf = [color=turquoise]La Federación de Magos Espaciales[/color]

wizard-title = Mago
wizard-description = ¡Hay un mago en la estación! Nunca se sabe lo que podría hacer.

roles-antag-wizard-name = Mago
roles-antag-wizard-objective = Dales una lección que nunca olvidarán.

wizard-role-greeting =
    ¡ERES UN MAGO!
    Ha habido tensiones entre la Federación de Magos Espaciales y NanoTrasen.
    Por eso, la Federación de Magos Espaciales te ha elegido para visitar la estación.
    Hazles una buena demostración de tus poderes.
    Tú decides qué hacer; recuerda que los Magos Espaciales quieren que salgas con vida.

wizard-round-end-name = mago

## PENDIENTE: aprendiz de mago (llegará en algún momento después del lanzamiento del mago)

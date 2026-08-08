
### Mensajes de interacción

# Se muestra cuando no quedan luces en el reemplazador.
comp-light-replacer-missing-light = No quedan luces en {THE($light-replacer)}.

# Se muestra al introducir una bombilla en el reemplazador.
comp-light-replacer-insert-light = Introduces {$bulb} en {THE($light-replacer)}.

# Se muestra al intentar introducir una bombilla rota.
comp-light-replacer-insert-broken-light = ¡No puedes introducir luces rotas!

# Se muestra al recargar desde una caja de luces.
comp-light-replacer-refill-from-storage = Recargas {THE($light-replacer)}.

### Examen

comp-light-replacer-no-lights = No contiene nada.
comp-light-replacer-has-lights = Contiene lo siguiente:
comp-light-replacer-light-listing = {$amount ->
    [one] [color=yellow]{$amount}[/color] [color=gray]{$name}[/color]
    *[other] [color=yellow]{$amount}[/color] [color=gray]{$name}[/color]
}

### Interfaz

# Se muestra al examinar una pila con detalle.
comp-stack-examine-detail-count = {$count ->
    [one] Hay [color={$markupCountColor}]{$count}[/color] unidad
    *[other] Hay [color={$markupCountColor}]{$count}[/color] unidades
} en la pila.

# Control del estado de la pila
comp-stack-status = Cantidad: [color=white]{$count}[/color]

### Mensajes de interacción

# Se muestra al intentar añadir algo a una pila llena.
comp-stack-already-full = La pila ya está llena.

# Se muestra cuando una pila se llena.
comp-stack-becomes-full = La pila ahora está llena.

# Texto relacionado con la división de pilas.
comp-stack-split = Divides la pila.
comp-stack-split-halve = Dividir por la mitad
comp-stack-split-too-small = La pila es demasiado pequeña para dividirla.

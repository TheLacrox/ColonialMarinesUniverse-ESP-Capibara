defusable-examine-defused = {CAPITALIZE(THE($name))}: [color=lime]mecanismo desactivado[/color].
defusable-examine-live = {CAPITALIZE(THE($name))} emite un [color=red]tic tac[/color] y le quedan [color=red]{$time}[/color] segundos.
defusable-examine-live-display-off = {CAPITALIZE(THE($name))} emite un [color=red]tic tac[/color], pero el temporizador parece apagado.
defusable-examine-inactive = {CAPITALIZE(THE($name))}: [color=lime]sin actividad[/color], pero aún se puede armar.
defusable-examine-bolts = Los pernos están {$down ->
[true] [color=red]bajados[/color]
*[false] [color=green]levantados[/color]
}.

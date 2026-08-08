# Texto que aparece al examinar a alguien que sostiene algo en las manos
comp-hands-examine = { CAPITALIZE(SUBJECT($user)) } { CONJUGATE-BE($user) } sosteniendo { $items }.
comp-hands-examine-empty = { CAPITALIZE(SUBJECT($user)) } no { CONJUGATE-BE($user) } sosteniendo nada.
comp-hands-examine-wrapper = { INDEFINITE($item) } [color=paleturquoise]{$item}[/color]

hands-system-blocked-by = Bloqueado por

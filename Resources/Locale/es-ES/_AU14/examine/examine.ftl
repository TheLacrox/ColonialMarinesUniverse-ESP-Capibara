# Better character examine (ported from WWDP), chat-log only

examine-name = ¡Es [bold]{$name}[/bold]!
examine-can-see = Al mirar a {OBJECT($ent)}, puedes ver:
examine-can-see-nothing = ¡{CAPITALIZE(GENDER($ent))} está completamente desnudo!

id-examine = - {CAPITALIZE(POSS-ADJ($ent))} [color=silver][bold]{$item}[/bold][/color] está en {POSS-ADJ($ent)} cinturón.
head-examine = - {CAPITALIZE(POSS-ADJ($ent))} [color=silver][bold]{$item}[/bold][/color] está en {POSS-ADJ($ent)} cabeza.
eyes-examine = - {CAPITALIZE(POSS-ADJ($ent))} [color=silver][bold]{$item}[/bold][/color] está sobre {POSS-ADJ($ent, "plural")} ojos.
mask-examine = - {CAPITALIZE(POSS-ADJ($ent))} [color=silver][bold]{$item}[/bold][/color] está sobre {POSS-ADJ($ent)} cara.
neck-examine = - {CAPITALIZE(POSS-ADJ($ent))} [color=silver][bold]{$item}[/bold][/color] está en {POSS-ADJ($ent)} cuello.
ears-examine = - {CAPITALIZE(POSS-ADJ($ent))} [color=silver][bold]{$item}[/bold][/color] está en {POSS-ADJ($ent)} oreja izquierda.
ears2-examine = - {CAPITALIZE(POSS-ADJ($ent))} [color=silver][bold]{$item}[/bold][/color] está en {POSS-ADJ($ent)} oreja derecha.
jumpsuit-examine = - {CAPITALIZE(POSS-ADJ($ent))} [color=silver][bold]{$item}[/bold][/color] es lo que {SUBJECT($ent)} lleva puesto.
outer-examine = - {CAPITALIZE(POSS-ADJ($ent))} [color=silver][bold]{$item}[/bold][/color] está sobre {POSS-ADJ($ent)} cuerpo.
suitstorage-examine = - {CAPITALIZE(POSS-ADJ($ent))} [color=silver][bold]{$item}[/bold][/color] está en {POSS-ADJ($ent)} hombro.
back-examine = - {CAPITALIZE(POSS-ADJ($ent))} [color=silver][bold]{$item}[/bold][/color] está en {POSS-ADJ($ent)} espalda.
gloves-examine = - {CAPITALIZE(POSS-ADJ($ent))} [color=silver][bold]{$item}[/bold][/color] está en {POSS-ADJ($ent, "plural")} manos.
belt-examine = - {CAPITALIZE(POSS-ADJ($ent))} [color=silver][bold]{$item}[/bold][/color] es lo que {SUBJECT($ent)} lleva puesto.
shoes-examine = - {CAPITALIZE(POSS-ADJ($ent))} [color=silver][bold]{$item}[/bold][/color] está en {POSS-ADJ($ent, "plural")} pies.

hand-left-examine = - {CAPITALIZE(POSS-ADJ($ent))} [color=silver][bold]{$item}[/bold][/color] está en {POSS-ADJ($ent)} mano izquierda.
hand-right-examine = - {CAPITALIZE(POSS-ADJ($ent))} [color=silver][bold]{$item}[/bold][/color] está en {POSS-ADJ($ent)} mano derecha.
hand-middle-examine = - {CAPITALIZE(POSS-ADJ($ent))} [color=silver][bold]{$item}[/bold][/color] está en una de {POSS-ADJ($ent, "plural")} manos.

id-card-examine-full = - {CAPITALIZE(POSS-ADJ($wearer))} identificación: [color=silver][bold]{$nameAndJob}[/bold][/color].

# Selfaware version

examine-name-selfaware = ¡Eres tú, [bold]{$name}[/bold]!
examine-can-see-selfaware = Al mirarte, puedes ver:
examine-can-see-nothing-selfaware = ¡Estás completamente desnudo!

id-examine-selfaware = - Llevas [color=silver][bold]{$item}[/bold][/color] en el cinturón.
head-examine-selfaware = - Llevas [color=silver][bold]{$item}[/bold][/color] en la cabeza.
eyes-examine-selfaware = - Llevas [color=silver][bold]{$item}[/bold][/color] sobre los ojos.
mask-examine-selfaware = - Llevas [color=silver][bold]{$item}[/bold][/color] sobre la cara.
neck-examine-selfaware = - Llevas [color=silver][bold]{$item}[/bold][/color] en el cuello.
ears-examine-selfaware = - Llevas [color=silver][bold]{$item}[/bold][/color] en la oreja izquierda.
ears2-examine-selfaware = - Llevas [color=silver][bold]{$item}[/bold][/color] en la oreja derecha.
jumpsuit-examine-selfaware = - Llevas puesto [color=silver][bold]{$item}[/bold][/color].
outer-examine-selfaware = - Llevas [color=silver][bold]{$item}[/bold][/color] sobre el cuerpo.
suitstorage-examine-selfaware = - Llevas [color=silver][bold]{$item}[/bold][/color] en el hombro.
back-examine-selfaware = - Llevas [color=silver][bold]{$item}[/bold][/color] a la espalda.
gloves-examine-selfaware = - Llevas [color=silver][bold]{$item}[/bold][/color] en las manos.
belt-examine-selfaware = - Llevas puesto [color=silver][bold]{$item}[/bold][/color].
shoes-examine-selfaware = - Llevas [color=silver][bold]{$item}[/bold][/color] en los pies.

hand-left-examine-selfaware = - Sostienes [color=silver][bold]{$item}[/bold][/color] en la mano izquierda.
hand-right-examine-selfaware = - Sostienes [color=silver][bold]{$item}[/bold][/color] en la mano derecha.
hand-middle-examine-selfaware = - Sostienes [color=silver][bold]{$item}[/bold][/color] en una de las manos.

# Selfaware examine

comp-hands-examine-empty-selfaware = No sostienes nada.
comp-hands-examine-selfaware = Sostienes { $items }.

humanoid-appearance-component-examine-selfaware = Eres { INDEFINITE($age) } { $age } { $species }.


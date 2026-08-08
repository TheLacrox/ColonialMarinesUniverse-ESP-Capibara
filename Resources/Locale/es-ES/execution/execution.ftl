execution-verb-name = Ejecutar
execution-verb-message = Usa tu arma para ejecutar a alguien.

# Todas las cadenas siguientes pueden usar estas variables:
# attacker (quien realiza la ejecución)
# victim (quien sufre la ejecución)
# weapon (el arma utilizada)

execution-popup-melee-initial-internal = Acercas {THE($weapon)} a la garganta de {THE($victim)}.
execution-popup-melee-initial-external = { CAPITALIZE(THE($attacker)) } acerca {POSS-ADJ($attacker)} {$weapon} a la garganta de {THE($victim)}.
execution-popup-melee-complete-internal = ¡Cortas la garganta de {THE($victim)}!
execution-popup-melee-complete-external = ¡{ CAPITALIZE(THE($attacker)) } corta la garganta de {THE($victim)}!

execution-popup-self-initial-internal = Acercas {THE($weapon)} a tu propia garganta.
execution-popup-self-initial-external = { CAPITALIZE(THE($attacker)) } acerca {POSS-ADJ($attacker)} {$weapon} a su propia garganta.
execution-popup-self-complete-internal = ¡Te cortas la garganta!
execution-popup-self-complete-external = ¡{ CAPITALIZE(THE($attacker)) } se corta la garganta!

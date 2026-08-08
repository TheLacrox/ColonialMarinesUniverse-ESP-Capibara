delivery-recipient-examine = Este envío es para {$recipient}, {$job}.
delivery-already-opened-examine = Ya se ha abierto.
delivery-earnings-examine = Entregarlo proporcionará a la estación [color=yellow]{$spesos}[/color] spesos.
delivery-recipient-no-name = Sin nombre
delivery-recipient-no-job = Desconocido

delivery-unlocked-self = Desbloqueas {$delivery} con tu huella dactilar.
delivery-opened-self = Abres {$delivery}.
delivery-unlocked-others = {CAPITALIZE($recipient)} desbloqueó {$delivery} con {POSS-ADJ($possadj)} huella dactilar.
delivery-opened-others = {CAPITALIZE($recipient)} abrió {$delivery}.

delivery-unlock-verb = Desbloquear
delivery-open-verb = Abrir
delivery-slice-verb = Abrir cortando

delivery-teleporter-amount-examine =
    { $amount ->
        [one] Contiene [color=yellow]{$amount}[/color] entrega.
        *[other] Contiene [color=yellow]{$amount}[/color] entregas.
    }
delivery-teleporter-empty = {$entity} no contiene nada.
delivery-teleporter-empty-verb = Recoger correo


# Modificadores
delivery-priority-examine = Es una [color=orange]entrega prioritaria de tipo {$type}[/color]. Quedan [color=orange]{$time}[/color] para entregarla y obtener una bonificación.
delivery-priority-delivered-examine = Es una [color=orange]entrega prioritaria de tipo {$type}[/color]. Se entregó a tiempo.
delivery-priority-expired-examine = Es una [color=orange]entrega prioritaria de tipo {$type}[/color]. Se agotó el tiempo.

delivery-fragile-examine = Es una [color=red]entrega frágil de tipo {$type}[/color]. Entrégala intacta para obtener una bonificación.
delivery-fragile-broken-examine = Es una [color=red]entrega frágil de tipo {$type}[/color]. Parece gravemente dañada.

delivery-bomb-examine = Es una [color=purple]entrega bomba de tipo {$type}[/color]. Oh, no.
delivery-bomb-primed-examine = Es una [color=purple]entrega bomba de tipo {$type}[/color]. Leer esto no es un buen uso de tu tiempo.

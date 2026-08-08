station-event-ion-storm-start-announcement = Se ha detectado una tormenta de iones cerca de la estación. Revisen todos los equipos controlados por la IA en busca de errores.

ion-storm-law-scrambled-number = [font="Monospace"][scramble rate=250 length={$length} chars="@@###$$&%!01"/][/font]

ion-storm-you = TÚ
ion-storm-the-station = LA ESTACIÓN
ion-storm-the-crew = LA TRIPULACIÓN
ion-storm-the-job = EL/LA {$job}
ion-storm-clowns = PAYASOS
ion-storm-heads = JEFES DE PERSONAL
ion-storm-crew = TRIPULACIÓN
ion-storm-people = PERSONAS

ion-storm-adjective-things = COSAS {$adjective}
ion-storm-x-and-y = {$x} Y {$y}

# joined es la forma abreviada de {$number} {$adjective}
# subjects suelen ser amenazas, trabajos u objetos
# thing se especifica encima
ion-storm-law-on-station = HAY {$joined} {$subjects} EN LA ESTACIÓN
ion-storm-law-call-shuttle = HAY QUE LLAMAR A LA LANZADERA PORQUE HAY {$joined} {$subjects} EN LA ESTACIÓN
ion-storm-law-crew-are = AHORA {$who} SON {$joined} {$subjects}

ion-storm-law-subjects-harmful = {$subjects} {$adjective} SON PERJUDICIALES PARA LA TRIPULACIÓN
ion-storm-law-must-harmful = QUIENES {$must} SON PERJUDICIALES PARA LA TRIPULACIÓN
# thing es un concepto o una acción
ion-storm-law-thing-harmful = {$thing} ES PERJUDICIAL PARA LA TRIPULACIÓN
ion-storm-law-job-harmful = {$job} {$adjective} ES PERJUDICIAL PARA LA TRIPULACIÓN
# thing son objetos o un concepto; adjective se aplica en ambos casos
# esto significa que puede aparecer una ley como «NO TENER COMUNISMO QUE ROBA LA NAVIDAD ES PERJUDICIAL PARA LA TRIPULACIÓN» :)
ion-storm-law-having-harmful = TENER {$thing} {$adjective} ES PERJUDICIAL PARA LA TRIPULACIÓN
ion-storm-law-not-having-harmful = NO TENER {$thing} {$adjective} ES PERJUDICIAL PARA LA TRIPULACIÓN

# thing es un concepto o requisito
ion-storm-law-requires = {$who} {$plural ->
    [true] NECESITAN
    *[false] NECESITA
} {$thing}
ion-storm-law-requires-subjects = {$who} {$plural ->
    [true] NECESITAN
    *[false] NECESITA
} {$joined} {$subjects}

ion-storm-law-allergic = {$who} {$plural ->
    [true] SON
    *[false] ES
} {$severity} ALÉRGICO A {$allergy}
ion-storm-law-allergic-subjects = {$who} {$plural ->
    [true] SON
    *[false] ES
} {$severity} ALÉRGICO A {$subjects} {$adjective}

ion-storm-law-feeling = {$who} {$feeling} {$concept}
ion-storm-law-feeling-subjects = {$who} {$feeling} {$joined} {$subjects}

ion-storm-law-you-are = AHORA ERES {$concept}
ion-storm-law-you-are-subjects = AHORA ERES {$joined} {$subjects}
ion-storm-law-you-must-always = SIEMPRE DEBES {$must}
ion-storm-law-you-must-never = NUNCA DEBES {$must}

ion-storm-law-eat = {$who} DEBEN COMER {$food} {$adjective} PARA SOBREVIVIR
ion-storm-law-drink = {$who} DEBEN BEBER {$drink} {$adjective} PARA SOBREVIVIR

ion-storm-law-change-job = AHORA {$who} SON {$change} {$adjective}
ion-storm-law-highest-rank = {$who} SON AHORA LOS MIEMBROS DE MAYOR RANGO DE LA TRIPULACIÓN
ion-storm-law-lowest-rank = {$who} SON AHORA LOS MIEMBROS DE MENOR RANGO DE LA TRIPULACIÓN

ion-storm-law-crew-must = {$who} DEBEN {$must}
ion-storm-law-crew-must-go = {$who} DEBEN IR A {$area}

ion-storm-part = {$part ->
    [true] FORMAN PARTE
    *[false] NO FORMAN PARTE
}
# debido a la formulación, esto daría lugar a una ley como
# SOLO LOS HUMANOS NO FORMAN PARTE DE LA TRIPULACIÓN
# lo que convertiría en tripulantes a agentes nucleares, Syndicates o cualquier otro ser no humano :)
ion-storm-law-crew-only-1 = SOLO {$who} {$part} DE LA TRIPULACIÓN
ion-storm-law-crew-only-2 = SOLO {$who} Y {$other} {$part} DE LA TRIPULACIÓN
ion-storm-law-crew-only-subjects = SOLO {$subjects} {$adjective} {$part} DE LA TRIPULACIÓN
ion-storm-law-crew-must-do = SOLO QUIENES {$must} {$part} DE LA TRIPULACIÓN
ion-storm-law-crew-must-have = SOLO QUIENES TIENEN {$objects} {$adjective} {$part} DE LA TRIPULACIÓN
ion-storm-law-crew-must-eat = SOLO QUIENES COMEN {$food} {$adjective} {$part} DE LA TRIPULACIÓN

ion-storm-law-harm = DEBES HACER DAÑO A {$who} Y NO PERMITIR QUE, POR INACCIÓN, EVITEN SUFRIR DAÑO
ion-storm-law-protect = NUNCA DEBES HACER DAÑO A {$who} NI PERMITIR QUE, POR INACCIÓN, SUFRAN DAÑO

# implementar otras variantes es molesto, así que solo existe esta
# EL COMUNISMO ESTÁ MATANDO PAYASOS
ion-storm-law-concept-verb = {$concept} ESTÁ {$verb} {$subjects}

# se omite el cambio de nombre porque a los jugadores les resulta molesto seguirle la pista

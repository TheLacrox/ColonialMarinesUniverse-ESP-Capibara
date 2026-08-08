
### Mensajes de interacción

# Al intentar comer sin el utensilio necesario... que debes llevar en la mano
food-you-need-to-hold-utensil = ¡Debes tener {INDEFINITE($utensil)} {$utensil} en la mano para comer eso!

food-nom = Das un mordisco a { THE($food) }. {$flavors}
food-swallow = Te tragas { THE($food) }. {$flavors}

food-has-used-storage = No puedes comerte { THE($food) } mientras guarde un objeto dentro.

food-system-remove-mask = Primero debes quitarte {$entity}.

## Sistema

food-system-you-cannot-eat-any-more = ¡No puedes comer más!
food-system-you-cannot-eat-any-more-other = ¡{CAPITALIZE(SUBJECT($target))} no puede comer más!
food-system-try-use-food-is-empty = ¡{CAPITALIZE(THE($entity))} no contiene nada!
food-system-wrong-utensil = No puedes comer {THE($food)} con {INDEFINITE($utensil)} {$utensil}.
food-system-cant-digest = ¡No puedes digerir {THE($entity)}!
food-system-cant-digest-other = ¡{CAPITALIZE(SUBJECT($target))} no puede digerir {THE($entity)}!

food-system-verb-eat = Comer

## Alimentación forzada

food-system-force-feed = ¡{CAPITALIZE(THE($user))} intenta obligarte a comer algo!
food-system-force-feed-success = ¡{CAPITALIZE(THE($user))} te ha obligado a comer algo! {$flavors}
food-system-force-feed-success-user = Alimentas a {THE($target)} correctamente

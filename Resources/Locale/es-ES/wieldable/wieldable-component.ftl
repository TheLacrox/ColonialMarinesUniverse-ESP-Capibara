### Localización para empuñar objetos con ambas manos

wieldable-verb-text-wield = Empuñar con ambas manos
wieldable-verb-text-unwield = Dejar de empuñar con ambas manos

wieldable-component-successful-wield = Empuñas { THE($item) } con ambas manos.
wieldable-component-failed-wield = Dejas de empuñar { THE($item) } con ambas manos.
wieldable-component-successful-wield-other = { CAPITALIZE(THE($user)) } empuña { THE($item) } con ambas manos.
wieldable-component-failed-wield-other = { CAPITALIZE(THE($user)) } deja de empuñar { THE($item) } con ambas manos.
wieldable-component-blocked-wield = { CAPITALIZE(THE($blocker)) } te impide empuñar { THE($item) } con ambas manos.

wieldable-component-no-hands = ¡No tienes suficientes manos!
wieldable-component-not-enough-free-hands = {$number ->
    [one] Necesitas una mano libre para empuñar { THE($item) } con ambas manos.
    *[other] Necesitas { $number } manos libres para empuñar { THE($item) } con ambas manos.
}
wieldable-component-not-in-hands = ¡{ CAPITALIZE(THE($item)) } no está en tus manos!

wieldable-component-requires = ¡Debes empuñar { CAPITALIZE(THE($item))} con ambas manos!

gunwieldbonus-component-examine = Esta arma tiene mayor precisión al empuñarla con ambas manos.

gunrequireswield-component-examine = Esta arma solo puede dispararse cuando se empuña con ambas manos.

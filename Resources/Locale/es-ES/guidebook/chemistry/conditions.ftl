reagent-effect-condition-guidebook-total-damage =
    { $max ->
        [2147483648] tiene al menos {NATURALFIXED($min, 2)} puntos de daño total
        *[other] { $min ->
                    [0] tiene como máximo {NATURALFIXED($max, 2)} puntos de daño total
                    *[other] tiene entre {NATURALFIXED($min, 2)} y {NATURALFIXED($max, 2)} puntos de daño total
                 }
    }

reagent-effect-condition-guidebook-total-hunger =
    { $max ->
        [2147483648] el objetivo tiene al menos {NATURALFIXED($min, 2)} puntos de hambre total
        *[other] { $min ->
                    [0] el objetivo tiene como máximo {NATURALFIXED($max, 2)} puntos de hambre total
                    *[other] el objetivo tiene entre {NATURALFIXED($min, 2)} y {NATURALFIXED($max, 2)} puntos de hambre total
                 }
    }

reagent-effect-condition-guidebook-reagent-threshold =
    { $max ->
        [2147483648] hay al menos {NATURALFIXED($min, 2)} u de {$reagent}
        *[other] { $min ->
                    [0] hay como máximo {NATURALFIXED($max, 2)} u de {$reagent}
                    *[other] hay entre {NATURALFIXED($min, 2)} u y {NATURALFIXED($max, 2)} u de {$reagent}
                 }
    }

reagent-effect-condition-guidebook-mob-state-condition =
    la criatura está { $state }

reagent-effect-condition-guidebook-job-condition =
    el trabajo del objetivo es { $job }

reagent-effect-condition-guidebook-solution-temperature =
    la temperatura de la solución es { $max ->
            [2147483648] de al menos {NATURALFIXED($min, 2)} K
            *[other] { $min ->
                        [0] de como máximo {NATURALFIXED($max, 2)} K
                        *[other] de entre {NATURALFIXED($min, 2)} K y {NATURALFIXED($max, 2)} K
                     }
    }

reagent-effect-condition-guidebook-body-temperature =
    la temperatura corporal es { $max ->
            [2147483648] de al menos {NATURALFIXED($min, 2)} K
            *[other] { $min ->
                        [0] de como máximo {NATURALFIXED($max, 2)} K
                        *[other] de entre {NATURALFIXED($min, 2)} K y {NATURALFIXED($max, 2)} K
                     }
    }

reagent-effect-condition-guidebook-organ-type =
    el órgano metabolizador { $shouldhave ->
                                [true] es
                                *[false] no es
                           } {INDEFINITE($name)} órgano {$name}

reagent-effect-condition-guidebook-has-tag =
    el objetivo { $invert ->
                 [true] no tiene
                 *[false] tiene
                } la etiqueta {$tag}

reagent-effect-condition-guidebook-this-reagent = este reactivo

reagent-effect-condition-guidebook-breathing =
    quien lo metaboliza { $isBreathing ->
                [true] respira con normalidad
                *[false] se está asfixiando
               }

reagent-effect-condition-guidebook-internals =
    quien lo metaboliza { $usingInternals ->
                [true] está usando el suministro interno
                *[false] respira el aire de la atmósfera
               }

-create-3rd-person =
    { $chance ->
        [1] Crea
        *[other] crear
    }

-cause-3rd-person =
    { $chance ->
        [1] Causa
        *[other] causar
    }

-satiate-3rd-person =
    { $chance ->
        [1] Sacia
        *[other] saciar
    }

reagent-effect-guidebook-create-entity-reaction-effect =
    { $chance ->
        [1] Crea
        *[other] crear
    } { $amount ->
        [1] {INDEFINITE($entname)}
        *[other] {$amount} {MAKEPLURAL($entname)}
    }

reagent-effect-guidebook-explosion-reaction-effect =
    { $chance ->
        [1] Provoca
        *[other] provocar
    } una explosión

reagent-effect-guidebook-emp-reaction-effect =
    { $chance ->
        [1] Provoca
        *[other] provocar
    } un pulso electromagnético

reagent-effect-guidebook-flash-reaction-effect =
    { $chance ->
        [1] Provoca
        *[other] provocar
    } un destello cegador

reagent-effect-guidebook-foam-area-reaction-effect =
    { $chance ->
        [1] Crea
        *[other] crear
    } grandes cantidades de espuma

reagent-effect-guidebook-smoke-area-reaction-effect =
    { $chance ->
        [1] Crea
        *[other] crear
    } grandes cantidades de humo

reagent-effect-guidebook-satiate-thirst =
    { $chance ->
        [1] Sacia
        *[other] saciar
    } { $relative ->
        [1] la sed a un ritmo normal
        *[other] la sed a {NATURALFIXED($relative, 3)} veces el ritmo normal
    }

reagent-effect-guidebook-satiate-hunger =
    { $chance ->
        [1] Sacia
        *[other] saciar
    } { $relative ->
        [1] el hambre a un ritmo normal
        *[other] el hambre a {NATURALFIXED($relative, 3)} veces el ritmo normal
    }

reagent-effect-guidebook-health-change =
    { $chance ->
        [1] { $healsordeals ->
                [heals] Cura
                [deals] Inflige
                *[both] Modifica la salud en
             }
        *[other] { $healsordeals ->
                    [heals] curar
                    [deals] infligir
                    *[both] modificar la salud en
                 }
    } { $changes }

reagent-effect-guidebook-even-health-change =
    { $chance ->
        [1] { $healsordeals ->
            [heals] Cura de manera uniforme
            [deals] Inflige de manera uniforme
            *[both] Modifica de manera uniforme la salud en
        }
        *[other] { $healsordeals ->
            [heals] curar de manera uniforme
            [deals] infligir de manera uniforme
            *[both] modificar de manera uniforme la salud en
        }
    } { $changes }


reagent-effect-guidebook-status-effect =
    { $type ->
        [add]   { $chance ->
                    [1] Causa
                    *[other] causar
                } {LOC($key)} durante al menos {NATURALFIXED($time, 3)} {MANY("segundo", $time)} y permite que se acumule
        *[set]  { $chance ->
                    [1] Causa
                    *[other] causar
                } {LOC($key)} durante al menos {NATURALFIXED($time, 3)} {MANY("segundo", $time)} sin permitir que se acumule
        [remove]{ $chance ->
                    [1] Elimina
                    *[other] eliminar
                } {NATURALFIXED($time, 3)} {MANY("segundo", $time)} de {LOC($key)}
    }

reagent-effect-guidebook-set-solution-temperature-effect =
    { $chance ->
        [1] Fija
        *[other] fijar
    } la temperatura de la solución en exactamente {NATURALFIXED($temperature, 2)} K

reagent-effect-guidebook-adjust-solution-temperature-effect =
    { $chance ->
        [1] { $deltasign ->
                [1] Aumenta
                *[-1] Disminuye
            }
        *[other]
            { $deltasign ->
                [1] aumentar
                *[-1] disminuir
            }
    } la temperatura de la solución hasta que alcanza { $deltasign ->
                [1] como máximo {NATURALFIXED($maxtemp, 2)} K
                *[-1] al menos {NATURALFIXED($mintemp, 2)} K
            }

reagent-effect-guidebook-adjust-reagent-reagent =
    { $chance ->
        [1] { $deltasign ->
                [1] Añade
                *[-1] Retira
            }
        *[other]
            { $deltasign ->
                [1] añadir
                *[-1] retirar
            }
    } {NATURALFIXED($amount, 2)} u de {$reagent} { $deltasign ->
        [1] a
        *[-1] de
    } la solución

reagent-effect-guidebook-adjust-reagent-group =
    { $chance ->
        [1] { $deltasign ->
                [1] Añade
                *[-1] Retira
            }
        *[other]
            { $deltasign ->
                [1] añadir
                *[-1] retirar
            }
    } {NATURALFIXED($amount, 2)} u de reactivos del grupo {$group} { $deltasign ->
            [1] a
            *[-1] de
        } la solución

reagent-effect-guidebook-adjust-temperature =
    { $chance ->
        [1] { $deltasign ->
                [1] Añade
                *[-1] Retira
            }
        *[other]
            { $deltasign ->
                [1] añadir
                *[-1] retirar
            }
    } {POWERJOULES($amount)} de calor { $deltasign ->
            [1] al
            *[-1] del
        } cuerpo que lo contiene

reagent-effect-guidebook-chem-cause-disease =
    { $chance ->
        [1] Causa
        *[other] causar
    } la enfermedad { $disease }

reagent-effect-guidebook-chem-cause-random-disease =
    { $chance ->
        [1] Causa
        *[other] causar
    } las enfermedades { $diseases }

reagent-effect-guidebook-jittering =
    { $chance ->
        [1] Causa
        *[other] causar
    } temblores

reagent-effect-guidebook-chem-clean-bloodstream =
    { $chance ->
        [1] Limpia
        *[other] limpiar
    } el torrente sanguíneo de otras sustancias químicas

reagent-effect-guidebook-cure-disease =
    { $chance ->
        [1] Cura
        *[other] curar
    } enfermedades

reagent-effect-guidebook-cure-eye-damage =
    { $chance ->
        [1] { $deltasign ->
                [1] Inflige
                *[-1] Cura
            }
        *[other]
            { $deltasign ->
                [1] infligir
                *[-1] curar
            }
    } daño ocular

reagent-effect-guidebook-chem-vomit =
    { $chance ->
        [1] Provoca
        *[other] provocar
    } vómitos

reagent-effect-guidebook-create-gas =
    { $chance ->
        [1] Crea
        *[other] crear
    } { $moles } { $moles ->
        [1] mol
        *[other] moles
    } de { $gas }

reagent-effect-guidebook-drunk =
    { $chance ->
        [1] Provoca
        *[other] provocar
    } embriaguez

reagent-effect-guidebook-electrocute =
    { $chance ->
        [1] Electrocuta
        *[other] electrocutar
    } a quien lo metaboliza durante {NATURALFIXED($time, 3)} {MANY("segundo", $time)}

reagent-effect-guidebook-emote =
    { $chance ->
        [1] Obliga
        *[other] obligar
    } a quien lo metaboliza a realizar [bold][color=white]{$emote}[/color][/bold]

reagent-effect-guidebook-extinguish-reaction =
    { $chance ->
        [1] Extingue
        *[other] extinguir
    } el fuego

reagent-effect-guidebook-flammable-reaction =
    { $chance ->
        [1] Aumenta
        *[other] aumentar
    } la inflamabilidad

reagent-effect-guidebook-ignite =
    { $chance ->
        [1] Prende fuego
        *[other] prender fuego
    } a quien lo metaboliza

reagent-effect-guidebook-make-sentient =
    { $chance ->
        [1] Vuelve
        *[other] volver
    } sintiente a quien lo metaboliza

reagent-effect-guidebook-make-polymorph =
    { $chance ->
        [1] Transforma
        *[other] transformar
    } a quien lo metaboliza en {$entityname}

reagent-effect-guidebook-modify-bleed-amount =
    { $chance ->
        [1] { $deltasign ->
                [1] Induce
                *[-1] Reduce
            }
        *[other] { $deltasign ->
                    [1] inducir
                    *[-1] reducir
                 }
    } el sangrado

reagent-effect-guidebook-modify-blood-level =
    { $chance ->
        [1] { $deltasign ->
                [1] Aumenta
                *[-1] Disminuye
            }
        *[other] { $deltasign ->
                    [1] aumentar
                    *[-1] disminuir
                 }
    } el nivel de sangre

reagent-effect-guidebook-paralyze =
    { $chance ->
        [1] Paraliza
        *[other] paralizar
    } a quien lo metaboliza durante al menos {NATURALFIXED($time, 3)} {MANY("segundo", $time)}

reagent-effect-guidebook-movespeed-modifier =
    { $chance ->
        [1] Modifica
        *[other] modificar
    } la velocidad de movimiento en {NATURALFIXED($walkspeed, 3)} veces durante al menos {NATURALFIXED($time, 3)} {MANY("segundo", $time)}

reagent-effect-guidebook-reset-narcolepsy =
    { $chance ->
        [1] Contiene temporalmente
        *[other] contener temporalmente
    } la narcolepsia

reagent-effect-guidebook-wash-cream-pie-reaction =
    { $chance ->
        [1] Limpia
        *[other] limpiar
    } los restos de tarta de crema de la cara

reagent-effect-guidebook-cure-zombie-infection =
    { $chance ->
        [1] Cura
        *[other] curar
    } una infección zombi en curso

reagent-effect-guidebook-cause-zombie-infection =
    { $chance ->
        [1] Contagia
        *[other] contagiar
    } la infección zombi a una persona

reagent-effect-guidebook-innoculate-zombie-infection =
    { $chance ->
        [1] Cura
        *[other] curar
    } una infección zombi en curso y proporciona inmunidad frente a futuras infecciones

reagent-effect-guidebook-reduce-rotting =
    { $chance ->
        [1] Revierte
        *[other] revertir
    } {NATURALFIXED($time, 3)} {MANY("segundo", $time)} de putrefacción

reagent-effect-guidebook-area-reaction =
    { $chance ->
        [1] Provoca
        *[other] provocar
    } una reacción de humo o espuma durante {NATURALFIXED($duration, 3)} {MANY("segundo", $duration)}

reagent-effect-guidebook-add-to-solution-reaction =
    { $chance ->
        [1] Hace
        *[other] hacer
    } que las sustancias químicas aplicadas a un objeto se añadan al recipiente de solución interno

reagent-effect-guidebook-artifact-unlock =
    { $chance ->
        [1] Ayuda a
        *[other] ayudar a
        } desbloquear un artefacto alienígena.

reagent-effect-guidebook-artifact-durability-restore =
    Restaura {$restored} puntos de durabilidad en los nodos activos de artefactos alienígenas.

reagent-effect-guidebook-plant-attribute =
    { $chance ->
        [1] Ajusta
        *[other] ajustar
    } {$attribute} en [color={$colorName}]{$amount}[/color]

reagent-effect-guidebook-plant-cryoxadone =
    { $chance ->
        [1] Rejuvenece
        *[other] rejuvenecer
    } la planta en función de su edad y su tiempo de crecimiento

reagent-effect-guidebook-plant-phalanximine =
    { $chance ->
        [1] Devuelve
        *[other] devolver
    } la viabilidad a una planta que una mutación había vuelto inviable

reagent-effect-guidebook-plant-diethylamine =
    { $chance ->
        [1] Aumenta
        *[other] aumentar
    } la esperanza de vida o la salud base de la planta, con un 10 % de probabilidad para cada una

reagent-effect-guidebook-plant-robust-harvest =
    { $chance ->
        [1] Aumenta
        *[other] aumentar
    } la potencia de la planta en {$increase} hasta un máximo de {$limit}. Hace que la planta pierda sus semillas cuando la potencia alcanza {$seedlesstreshold}. Intentar elevar la potencia por encima de {$limit} puede reducir el rendimiento con una probabilidad del 10 %

reagent-effect-guidebook-plant-seeds-add =
    { $chance ->
        [1] Restaura las
        *[other] restaurar las
    } semillas de la planta

reagent-effect-guidebook-plant-seeds-remove =
    { $chance ->
        [1] Elimina las
        *[other] eliminar las
    } semillas de la planta

rmc-medical-examine-unrevivable = [color=purple][italic]{ CAPITALIZE(POSS-ADJ($victim, "plural")) } ojos han perdido toda expresión; no hay señales de vida.[/italic][/color]

rmc-medical-examine-headless = [color=purple][italic]{CAPITALIZE(SUBJECT($victim))} {CONJUGATE-BE($victim)} sin duda muerto.[/italic][/color]

rmc-medical-examine-unconscious = [color=lightblue]{ CAPITALIZE(SUBJECT($victim)) } { GENDER($victim) ->
    [epicene] parece
    *[other] parece
  } estar inconsciente.[/color]

rmc-medical-examine-dead = [color=red]{CAPITALIZE(SUBJECT($victim))} {CONJUGATE-BE($victim)} sin respirar.[/color]

rmc-medical-examine-dead-simple-mob = [color=red]{CAPITALIZE(SUBJECT($victim))} {CONJUGATE-BE($victim)} MUERTO. Ha estirado la pata.[/color]

rmc-medical-examine-dead-xeno = [color=red]{CAPITALIZE(SUBJECT($victim))} {CONJUGATE-BE($victim)} MUERTO. Ha estirado la pata. Se dirige a esa gran colmena del cielo.[/color]

rmc-medical-examine-alive = [color=green]{CAPITALIZE(SUBJECT($victim))} {CONJUGATE-BE($victim)} con vida y respirando.[/color]

rmc-medical-examine-bleeding = [color=#d10a0a]{CAPITALIZE(SUBJECT($victim))} {CONJUGATE-HAVE($victim)} heridas sangrantes en {POSS-ADJ($victim)} cuerpo.[/color]

rmc-medical-examine-bleeding-from = [color=#d10a0a]{CAPITALIZE(SUBJECT($victim))} {CONJUGATE-BE($victim)} sangrando por una zona de {POSS-ADJ($victim)} cuerpo: {$parts}.[/color]

rmc-medical-examine-verb = Mostrar acciones médicas

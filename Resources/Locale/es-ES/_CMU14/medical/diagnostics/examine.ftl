cmu-medical-examine-wound-line = [color=red]{ CAPITALIZE(SUBJECT($target)) } { CONJUGATE-HAVE($target) } { $wounds } en { POSS-ADJ($target) } { $part }.[/color]
cmu-medical-examine-fracture-line = [color=#dca94c]{ CAPITALIZE(SUBJECT($target)) } { CONJUGATE-HAVE($target) } { $fracture } en { POSS-ADJ($target) } { $part }.[/color]
cmu-medical-examine-wounds-line = [color=red]{ CAPITALIZE(SUBJECT($target)) } { CONJUGATE-HAVE($target) } heridas: { $parts }.[/color]
cmu-medical-examine-fractures-line = [color=#dca94c]{ CAPITALIZE(SUBJECT($target)) } { CONJUGATE-HAVE($target) } fracturas: { $parts }.[/color]
cmu-medical-examine-body-part-line = { $part }: { $conditions }.
cmu-medical-detailed-examine-verb = Inspeccionar lesiones
cmu-medical-detailed-examine-verb-message = Examina sus lesiones más de cerca.
cmu-medical-detailed-examine-start = Empiezas a comprobar si { THE($target) } tiene lesiones.
cmu-medical-detailed-examine-none = No se encontraron lesiones evidentes.
cmu-medical-detailed-examine-window-title = Lesiones - { $target }
cmu-medical-detailed-examine-window-heading = Informe de lesiones
cmu-medical-detailed-examine-window-bleeding = Hemorragia: { $tier }

cmu-robotic-limb-material-synthetic = sintético
cmu-robotic-limb-examine-state = prótesis
cmu-robotic-limb-examine-brute = placas abolladas
cmu-robotic-limb-examine-burn = cableado chamuscado
cmu-robotic-limb-detailed-state = prótesis
cmu-robotic-limb-detailed-brute = traumatismo mecánico: placas abolladas
cmu-robotic-limb-detailed-burn = daño térmico: cableado chamuscado
cmu-robotic-limb-inspect-header = Daños en la extremidad robótica

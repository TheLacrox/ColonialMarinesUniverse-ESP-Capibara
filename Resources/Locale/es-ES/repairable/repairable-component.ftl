### Mensajes de interacción

# Se muestra al reparar algo.
comp-repairable-repair = Reparas {PROPER($target) ->
  [true] {""}
  *[false] el objeto{" "}
}{$target} con {PROPER($tool) ->
  [true] {""}
  *[false] la herramienta{" "}
}{$tool}

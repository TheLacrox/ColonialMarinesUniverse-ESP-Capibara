generator-clogged = ¡{CAPITALIZE(THE($generator))} se apaga de golpe!

portable-generator-verb-start = Arrancar generador
portable-generator-verb-start-msg-unreliable = Arranca el generador. Puede que necesites varios intentos.
portable-generator-verb-start-msg-reliable = Arranca el generador.
portable-generator-verb-start-msg-unanchored = ¡Primero debes anclar el generador!
portable-generator-verb-stop = Detener generador
portable-generator-start-fail = Tiras del cordón, pero no arranca.
portable-generator-start-success = Tiras del cordón y cobra vida con un zumbido.

portable-generator-ui-title = Generador portátil
portable-generator-ui-status-stopped = Detenido:
portable-generator-ui-status-starting = Arrancando:
portable-generator-ui-status-running = En marcha:
portable-generator-ui-start = Arrancar
portable-generator-ui-stop = Detener
portable-generator-ui-target-power-label = Potencia objetivo (kW):
portable-generator-ui-efficiency-label = Eficiencia:
portable-generator-ui-fuel-use-label = Consumo de combustible:
portable-generator-ui-fuel-left-label = Combustible restante:
portable-generator-ui-clogged = ¡Se han detectado contaminantes en el depósito de combustible!
portable-generator-ui-eject = Expulsar
portable-generator-ui-eta = (~{ $minutes } min)
portable-generator-ui-unanchored = Desanclado
portable-generator-ui-current-output = Salida actual: {$voltage}
portable-generator-ui-network-stats = Red:
portable-generator-ui-network-stats-value = { POWERWATTS($supply) } / { POWERWATTS($load) }
portable-generator-ui-network-stats-not-connected = Sin conexión

power-switchable-generator-examine = La tensión de salida está ajustada a {$voltage}.
power-switchable-generator-switched = ¡Tensión de salida cambiada a {$voltage}!

power-switchable-voltage = { $voltage ->
    [HV] [color=orange]HV[/color]
    [MV] [color=yellow]MV[/color]
    *[LV] [color=green]LV[/color]
}
power-switchable-switch-voltage = Cambiar a {$voltage}

fuel-generator-verb-disable-on = ¡Apaga primero el generador!

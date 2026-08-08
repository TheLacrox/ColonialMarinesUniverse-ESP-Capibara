cmd-atvrange-desc = Establece el intervalo de depuración atmosférica (como dos números decimales: inicio [red] y fin [blue])
cmd-atvrange-help = Uso: {$command} <inicio> <fin>
cmd-atvrange-error-start = El número decimal de INICIO no es válido
cmd-atvrange-error-end = El número decimal de FIN no es válido
cmd-atvrange-error-zero = La escala no puede ser cero, ya que provocaría una división entre cero en AtmosDebugOverlay.

cmd-atvmode-desc = Establece el modo de depuración atmosférica. Esto reiniciará automáticamente la escala.
cmd-atvmode-help = Uso: {$command} <TotalMoles/GasMoles/Temperature> [<ID de gas (para GasMoles)>]
cmd-atvmode-error-invalid = Modo no válido
cmd-atvmode-error-target-gas = Debes proporcionar un gas objetivo para este modo.
cmd-atvmode-error-out-of-range = No se pudo interpretar el ID del gas o está fuera del intervalo.
cmd-atvmode-error-info = Este modo no requiere más información.

cmd-atvcbm-desc = Cambia de rojo/verde/azul a escala de grises
cmd-atvcbm-help = Uso: {$command} <true/false>
cmd-atvcbm-error = Indicador no válido

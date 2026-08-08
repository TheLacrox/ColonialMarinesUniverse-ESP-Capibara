anomaly-component-contact-damage = ¡La anomalía te abrasa la piel!

anomaly-vessel-component-anomaly-assigned = Anomalía asignada al recipiente.
anomaly-vessel-component-not-assigned = Este recipiente no está asignado a ninguna anomalía. Prueba a usar un escáner sobre él.
anomaly-vessel-component-assigned = Este recipiente ya está asignado a una anomalía.

anomaly-particles-delta = Partículas delta
anomaly-particles-epsilon = Partículas épsilon
anomaly-particles-zeta = Partículas zeta
anomaly-particles-omega = Partículas omega
anomaly-particles-sigma = Partículas sigma

anomaly-scanner-component-scan-complete = ¡Escaneo completado!

anomaly-scanner-ui-title = escáner de anomalías
anomaly-scanner-no-anomaly = No hay ninguna anomalía escaneada.
anomaly-scanner-severity-percentage = Gravedad actual: [color=gray]{$percent}[/color]
anomaly-scanner-severity-percentage-unknown = Gravedad actual: [color=red]ERROR[/color]
anomaly-scanner-stability-low = Estado actual de la anomalía: [color=gold]En desintegración[/color]
anomaly-scanner-stability-medium = Estado actual de la anomalía: [color=forestgreen]Estable[/color]
anomaly-scanner-stability-high = Estado actual de la anomalía: [color=crimson]En crecimiento[/color]
anomaly-scanner-stability-unknown = Estado actual de la anomalía: [color=red]ERROR[/color]
anomaly-scanner-point-output = Producción de puntos: [color=gray]{$point}[/color]
anomaly-scanner-point-output-unknown = Producción de puntos: [color=red]ERROR[/color]
anomaly-scanner-particle-readout = Análisis de reacción a partículas:
anomaly-scanner-particle-danger = - [color=crimson]Tipo peligroso:[/color] {$type}
anomaly-scanner-particle-unstable = - [color=plum]Tipo inestable:[/color] {$type}
anomaly-scanner-particle-containment = - [color=goldenrod]Tipo de contención:[/color] {$type}
anomaly-scanner-particle-transformation = - [color=#6b75fa]Tipo de transformación:[/color] {$type}
anomaly-scanner-particle-danger-unknown = - [color=crimson]Tipo peligroso:[/color] [color=red]ERROR[/color]
anomaly-scanner-particle-unstable-unknown = - [color=plum]Tipo inestable:[/color] [color=red]ERROR[/color]
anomaly-scanner-particle-containment-unknown = - [color=goldenrod]Tipo de contención:[/color] [color=red]ERROR[/color]
anomaly-scanner-particle-transformation-unknown = - [color=#6b75fa]Tipo de transformación:[/color] [color=red]ERROR[/color]
anomaly-scanner-pulse-timer = Tiempo hasta el próximo pulso: [color=gray]{$time}[/color]

anomaly-gorilla-core-slot-name = Núcleo de anomalía
anomaly-gorilla-charge-none = No contiene ningún [bold]núcleo de anomalía[/bold].
anomaly-gorilla-charge-limit = Dispone de [color={$count ->
    [3]green
    [2]yellow
    [1]orange
    [0]red
    *[other]purple
}]{$count} {$count ->
    [one]carga
    *[other]cargas
}[/color].
anomaly-gorilla-charge-infinite = Tiene [color=gold]cargas infinitas[/color]. [italic]Por ahora...[/italic]

anomaly-sync-connected = Anomalía conectada correctamente
anomaly-sync-disconnected = ¡Se ha perdido la conexión con la anomalía!
anomaly-sync-no-anomaly = No hay ninguna anomalía al alcance.
anomaly-sync-examine-connected = Está [color=darkgreen]conectado[/color] a una anomalía.
anomaly-sync-examine-not-connected = [color=darkred]No está conectado[/color] a ninguna anomalía.
anomaly-sync-connect-verb-text = Conectar anomalía
anomaly-sync-connect-verb-message = Conecta una anomalía cercana a {THE($machine)}.

anomaly-generator-ui-title = Generador de anomalías
anomaly-generator-fuel-display = Combustible:
anomaly-generator-cooldown = Recarga: [color=gray]{$time}[/color]
anomaly-generator-no-cooldown = Recarga: [color=gray]Completa[/color]
anomaly-generator-yes-fire = Estado: [color=forestgreen]Listo[/color]
anomaly-generator-no-fire = Estado: [color=crimson]No disponible[/color]
anomaly-generator-generate = Generar anomalía
anomaly-generator-charges = {$charges ->
    [one] {$charges} carga
    *[other] {$charges} cargas
}
anomaly-generator-announcement = ¡Se ha generado una anomalía!

anomaly-command-pulse = Hace que la anomalía objetivo emita un pulso
anomaly-command-supercritical = Vuelve supercrítica la anomalía objetivo

# Texto decorativo del pie
anomaly-generator-flavor-left = La anomalía podría aparecer dentro del operador.
anomaly-generator-flavor-right = v1.1

anomaly-behavior-unknown = [color=red]ERROR. No se puede leer.[/color]

anomaly-behavior-title = análisis de desviaciones de comportamiento:
anomaly-behavior-point = [color=gold]La anomalía produce el {$mod} % de los puntos[/color]

anomaly-behavior-safe = [color=forestgreen]La anomalía es extremadamente estable. Las pulsaciones son muy poco frecuentes.[/color]
anomaly-behavior-slow = [color=forestgreen]Las pulsaciones son mucho menos frecuentes.[/color]
anomaly-behavior-light = [color=forestgreen]La potencia de las pulsaciones se ha reducido considerablemente.[/color]
anomaly-behavior-balanced = No se detectaron desviaciones de comportamiento.
anomaly-behavior-delayed-force = Las pulsaciones son mucho menos frecuentes, pero su potencia ha aumentado.
anomaly-behavior-rapid = Las pulsaciones son mucho más frecuentes, pero su intensidad se ha atenuado.
anomaly-behavior-reflect = Se detectó un revestimiento protector.
anomaly-behavior-nonsensivity = Se detectó una reacción débil a las partículas.
anomaly-behavior-sensivity = Se detectó una reacción amplificada a las partículas.
anomaly-behavior-invisibility = Se detectó una distorsión de las ondas luminosas.
anomaly-behavior-secret = Se detectaron interferencias. Algunos datos no se pueden leer.
anomaly-behavior-inconstancy = [color=crimson]Se detectó inconstancia. Los tipos de partículas pueden cambiar con el tiempo.[/color]
anomaly-behavior-fast = [color=crimson]La frecuencia de las pulsaciones ha aumentado considerablemente.[/color]
anomaly-behavior-strenght = [color=crimson]La potencia de las pulsaciones ha aumentado considerablemente.[/color]
anomaly-behavior-moving = [color=crimson]Se detectó inestabilidad en las coordenadas.[/color]

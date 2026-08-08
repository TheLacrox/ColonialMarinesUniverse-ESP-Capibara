# This file is a mess and I apologize for it - MACMAN2003

research-database-details = [bold]Detalles de la base de datos:[/bold]
cmu-paper-header-wy = [italic][bold]Documento oficial de Weyland-Yutani[/bold][/italic]
# for some really fucked up reason, {"\u000a"} is necessary for newlines
cmu-paper-subheader-xrf-analysis = [italic]Informe automatizado A-XRF[/italic]{"\u000a"}[head=2]Análisis de {$NAME}[/head]{"\u000a"}[bold]Resultados de la muestra:[/bold]#{$NUMBER}
cmu-paper-subheader-research-xrf-fail = [italic]Impresión del análisis del reactivo[/italic]{"\u000a"}[head=2]ERROR DE ANÁLISIS[/head]

cmu-paper-research-fail-reason = [bold]Motivo del error:[/bold]{"\u000a"}[italic]{$REASON}[/italic]

cmu-paper-xrf-footer = [italic]Este informe fue generado automáticamente por el escáner A-XRF.[/italic]

research-report-reaction-header = La sustancia química presenta los siguientes indicadores de reacción:

research-report-overdose = Provoca una sobredosis a partir de {$OD} unidades.
research-report-crit-overdose = Provoca una sobredosis crítica a partir de {$COD} unidades.
research-report-metab-mult = Multiplicador de duración estándar de {$MULT}x.

research-report-clearance-insuf = CLASIFICADO:[italic] Se requiere un nivel de autorización {$CLEAR} para leer la entrada de la base de datos.[/italic]
research-report-x-needed = CLASIFICADO:[italic] Se requiere un nivel de autorización [bold]X[/bold] para leer la entrada de la base de datos.[/italic]

research-report-no-data = [italic]No se encontraron detalles sobre este reactivo en la base de datos.[/italic]

research-report-spectrum-saved = [italic]Se guardó en la base de datos el espectro de emisión de {$NAME}.[/italic]

research-report-composition-details = [bold]Detalles de la composición:[/bold]

research-report-unknown-emission = [italic]- Espectro de emisión desconocido.[/italic]

research-report-ingredient = [italic] - {$AMOUNT} {$NAME}[/italic]

research-report-catalyst-details = La reacción requeriría los siguientes catalizadores:

research-report-element = [italic] - {$NAME}[/italic]

research-report-unable-analyze = [italic]ERROR: no se puede analizar el espectro de emisión de la muestra.[/italic]

xrf-report-error = Análisis de ERROR

research-report-analysis-name = Análisis de {$NAME1}{$NAME2}

research-report-simulation-name = Resultado de la simulación para {$ID}

cmu-paper-header-wy-sim = [italic][bold]Documento oficial de la compañía[/bold]{"\u000a"}Informe de síntesis simulada[/italic]{"\u000a"}[head=2]Resultado para {$ID}[/head]

cmu-paper-sim-footer = [italic]Este informe fue impreso automáticamente por el simulador de síntesis.[/italic]

cmu-paper-ciph-hint-header = [italic][bold]Documento oficial de la compañía[/bold]{"\u000a"}Notas del experimento y autorización de pruebas[/italic]
cmu-paper-ciph-hint-subheader = [head=3][color=#517087]División de Armas Biológicas de Weyland-Yutani[/head][/color]
cmu-paper-ciph-hint = Durante las pruebas se descubrió que el componente teórico [bold]{$CIPH}[/bold] estaba compuesto por [bold]{$A}[/bold] y [bold]{$B}[/bold]. Un descubrimiento reciente nos lleva a creer que la última pieza es [bold]{$C}[/bold].
cmu-paper-xeno-knowledge = El examen preliminar ha dado lugar a la hipótesis de que [bold]Cifrado[/bold] está relacionado de alguna forma con la especie de xenofauna DESIGNATION_PENDING.{"\u000a"} Los conocimientos actuales de la base de datos sobre DESIGNATION_PENDING indican que son formas de vida eusociales y parasitoides obligadas.{"\u000a"} Los datos obtenidos durante una misión de salvamento de 2122 y una operación del USCMC en 2179 indican que son extremadamente inteligentes y letales. {"\u000a"} Si se van a realizar pruebas, garantiza una contención reforzada y mantén preparados equipos de seguridad con armas automáticas y perforantes.
cmu-paper-xeno-sample-deliv =   {"\u000a"} Hemos autorizado la entrega de una muestra de DESIGNATION_PENDING al ascensor ASRS más cercano. {"\u000a"} Nota bene: las muestras de especímenes DESIGNATION_PENDING son muy escasas. [bold]No[/bold] la pierdas.
cmu-paper-ciph-hint-footer = - [italic]Weyland-Yutani[/italic]

research-chem-terminal-update = ¡Se han actualizado los contratos químicos!

research-data-ui-clearance = [color=#ffbf00][head=2]Nivel de autorización {$NUM}[/head][/color]
research-data-ui-credits = [color=#ffbf00][head=2]Créditos disponibles: {$NUM}[/head][/color]

research-data-ui-manage = Gestionar investigación
research-data-ui-view = Ver sustancias químicas

research-data-ui-chem-name = [color=#ffbf00][head=3]{$NAME}[/head][/color]

research-data-ui-diff-hard = Difícil
research-data-ui-diff-inter = Intermedia
research-data-ui-diff-easy = Fácil

research-data-ui-chem-difficulty = [color=#ffbf00][head=3]Dificultad: {$DIFF}[/head][/color]

research-data-ui-chem-desc = [color=#ffbf00]La evaluación inicial indica que una parte de la receta es {$RECIHINT}{"\u000a"}Las primeras pruebas muestran la propiedad {$PROPHINT}[/color]

research-data-ui-time-left = [color=#ffbf00]Los contratos se renuevan en: {$TIME}[/color]

research-data-ui-chem-take = [color=#ffbf00][head=3]Aceptar contrato[/head][/color]

research-data-synthesis-name = Síntesis de {$NAME}

research-data-contract-name = Contrato de {$NAME}

research-data-ui-analysis-scan = [color=#ffbf00][bold]Análisis[/bold][/color]
research-data-ui-analysis-sim = [color=#ffbf00][bold]Simulación[/bold][/color]
research-data-ui-compound-idx = [color=#ffbf00][bold]{$NAME}[/bold][/color]

research-data-ui-scan-time = [color=#ffbf00][bold]Tiempo de escaneo[/bold][/color]
research-data-ui-vc-type = [color=#ffbf00][bold]Tipo[/bold][/color]
research-data-ui-compound = [color=#ffbf00][bold]Compuesto[/bold][/color]
research-data-ui-actions = [color=#ffbf00][bold]Acciones[/bold][/color]

research-data-ui-reprint = [color=#ffbf00][head=3]Reimprimir último contrato[/head][/color]
research-data-ui-contracts = [color=#ffbf00][head=3]Contratos químicos[/head][/color]
research-data-ui-scan-time-idx = [color=#ffbf00][bold]{$TIME}[/bold][/color]
research-data-ui-improve = [color=#ffbf00][head=3]Mejorar: {$NUM} CR[/head][/color]
ui-research-data-terminal-name = Terminal de datos de investigación

research-data-ui-read = [color=#ffbf00][bold]Leer[/bold][/color]
research-data-ui-print = [color=#ffbf00][bold]Imprimir[/bold][/color]

ui-chem-simulator-window-name = Simulador químico

research-sim-ui-credits = [bold]CRÉDITOS DE INVESTIGACIÓN: {$NUM}[/bold]
research-sim-ui-cost-null = COSTE ESTIMADO DE LA SIMULACIÓN: NULO
research-sim-ui-cost = COSTE ESTIMADO DE LA SIMULACIÓN: {$NUM}
research-sim-ui-target-name = NOMBRE DEL OBJETIVO: {$NAME}
research-sim-ui-ref-name = NOMBRE DE REFERENCIA: {$NAME}
research-sim-ui-no-targ-chem = NOMBRE DEL OBJETIVO: DATOS QUÍMICOS NO INTRODUCIDOS
research-sim-ui-no-ref-chem = NOMBRE DE REFERENCIA: DATOS QUÍMICOS NO INTRODUCIDOS
research-sim-ui-overdose = NIVEL DE SOBREDOSIS TRAS LA SIMULACIÓN: {$NUM}
research-sim-ui-no-overdose = NIVEL DE SOBREDOSIS TRAS LA SIMULACIÓN:

research-sim-ui-simulate = SIMULAR
research-sim-ui-eject-targ = EXPULSAR OBJETIVO
research-sim-ui-eject-ref = EXPULSAR REFERENCIA
research-sim-ui-override = ANULAR
research-sim-ui-override-tooltip = Desactiva la protección al relacionar propiedades incompatibles.
research-sim-ui-amplify = AMPLIFICAR
research-sim-ui-amplify-tooltip = Amplifica un nivel la propiedad elegida. Esta operación reduce el nivel de OD.
research-sim-ui-suppress = SUPRIMIR
research-sim-ui-suppress-tooltip = Suprime un nivel de la propiedad elegida. Esta operación reduce el nivel de OD.
research-sim-ui-relate = RELACIONAR
research-sim-ui-relate-tooltip = Usa la sustancia química de referencia para reemplazar una propiedad elegida de la sustancia objetivo. El nivel de esa propiedad debe ser igual en el objetivo y en la referencia. Esta operación reduce el nivel de OD.
research-sim-ui-add = AÑADIR
research-sim-ui-add-tooltip = Usa una propiedad de la sustancia de referencia para añadirla a la sustancia objetivo sin consecuencias negativas para esta última. Sin embargo, daña la estructura de la sustancia de referencia e impide cualquier otra modificación.

research-sim-ui-no-data = [color=black][bold]¡No se han introducido datos![/bold][/color]

research-sim-ui-target-data = [head=3]Datos del objetivo[/head]
research-sim-ui-reference-data = [head=3]Datos de referencia[/head]
research-sim-ui-price = [bold]Precio de la operación: {$COST}[/bold]

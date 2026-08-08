anprc-window-title = Radio táctica AN/PRC-117G

anprc-transmit-hint-header = TRANSMITIR
anprc-transmit-hint-active = :r transmite en la presintonía activa

anprc-power-off-button = APAGAR
anprc-power-on-button = ENCENDER

anprc-status-equipped = EQUIPADA
anprc-status-unequipped = NO EQUIPADA
anprc-status-on = ENCENDIDA
anprc-status-off = APAGADA

anprc-slot-empty-display = SIN CANAL


anprc-radio-off = La radio no emite ningún sonido. Está apagada.
anprc-not-authorized = La radio chasquea. No tienes formación para manejar este equipo.
anprc-no-active-slot = No hay ninguna presintonía activa. Añade primero una red.
anprc-slot-empty = La presintonía { $slot } no tiene ningún canal asignado.
anprc-no-tower = Estática. { $channel } necesita una torre de comunicaciones o un relé de un RTO cualificado.
anprc-not-rto-warning = No tienes formación para usar esta radio. No retransmitirá ninguna red mientras la lleves a la espalda y no podrás transmitir.
anprc-verb-open = Abrir panel de la radio
anprc-out-of-range = Estática. No hay ningún relé al alcance en { $channel }.

anprc-frequency-invalid = Formato de frecuencia no válido. Introduce un número como 1606 o 1.606.
anprc-frequency-out-of-band = No se puede establecer una red ahí. Las frecuencias directas deben estar entre 1.000 y 2.999 MHz o en la banda softwave de 30.000 a 87.999.
anprc-frequency-not-found = No se encontró ningún canal en la frecuencia { $freq }.
anprc-frequency-set = [{ $slot }] sintonizada en { $freq } MHz.
anprc-frequency-set-net = [{ $slot }] sintonizada en { $freq } MHz: conectada a la red { $channel }.
anprc-frequency-set-unknown = [{ $slot }] sintonizada en { $freq } MHz: red sin identificar. Se registrará el tráfico.
anprc-frequency-set-dynamic = [{ $slot }] establecida en { $freq } MHz (frecuencia directa): no hay ninguna red asignada. Transmite con :r.

anprc-slot-max-reached = Se ha alcanzado el máximo de presintonías (4). Elimina primero una.

anprc-monitor-no-transmit = MONITOR ACTIVO: la radio está en modo de solo recepción. Desactiva MON para transmitir.

anprc-ct-mode-no-fill = MODO CT: se requiere una carga criptográfica para transmitir. Carga primero las claves COMSEC.

anprc-scan-switched = ESCANEO: tráfico en [{ $label }] (P{ $slot } · { $channel }). Se ha cambiado la red activa.

anprc-squelch-suppressed = *silenciador*

anprc-crypto-not-equipped = Debes llevar puesta la radio para cargar las claves criptográficas.
anprc-crypto-already-loaded = Ya está cargada: { $designation }. Primero ponla a cero.
anprc-crypto-loaded = { $designation } cargada. Transmisiones cifradas.
anprc-crypto-zeroized = { $designation } puesta a cero. Transmisiones sin proteger.
anprc-crypto-destroyed = { $designation } destruida físicamente. No se puede recuperar la carga.
anprc-crypto-no-card = No hay ninguna carga criptográfica.
anprc-crypto-wrong-faction = Este dispositivo de claves no es compatible con tu radio.
anprc-crypto-examine-empty = No hay ninguna carga criptográfica. Transmisiones sin proteger.
anprc-crypto-examine-loaded = { $designation } cargada ({ $faction }).
anprc-crypto-examine-stale = { $designation } cargada ({ $faction }): SUSTITUIDA, ya no protege el tráfico.

anprc-comsec-unsecured = ADVERTENCIA COMSEC: transmitiendo en { $channel } ({ $faction }) sin carga criptográfica. Todas las partes pueden leer el tráfico.

anprc-recrypto-no-card = No hay ninguna tarjeta de claves válida. Inserta primero la tarjeta de tu facción.
anprc-recrypto-stale-card = Esta tarjeta ya ha sido sustituida. Inserta una tarjeta vigente para ordenar un recifrado.
anprc-recrypto-foreign-card = CAMBIO DENEGADO: la carga instalada no coincide con la autoridad emisora de esta radio.
anprc-recrypto-ordered = CAMBIO COMSEC ORDENADO: todas las tarjetas de claves de { $faction } emitidas antes de esta orden quedan sustituidas. Solicita una carga de reemplazo por el canal de reabastecimiento habitual.
anprc-recrypto-not-authorized = CAMBIO DENEGADO: el recifrado requiere autorización COMSEC del mando.
anprc-recrypto-button = ORDENAR RECIFRADO: SUSTITUIR CARGA DE LA FACCIÓN
anprc-recrypto-button-confirm = PULSA DE NUEVO PARA CONFIRMAR: SUSTITUYE TODAS LAS CARGAS DE LA FACCIÓN
anprc-recrypto-superseded-notice = CAMBIO COMSEC: la carga instalada ha sido sustituida. Solicita una carga de reemplazo.

anprc-battery-depleted = La radio no tiene carga. Inserta una batería.
anprc-battery-empty = La AN/PRC-117G se apaga: batería agotada.
anprc-battery-insufficient = La batería no tiene suficiente carga para transmitir.

anprc-unknown-station = ESTACIÓN DESCONOCIDA
anprc-radio-check-call = TODAS LAS ESTACIONES, AQUÍ { $station }, CONTROL DE RADIO, CAMBIO.
anprc-radio-check-report = RESPUESTAS AL CONTROL DE RADIO: LIMA CHARLIE: { $clear } | DÉBIL PERO LEGIBLE: { $degraded }
anprc-radio-check-nothing-heard = NO SE OYE NADA
anprc-radio-check-interference = INTERFERENCIAS EN LA RED: rumbo del emisor más potente { $bearing }.

anprc-verb-plant = Instalar retransmisor
anprc-verb-packup = Recoger radio
anprc-retrans-planted = La radio queda anclada y se activa como estación retransmisora desatendida.
anprc-retrans-packed = La estación retransmisora se pliega y vuelve a convertirse en una radio de mochila.
anprc-retrans-pickup-blocked = Está anclada como estación retransmisora. Recógela primero.

anprc-verb-handset = Tomar auricular
anprc-verb-handset-release = Colgar auricular
anprc-handset-taken = Tomas el auricular con cable de { $radio }.
anprc-handset-released = Vuelves a colgar el auricular en { $radio }.
anprc-handset-in-use = Alguien ya está usando ese auricular.
anprc-handset-hands-full = Necesitas una mano libre para tomar el auricular.
anprc-handset-cord = El cable te arranca el auricular de la mano cuando te alejas.
anprc-handset-radio-gone = El auricular deja de funcionar.
anprc-handset-hint = Mientras sostienes el auricular, al hablar transmites por la red activa de la mochila. Susurra para no salir al aire.

# search receiver
anprc-sweep-started = El equipo abandona la red y empieza a barrer la banda. No oirás ni transmitirás nada hasta que lo detengas.
anprc-sweep-needs-online = El equipo debe estar encendido y equipado para buscar.
anprc-sweep-aborted = La búsqueda se detiene al apagarse el equipo.
anprc-sweep-aborted-power = La batería se agota y la búsqueda se detiene.
anprc-sweep-tx-blocked = El equipo está buscando en la banda. Detén la búsqueda antes de transmitir.
anprc-sweep-contact = La búsqueda se estrecha. Hay algo transmitiendo en { $freq } MHz.
anprc-sweep-resolved = LOCALIZADA: { $freq } MHz - { $net }.
anprc-sweep-unknown-net = RED SIN IDENTIFICAR

# net log to paper
anprc-log-print-empty = No hay nada en el registro que merezca anotarse.
anprc-log-printed = Transcribes { $count } entradas del registro en el papel.

# Documentos impresos de AN/PRC
cmu-anprc-paper-intercept-log-title = [head=2]REGISTRO DE INTERCEPTACIONES[/head]
cmu-anprc-paper-net-log-title = [head=2]REGISTRO DE RED[/head]
cmu-anprc-paper-unknown-station = ESTACIÓN DESCONOCIDA
cmu-anprc-paper-station = [bold]ESTACIÓN:[/bold] { $station }
cmu-anprc-paper-entries = [bold]ENTRADAS:[/bold] { $count }
cmu-anprc-paper-intercept-marker = [bold](INTERCEPTACIÓN)[/bold]
cmu-anprc-paper-log-footer = [italic]Transcrito de un registro de red AN/PRC-117G. Las horas corresponden al reloj configurado, no a la hora local.[/italic]

cmu-anprc-paper-soi-title = [head=2]INSTRUCCIONES DE OPERACIÓN DE SEÑALES[/head]
cmu-anprc-paper-frequency-assignments-title = [head=3]ASIGNACIONES DE FRECUENCIAS DE RED AN/PRC-117G[/head]
cmu-anprc-paper-frequency-instructions = Introduce una frecuencia en la pestaña FREQ del panel de la radio, con o sin punto (2592 y 2.592 son equivalentes), para asignar la red correspondiente a una presintonía.
cmu-anprc-paper-comsec-notice = [italic]AVISO COMSEC: esta tarjeta es un documento controlado. Destrúyela antes de que sea capturada. Las frecuencias se asignan para cada operación y caducan al finalizarla.[/italic]

# Interfaz AN/PRC-117G derivada de sus consumidores XAML y C#
cmu-anprc-ui-add = AÑADIR
cmu-anprc-ui-add-net = + AÑADIR RED
cmu-anprc-ui-all-nets = TODAS LAS REDES
cmu-anprc-ui-anchor = ANCLA
cmu-anprc-ui-anchor-active = ANCLA: ACTIVA
cmu-anprc-ui-anchor-offline = ANCLA: FUERA DE LÍNEA
cmu-anprc-ui-anchor-standby = ANCLA: ESPERA
cmu-anprc-ui-antenna = ANT: { $antenna }
cmu-anprc-ui-antenna-placeholder = ANT: ---
cmu-anprc-ui-band = BANDA: { $band }
cmu-anprc-ui-band-idle = BANDA INACTIVA
cmu-anprc-ui-band-placeholder = BANDA: ---
cmu-anprc-ui-bit-no-net = BIT: SIN RED
cmu-anprc-ui-bit-not-seated = BIT: SIN INSTALAR
cmu-anprc-ui-bit-offline = BIT: FUERA DE LÍNEA
cmu-anprc-ui-bit-pass = BIT: CORRECTO
cmu-anprc-ui-bypass-armed = DESVÍO: ARMADO
cmu-anprc-ui-bypass-no = DESVÍO: NO
cmu-anprc-ui-callsign = INDICATIVO
cmu-anprc-ui-callsign-auto = { $callsign } (AUTO)
cmu-anprc-ui-callsign-directory = DIRECTORIO DE INDICATIVOS
cmu-anprc-ui-callsign-help = Indicativo de estación. Vacío = indicativo asignado (AUTO). FIJAR vacío lo borra.
cmu-anprc-ui-callsign-placeholder = Máx. 16 caracteres (p. ej., LIMA-6)
cmu-anprc-ui-cancel = CANCELAR
cmu-anprc-ui-channel = CANAL: { $channel }
cmu-anprc-ui-channel-placeholder = CANAL: ---
cmu-anprc-ui-clear = BORRAR
cmu-anprc-ui-clear-short = BORR.
cmu-anprc-ui-close = CERRAR
cmu-anprc-ui-contact = { $frequency } MHz · { $name }
cmu-anprc-ui-contact-own-net = { $frequency } MHz · { $name } · RED PROPIA
cmu-anprc-ui-contact-partial = ~{ $frequency } MHz · PARCIAL { $tier }/{ $maximum }
cmu-anprc-ui-contacts = CONTACTOS
cmu-anprc-ui-delete-short = ELIM.
cmu-anprc-ui-destroy = DESTRUIR
cmu-anprc-ui-direct-frequency = FREC. DIRECTA
cmu-anprc-ui-direct-net = DIRECTA { $frequency }
cmu-anprc-ui-empty = --- VACÍA ---
cmu-anprc-ui-entry-count =
    { $count ->
        [one] { $count } entrada
       *[other] { $count } entradas
    }
cmu-anprc-ui-equipped = EQUIPADA
cmu-anprc-ui-fault-no-net = FALLO: SIN RED
cmu-anprc-ui-fault-none = FALLO: NINGUNO
cmu-anprc-ui-fault-not-worn = FALLO: NO EQUIPADA
cmu-anprc-ui-fault-off = FALLO: APAGADA
cmu-anprc-ui-fill-loaded = CARGA: { $designation } ({ $faction })
cmu-anprc-ui-fill-none = CARGA: NINGUNA - inserta una tarjeta de claves
cmu-anprc-ui-fill-superseded = CARGA: { $designation } ({ $faction }) - SUSTITUIDA, SE REQUIERE RECIFRADO
cmu-anprc-ui-filtered-entry-count =
    { $total ->
        [one] { $shown }/{ $total } entrada
       *[other] { $shown }/{ $total } entradas
    }
cmu-anprc-ui-footer-status = { $placement } · { $power } · { $net }
cmu-anprc-ui-frequency = FREC.: { $frequency }
cmu-anprc-ui-frequency-direct = { $frequency } MHz · DIRECTA
cmu-anprc-ui-frequency-placeholder = p. ej., 1606 o 1.606
cmu-anprc-ui-frequency-short = FREC.
cmu-anprc-ui-frequency-unknown-net = { $frequency } MHz · RED SIN IDENTIFICAR
cmu-anprc-ui-idle = INACTIVA
cmu-anprc-ui-link-no-net = ENLACE: SIN RED
cmu-anprc-ui-link-not-worn = ENLACE: NO EQUIPADA
cmu-anprc-ui-link-placeholder = ENLACE: ---
cmu-anprc-ui-link-ready = ENLACE: LISTO
cmu-anprc-ui-link-retrans = ENLACE: RETRANSM.
cmu-anprc-ui-link-standby = ENLACE: ESPERA
cmu-anprc-ui-log-entry = [{ $time }] { $sender } · { $channel }
cmu-anprc-ui-log-entry-intercept = [{ $time }] { $sender } · { $channel } · INTERCEPCIÓN
cmu-anprc-ui-log-filter-placeholder = Filtrar remitente / texto
cmu-anprc-ui-mode = MODO: { $mode }
cmu-anprc-ui-mode-button = MODO { $mode }
cmu-anprc-ui-mode-button-fh = MODO FH
cmu-anprc-ui-mode-fh = MODO: FH
cmu-anprc-ui-monitor-off = MON DESACT.
cmu-anprc-ui-monitor-on = MON ACT.
cmu-anprc-ui-monitor-short = MON
cmu-anprc-ui-net = RED
cmu-anprc-ui-net-label-placeholder = Máx. 8 caracteres (p. ej., CMD)
cmu-anprc-ui-net-list-entry = { $name }  -  { $frequency } MHz
cmu-anprc-ui-net-list-intercept = { $name }  -  { $frequency } MHz · INTERCEPCIÓN
cmu-anprc-ui-net-log = REGISTRO DE RED
cmu-anprc-ui-nets-dropped = REDES DESCONECTADAS · TX INHIBIDA
cmu-anprc-ui-new-net-label = ETIQUETA DE RED NUEVA:
cmu-anprc-ui-no-cell = SIN BATERÍA
cmu-anprc-ui-no-contacts = SIN CONTACTOS
cmu-anprc-ui-no-filter-matches = NINGUNA ENTRADA COINCIDE CON EL FILTRO
cmu-anprc-ui-no-net = SIN RED
cmu-anprc-ui-no-net-loaded = NINGUNA RED CARGADA
cmu-anprc-ui-no-net-sentence = Sin red
cmu-anprc-ui-no-slot-active = NINGUNA PRESINTONÍA ACTIVA
cmu-anprc-ui-not-set = SIN ESTABLECER
cmu-anprc-ui-off = APAGADA
cmu-anprc-ui-offline = FUERA DE LÍNEA
cmu-anprc-ui-on = ENCENDIDA
cmu-anprc-ui-planted = INSTALADA
cmu-anprc-ui-power-high = ALTA
cmu-anprc-ui-power-low = BAJA
cmu-anprc-ui-power-medium = MEDIA
cmu-anprc-ui-power-off = ALIM.: APAG.
cmu-anprc-ui-power-on = ALIM.: ENC.
cmu-anprc-ui-power-placeholder = ALIM.: ---
cmu-anprc-ui-preset-nets = REDES PRESINTONIZADAS
cmu-anprc-ui-presets = PRESINTONÍAS
cmu-anprc-ui-print-intercepts = IMPRIMIR INTERCEPCIONES
cmu-anprc-ui-print-log = IMPRIMIR REGISTRO
cmu-anprc-ui-radio-check = CONTROL DE RADIO
cmu-anprc-ui-relay = RELÉ
cmu-anprc-ui-retrans-station = ESTACIÓN RETRANSMISORA
cmu-anprc-ui-role = FUNCIÓN
cmu-anprc-ui-rto-relay = RELÉ RTO
cmu-anprc-ui-scan-off = ESCANEO DESACT.
cmu-anprc-ui-scan-on = ESCANEO ACT.
cmu-anprc-ui-search = BÚSQUEDA
cmu-anprc-ui-search-head = POSICIÓN: { $frequency } MHz
cmu-anprc-ui-search-warning = La búsqueda desconecta todas las redes y bloquea la transmisión.
cmu-anprc-ui-searching = BUSCANDO
cmu-anprc-ui-secured = PROTEGIDA ({ $designation })
cmu-anprc-ui-set = FIJAR
cmu-anprc-ui-signal-short = SEÑ
cmu-anprc-ui-slot-empty = PRESINTONÍA VACÍA
cmu-anprc-ui-squelch = SQL { $level }
cmu-anprc-ui-stale = SUSTITUIDA ({ $designation })
cmu-anprc-ui-standby = ESPERA
cmu-anprc-ui-start-search = INICIAR BÚSQUEDA
cmu-anprc-ui-stop-search = DETENER BÚSQUEDA
cmu-anprc-ui-subtitle = RELÉ RTO DE MOCHILA
cmu-anprc-ui-transmit-hint = :r transmite por la red seleccionada.
cmu-anprc-ui-transmit-power = TX { $power }
cmu-anprc-ui-tune = SINTONIZAR
cmu-anprc-ui-tune-slot = SINTONIZAR PRESINTONÍA:
cmu-anprc-ui-tune-slot-label = SINTONIZAR [{ $label }]:
cmu-anprc-ui-unequipped = NO EQUIPADA
cmu-anprc-ui-unknown-station = ESTACIÓN DESCONOCIDA
cmu-anprc-ui-unsecured = SIN PROTEGER
cmu-anprc-ui-waveform = ONDA: { $waveform }
cmu-anprc-ui-waveform-los = ONDA: LOS
cmu-anprc-ui-waveform-placeholder = ONDA: ---
cmu-anprc-ui-zero-entries = 0 entradas
cmu-anprc-ui-zeroize = PONER A CERO


# Cadenas de UX de cirugía V2-β.
# - Encabezado/indicación de la ventana
# - Línea de estado del paso preparado
# - Mensajes de herramienta incorrecta, parte incorrecta o falta de herramienta
# - Nombres de categorías de herramientas (categorías del resolutor de SharedCMUSurgeryFlowSystem)
# - Etiquetas de cada paso para las 19 cirugías V1 de CMU

# ---- Controles de la ventana -----------------------------------------

cmu-medical-surgery-window-title = Procedimiento quirúrgico
cmu-medical-surgery-window-hint = Elige una parte del cuerpo y una cirugía; después, haz clic en el paciente con la herramienta necesaria.
cmu-medical-surgery-no-eligible = No hay cirugías disponibles aquí.
cmu-medical-surgery-section-patient = Paciente
cmu-medical-surgery-section-workflow = Flujo de trabajo
cmu-medical-surgery-workflow-ready = No hay ningún procedimiento activo seleccionado.
cmu-medical-surgery-workflow-active = { $surgery } activa en { $part }.
cmu-medical-surgery-section-parts = Partes del cuerpo
cmu-medical-surgery-section-surgeries = Cirugías
cmu-medical-surgery-section-surgeries-on = Cirugías en { $part }
cmu-medical-surgery-no-part-selected = Selecciona una parte del cuerpo.
cmu-medical-surgery-procedure-detail = { $step } / { $tool }
cmu-medical-surgery-arm-button = Iniciar cirugía
cmu-medical-surgery-cancel-armed = Cancelar cirugía
cmu-medical-surgery-step-hint = Paso { $step }/{ $total } — { $label } ({ $tool })
cmu-medical-surgery-step-hint-prereq = Paso previo { $step }/{ $total } — { $label } ({ $tool })
cmu-medical-surgery-armed-heading = PREPARADA

# ---- Panel destacado de procedimiento en curso ----------------------

cmu-medical-surgery-in-progress-heading = EN CURSO
cmu-medical-surgery-in-progress-subtitle = { $surgery } · { $part }
cmu-medical-surgery-in-progress-credit = Último paso por { $surgeon } · comenzó hace { $elapsed }
cmu-medical-surgery-step-now = Paso { $step }: { $label }
cmu-medical-surgery-action-hint = Haz clic en { $part } con { $tool }.
cmu-medical-surgery-action-hint-no-tool = Haz clic en { $part } para continuar.
cmu-medical-surgery-choose-next-heading = Elige la siguiente cirugía
cmu-medical-surgery-choose-next-hint = Continúa con otra reparación en esta parte abierta o ciérrala.
cmu-medical-surgery-continue-with-button = Continuar con { $surgery }
cmu-medical-surgery-close-up-button = Cerrar
cmu-medical-surgery-continue-button = Continuar cirugía
cmu-medical-surgery-abandon-button = Abandonar cirugía
cmu-medical-surgery-actions-heading = Acciones

# ---- Etiquetas de la sección de cada parte ---------------------------

cmu-medical-surgery-part-heading = { $part }
cmu-medical-surgery-part-condition-healthy = Sana
cmu-medical-surgery-part-condition-locked = Hay otra cirugía en curso en { $other } — termínala o abandónala primero
cmu-medical-surgery-part-condition-no-eligible = No hay cirugías disponibles

cmu-medical-surgery-condition-incision-open = Incisión abierta
cmu-medical-surgery-condition-ribcage-open = Caja torácica abierta
cmu-medical-surgery-condition-skull-open = Cráneo abierto
cmu-medical-surgery-condition-bones-open = Huesos abiertos
cmu-medical-surgery-condition-fracture = Fractura { $severity }
cmu-medical-surgery-condition-internal-bleed = Hemorragia interna
cmu-medical-surgery-condition-eschar = Escara
cmu-medical-surgery-condition-wounds = Heridas
cmu-medical-surgery-condition-damaged = Dañada
cmu-medical-surgery-condition-vascular-tear = Vaso desgarrado
cmu-medical-surgery-condition-embedded-foreign-body = Cuerpo extraño
cmu-medical-surgery-condition-compartment-pressure = Presión compartimental
cmu-medical-surgery-condition-contaminated-wound = Herida contaminada
cmu-medical-surgery-condition-bone-splinters = Astillas óseas
cmu-medical-surgery-condition-organ-adhesion = Adherencias del órgano
cmu-medical-surgery-condition-organ-hemorrhage = Hemorragia del órgano
cmu-medical-surgery-condition-in-progress = Cirugía en curso
cmu-medical-surgery-condition-missing = Amputada

# ---- Encabezados de categorías de la BUI -----------------------------

cmu-medical-surgery-category-fracture = Fractura
cmu-medical-surgery-category-bleed = Hemorragia interna
cmu-medical-surgery-category-burn = Quemaduras
cmu-medical-surgery-category-remove_organ = Extirpar órgano
cmu-medical-surgery-category-transplant = Trasplantar órgano
cmu-medical-surgery-category-suture = Suturar órgano
cmu-medical-surgery-category-head_organ = Cirugía de cabeza
cmu-medical-surgery-category-amputation = Amputar extremidad
cmu-medical-surgery-category-reattach = Reimplantar extremidad
cmu-medical-surgery-category-parasite = Extracción de parásito
cmu-medical-surgery-category-close_up = Cerrar
cmu-medical-surgery-category-general = Otras

# ---- Superficie de examen (CMUSurgeryStateExamineSystem) -------------

cmu-medical-surgery-examine-patient-in-progress = [color=#dca94c]{ $surgery } en curso (último paso por { $surgeon }) — siguiente: { $next }.[/color]
cmu-medical-surgery-examine-part-in-progress = [color=#dca94c]{ $surgery } en curso (último paso por { $surgeon }) — siguiente: { $next }.[/color]
cmu-medical-surgery-examine-part-abandoned = [color=#888888]Herida abierta — no hay ninguna cirugía en curso.[/color]

cmu-medical-surgery-examine-incision = [color=#888888]Hay una incisión quirúrgica en { $part }.[/color]
cmu-medical-surgery-examine-site-details = [color=#dca94c]{ $part }: { $access }; { $hemostasis }; paso actual: { $step }.[/color]
cmu-medical-surgery-examine-no-active-step = ningún procedimiento activo
cmu-medical-surgery-access-closed = cerrado
cmu-medical-surgery-access-incised = solo incisión
cmu-medical-surgery-access-shallow = acceso superficial
cmu-medical-surgery-access-bone-cut = hueso cortado, aún sin abrir
cmu-medical-surgery-access-deep = acceso profundo
cmu-medical-surgery-hemostasis-none = sin sangrado quirúrgico
cmu-medical-surgery-hemostasis-uncontrolled = sangrado quirúrgico sin controlar
cmu-medical-surgery-hemostasis-clamped = vasos sangrantes pinzados

# ---- Etiquetas de pasos de cierre (resolución alternativa de RMC) ----

cmu-medical-surgery-step-close-incision-label = Cerrar incisión
cmu-medical-surgery-step-mend-ribcage-label = Reparar caja torácica
cmu-medical-surgery-step-mend-skull-label = Reparar cráneo
cmu-medical-surgery-step-mend-bones-label = Reparar huesos
cmu-medical-surgery-step-close-bones-label = Cerrar huesos

# ---- Estado del paso preparado ---------------------------------------

cmu-medical-surgery-armed-none = (ninguna cirugía preparada)
cmu-medical-surgery-armed-step = Preparada: { $surgery } — Paso { $step } ({ $tool })
cmu-medical-surgery-armed-cancelled = Cirugía cancelada.
cmu-medical-surgery-armed-expired = La selección de cirugía agotó el tiempo de espera.
cmu-medical-surgery-auto-armed = Se seleccionó { $surgery }.
cmu-medical-surgery-ui-less-select-part = Selecciona una parte del cuerpo antes de usar una herramienta quirúrgica.
cmu-medical-surgery-ui-less-no-action = Esa herramienta no tiene ninguna acción clara en el sitio quirúrgico seleccionado.
cmu-medical-surgery-unclamped-closure = La incisión se cierra sobre un sangrado sin controlar, lo que provoca una hemorragia interna.
cmu-medical-surgery-amputation-cancelled = Taponas la incisión y cancelas la amputación pendiente.
cmu-medical-surgery-auto-continue = Continuando con { $surgery }.
cmu-medical-surgery-choose-repair-or-close = Elige una reparación de órgano o cierra al paciente.

# ---- Mensajes al hacer clic en el objetivo ---------------------------

cmu-medical-surgery-wrong-part = Esa no es la parte para la que preparaste la cirugía.
cmu-medical-surgery-wrong-tool = Esa no es la herramienta correcta para este paso.
cmu-medical-surgery-wrong-tool-damage = ¡Se te resbala { $tool }!
cmu-medical-surgery-improvised-mishap = La herramienta improvisada ({ $tool }) se resbala y causa un traumatismo adicional.
cmu-medical-surgery-step-failed = La operación sale mal y causa un traumatismo.
cmu-medical-surgery-step-failed-with-tool = { $tool } se resbala y causa un traumatismo quirúrgico.
cmu-medical-surgery-no-tool = Necesitas una herramienta quirúrgica para realizar este paso.
cmu-medical-surgery-missing-skills = No sabes cómo realizar este paso.
cmu-medical-surgery-cannot-start = Esa cirugía ya no está disponible.
cmu-medical-surgery-step-busy = Ya hay otra acción quirúrgica en curso sobre este paciente.
cmu-medical-surgery-needs-operating-table = Pon al paciente sobre una mesa de operaciones primero.
cmu-medical-surgery-remove-helmet = Quítale el casco primero.
cmu-medical-surgery-remove-armor = Quítale primero la armadura que estorba.
cmu-medical-surgery-wrong-limb = Esa extremidad no corresponde a ningún hueco libre del paciente.
cmu-medical-surgery-welder-not-lit = Enciende la herramienta primero.
cmu-medical-surgery-patient-not-lying = El paciente debe estar tumbado o sujeto a una mesa de operaciones.
cmu-medical-surgery-patient-not-controlled = El paciente necesita anestesia, analgésicos potentes o sujeciones antes de la cirugía.
cmu-medical-surgery-self-pain-control = Para operarte a ti mismo necesitas antes analgésicos potentes.
cmu-medical-surgery-self-not-secured = Sujétate a una silla, una cama o una camilla antes de intentar operarte a ti mismo.
cmu-medical-surgery-self-not-allowed = No puedes realizarte esa cirugía a ti mismo.
cmu-medical-surgery-step-pain-uncontrolled = El paciente siente demasiado dolor para continuar la cirugía. Usa anestesia o analgésicos potentes antes de volver a intentarlo.
cmu-medical-amputation-success = Se ha amputado la extremidad.

# ---- Nombres de categorías de herramientas (botón BUI + línea preparada) ----

cmu-medical-surgery-tool-category-scalpel = Bisturí
cmu-medical-surgery-tool-category-hemostat = Pinza hemostática
cmu-medical-surgery-tool-category-retractor = Separador
cmu-medical-surgery-tool-category-cautery = Cauterio
cmu-medical-surgery-tool-category-bone_saw = Sierra de huesos
cmu-medical-surgery-tool-category-bone_setter = Recolocador de huesos
cmu-medical-surgery-tool-category-bone_gel = Gel óseo
cmu-medical-surgery-tool-category-bone_graft = Injerto óseo
cmu-medical-surgery-tool-category-fix_o_vein = Fix-O-Vein
cmu-medical-surgery-tool-category-organ_clamp = Pinza para órganos
cmu-medical-surgery-tool-category-scalpel_or_burn_kit = Bisturí o botiquín para quemaduras
cmu-medical-surgery-tool-category-severed_limb = Extremidad compatible
cmu-medical-surgery-tool-category-blowtorch = Soldador encendido
cmu-medical-surgery-tool-category-cable_coil = Bobina de cable

# ---- Etiquetas de cada paso ------------------------------------------

cmu-medical-surgery-step-realign-simple-label = Realinear fractura simple
cmu-medical-surgery-step-realign-compound-label = Realinear fractura abierta
cmu-medical-surgery-step-realign-shattered-label = Realinear fractura conminuta
cmu-medical-surgery-step-apply-gel-label = Aplicar gel óseo
cmu-medical-surgery-step-apply-gel-second-label = Aplicar gel óseo (segunda capa)
cmu-medical-surgery-step-insert-graft-label = Insertar injerto óseo
cmu-medical-surgery-step-cauterize-bleed-label = Reparar hemorragia interna
cmu-medical-surgery-step-tie-vessel-label = Ligar vaso desgarrado
cmu-medical-surgery-step-extract-foreign-body-label = Extraer cuerpo extraño
cmu-medical-surgery-step-relieve-pressure-label = Aliviar presión compartimental
cmu-medical-surgery-step-debride-contamination-label = Desbridar tejido contaminado
cmu-medical-surgery-step-remove-bone-fragments-label = Retirar fragmentos óseos
cmu-medical-surgery-step-free-organ-adhesions-label = Liberar adherencias del órgano
cmu-medical-surgery-step-pack-organ-bleed-label = Taponar hemorragia del órgano
cmu-medical-surgery-step-clamp-liver-label = Pinzar vasos del hígado
cmu-medical-surgery-step-clamp-lungs-label = Pinzar vasos de los pulmones
cmu-medical-surgery-step-clamp-kidneys-label = Pinzar vasos de los riñones
cmu-medical-surgery-step-clamp-heart-label = Pinzar vasos del corazón
cmu-medical-surgery-step-clamp-stomach-label = Pinzar vasos del estómago
cmu-medical-surgery-step-extract-liver-label = Extraer hígado
cmu-medical-surgery-step-extract-lungs-label = Extraer pulmones
cmu-medical-surgery-step-extract-kidneys-label = Extraer riñones
cmu-medical-surgery-step-extract-heart-label = Extraer corazón
cmu-medical-surgery-step-extract-stomach-label = Extraer estómago
cmu-medical-surgery-step-reinsert-liver-label = Insertar hígado de reemplazo
cmu-medical-surgery-step-reinsert-lungs-label = Insertar pulmones de reemplazo
cmu-medical-surgery-step-reinsert-kidneys-label = Insertar riñones de reemplazo
cmu-medical-surgery-step-reinsert-stomach-label = Insertar estómago de reemplazo
cmu-medical-surgery-step-transplant-heart-label = Trasplantar corazón del donante
cmu-medical-surgery-step-suture-liver-label = Suturar hígado
cmu-medical-surgery-step-suture-lungs-label = Suturar pulmones
cmu-medical-surgery-step-suture-kidneys-label = Suturar riñones
cmu-medical-surgery-step-suture-heart-label = Suturar corazón
cmu-medical-surgery-step-suture-stomach-label = Suturar estómago
cmu-medical-surgery-step-amputate-limb-label = Amputar extremidad
cmu-medical-surgery-step-reattach-limb-label = Reimplantar extremidad amputada

# ---- Autodoc ---------------------------------------------------------

cmu-autodoc-window-title = Autodoc
cmu-autodoc-no-patient = Sin paciente
cmu-autodoc-status-no-pod = No hay ninguna cápsula de Autodoc vinculada cerca.
cmu-autodoc-status-empty = La cápsula vinculada está vacía.
cmu-autodoc-status-ready = Listo para poner en cola procedimientos automatizados.
cmu-autodoc-status-running = Ejecutando los procedimientos en cola.
cmu-autodoc-current-idle = Procedimiento actual: inactivo
cmu-autodoc-current-step = Procedimiento actual: { $step }
cmu-autodoc-current-step-timed = Procedimiento actual: { $step } ({ $time } restante)
cmu-autodoc-current-step-detail = { $surgery } / { $part } / { $step }
cmu-autodoc-start-button = Iniciar
cmu-autodoc-stop-button = Detener
cmu-autodoc-clear-button = Vaciar
cmu-autodoc-eject-button = Expulsar paciente
cmu-autodoc-remove-button = Retirar
cmu-autodoc-queue-button = Añadir a la cola
cmu-autodoc-queue-heading = Cola
cmu-autodoc-parts-heading = Partes
cmu-autodoc-surgeries-heading = Cirugías
cmu-autodoc-queue-empty = No hay procedimientos en cola.
cmu-autodoc-queue-summary = { $count } procedimiento(s) en cola
cmu-autodoc-available-procedures = { $count } procedimiento(s) disponible(s)
cmu-autodoc-part-procedures = { $count } procedimiento(s)
cmu-autodoc-surgery2-required = Se necesita formación en Cirugía 2 para poner en cola pasos del Autodoc.
cmu-autodoc-no-surgeries = No hay cirugías disponibles aquí.
cmu-autodoc-queue-row = #{ $index } { $surgery } en { $part } - { $step }
cmu-autodoc-surgery-row = { $surgery } - { $step }
cmu-autodoc-automated-step-label = Ciclo de reparación automatizado
cmu-autodoc-automated-step-note = El Autodoc repara este objetivo con un temporizador mecánico.
cmu-autodoc-repair-wounds-surgery = Reparar heridas/quemaduras
cmu-autodoc-procedure-time-note = Procedimiento automatizado de { $time }.
cmu-autodoc-minutes = { $minutes } min

# ---- Escáner corporal ------------------------------------------------

cmu-body-scanner-window-title = Escáner corporal
cmu-body-scanner-no-patient = Sin paciente
cmu-body-scanner-status-no-pod = No hay ninguna cápsula de escáner corporal vinculada cerca.
cmu-body-scanner-status-empty = La cápsula de escaneo vinculada está vacía.
cmu-body-scanner-status-ready = Escaneo del paciente listo.
cmu-body-scanner-status-no-skill = Se necesita formación en Cirugía 1 para completar los escaneos.
cmu-body-scanner-boost-active = Asistencia quirúrgica calibrada: { $time } restante.
cmu-body-scanner-boost-inactive = Asistencia quirúrgica sin calibrar.
cmu-body-scanner-scan-heading = Escaneo
cmu-body-scanner-terms-heading = Capas de corte
cmu-body-scanner-targets-heading = Lecturas de cortes activas
cmu-body-scanner-start-button = Iniciar calibración
cmu-body-scanner-reset-button = Restablecer calibración
cmu-body-scanner-eject-button = Expulsar paciente
cmu-body-scanner-surgery1-required = Se necesita formación en Cirugía 1 para realizar escaneos corporales.
cmu-body-scanner-no-scan-lines = No hay datos de escaneo.
cmu-body-scanner-diagnostic-summary = { $count } línea(s) de diagnóstico
cmu-body-scanner-match-summary = { $matched }/{ $required } fijadas, { $time } restante
cmu-body-scanner-match-summary-idle = { $matched }/{ $required } fijadas, sin iniciar
cmu-body-scanner-calibrated-summary = Calibrado, quedan { $time } de asistencia
cmu-body-scanner-calibrated-badge = CALIBRADO { $time }
cmu-body-scanner-calibration-ready = 2:00
cmu-body-scanner-lockout-summary = Corte activo bloqueado, { $time } restante
cmu-body-scanner-lockout-status = Corte activo bloqueado: { $time } restante.
cmu-body-scanner-lockout-detail = Falló la calibración. Espera a que termine el bloqueo.
cmu-body-scanner-no-surgical-targets = No se detectaron objetivos.
cmu-body-scanner-no-surgical-targets-detail = No se concedió ninguna bonificación.
cmu-body-scanner-calibration-heading = Escaneo de cortes anatómicos
cmu-body-scanner-sweep-title = Barrido estratificado del escáner
cmu-body-scanner-sweep-detail = Sintoniza un corte para empezar.
cmu-body-scanner-layer-selected = Corte sintonizado - { $locked }/{ $total } fijadas
cmu-body-scanner-layer-ready = { $locked }/{ $total } fijadas
cmu-body-scanner-layer-empty = No hay lecturas anómalas
cmu-body-scanner-signal-locked = Señal fijada
cmu-body-scanner-signal-ready = { $detail } - fijar en cian
cmu-body-scanner-start-status = Inicia la calibración para comenzar el escaneo de cortes.
cmu-body-scanner-ready-status = Sintoniza un corte y fija las lecturas anómalas mientras el barrido sea cian.
cmu-body-scanner-armed-status = Corte sintonizado: { $layer }. Fija las lecturas cuando el barrido entre en la zona cian.
cmu-body-scanner-penalty-status = Tiempo o corte incorrectos: -{ $seconds } s.
cmu-body-scanner-feedback-correct = Señal fijada.
cmu-body-scanner-feedback-wrong-timing = El barrido no pasó por la banda de captura: -{ $seconds } s.
cmu-body-scanner-feedback-wrong-layer = Interferencia de capa: -{ $seconds } s.
cmu-body-scanner-expired-status = Se agotó el tiempo. Restablece la calibración para reintentarlo.
cmu-body-scanner-complete-status = Todas las lecturas fijadas. Asistencia quirúrgica calibrada.
cmu-body-scanner-timer-active = TEMPORIZADOR DE CORTE ACTIVO
cmu-body-scanner-timer-expired = TEMPORIZADOR AGOTADO
cmu-body-scanner-timer-locked = CORTE BLOQUEADO
cmu-body-scanner-timer-detail = Fija las lecturas antes de que se cierre la ventana de escaneo.
cmu-body-scanner-no-layer-signals = No hay lecturas anómalas en { $layer }.
cmu-body-scanner-interference-title = Lectura sin resolver
cmu-body-scanner-interference-detail = Interferencia en { $layer }
cmu-body-scanner-decoy-ready = { $detail } - eco ruidoso
cmu-body-scanner-decoy-vitals-1 = Pico de eco cardíaco
cmu-body-scanner-decoy-vitals-2 = Destello de oxígeno en sangre
cmu-body-scanner-decoy-detail-vitals = artefacto vital transitorio
cmu-body-scanner-decoy-skeleton-1 = Sombra de fisura ósea
cmu-body-scanner-decoy-skeleton-2 = Espectro de alineación articular
cmu-body-scanner-decoy-detail-skeleton = silueta ósea inestable
cmu-body-scanner-decoy-organs-1 = Resplandor tenue de órgano
cmu-body-scanner-decoy-organs-2 = Reflejo de densidad
cmu-body-scanner-decoy-detail-organs = densidad orgánica incoherente
cmu-body-scanner-decoy-tissue-1 = Destello de tejido superficial
cmu-body-scanner-decoy-tissue-2 = Banda de ruido vascular
cmu-body-scanner-decoy-detail-tissue = retorno ruidoso de tejidos blandos
cmu-body-scanner-triage-stable = Lectura estable
cmu-body-scanner-triage-serious = Hallazgos graves
cmu-body-scanner-triage-critical = Hallazgos críticos
cmu-body-scanner-triage-clear = No hay hallazgos anómalos inmediatos.
cmu-body-scanner-health-stable = Estable
cmu-body-scanner-health-damaged = Dañado
cmu-body-scanner-health-critical = Crítico
cmu-body-scanner-section-vitals = Constantes vitales
cmu-body-scanner-section-body = Cuerpo
cmu-body-scanner-section-organs = Órganos
cmu-body-scanner-term-assigned = { $term } -> { $target }
cmu-body-scanner-target-filled = { $target }: { $term }
cmu-body-scanner-line-state = Estado: { $state }
cmu-body-scanner-line-damage = Daño: total { $total } (físico { $brute }, quemadura { $burn })
cmu-body-scanner-line-blood = Sangre: { $blood } / { $max }
cmu-body-scanner-heart-stopped = Corazón: no se detecta actividad
cmu-body-scanner-heart-active = Corazón: { $bpm } lpm
cmu-body-scanner-line-no-data = No hay datos de diagnóstico disponibles.
cmu-body-scanner-line-part = { $part }: { $details }
cmu-body-scanner-part-health = PV { $current } / { $max }
cmu-body-scanner-part-wounds = { $count } herida(s) sin tratar
cmu-body-scanner-part-fracture = Fractura { $severity }
cmu-body-scanner-part-bleed = hemorragia interna { $rate }/s
cmu-body-scanner-part-eschar = escara
cmu-body-scanner-part-splinted = entablillada
cmu-body-scanner-part-cast = escayolada
cmu-body-scanner-part-tourniquet = con torniquete
cmu-body-scanner-part-missing-limb = extremidad ausente/amputada
cmu-body-scanner-line-organ = { $organ }: { $stage } ({ $current } / { $max })
cmu-body-scanner-line-missing-organ = Falta { $organ } en { $part }
cmu-body-scanner-title-state = Estado
cmu-body-scanner-title-damage = Daño
cmu-body-scanner-title-blood = Sangre
cmu-body-scanner-title-heart = Corazón
cmu-body-scanner-title-no-data = Diagnóstico
cmu-body-scanner-title-missing-organ = Falta { $organ }
cmu-body-scanner-detail-damage = total { $total } (físico { $brute }, quemadura { $burn })
cmu-body-scanner-detail-blood = { $blood } / { $max }
cmu-body-scanner-detail-heart-stopped = no se detecta actividad
cmu-body-scanner-detail-heart-active = { $bpm } lpm
cmu-body-scanner-detail-no-data = No hay datos de diagnóstico disponibles.
cmu-body-scanner-detail-organ = { $stage } ({ $current } / { $max })
cmu-body-scanner-detail-missing-organ = en { $part }
cmu-body-scanner-signal-heart-stopped = Corazón: no se detecta actividad
cmu-body-scanner-signal-organ-damage = { $organ }: daño orgánico { $stage }
cmu-body-scanner-signal-low-blood = Volumen sanguíneo bajo: { $blood } / { $max }
cmu-body-scanner-signal-internal-bleed = { $part }: hemorragia interna { $rate }/s
cmu-body-scanner-signal-fracture = { $part }: fractura { $severity }
cmu-body-scanner-signal-wounds = { $part }: { $count } herida(s) sin tratar
cmu-body-scanner-signal-trauma = { $part }: traumatismo tisular { $current } / { $max }
cmu-body-scanner-signal-missing-organ = Falta { $organ } en { $part }
cmu-body-scanner-signal-missing-limb = { $part }: extremidad ausente/amputada
cmu-body-scanner-slice-detail-cardiac = ritmo cardíaco
cmu-body-scanner-slice-detail-organ = densidad del órgano
cmu-body-scanner-slice-detail-blood = volumen sanguíneo
cmu-body-scanner-slice-detail-bleed = flujo tisular
cmu-body-scanner-slice-detail-fracture = alineación ósea
cmu-body-scanner-slice-detail-wound = alteración tisular
cmu-body-scanner-slice-detail-trauma = densidad de tejidos blandos
cmu-body-scanner-slice-detail-missing-organ = silueta del órgano
cmu-body-scanner-slice-detail-missing-limb = silueta de la extremidad

cmu-limb-printer-window-title = Impresora de extremidades
cmu-limb-printer-header = Fabricación de extremidades
cmu-limb-printer-matrix-heading = Matriz de síntesis
cmu-limb-printer-blood-heading = Plantilla sanguínea
cmu-limb-printer-metal-heading = Reserva de armazones robóticos
cmu-limb-printer-metal-type = Láminas de metal
cmu-limb-printer-no-beaker = No hay ningún vaso de precipitados con matriz introducido.
cmu-limb-printer-no-syringe = No hay ninguna jeringa de sangre introducida.
cmu-limb-printer-no-metal = No hay láminas de metal introducidas.
cmu-limb-printer-fluid-amount = { $current } / { $max }u
cmu-limb-printer-stack-amount = { $current } / { $max }
cmu-limb-printer-matrix-cost = { $cost }u de matriz por impresión
cmu-limb-printer-blood-cost = { $cost }u de sangre por impresión
cmu-limb-printer-metal-cost = { $cost } láminas por impresión robótica
cmu-limb-printer-remove-beaker = Retirar vaso
cmu-limb-printer-remove-syringe = Retirar jeringa
cmu-limb-printer-remove-metal = Retirar metal
cmu-limb-printer-left-heading = Izquierda
cmu-limb-printer-right-heading = Derecha
cmu-limb-printer-print-ready = Lista para imprimir
cmu-limb-printer-status-ready = Lista para sintetizar.
cmu-limb-printer-missing-beaker = Introduce un vaso de precipitados con matriz biogénica.
cmu-limb-printer-missing-matrix = No hay suficiente matriz biogénica.
cmu-limb-printer-missing-syringe = Introduce una jeringa con sangre del paciente.
cmu-limb-printer-missing-blood = No hay suficiente sangre del paciente en la muestra.
cmu-limb-printer-missing-metal-slot = Introduce láminas de metal.
cmu-limb-printer-missing-metal = No hay suficientes láminas de metal.
cmu-limb-printer-wrong-metal = Introduce láminas de metal, no acero base.
cmu-limb-printer-printed = Se imprimió { $limb }.
cmu-limb-printer-left-arm = Brazo izquierdo
cmu-limb-printer-left-hand = Mano izquierda
cmu-limb-printer-left-leg = Pierna izquierda
cmu-limb-printer-left-foot = Pie izquierdo
cmu-limb-printer-right-arm = Brazo derecho
cmu-limb-printer-right-hand = Mano derecha
cmu-limb-printer-right-leg = Pierna derecha
cmu-limb-printer-right-foot = Pie derecho
cmu-limb-printer-left-robotic-arm = Brazo robótico izquierdo
cmu-limb-printer-left-robotic-hand = Mano robótica izquierda
cmu-limb-printer-left-robotic-leg = Pierna robótica izquierda
cmu-limb-printer-left-robotic-foot = Pie robótico izquierdo
cmu-limb-printer-right-robotic-arm = Brazo robótico derecho
cmu-limb-printer-right-robotic-hand = Mano robótica derecha
cmu-limb-printer-right-robotic-leg = Pierna robótica derecha
cmu-limb-printer-right-robotic-foot = Pie robótico derecho
cmu-limb-printer-slot-beaker = vaso de matriz
cmu-limb-printer-slot-syringe = jeringa de sangre
cmu-limb-printer-slot-metal = Láminas de metal

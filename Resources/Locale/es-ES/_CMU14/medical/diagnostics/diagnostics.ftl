cmu-medical-scanner-body-map-header        = Mapa corporal
cmu-medical-scanner-pulse-label            = Pulso:
cmu-medical-scanner-body-parts-header      = Partes del cuerpo
cmu-medical-scanner-organs-header          = Órganos
cmu-medical-scanner-fractures-header       = Fracturas
cmu-medical-scanner-bleeds-header          = Hemorragias internas
cmu-medical-scanner-pulse-stopped          = [color=red][bold]Sin pulso — corazón detenido[/bold][/color]
cmu-medical-scanner-pulse-bpm              = { $bpm } LPM
cmu-medical-scanner-part-line              = { $part }: { $current }/{ $max } PV
cmu-medical-scanner-part-suffix-splinted   = (entablillada)
cmu-medical-scanner-part-suffix-cast       = (escayolada)
cmu-medical-scanner-part-suffix-wounds     = ({ $count } herida{ $count ->
    [one] {""}
   *[other] s
})
cmu-medical-scanner-organ-line             = { $organ }: { $stage } ({ $current }/{ $max })
cmu-medical-scanner-organ-removed          = { $organ }: [color=red]EXTIRPADO[/color]
cmu-medical-scanner-fracture-line-exact    = { $part }: fractura { $severity }
cmu-medical-scanner-fracture-line-vague    = { $part }: fractura detectada
cmu-medical-scanner-fracture-suppressed    = (suprimida)
cmu-medical-scanner-bleed-exact            = { $part }: { $rate } pérdida de sangre/s
cmu-medical-scanner-bleed-vague            = Hemorragia interna detectada (ubicación desconocida)

cmu-medical-stethoscope-pulse              = Frecuencia cardíaca: { $bpm }.
cmu-medical-stethoscope-pulse-qualitative  = El pulso es { $description }.
cmu-medical-stethoscope-no-pulse           = No se detectan latidos.
cmu-medical-stethoscope-no-heart           = No hay ningún corazón en el pecho del paciente.
cmu-medical-stethoscope-lungs-precise      = Pulmones: { $stage }.
cmu-medical-stethoscope-lungs-qualitative  = Los pulmones suenan { $description }.
cmu-medical-stethoscope-no-lungs           = No hay pulmones en el pecho del paciente.

cmu-medical-scanner-section-head           = Cabeza
cmu-medical-scanner-section-torso          = Torso
cmu-medical-scanner-section-arms           = Brazos
cmu-medical-scanner-section-legs           = Piernas
cmu-medical-scanner-section-organs         = Órganos
cmu-medical-scanner-hp                     = PV
cmu-medical-scanner-bone                   = Hueso
cmu-medical-scanner-fracture               = Fractura: { $severity }
cmu-medical-scanner-fracture-vague         = Fractura: detectada
cmu-medical-scanner-bleed-internal         = Hemorragia interna
cmu-medical-scanner-pain-unknown           = Dolor: ?
cmu-medical-scanner-pain-none              = Dolor: ninguno
cmu-medical-scanner-pain-mild              = Dolor: leve
cmu-medical-scanner-pain-moderate          = Dolor: moderado
cmu-medical-scanner-pain-severe            = Dolor: intenso
cmu-medical-scanner-pain-shock             = Dolor: choque
cmu-medical-scanner-pain-risk-unknown      = ?
cmu-medical-scanner-pain-risk-low          = Bajo
cmu-medical-scanner-pain-risk-elevated     = Elevado
cmu-medical-scanner-pain-risk-high         = Alto
cmu-medical-scanner-pain-risk-imminent     = Inminente
cmu-medical-scanner-pain-risk-active       = Activo
cmu-medical-scanner-pain-risk-suppressed-suffix =  (supr.)

# Rediseño V2-ε de la hoja de estadísticas — tarjetas oscuras + indicador de estado + diagrama corporal
cmu-medical-scanner-card-body              = Cuerpo
cmu-medical-scanner-card-organs            = Órganos
cmu-medical-scanner-card-reagents          = Reactivos en el torrente sanguíneo
cmu-medical-scanner-card-recommended       = Recomendado
cmu-medical-scanner-card-patient           = Paciente
cmu-medical-scanner-card-damage            = Perfil de daños
cmu-medical-scanner-loading                = Recibiendo telemetría del escaneo
cmu-medical-scanner-loading-subtext        = resolviendo el estado del servidor

cmu-medical-scanner-stat-health            = SALUD
cmu-medical-scanner-stat-pulse             = PULSO LPM
cmu-medical-scanner-stat-blood             = SANGRE
cmu-medical-scanner-stat-temp              = TEMP. °C
cmu-medical-scanner-stat-shock-risk        = RIESGO DE CHOQUE
cmu-medical-scanner-stat-pulse-stopped     = 0
cmu-medical-scanner-stat-deceased-short    = MUERTO

cmu-medical-scanner-status-stable          = ESTABLE
cmu-medical-scanner-status-serious         = GRAVE
cmu-medical-scanner-status-critical        = CRÍTICO
cmu-medical-scanner-status-deceased        = FALLECIDO

cmu-medical-scanner-severity-healthy       = Sano
cmu-medical-scanner-severity-bruised       = Magullado
cmu-medical-scanner-severity-damaged       = Dañado
cmu-medical-scanner-severity-critical      = Crítico
cmu-medical-scanner-severity-severed       = Amputado

cmu-medical-scanner-chip-fracture-vague    = Fractura
cmu-medical-scanner-chip-suppressed-suffix =  (supr.)
cmu-medical-scanner-chip-bleed             = HI
cmu-medical-scanner-chip-bleeding          = Sangrado
cmu-medical-scanner-chip-shrapnel          = { $count } frag.
cmu-medical-scanner-chip-splint            = Férula
cmu-medical-scanner-chip-cast              = Escayola
cmu-medical-scanner-chip-tourniquet        = TQ
cmu-medical-scanner-eschar                 = escara
cmu-medical-scanner-chip-wounds            = { $count } herida{ $count ->
    [one] {""}
   *[other] s
}

# Indicaciones de restricción por habilidad: muestran lo que el examinador no puede detectar
# para que el médico sepa si debe formarse más en vez de asumir que el paciente está bien.
cmu-medical-scanner-skill-hint-fractures   = Formación insuficiente para detectar fracturas o hemorragias internas (se requiere Med-1).
cmu-medical-scanner-skill-hint-organs      = Formación insuficiente para evaluar daños en los órganos (se requiere Med-2).
cmu-medical-scanner-synthetic-physiology   = Fisiología sintética detectada

# Claves heredadas de V2-ε Mix B (aún referenciadas por pruebas/rutas alternativas)
cmu-medical-scanner-vitals-pain            = Dolor
cmu-medical-scanner-stable-summary         = Estable: { $list }
cmu-medical-scanner-acute-issues-header    = Problemas agudos
cmu-medical-scanner-acute-severed          = Amputado: { $part }
cmu-medical-scanner-acute-fracture         = Fractura { $severity }: { $part }
cmu-medical-scanner-acute-fracture-vague   = Fractura: { $part }
cmu-medical-scanner-acute-bleed            = Hemorragia interna: { $part }
cmu-medical-scanner-acute-bleed-vague      = Hemorragia interna detectada
cmu-medical-scanner-acute-organ            = { $stage }: { $organ }
cmu-medical-scanner-acute-organ-removed    = Extirpado: { $organ }
cmu-medical-scanner-organ-removed-short    = Extirpado

# Nombres de órganos para mostrar: etiquetas sencillas asociadas a los ID de prototipo CMUOrganHuman*.
# Las claves individuales para cada órgano hacen que la capa de localización sea el único lugar
# que necesita cambios si modificamos los nombres en V2.5.
cmu-medical-scanner-organ-heart            = Corazón
cmu-medical-scanner-organ-lungs            = Pulmones
cmu-medical-scanner-organ-liver            = Hígado
cmu-medical-scanner-organ-brain            = Cerebro
cmu-medical-scanner-organ-kidneys          = Riñones
cmu-medical-scanner-organ-stomach          = Estómago
cmu-medical-scanner-organ-eyes             = Ojos

cmu-medical-stethoscope-pain-mild          = El paciente parece incómodo.
cmu-medical-stethoscope-pain-moderate      = El paciente siente un dolor evidente.
cmu-medical-stethoscope-pain-severe        = El paciente siente un dolor intenso.
cmu-medical-stethoscope-pain-shock         = El paciente está en choque.

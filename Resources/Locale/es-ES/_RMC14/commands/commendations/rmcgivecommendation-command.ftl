# Comando para conceder menciones
cmd-rmcgivecommendation-desc = Concede una medalla o jalea a un jugador
cmd-rmcgivecommendation-help = Uso: rmcgivecommendation <nombre del otorgante> <receptor> <nombre del receptor> <tipo> <tipo de mención> <cita> [ID de ronda]
  Argumentos:
  nombre del otorgante: quien concede la distinción dentro del personaje (DEBE entrecomillarse si contiene espacios)
  receptor: nombre o ID de usuario del jugador
  nombre del receptor: nombre del personaje (DEBE entrecomillarse si contiene espacios)
  tipo: medal o jelly
  tipo de mención: un número (utiliza el completado con tabulador para ver los tipos disponibles)
  cita: motivo de la distinción (DEBE ir entre comillas)
  ID de ronda: número de ronda; de forma predeterminada, la ronda actual (opcional)
  
  Ejemplos:
    rmcgivecommendation "UNMC High Command" PlayerName "John Doe" medal 1 "Por una valentía excepcional"
    rmcgivecommendation "The Queen Mother" XenoPlayer "XX-Alpha" jelly 2 "Por defender la colmena"
    rmcgivecommendation "UNMC High Command" PlayerName "John Doe" medal 1 "Por una valentía excepcional" 42

# Errores
cmd-rmcgivecommendation-invalid-arguments = ¡Número de argumentos incorrecto!
cmd-rmcgivecommendation-invalid-type = ¡Tipo no válido! Debe ser 'medal' o 'jelly'.
cmd-rmcgivecommendation-invalid-award-type = ¡Tipo «{ $type }» no válido! Debe estar entre 1 y { $max }.
cmd-rmcgivecommendation-empty-citation = ¡El motivo no puede estar vacío!
cmd-rmcgivecommendation-player-not-found = No se ha encontrado al jugador «{ $player }».

# Operación correcta
cmd-rmcgivecommendation-success = ¡Se ha concedido { $award } a { $player }!
cmd-rmcgivecommendation-admin-announcement = { $admin } ha concedido { $type } «{ $award }» a { $receiver } (personaje: { $character }) en la ronda { $round }

# Sugerencias de completado
cmd-rmcgivecommendation-hint-giver = Nombre dentro del personaje de quien concede la distinción (introdúcelo con cuidado)
cmd-rmcgivecommendation-hint-giver-highcommand = Concedente habitual de medallas de los marines
cmd-rmcgivecommendation-hint-giver-queen-mother = Concedente habitual de jaleas xeno
cmd-rmcgivecommendation-hint-receiver = Nombre o ID de usuario del receptor
cmd-rmcgivecommendation-hint-receiver-name = Nombre del personaje receptor (introdúcelo con cuidado)
cmd-rmcgivecommendation-hint-type = Tipo (medal o jelly)
cmd-rmcgivecommendation-hint-type-medal = Conceder una medalla a un marine
cmd-rmcgivecommendation-hint-type-jelly = Conceder jalea real a un xeno
cmd-rmcgivecommendation-hint-medal-type = Tipo de medalla (1-{ $count })
cmd-rmcgivecommendation-hint-jelly-type = Tipo de jalea (1-{ $count })
cmd-rmcgivecommendation-hint-invalid-type = El tipo debe ser 'medal' o 'jelly'
cmd-rmcgivecommendation-hint-citation = Texto del motivo (introdúcelo con cuidado dentro del personaje)
cmd-rmcgivecommendation-hint-round = ID de ronda (opcional)
cmd-rmcgivecommendation-hint-round-current = Ronda actual

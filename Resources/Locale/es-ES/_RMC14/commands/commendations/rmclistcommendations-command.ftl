# Comando para enumerar menciones
cmd-rmclistcommendations-desc = Enumera las menciones por ronda, jugador, id o entradas recientes.
cmd-rmclistcommendations-help = Uso:
  rmclistcommendations last <cantidad> [tipo]
    - Enumera las menciones más recientes
    - cantidad: número de menciones recientes que se mostrarán
    - tipo: filtro por tipo de mención (all de forma predeterminada)
  
  rmclistcommendations round <ID de ronda> [tipo]
    - Enumera todas las menciones de una ronda concreta
    - tipo: filtro por tipo de mención (all de forma predeterminada)

  rmclistcommendations id <ID de mención>
    - Enumera una sola mención por id
  
  rmclistcommendations player giver <nombre o ID de usuario> <cantidad> [tipo]
    - Enumera las menciones concedidas por un jugador
    - cantidad: número de menciones recientes que se mostrarán
    - tipo: filtro por tipo de mención (all de forma predeterminada)
  
  rmclistcommendations player receiver <nombre o ID de usuario> <cantidad> [tipo]
    - Enumera las menciones recibidas por un jugador
    - cantidad: número de menciones recientes que se mostrarán
    - tipo: filtro por tipo de mención (all de forma predeterminada)
  
  Ejemplos:
    rmclistcommendations last 10
    rmclistcommendations last 5 jelly
    rmclistcommendations round 42
    rmclistcommendations round 42 medal
    rmclistcommendations id 128
    rmclistcommendations player giver NombreDeJugador 10
    rmclistcommendations player receiver NombreDeJugador 5 jelly

# Errores
cmd-rmclistcommendations-invalid-arguments = ¡Argumentos incorrectos!
cmd-rmclistcommendations-invalid-round-id = ¡ID de ronda no válido!
cmd-rmclistcommendations-invalid-id = ¡ID de mención no válido!
cmd-rmclistcommendations-invalid-type = ¡Tipo «{ $type }» no válido!
cmd-rmclistcommendations-invalid-player-mode = ¡Modo de jugador no válido! Debe ser 'giver' o 'receiver'.
cmd-rmclistcommendations-invalid-count = ¡Cantidad no válida! Debe ser un número positivo.
cmd-rmclistcommendations-player-not-found = No se ha encontrado al jugador «{ $player }».
cmd-rmclistcommendations-no-results = No se ha encontrado ninguna mención.

# Encabezados
cmd-rmclistcommendations-last-header = Se muestran las { $count } menciones más recientes (solicitadas: { $total }):
cmd-rmclistcommendations-round-header = Menciones de la ronda { $round } ({ $count } en total):
cmd-rmclistcommendations-id-header = Mención { $id }:
cmd-rmclistcommendations-giver-header = Se muestran las { $count } menciones concedidas más recientes (solicitadas: { $total }):
cmd-rmclistcommendations-receiver-header = Se muestran las { $count } menciones recibidas más recientes (solicitadas: { $total }):

# Formato
cmd-rmclistcommendations-format = id [{ $id }] { $type }: { $name } - { $giverUserName } ({ $giver }) → { $receiverUserName } ({ $receiver }) Ronda { $round }: { $text }

# Sugerencias de completado
cmd-rmclistcommendations-hint-mode = Modo (last, round, id o player)
cmd-rmclistcommendations-hint-mode-last = Enumerar las menciones más recientes
cmd-rmclistcommendations-hint-mode-round = Enumerar menciones por ronda
cmd-rmclistcommendations-hint-mode-id = Enumerar una mención por id
cmd-rmclistcommendations-hint-mode-player = Enumerar menciones por jugador
cmd-rmclistcommendations-hint-round-id = ID de ronda
cmd-rmclistcommendations-hint-commendation-id = ID de mención
cmd-rmclistcommendations-hint-player-mode = Modo de jugador (giver o receiver)
cmd-rmclistcommendations-hint-player-giver = Menciones concedidas por el jugador
cmd-rmclistcommendations-hint-player-receiver = Menciones recibidas por el jugador
cmd-rmclistcommendations-hint-player = Nombre o ID de usuario del jugador
cmd-rmclistcommendations-hint-count = Número de menciones que se mostrarán
cmd-rmclistcommendations-hint-type = Filtro por tipo de mención

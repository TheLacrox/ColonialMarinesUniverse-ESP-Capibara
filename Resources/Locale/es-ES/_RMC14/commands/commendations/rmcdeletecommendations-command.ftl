cmd-rmcdeletecommendations-desc = Elimina menciones por ronda, concedente, receptor o id.
cmd-rmcdeletecommendations-help = Uso:
  rmcdeletecommendations id <ID de mención>
    - Elimina una sola mención por id

  rmcdeletecommendations round <ID de ronda> <tipo>
    - Elimina todas las menciones de una ronda y un tipo concretos
    - tipo: filtro por tipo de mención

  rmcdeletecommendations round <ID de ronda> <tipo> giver <nombre o ID de usuario>
    - Elimina las menciones de una ronda y un tipo concedidas por un jugador
    - tipo: filtro por tipo de mención

  rmcdeletecommendations round <ID de ronda> <tipo> receiver <nombre o ID de usuario>
    - Elimina las menciones de una ronda y un tipo recibidas por un jugador
    - tipo: filtro por tipo de mención

  Ejemplos:
    rmcdeletecommendations id 128
    rmcdeletecommendations round 42 medal
    rmcdeletecommendations round 42 jelly giver NombreDeJugador
    rmcdeletecommendations round 42 medal receiver NombreDeJugador

cmd-rmcdeletecommendations-invalid-arguments = ¡Argumentos incorrectos!
cmd-rmcdeletecommendations-invalid-round-id = ¡ID de ronda no válido!
cmd-rmcdeletecommendations-invalid-id = ¡ID de mención no válido!
cmd-rmcdeletecommendations-invalid-type = ¡Tipo «{ $type }» no válido!
cmd-rmcdeletecommendations-invalid-player-mode = ¡Modo de jugador no válido! Debe ser 'giver' o 'receiver'.
cmd-rmcdeletecommendations-player-not-found = No se ha encontrado al jugador «{ $player }».
cmd-rmcdeletecommendations-no-results = No se ha encontrado ninguna mención.

cmd-rmcdeletecommendations-id-header = Mención { $id } eliminada:
cmd-rmcdeletecommendations-round-header = Menciones eliminadas de la ronda { $round } ({ $count } en total):
cmd-rmcdeletecommendations-format = id [{ $id }] { $type }: { $name } - { $giverUserName } ({ $giver }) → { $receiverUserName } ({ $receiver }) Ronda { $round }: { $text }
cmd-rmcdeletecommendations-admin-announcement = { $admin } ha eliminado las menciones con ID: { $ids }
cmd-rmcdeletecommendations-admin-announcement-round = { $admin } ha eliminado las menciones de la ronda { $round } con ID: { $ids }

cmd-rmcdeletecommendations-hint-mode = Modo (id o round)
cmd-rmcdeletecommendations-hint-mode-id = Eliminar una mención por id
cmd-rmcdeletecommendations-hint-mode-round = Eliminar menciones por ronda
cmd-rmcdeletecommendations-hint-round-id = ID de ronda
cmd-rmcdeletecommendations-hint-commendation-id = ID de mención
cmd-rmcdeletecommendations-hint-type = Tipo de mención
cmd-rmcdeletecommendations-hint-player-mode = Modo de jugador (giver o receiver)
cmd-rmcdeletecommendations-hint-player-giver = Menciones concedidas por el jugador
cmd-rmcdeletecommendations-hint-player-receiver = Menciones recibidas por el jugador
cmd-rmcdeletecommendations-hint-player = Nombre o ID de usuario del jugador

# Se muestra como iniciador cuando ningún usuario crea la votación.
ui-vote-initiator-server = El servidor

## Default.Votes

ui-vote-restart-title = Reiniciar la ronda
ui-vote-restart-succeeded = La votación para reiniciar ha prosperado.
ui-vote-restart-failed = La votación para reiniciar no ha prosperado (se necesita { TOSTRING($ratio, "P0") }).
ui-vote-restart-fail-not-enough-ghost-players = La votación para reiniciar no ha prosperado: se requiere un mínimo del { $ghostPlayerRequirement } % de jugadores fantasma para iniciarla. Ahora mismo no hay suficientes.
ui-vote-restart-yes = Sí
ui-vote-restart-no = No
ui-vote-restart-abstain = Abstenerse

ui-vote-gamemode-title = Siguiente modo de juego
ui-vote-gamemode-tie = ¡Empate en la votación del modo de juego! Se ha elegido... { $picked }
ui-vote-gamemode-win = ¡{ $winner } ganó la votación del modo de juego!

ui-vote-map-title = Siguiente mapa
ui-vote-map-tie = ¡Empate en la votación del mapa! Se ha elegido... { $picked }
ui-vote-map-win = ¡{ $winner } ganó la votación del mapa!
ui-vote-map-notlobby = ¡Solo se puede votar el mapa siguiente en el vestíbulo previo a la ronda!
ui-vote-map-notlobby-time = ¡Solo se puede votar el mapa siguiente en el vestíbulo previo a la ronda cuando quedan { $time }!


# Votaciones de expulsión
ui-vote-votekick-unknown-initiator = Un jugador
ui-vote-votekick-unknown-target = Jugador desconocido
ui-vote-votekick-title = { $initiator } ha iniciado una votación para expulsar a { $targetEntity }. Motivo: { $reason }
ui-vote-votekick-yes = Sí
ui-vote-votekick-no = No
ui-vote-votekick-abstain = Abstenerse
ui-vote-votekick-success = La votación para expulsar a { $target } ha prosperado. Motivo: { $reason }
ui-vote-votekick-failure = La votación para expulsar a { $target } no ha prosperado. Motivo: { $reason }
ui-vote-votekick-not-enough-eligible = No hay suficientes votantes aptos conectados para iniciar una votación de expulsión: { $voters }/{ $requirement }
ui-vote-votekick-server-cancelled = El servidor canceló la votación para expulsar a { $target }.

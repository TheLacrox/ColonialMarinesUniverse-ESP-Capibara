discord-watchlist-connection-header =
    { $players ->
        [one] {$players} jugador incluido en una lista de seguimiento se ha
        *[other] {$players} jugadores incluidos en una lista de seguimiento se han
    } conectado a {$serverName}

discord-watchlist-connection-entry = - {$playerName}, con el mensaje «{$message}»{ $expiry ->
        [0] {""}
        *[other] {" "}(caduca <t:{$expiry}:R>)
    }{ $otherWatchlists ->
        [0] {""}
        [one] {" "}y {$otherWatchlists} lista de seguimiento más
        *[other] {" "}y otras {$otherWatchlists} listas de seguimiento
    }

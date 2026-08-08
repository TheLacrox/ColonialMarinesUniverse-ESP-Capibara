cmd-whitelistadd-desc = Añade a la lista de permitidos del servidor al jugador con el nombre de usuario indicado.
cmd-whitelistadd-help = Uso: whitelistadd <nombre de usuario o ID de usuario>
cmd-whitelistadd-existing = ¡{$username} ya está en la lista de permitidos!
cmd-whitelistadd-added = Se ha añadido a {$username} a la lista de permitidos.
cmd-whitelistadd-not-found = No se pudo encontrar a «{$username}».
cmd-whitelistadd-arg-player = [jugador]

cmd-whitelistremove-desc = Elimina de la lista de permitidos del servidor al jugador con el nombre de usuario indicado.
cmd-whitelistremove-help = Uso: whitelistremove <nombre de usuario o ID de usuario>
cmd-whitelistremove-existing = ¡{$username} no está en la lista de permitidos!
cmd-whitelistremove-removed = Se ha eliminado a {$username} de la lista de permitidos.
cmd-whitelistremove-not-found = No se pudo encontrar a «{$username}».
cmd-whitelistremove-arg-player = [jugador]

cmd-kicknonwhitelisted-desc = Expulsa del servidor a todos los jugadores que no estén en la lista de permitidos.
cmd-kicknonwhitelisted-help = Uso: kicknonwhitelisted

ban-banned-permanent = Este veto solo se retirará mediante una apelación.
ban-banned-permanent-appeal = Este veto solo se retirará mediante una apelación. Puedes apelar en {$link}.
ban-expires = Este veto durará {$duration} minutos y vencerá a las {$time} UTC.
ban-banned-1 = Se te ha prohibido jugar aquí a ti o a cualquier otra persona que use este ordenador o esta conexión.
ban-banned-2 = El motivo del veto es: "{$reason}"
ban-banned-3 = Se registrará cualquier intento de eludir este veto, como crear una cuenta nueva.

soft-player-cap-full = ¡El servidor está lleno!
panic-bunker-account-denied = Estamos en modo «búnker de pánico». No se aceptan temporalmente conexiones nuevas que no cumplan determinados requisitos. Volveremos pronto; inténtalo de nuevo más tarde o visita nuestro Discord para obtener más información.
panic-bunker-account-denied-reason = Estamos en modo «búnker de pánico». No se aceptan temporalmente conexiones nuevas que no cumplan determinados requisitos. Volveremos pronto; visita nuestro Discord para obtener más información. Requisito: "{$reason}"
panic-bunker-account-reason-account = Tu cuenta es demasiado reciente. ¡Debe tener más de {$minutes} minutos!
panic-bunker-account-reason-overall = ¡El tiempo total de juego debe superar los {$minutes} minutos!

whitelist-playtime = No tienes suficiente tiempo de juego para entrar en este servidor. Necesitas al menos {$minutes} minutos de juego.
whitelist-player-count = Este servidor no acepta jugadores en este momento. Inténtalo de nuevo más tarde.
whitelist-notes = Tienes demasiadas notas administrativas para entrar en este servidor. Puedes consultarlas escribiendo /adminremarks en el chat.
whitelist-manual = No estás en la lista de permitidos de este servidor.
whitelist-blacklisted = Estás en la lista de bloqueados de este servidor.
whitelist-always-deny = No tienes permiso para entrar en este servidor.
whitelist-fail-prefix = Fuera de la lista de permitidos: {$msg}

cmd-blacklistadd-desc = Añade a la lista de bloqueados del servidor al jugador con el nombre de usuario indicado.
cmd-blacklistadd-help = Uso: blacklistadd <nombre de usuario>
cmd-blacklistadd-existing = ¡{$username} ya está en la lista de bloqueados!
cmd-blacklistadd-added = Se ha añadido a {$username} a la lista de bloqueados.
cmd-blacklistadd-not-found = No se pudo encontrar a «{$username}».
cmd-blacklistadd-arg-player = [jugador]

cmd-blacklistremove-desc = Elimina de la lista de bloqueados del servidor al jugador con el nombre de usuario indicado.
cmd-blacklistremove-help = Uso: blacklistremove <nombre de usuario>
cmd-blacklistremove-existing = ¡{$username} no está en la lista de bloqueados!
cmd-blacklistremove-removed = Se ha eliminado a {$username} de la lista de bloqueados.
cmd-blacklistremove-not-found = No se pudo encontrar a «{$username}».
cmd-blacklistremove-arg-player = [jugador]

baby-jail-account-denied = Este servidor es para principiantes y está pensado tanto para jugadores nuevos como para quienes quieran ayudarlos. No se aceptan conexiones nuevas de cuentas demasiado antiguas o que no estén en una lista de permitidos. Prueba otros servidores y descubre todo lo que Space Station 14 puede ofrecer. ¡Diviértete!
baby-jail-account-denied-reason = Este servidor es para principiantes y está pensado tanto para jugadores nuevos como para quienes quieran ayudarlos. No se aceptan conexiones nuevas de cuentas demasiado antiguas o que no estén en una lista de permitidos. Prueba otros servidores y descubre todo lo que Space Station 14 puede ofrecer. ¡Diviértete! Motivo: "{$reason}"
baby-jail-account-reason-account = Tu cuenta de Space Station 14 es demasiado antigua. Debe tener menos de {$minutes} minutos.
baby-jail-account-reason-overall = Tu tiempo total de juego en el servidor debe ser inferior a {$minutes} minutos.

generic-misconfigured = El servidor está mal configurado y no acepta jugadores. Ponte en contacto con su propietario e inténtalo de nuevo más tarde.

# RMC14 Change
ipintel-server-ratelimited = No estás vetado. Este juego usa una verificación externa que ha alcanzado su límite máximo para conexiones nuevas. Espera uno o dos minutos y vuelve a conectarte; no hace falta apelar. Si no funciona, inténtalo otro día o abre un ticket.
ipintel-unknown = Este servidor utiliza un sistema de seguridad con verificación externa, pero se ha producido un error. Ponte en contacto con el equipo administrativo del servidor para recibir ayuda e inténtalo de nuevo más tarde.
ipintel-suspicious = Te estás conectando desde un centro de datos o una VPN. Esto no es un veto contra tu cuenta: basta con que desactives la VPN. Si sigues teniendo un problema técnico o necesitas una VPN para jugar, puedes solicitar una exención en https://discord.gg/FtsCESsrzD

hwid-required = Tu cliente se ha negado a enviar un ID de hardware. Ponte en contacto con el equipo administrativo para obtener ayuda.

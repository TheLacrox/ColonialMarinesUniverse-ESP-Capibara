## Cadenas del comando "grant_connect_bypass".

cmd-grant_connect_bypass-desc = Permite temporalmente que un usuario omita las comprobaciones de conexión habituales.
cmd-grant_connect_bypass-help = Uso: grant_connect_bypass <usuario> [duración en minutos]
    Concede temporalmente a un usuario la posibilidad de omitir las restricciones de conexión habituales.
    La excepción solo se aplica a este servidor de juego y caduca, de forma predeterminada, al cabo de 1 hora.
    Podrá conectarse sin importar la lista blanca, el búnker de pánico o el límite de jugadores.

cmd-grant_connect_bypass-arg-user = <usuario>
cmd-grant_connect_bypass-arg-duration = [duración en minutos]

cmd-grant_connect_bypass-invalid-args = Se esperaban 1 o 2 argumentos
cmd-grant_connect_bypass-unknown-user = No se puede encontrar al usuario '{$user}'
cmd-grant_connect_bypass-invalid-duration = Duración no válida: '{$duration}'

cmd-grant_connect_bypass-success = Se añadió correctamente la excepción para el usuario '{$user}'

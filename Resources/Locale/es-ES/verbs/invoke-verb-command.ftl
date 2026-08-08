### Localización del comando que invoca verbos.
# Principalmente ayuda y mensajes de error.

invoke-verb-command-description = Invoca sobre una entidad un verbo con el nombre indicado y usa la entidad del jugador como ejecutora
invoke-verb-command-help = invokeverb <uidJugador | "self"> <uidObjetivo> <nombreVerbo | "interaction" | "activation" | "alternative">

invoke-verb-command-invalid-args = invokeverb requiere 2 argumentos.

invoke-verb-command-invalid-player-uid = No se pudo interpretar el uid del jugador o no se indicó "self".
invoke-verb-command-invalid-target-uid = No se pudo interpretar el uid del objetivo.

invoke-verb-command-invalid-player-entity = El uid de jugador indicado no corresponde a una entidad válida.
invoke-verb-command-invalid-target-entity = El uid de objetivo indicado no corresponde a una entidad válida.

invoke-verb-command-success = Se invocó el verbo «{ $verb }» sobre { $target } con { $player } como usuario.

invoke-verb-command-verb-not-found = No se encontró el verbo { $verb } en { $target }.

# Loc strings for various entity state & client-side PVS related commands

cmd-reset-ent-help = Uso: {$command} <UID de entidad>
cmd-reset-ent-desc = Restablece una entidad al estado más reciente recibido del servidor. También restablecerá las entidades que se hayan desvinculado y enviado al espacio nulo.

cmd-reset-all-ents-help = Uso: {$command}
cmd-reset-all-ents-desc = Restablece todas las entidades al estado más reciente recibido del servidor. Solo afecta a las entidades que no se hayan desvinculado y enviado al espacio nulo.

cmd-detach-ent-help = Uso: {$command} <UID de entidad>
cmd-detach-ent-desc = Desvincula una entidad y la envía al espacio nulo, como si hubiera salido del alcance del PVS.

cmd-local-delete-help = Uso: {$command} <UID de entidad>
cmd-local-delete-desc = Elimina una entidad. A diferencia del comando de eliminación normal, este actúa EN EL CLIENTE. A menos que sea una entidad del cliente, es probable que esto provoque errores.

cmd-full-state-reset-help = Uso: {$command}
cmd-full-state-reset-desc = Descarta toda la información de estado de las entidades y solicita al servidor un estado completo.

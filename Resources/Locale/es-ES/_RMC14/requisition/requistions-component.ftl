# Computadora de requisiciones
requisition-paperwork-receiver-name = Sección de Logística
requisition-paperwork-reward-message = ¡Confirmación recibida! Se han transferido ${$amount} del excedente presupuestario

# Factura de requisiciones
requisition-paper-print-name = Factura de {$name}
requisition-paper-print-manifest = [head=2]
    {$containerName}[/head][bold]{$content}[/bold][head=2]
    PESO: {$weight} LB
    LOTE {$lot}
    N.º SERIE {$serialNumber}[/head]
requisition-paper-print-content = - {$count} {$item}

# Consola de entrega de suministros
ui-supply-drop-consle-name = Consola de entrega de suministros
ui-supply-drop-console-name-bolded = [bold]ENTREGA DE SUMINISTROS[/bold]
ui-supply-drop-console-longitude = Longitud:
ui-supply-drop-console-latitude = Latitud:
ui-supply-drop-pad-status = [bold]Estado de la plataforma de suministros[/bold]
ui-supply-drop-console-update = Actualizar
ui-supply-drop-console-ready = ¡Lista para lanzar!
ui-supply-drop-console-launch = LANZAR ENTREGA DE SUMINISTROS
ui-supply-drop-console-launch-confirmation = ¿Confirmar entrega de suministros?
ui-supply-drop-console-cooldown = {$time} segundos hasta el siguiente lanzamiento
ui-supply-drop-crate-status =
    { $hasCrate ->
        [true] Estado de la plataforma de suministros: caja cargada.
       *[false] No hay ninguna caja cargada.
    }

# Interfaz del ordenador de requisiciones
cmu-requisitions-no-platform = Sin plataforma
cmu-requisitions-platform-lowered = Plataforma: bajada
cmu-requisitions-platform-raised = Plataforma: subida
cmu-requisitions-asrs-busy = ASRS ocupado
cmu-requisitions-raise = Subir
cmu-requisitions-lower = Bajar
cmu-requisitions-please-wait = Espera
cmu-requisitions-lowering = Bajando...
cmu-requisitions-raising = Subiendo...
cmu-requisitions-supply-budget = Presupuesto de suministros: { $balance }
cmu-requisitions-categories = CATEGORÍAS
cmu-requisitions-all-categories = TODAS LAS CATEGORÍAS
cmu-requisitions-search-results = RESULTADOS DE BÚSQUEDA
cmu-requisitions-no-matching-orders = No hay pedidos coincidentes.
cmu-requisitions-order-preview = VISTA PREVIA DEL PEDIDO
cmu-requisitions-no-order-selected = Ningún pedido seleccionado
cmu-requisitions-cost = Coste: { $cost }
cmu-requisitions-no-manifest-description = No hay descripción del manifiesto.
cmu-requisitions-sealed-crate = Se entrega en una caja sellada.
cmu-requisitions-manifest = MANIFIESTO
cmu-requisitions-stock-unlimited = Existencias: ilimitadas
cmu-requisitions-stock = Existencias: { $current }/{ $maximum }{ $refill }
cmu-requisitions-now = ahora

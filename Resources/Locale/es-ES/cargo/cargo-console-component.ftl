## Interfaz
cargo-console-menu-title = Consola de solicitudes de suministros
cargo-console-menu-account-name-label = Cuenta:{" "}
cargo-console-menu-account-name-none-text = Ninguna
cargo-console-menu-account-name-format = [bold][color={$color}]{$name}[/color][/bold] [font="Monospace"]\[{$code}\][/font]
cargo-console-menu-shuttle-name-label = Nombre del transbordador:{" "}
cargo-console-menu-shuttle-name-none-text = Ninguno
cargo-console-menu-points-label = Saldo:{" "}
cargo-console-menu-points-amount = ${$amount}
cargo-console-menu-shuttle-status-label = Estado del transbordador:{" "}
cargo-console-menu-shuttle-status-away-text = Ausente
cargo-console-menu-order-capacity-label = Capacidad de pedidos:{" "}
cargo-console-menu-call-shuttle-button = Activar teleplataforma
cargo-console-menu-permissions-button = Permisos
cargo-console-menu-categories-label = Categorías:{" "}
cargo-console-menu-search-bar-placeholder = Buscar
cargo-console-menu-requests-label = Solicitudes
cargo-console-menu-orders-label = Pedidos
cargo-console-menu-order-reason-description = Motivos: {$reason}
cargo-console-menu-populate-categories-all-text = Todos
cargo-console-menu-populate-orders-cargo-order-row-product-name-text = {$productName} (x{$orderAmount}), solicitado por {$orderRequester} con cargo a [color={$accountColor}]{$account}[/color]
cargo-console-menu-cargo-order-row-approve-button = Aprobar
cargo-console-menu-cargo-order-row-cancel-button = Cancelar
cargo-console-menu-tab-title-orders = Pedidos
cargo-console-menu-tab-title-funds = Transferencias
cargo-console-menu-account-action-transfer-limit = [bold]Límite de transferencia:[/bold] ${$limit}
cargo-console-menu-account-action-transfer-limit-unlimited-notifier = [color=gold](Ilimitado)[/color]
cargo-console-menu-account-action-select = [bold]Acción de la cuenta:[/bold]
cargo-console-menu-account-action-amount = [bold]Cantidad:[/bold] $
cargo-console-menu-account-action-button = Transferir
cargo-console-menu-toggle-account-lock-button = Alternar límite de transferencia
cargo-console-menu-account-action-option-withdraw = Retirar efectivo
cargo-console-menu-account-action-option-transfer = Transferir fondos a {$code}

# Pedidos
cargo-console-order-not-allowed = Acceso no autorizado
cargo-console-station-not-found = No hay ninguna estación disponible
cargo-console-invalid-product = ID de producto no válido
cargo-console-too-many = Demasiados pedidos aprobados
cargo-console-snip-snip = Pedido reducido a la capacidad disponible
cargo-console-insufficient-funds = Fondos insuficientes (se necesitan {$cost})
cargo-console-unfulfilled = No hay espacio para completar el pedido
cargo-console-trade-station = Enviado a {$destination}
cargo-console-unlock-approved-order-broadcast = [bold]{$approver}[/bold] aprobó [bold]{$productName} x{$orderAmount}[/bold], con un coste de [bold]{$cost}[/bold]
cargo-console-fund-withdraw-broadcast = [bold]{$name} retiró {$amount} spesos de {$name1} \[{$code1}\]
cargo-console-fund-transfer-broadcast = [bold]{$name} transfirió {$amount} spesos de {$name1} \[{$code1}\] a {$name2} \[{$code2}\][/bold]
cargo-console-fund-transfer-user-unknown = Desconocido

cargo-console-paper-reason-default = Ninguno
cargo-console-paper-approver-default = Uno mismo
cargo-console-paper-print-name = Pedido n.º {$orderNumber}
cargo-console-paper-print-text = [head=2]Pedido n.º {$orderNumber}[/head]
    {"[bold]Artículo:[/bold]"} {$itemName} (x{$orderQuantity})
    {"[bold]Solicitado por:[/bold]"} {$requester}

    {"[head=3]Información del pedido[/head]"}
    {"[bold]Pagador[/bold]:"} {$account} [font="Monospace"]\[{$accountcode}\][/font]
    {"[bold]Aprobado por:[/bold]"} {$approver}
    {"[bold]Motivo:[/bold]"} {$reason}

# Consola del transbordador de suministros
cargo-shuttle-console-menu-title = Consola del transbordador de suministros
cargo-shuttle-console-station-unknown = Desconocida
cargo-shuttle-console-shuttle-not-found = No encontrado
cargo-shuttle-console-organics = Se detectaron formas de vida orgánicas en el transbordador
cargo-no-shuttle = ¡No se encontró ningún transbordador de suministros!

# Consola de asignación de fondos
cargo-funding-alloc-console-menu-title = Consola de asignación de fondos
cargo-funding-alloc-console-label-account = [bold]Cuenta[/bold]
cargo-funding-alloc-console-label-code = [bold] Código [/bold]
cargo-funding-alloc-console-label-balance = [bold] Saldo [/bold]
cargo-funding-alloc-console-label-cut = [bold] Reparto de ingresos (%) [/bold]

cargo-funding-alloc-console-label-primary-cut = Porcentaje de Suministros sobre fondos que no proceden de cajas fuertes (%):
cargo-funding-alloc-console-label-lockbox-cut = Porcentaje de Suministros sobre ventas de cajas fuertes (%):

cargo-funding-alloc-console-label-help-non-adjustible = Suministros recibe el {$percent} % de los beneficios de ventas que no proceden de cajas fuertes. El resto se reparte como se indica abajo:
cargo-funding-alloc-console-label-help-adjustible = Los fondos restantes de fuentes distintas a cajas fuertes se distribuyen como se indica abajo:
cargo-funding-alloc-console-button-save = Guardar cambios
cargo-funding-alloc-console-label-save-fail = [bold]¡Reparto de ingresos no válido![/bold] [color=red]({$pos ->
    [1] +
    *[-1] -
}{$val} %)[/color]

# Plantilla del comprobante
cargo-acquisition-slip-body = [head=3]Detalles del activo[/head]
    {"[bold]Producto:[/bold]"} {$product}
    {"[bold]Descripción:[/bold]"} {$description}
    {"[bold]Coste unitario:[/bold"}] ${$unit}
    {"[bold]Cantidad:[/bold]"} {$amount}
    {"[bold]Coste:[/bold]"} ${$cost}

    {"[head=3]Detalles de la compra[/head]"}
    {"[bold]Solicitante:[/bold]"} {$orderer}
    {"[bold]Motivo:[/bold]"} {$reason}

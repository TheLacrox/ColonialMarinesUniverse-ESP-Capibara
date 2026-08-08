# Herramientas administrativas y banco de trabajo de Insurgency.
# Estos mensajes son exclusivos de es-ES; los consumidores conservan fallback literal en inglés.

# Editor de facciones

cmu-insfor-tools-editor-window-title = Editor de facciones de INSFOR
cmu-insfor-tools-editor-custom-window-title = Editor de facciones personalizadas de INSFOR
cmu-insfor-tools-editor-help = Ayuda: ¿qué significa cada campo?
cmu-insfor-tools-editor-factions = Facciones
cmu-insfor-tools-editor-new-faction = Nueva facción
cmu-insfor-tools-editor-export-blank-sheet = Exportar hoja en blanco para un jugador
cmu-insfor-tools-editor-import-filled-sheet = Importar hoja cumplimentada
cmu-insfor-tools-editor-untitled = (sin título)
cmu-insfor-tools-editor-untitled-id = (sin título n.º { $id })
cmu-insfor-tools-editor-editing = Editando: { $title }
cmu-insfor-tools-editor-field-title = Título
cmu-insfor-tools-editor-field-recruited-message = Mensaje de reclutamiento
cmu-insfor-tools-editor-field-description = Descripción
cmu-insfor-tools-editor-field-roleplay-style = Estilo de interpretación
cmu-insfor-tools-editor-field-flag-entity = Entidad de bandera
cmu-insfor-tools-editor-field-status-icon = Icono de estado
cmu-insfor-tools-editor-field-recruited-icon = Icono de miembro reclutado sin icono por puesto
cmu-insfor-tools-editor-field-dollar-rate = Dólares por punto
cmu-insfor-tools-editor-default-faction = Facción predeterminada (creada por el servidor y almacenada en la base de datos)
cmu-insfor-tools-editor-opposed-govfor = Facciones GOVFOR enemigas
cmu-insfor-tools-editor-other-placeables = Kit de célula: otras entidades desplegables
cmu-insfor-tools-editor-accept-dollars = Aceptar también dólares en efectivo a cambio de puntos
cmu-insfor-tools-editor-tab-faction-info = Información de la facción
cmu-insfor-tools-editor-tab-economy = Economía
cmu-insfor-tools-editor-tab-cell-kit = Kit de célula
cmu-insfor-tools-editor-tab-vendors = Distribuidores
cmu-insfor-tools-editor-tab-loadouts = Equipamientos
cmu-insfor-tools-editor-save-server-custom = Guardar en el servidor como personalizada
cmu-insfor-tools-editor-save-server-default = Guardar en el servidor como predeterminada
cmu-insfor-tools-editor-save-local-custom = Guardar como personalizada local
cmu-insfor-tools-editor-export-sheet = Exportar a una hoja
cmu-insfor-tools-editor-apply-round = Aplicar a la ronda
cmu-insfor-tools-editor-delete = Eliminar
cmu-insfor-tools-editor-clear = Limpiar
cmu-insfor-tools-editor-add = + Añadir
cmu-insfor-tools-editor-analyzer-submittables = Analizador: artículos canjeables por puntos (vacío = solo dólares)
cmu-insfor-tools-editor-items-per-point = artículos por punto
cmu-insfor-tools-editor-points-per-item = puntos por artículo
cmu-insfor-tools-editor-placeholder-ratio = proporción
cmu-insfor-tools-editor-add-submittable = + Añadir artículo canjeable
cmu-insfor-tools-editor-cell-kit-vendors = Kit de célula: distribuidores
cmu-insfor-tools-editor-vendor-name = Nombre del distribuidor
cmu-insfor-tools-editor-base-model = Modelo base
cmu-insfor-tools-editor-vendor-wrenchable = Desanclable (puede soltarse con una llave y trasladarse)
cmu-insfor-tools-editor-vendor-invulnerable = Invulnerable (la entidad base no se rompe ni cambia al recibir daño)
cmu-insfor-tools-editor-vendor-intel-points = Usa los puntos de inteligencia de la célula (el dinero del ordenador de inteligencia abastece este distribuidor)
cmu-insfor-tools-editor-vendor-use-base-arsenal = Usar el arsenal propio del modelo base (ignorar las secciones inferiores)
cmu-insfor-tools-editor-remove-vendor = Eliminar distribuidor
cmu-insfor-tools-editor-add-vendor = + Añadir distribuidor
cmu-insfor-tools-editor-sections = Secciones
cmu-insfor-tools-editor-section-name = Nombre de la sección
cmu-insfor-tools-editor-placeholder-per-player = por jugador
cmu-insfor-tools-editor-placeholder-global = global
cmu-insfor-tools-editor-category-limit = Límite de la categoría
cmu-insfor-tools-editor-remove-section = Eliminar sección
cmu-insfor-tools-editor-add-section = + Añadir sección
cmu-insfor-tools-editor-items-heading = Artículos (entidad / puntos / cantidad / máximo)
cmu-insfor-tools-editor-placeholder-points = puntos
cmu-insfor-tools-editor-placeholder-amount = cantidad
cmu-insfor-tools-editor-placeholder-max = máximo
cmu-insfor-tools-editor-add-item = + Añadir artículo
cmu-insfor-tools-editor-role-loadouts = Equipamientos de puesto (contenido del paquete A)
cmu-insfor-tools-editor-role-job = Puesto
cmu-insfor-tools-editor-contents = Contenido
cmu-insfor-tools-editor-remove-loadout = Eliminar equipamiento
cmu-insfor-tools-editor-add-loadout = + Añadir equipamiento
cmu-insfor-tools-editor-per-job-icons = Iconos de estado por puesto (vacío = todos usan el icono de facción superior)
cmu-insfor-tools-editor-add-per-job-icon = + Añadir icono por puesto
cmu-insfor-tools-editor-machine-analyzer = Analizador
cmu-insfor-tools-editor-machine-intel-computer = Ordenador de inteligencia de la CLF
cmu-insfor-tools-editor-machine-objectives-console = Consola de objetivos de la CLF
cmu-insfor-tools-editor-machine-tech-tree-console = Consola del árbol tecnológico de la CLF
cmu-insfor-tools-editor-machine-fax = Fax
cmu-insfor-tools-editor-default-machines = Máquinas predeterminadas del kit de célula
cmu-insfor-tools-editor-choose = Elegir…

# Ayuda del editor

cmu-insfor-tools-help-window-title = Editor de facciones de INSFOR: ayuda
cmu-insfor-tools-help-introduction =
    Una facción INSFOR es una de las células insurgentes que el líder de la CLF puede elegir tras aparecer. Aquí se define quiénes son, cómo convierten dinero en puntos, qué puede desplegar el kit pesado de célula de su líder y qué recibe cada puesto en su «paquete A». No hace falta escribir ningún ID de prototipo: cada entidad, puesto e icono se elige mediante un selector con búsqueda. El servidor vuelve a comprobar y limita todos los valores guardados, por lo que un valor incorrecto no puede romper la ronda.
cmu-insfor-tools-help-faction-list-title = Lista de facciones de la izquierda y marca «*»
cmu-insfor-tools-help-faction-list-body =
    La columna izquierda muestra todas las facciones guardadas y, arriba, la CLF integrada. Una facción lleva un «*» junto a su nombre cuando está configurada para enfrentarse al bando GOVFOR elegido para la ronda; es decir, cuando puede escogerse en esta ronda. La ausencia de la marca solo significa que no se enfrenta al GOVFOR actual: la facción puede editarse igualmente. Pulsa una facción para editarla o «Nueva facción» para empezar desde cero.
cmu-insfor-tools-help-identity-title = Identidad
cmu-insfor-tools-help-identity-body =
    Título: nombre de la facción que aparece en la lista de selección y en la ventana de revelación.
    Mensaje de reclutamiento: instrucciones que recibe quien acaba de ser reclutado, por ejemplo mediante la pistola de tatuajes. Si se deja vacío, se usa el mensaje predeterminado de la CLF.
    Descripción / estilo de interpretación: información mostrada en las instrucciones de antagonista y en la ventana de revelación para que sus miembros sepan quiénes son y cómo deben actuar.
    Entidad de bandera: objeto físico de bandera elegido en el catálogo (opcional).
    Icono de estado: icono de pertenencia a la facción que sus miembros ven entre sí, elegido en la lista de iconos.
cmu-insfor-tools-help-default-faction-title = Facción predeterminada (casilla)
cmu-insfor-tools-help-default-faction-body =
    Activada: la facción ha sido creada por el servidor y se guarda en su base de datos; se ofrece a los líderes cuyo GOVFOR coincida con la lista de enemigos inferior. Desactivada: es una facción personal o personalizada. Los botones situados al pie determinan dónde se guarda.
cmu-insfor-tools-help-opposed-govfor-title = Facciones GOVFOR enemigas
cmu-insfor-tools-help-opposed-govfor-body =
    Pelotones GOVFOR —USMC, TWE RMC, UPP y otros— a los que puede enfrentarse esta facción. Si la lista contiene el GOVFOR de la ronda, la facción se ofrece al líder y recibe la marca «*». Puedes añadir tantos como necesites.
cmu-insfor-tools-help-economy-title = Economía: dólares por puntos
cmu-insfor-tools-help-economy-body =
    Dólares por punto: determina cómo se convierten los dólares de inteligencia en puntos para los distribuidores de la célula.
    Aceptar también dólares: si se activa, el analizador seguirá aceptando efectivo aunque se hayan añadido otros artículos canjeables. Desactívalo si la economía de la facción debe ignorar por completo el dinero.
cmu-insfor-tools-help-analyzer-title = Analizador: artículos canjeables por puntos
cmu-insfor-tools-help-analyzer-body =
    Define qué acepta el analizador y convierte en puntos de célula además del efectivo. Cada fila contiene un artículo elegido en el selector y una proporción con dos modos:
    • Artículos por punto: se consume esa cantidad para producir un punto; es apropiado para bienes baratos.
    • Puntos por artículo: cada unidad produce esa cantidad de puntos; es apropiado para bienes valiosos.
    Deja la lista vacía para conservar el funcionamiento basado en dólares. El valor mínimo siempre es 1 para impedir que una entrega genere puntos gratuitos.
cmu-insfor-tools-help-default-machines-title = Máquinas predeterminadas del kit de célula
cmu-insfor-tools-help-default-machines-body =
    Activa las máquinas conocidas de la CLF —analizador, ordenador de inteligencia, consola de objetivos, consola del árbol tecnológico y fax— que el líder podrá desplegar con el kit pesado de célula. Reutilizan el sistema normal de dinero y puntos de la CLF; no necesitan configuración adicional.
cmu-insfor-tools-help-other-placeables-title = Kit de célula: otras entidades desplegables
cmu-insfor-tools-help-other-placeables-body =
    Entidades individuales adicionales que el líder puede colocar libremente mediante el kit pesado de célula, como lámparas, barricadas u objetos decorativos. Todas se eligen mediante el selector de entidades.
cmu-insfor-tools-help-vendors-title = Kit de célula: distribuidores
cmu-insfor-tools-help-vendors-body =
    Cada distribuidor que el líder puede desplegar desde el kit contiene:
    • Nombre: texto mostrado en el distribuidor desplegado y en la lista del kit.
    • Modelo base: entidad de distribuidor existente de la que se reutilizan el aspecto y las colisiones; las secciones inferiores sustituyen su arsenal.
    • Desanclable: permite soltarlo con una llave y trasladarlo después de colocarlo.
    • Invulnerable: impide que se rompa o cambie al recibir daño.
    • Usa puntos de inteligencia de la célula: los artículos se pagan con la reserva compartida de la célula, abastecida con dinero en el ordenador de inteligencia, en vez de con los puntos del comprador.
    • Usar el arsenal propio del modelo base: ignora las secciones inferiores y conserva las existencias integradas de la entidad base. Úsalo solo para reutilizar un distribuidor completo, como el estante de requisiciones de la CLF.
cmu-insfor-tools-help-vendor-sections-title = Secciones y artículos del distribuidor
cmu-insfor-tools-help-vendor-sections-body =
    Un distribuidor se divide en secciones o categorías. Cada sección contiene:
    • Nombre de la sección.
    • Límite de categoría: dos topes opcionales, uno por jugador y otro compartido por todos los jugadores.
    Cada fila de artículo contiene:
    • La entidad, elegida mediante el selector.
    • Puntos: su coste; 0 significa gratuito.
    • Cantidad: unidades disponibles.
    • Máximo: tope hasta el que se reponen las existencias.
    Deja los puntos vacíos para que el artículo solo esté limitado por sus existencias y sea gratuito.
cmu-insfor-tools-help-loadouts-title = Equipamientos de puesto: paquete A
cmu-insfor-tools-help-loadouts-body =
    Como la facción se elige después de que aparezcan los jugadores, el equipo de cada puesto se entrega posteriormente dentro de una caja «paquete A». Añade una fila por puesto y elige el puesto y las entidades que contiene.
cmu-insfor-tools-help-saving-title = Guardado y aplicación
cmu-insfor-tools-help-saving-body =
    Guardar en el servidor como predeterminada: almacena la facción en la base de datos del servidor como facción del anfitrión.
    Guardar como personalizada local: la almacena solo en este equipo para que aparezca en la lista de facciones personalizadas del líder.
    Aplicar a la ronda: aplica inmediatamente esta facción a la célula de la ronda actual.
    Eliminar: borra una facción guardada; la CLF integrada no puede eliminarse.

# Banco de trabajo del zapador

cmu-insfor-tools-sapper-window-title = Banco de trabajo del zapador
cmu-insfor-tools-sapper-tab-gunsmithing = Armería
cmu-insfor-tools-sapper-tab-fabrication = Fabricación
cmu-insfor-tools-sapper-no-weapon = No hay ningún arma cargada
cmu-insfor-tools-sapper-take-weapon = Recoger arma
cmu-insfor-tools-sapper-attachment-slots = Ranuras para accesorios
cmu-insfor-tools-sapper-load-weapon-for-slots = Carga un arma para ver sus ranuras.
cmu-insfor-tools-sapper-modifiers = Mejoras / penalizaciones
cmu-insfor-tools-sapper-no-modifiers = No hay modificadores de accesorios aplicados.
cmu-insfor-tools-sapper-empty = vacío
cmu-insfor-tools-sapper-slot-summary = { $slot }: { $attachment }
cmu-insfor-tools-sapper-add = + Añadir
cmu-insfor-tools-sapper-remove = − Retirar
cmu-insfor-tools-sapper-materials = Materiales
cmu-insfor-tools-sapper-no-materials-loaded = No hay materiales cargados
cmu-insfor-tools-sapper-material-count = { $material }: { $count }
cmu-insfor-tools-sapper-eject = Expulsar
cmu-insfor-tools-sapper-loose-ingredients = Ingredientes sueltos
cmu-insfor-tools-sapper-loose-ingredients-help = Deben estar sueltos sobre el banco o junto a él para poder consumirse:
cmu-insfor-tools-sapper-ingredient-count = ×{ $count } { $ingredient }
cmu-insfor-tools-sapper-craft = Fabricar
cmu-insfor-tools-sapper-no-materials = Sin materiales
cmu-insfor-tools-sapper-material-cost = { $count } × { $material }
cmu-insfor-tools-sapper-slot-rail = Riel
cmu-insfor-tools-sapper-slot-barrel = Cañón
cmu-insfor-tools-sapper-slot-underbarrel = Bajo el cañón
cmu-insfor-tools-sapper-slot-stock = Culata
cmu-insfor-tools-sapper-material-metal = Láminas de metal
cmu-insfor-tools-sapper-material-plasteel = Láminas de plastiacero
cmu-insfor-tools-sapper-material-wood = Tablones de madera
cmu-insfor-tools-sapper-material-plastic = Láminas de plástico
cmu-insfor-tools-sapper-ingredient-cable = cualquier bobina de cable
cmu-insfor-tools-sapper-ingredient-electronics = cualquier componente electrónico
cmu-insfor-tools-sapper-ingredient-power-cell = batería
cmu-insfor-tools-sapper-ingredient-buckshot = cartuchos de perdigones
cmu-insfor-tools-sapper-ingredient-ied = IED
cmu-insfor-tools-sapper-ingredient-handcuffs = cualquier tipo de esposas
cmu-insfor-tools-sapper-stat-accuracy = Precisión: { $value }
cmu-insfor-tools-sapper-stat-damage-falloff = Pérdida de daño con la distancia: { $value }
cmu-insfor-tools-sapper-stat-burst-scatter = Dispersión de ráfaga: { $value }
cmu-insfor-tools-sapper-stat-shots-per-burst = Disparos por ráfaga: { $value }
cmu-insfor-tools-sapper-stat-damage = Daño: { $value }
cmu-insfor-tools-sapper-stat-recoil = Retroceso: { $value }
cmu-insfor-tools-sapper-stat-scatter = Dispersión: { $value }
cmu-insfor-tools-sapper-stat-fire-delay = Intervalo entre disparos: { $value }
cmu-insfor-tools-sapper-stat-projectile-speed = Velocidad del proyectil: { $value }
cmu-insfor-tools-sapper-stat-range = Alcance: { $value }
cmu-insfor-tools-sapper-stat-walk-speed = Velocidad al caminar: { $value }
cmu-insfor-tools-sapper-stat-sprint-speed = Velocidad al correr: { $value }
cmu-insfor-tools-sapper-stat-item-size = Tamaño del objeto: { $value }
cmu-insfor-tools-sapper-stat-wield-delay = Tiempo de empuñado: { $value }

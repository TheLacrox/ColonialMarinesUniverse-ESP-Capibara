command-help-usage =
    Uso:
command-help-invertible =
    El comportamiento de este comando puede invertirse con el prefijo "not".
command-description-tpto =
    Teletransporta las entidades indicadas hasta una entidad de destino.
command-description-player-list =
    Devuelve una lista de todas las sesiones de jugadores.
command-description-player-self =
    Devuelve la sesión del jugador actual.
command-description-player-imm =
    Devuelve la sesión asociada al jugador proporcionado como argumento.
command-description-player-entity =
    Devuelve las entidades de las sesiones de entrada.
command-description-self =
    Devuelve la entidad vinculada actualmente.
command-description-physics-velocity =
    Devuelve la velocidad de las entidades de entrada.
command-description-physics-angular-velocity =
    Devuelve la velocidad angular de las entidades de entrada.
command-description-buildinfo =
    Proporciona información sobre la compilación del juego.
command-description-cmd-list =
    Devuelve una lista de todos los comandos de este lado.
command-description-explain =
    Explica la expresión indicada y proporciona las descripciones y firmas de los comandos. Solo funciona con expresiones válidas; no puede explicar comandos que no consiga analizar.
command-description-search =
    Busca en la entrada el valor proporcionado.
command-description-stopwatch =
    Mide el tiempo de ejecución de la expresión indicada.
command-description-types-consumers =
    Proporciona todos los comandos que pueden consumir el tipo indicado.
command-description-types-tree =
    Herramienta de depuración que devuelve todos los tipos a los que el intérprete de comandos puede convertir la entrada de forma descendente.
command-description-types-gettype =
    Devuelve el tipo de la entrada.
command-description-types-fullname =
    Devuelve el nombre completo del tipo de entrada según CoreCLR.
command-description-as =
    Convierte la entrada al tipo indicado.
    En la práctica, sirve como indicación de tipo cuando tú conoces el tipo pero el intérprete no.
command-description-count =
    Cuenta el número de elementos de la entrada y devuelve un entero.
command-description-map =
    Aplica el bloque indicado a cada elemento de la entrada.
command-description-select =
    Selecciona N objetos o el N % de los objetos de la entrada.
    También se puede invertir este comando con not para seleccionar todo excepto N objetos.
command-description-comp =
    Devuelve el componente indicado de las entidades de entrada y descarta las entidades que no lo tengan.
command-description-delete =
    Elimina las entidades de entrada.
command-description-ent =
    Devuelve el ID de entidad proporcionado.
command-description-entities =
    Devuelve todas las entidades del servidor.
command-description-paused =
    Filtra las entidades de entrada según estén o no en pausa.
command-description-with =
    Filtra las entidades de entrada según tengan o no el componente indicado.
command-description-fuck =
    Lanza una excepción.
command-description-ecscomp-listty =
    Enumera todos los tipos de componentes registrados.
command-description-cd =
    Cambia el directorio actual de la sesión a la ruta relativa o absoluta indicada.
command-description-ls-here =
    Enumera el contenido del directorio actual.
command-description-ls-in =
    Enumera el contenido de la ruta relativa o absoluta indicada.
command-description-methods-get =
    Devuelve todos los métodos asociados al tipo de entrada.
command-description-methods-overrides =
    Devuelve todos los métodos reemplazados en el tipo de entrada.
command-description-methods-overridesfrom =
    Devuelve todos los métodos del tipo indicado que se reemplazan en el tipo de entrada.
command-description-cmd-moo =
    Plantea las preguntas importantes.
command-description-cmd-descloc =
    Devuelve la cadena de localización de la descripción de un comando.
command-description-cmd-getshim =
    Devuelve el adaptador de ejecución de un comando.
command-description-help =
    Proporciona un resumen rápido sobre cómo usar Toolshed.
command-description-ioc-registered =
    Devuelve todos los tipos registrados con IoCManager en el hilo actual (normalmente, el hilo del juego).
command-description-ioc-get =
    Obtiene una instancia de un registro de IoC.
command-description-loc-tryloc =
    Intenta obtener una cadena de localización y devuelve null si no puede.
command-description-loc-loc =
    Obtiene una cadena de localización y devuelve la cadena sin localizar si no puede.
command-description-physics-angular_velocity =
    Devuelve la velocidad angular de las entidades indicadas.
command-description-vars =
    Proporciona una lista de todas las variables establecidas en esta sesión.
command-description-any =
    Devuelve true si hay algún valor en la entrada; de lo contrario, devuelve false.
command-description-contains =
    Devuelve si la secuencia de entrada contiene el valor especificado.
command-description-ArrowCommand =
    Asigna la entrada a una variable.
command-description-isempty =
    Devuelve true si la entrada está vacía; de lo contrario, devuelve false.
command-description-isnull =
    Devuelve true si la entrada es null; de lo contrario, devuelve false.
command-description-unique =
    Filtra la secuencia de entrada para eliminar los valores duplicados.
command-description-where =
    Dada una secuencia de entrada IEnumerable<T>, recibe un bloque con la firma T -> bool que decide si cada valor de entrada debe incluirse en la secuencia de salida.
command-description-do =
    Proporciona compatibilidad con BQL y aplica los comandos antiguos indicados a la secuencia de entrada.
command-description-named =
    Filtra las entidades de entrada por su nombre mediante la expresión regular ^selector$.
command-description-prototyped =
    Filtra las entidades de entrada por su prototipo.
command-description-nearby =
    Crea una lista nueva con todas las entidades situadas dentro del alcance indicado de las entradas.
command-description-first =
    Devuelve el primer elemento de la secuencia indicada.
command-description-splat =
    "Expande" un bloque, valor o variable y crea N copias en una lista.
command-description-val =
    Convierte el valor, bloque o variable indicado al tipo especificado. Sirve principalmente para sortear las limitaciones actuales de las variables.
command-description-var =
    Devuelve el contenido de la variable indicada. Intentará deducir automáticamente el tipo de la variable. Puede que los comandos compuestos que modifican una variable deban usar el comando 'val' en su lugar.
command-description-actor-controlled =
    Filtra las entidades según estén o no bajo control activo.
command-description-actor-session =
    Devuelve las sesiones asociadas a las entidades de entrada.
command-description-physics-parent =
    Devuelve las entidades superiores de las entidades de entrada.
command-description-emplace =
    Ejecuta el bloque indicado sobre sus entradas y coloca el valor de entrada en la variable $value dentro del bloque.
    Para las entidades, también extrae $wx, $wy, $proto, $desc, $name y $paused.
    También puede extraer valores de otros tipos; consulta la documentación del tipo para obtener más información.
command-description-AddCommand =
    Realiza una suma numérica.
command-description-SubtractCommand =
    Realiza una resta numérica.
command-description-MultiplyCommand =
    Realiza una multiplicación numérica.
command-description-DivideCommand =
    Realiza una división numérica.
command-description-min =
    Devuelve el menor de dos valores.
command-description-max =
    Devuelve el mayor de dos valores.
command-description-BitAndCommand =
    Realiza una operación AND bit a bit.
command-description-bitor =
    Realiza una operación OR bit a bit.
command-description-BitXorCommand =
    Realiza una operación XOR bit a bit.
command-description-neg =
    Niega la entrada.
command-description-GreaterThanCommand =
    Realiza una comparación «mayor que»: x > y.
command-description-LessThanCommand =
    Realiza una comparación «menor que»: x < y.
command-description-GreaterThanOrEqualCommand =
    Realiza una comparación «mayor o igual que»: x >= y.
command-description-LessThanOrEqualCommand =
    Realiza una comparación «menor o igual que»: x <= y.
command-description-EqualCommand =
    Realiza una comparación de igualdad y devuelve true si las entradas son iguales.
command-description-NotEqualCommand =
    Realiza una comparación de igualdad y devuelve true si las entradas no son iguales.
command-description-append =
    Añade un valor al final de la secuencia de entrada.
command-description-DefaultIfNullCommand =
    Si la entrada es null, la sustituye por el valor predeterminado del tipo, aunque solo para tipos de valor (no objetos).
command-description-OrValueCommand =
    Si la entrada es null, usa el valor alternativo proporcionado.
command-description-DebugPrintCommand =
    Muestra el valor indicado sin modificarlo para generar mensajes de depuración al ejecutar un comando.
command-description-i =
    Constante entera.
command-description-f =
    Constante decimal.
command-description-s =
    Constante de cadena.
command-description-b =
    Constante booleana.
command-description-join =
    Une dos secuencias para formar una sola.
command-description-reduce =
    Usa el bloque indicado como reductor para convertir una secuencia en un único valor.
    El lado izquierdo del bloque está implícito y el derecho se guarda en $value.
command-description-rep =
    Repite N veces el valor de entrada para formar una secuencia.
command-description-take =
    Toma N valores de la secuencia de entrada.
command-description-spawn-at =
    Genera una entidad en las coordenadas indicadas.
command-description-spawn-on =
    Genera una entidad sobre la entidad indicada, en sus coordenadas.
command-description-spawn-in =
    Genera una entidad en el contenedor indicado de la entidad dada y, si no cabe, la deja caer en sus coordenadas.
command-description-spawn-attached =
    Genera una entidad vinculada a la entidad indicada, en la posición relativa (0 0).
command-description-mappos =
    Devuelve las coordenadas de una entidad con respecto a su mapa actual.
command-description-pos =
    Devuelve las coordenadas de una entidad.
command-description-tp-coords =
    Teletransporta las entidades indicadas a las coordenadas de destino.
command-description-tp-to =
    Teletransporta las entidades indicadas hasta la entidad de destino.
command-description-tp-into =
    Teletransporta las entidades indicadas "dentro" de la entidad de destino y las vincula a ella en la posición relativa (0 0).
command-description-comp-get =
    Obtiene el componente indicado de la entidad dada.
command-description-comp-add =
    Añade el componente indicado a la entidad dada.
command-description-comp-ensure =
    Garantiza que la entidad indicada tenga el componente dado.
command-description-comp-has =
    Comprueba si la entidad indicada tiene el componente dado.
command-description-AddVecCommand =
    Suma un escalar (un único valor) a cada elemento de la entrada.
command-description-SubVecCommand =
    Resta un escalar (un único valor) a cada elemento de la entrada.
command-description-MulVecCommand =
    Multiplica cada elemento de la entrada por un escalar (un único valor).
command-description-DivVecCommand =
    Divide cada elemento de la entrada entre un escalar (un único valor).
command-description-rng-to =
    Devuelve un número comprendido entre la entrada (incluida) y el argumento (excluido).
command-description-rng-from =
    Devuelve un número comprendido entre el argumento (incluido) y la entrada (excluida).
command-description-rng-prob =
    Devuelve un booleano basado en la probabilidad de entrada (de 0 a 1).
command-description-sum =
    Calcula la suma de la entrada.
command-description-bin =
    Agrupa la entrada en "contenedores" y cuenta cuántas veces aparece cada elemento único.
command-description-extremes =
    Devuelve entrelazados los dos extremos de una lista.
command-description-sortby =
    Ordena la entrada de menor a mayor según la clave calculada.
command-description-sortmapby =
    Ordena la entrada de menor a mayor según la clave calculada y después sustituye cada valor por esa clave.
command-description-sort =
    Ordena la entrada de menor a mayor.
command-description-sortdownby =
    Ordena la entrada de mayor a menor según la clave calculada.
command-description-sortmapdownby =
    Ordena la entrada de mayor a menor según la clave calculada y después sustituye cada valor por esa clave.
command-description-sortdown =
    Ordena la entrada de mayor a menor.
command-description-iota =
    Devuelve una lista de números del 1 al N.
command-description-to =
    Devuelve una lista de números de N a M.
command-description-curtick =
    El tick actual del juego.
command-description-curtime =
    El tiempo actual del juego (un TimeSpan).
command-description-realtime =
    El tiempo real transcurrido desde el inicio (un TimeSpan).
command-description-servertime =
    El tiempo de juego actual del servidor o cero si somos el servidor (un TimeSpan).
command-description-replace =
    Sustituye las entidades de entrada por el prototipo indicado y conserva la posición y la rotación, pero nada más.
command-description-allcomps =
    Devuelve todos los componentes de la entidad indicada.
command-description-entitysystemupdateorder-tick =
    Enumera el orden de actualización por tick de los sistemas de entidades.
command-description-entitysystemupdateorder-frame =
    Enumera el orden de actualización por fotograma de los sistemas de entidades.
command-description-more =
    Muestra el contenido de $more, es decir, cualquier elemento adicional que Toolshed no haya mostrado del último comando.
command-description-ModulusCommand =
    Calcula el módulo de dos valores.
    Normalmente es el resto; consulta la documentación de C# correspondiente al tipo.
command-description-ModVecCommand =
    Realiza la operación módulo sobre la entrada con el valor constante indicado a la derecha.
command-description-BitAndNotCommand =
    Realiza una operación AND-NOT bit a bit sobre la entrada.
command-description-bitornot =
    Realiza una operación OR-NOT bit a bit sobre la entrada.
command-description-BitXnorCommand =
    Realiza una operación XNOR bit a bit sobre la entrada.
command-description-BitNotCommand =
    Realiza una operación NOT bit a bit sobre la entrada.
command-description-abs =
    Calcula el valor absoluto de la entrada (elimina el signo).
command-description-average =
    Calcula el promedio (media aritmética) de la entrada.
command-description-bibytecount =
    Devuelve el tamaño de la entrada en bytes, siempre que la entrada implemente IBinaryInteger.
    NO equivale a sizeof.
command-description-shortestbitlength =
    Devuelve el número mínimo de bits necesario para representar el valor de entrada.
command-description-countleadzeros =
    Cuenta el número de ceros binarios iniciales del valor de entrada.
command-description-counttrailingzeros =
    Cuenta el número de ceros binarios finales del valor de entrada.
command-description-fpi =
    Pi (3.14159...) como float.
command-description-fe =
    e (2.71828...) como float.
command-description-ftau =
    Tau (6.28318...) como float.
command-description-fepsilon =
    El valor épsilon de un float, exactamente 1.4e-45.
command-description-dpi =
    Pi (3.14159...) como double.
command-description-de =
    e (2.71828...) como double.
command-description-dtau =
    Tau (6.28318...) como double.
command-description-depsilon =
    El valor épsilon de un double, exactamente 4.9406564584124654E-324.
command-description-hpi =
    Pi (3.14...) como half.
command-description-he =
    e (2.71...) como half.
command-description-htau =
    Tau (6.28...) como half.
command-description-hepsilon =
    El valor épsilon de un half, exactamente 5.9604645E-08.
command-description-floor =
    Devuelve el suelo del valor de entrada (redondea hacia cero).
command-description-ceil =
    Devuelve el techo del valor de entrada (redondea alejándose de cero).
command-description-round =
    Redondea el valor de entrada.
command-description-trunc =
    Trunca el valor de entrada.
command-description-round2frac =
    Redondea el valor de entrada al número especificado de cifras decimales.
command-description-exponentbytecount =
    Devuelve el número de bytes necesarios para almacenar el exponente.
command-description-significandbytecount =
    Devuelve el número de bytes necesarios para almacenar el significando.
command-description-significandbitcount =
    Devuelve la longitud exacta en bits del significando.
command-description-exponentshortestbitcount =
    Devuelve el número mínimo de bits necesario para almacenar el exponente.
command-description-stepnext =
    Avanza al siguiente valor float sumando uno al significando con acarreo.
command-description-stepprev =
    Retrocede al valor float anterior restando uno del significando con acarreo.
command-description-checkedto =
    Convierte el tipo numérico de entrada al de destino y produce un error si no es posible.
command-description-saturateto =
    Convierte el tipo numérico de entrada al de destino y satura el resultado si el valor está fuera del intervalo.
    Por ejemplo, convertir 382 a byte saturaría el resultado a 255 (el valor máximo de un byte).
command-description-truncto =
    Convierte el tipo numérico de entrada al de destino mediante truncamiento.
    En el caso de los enteros, se trata de una conversión de bits con extensión de signo.
command-description-iscanonical =
    Devuelve si la entrada está en forma canónica.
command-description-iscomplex =
    Devuelve si la entrada es un número complejo (por valor, no por tipo).
command-description-iseven =
    Devuelve si la entrada es par.
    No es un paquete de JavaScript.
command-description-isodd =
    Devuelve si la entrada es impar.
command-description-isfinite =
    Devuelve si la entrada es finita.
command-description-isimaginary =
    Devuelve si la entrada es puramente imaginaria (sin parte real).
command-description-isinfinite =
    Devuelve si la entrada es infinita.
command-description-isinteger =
    Devuelve si la entrada es un entero (por valor, no por tipo).
command-description-isnan =
    Devuelve si la entrada no es un número (NaN).
    Se trata de un valor especial de coma flotante, por lo que se comprueba por valor, no por tipo.
command-description-isnegative =
    Devuelve si la entrada es negativa.
command-description-ispositive =
    Devuelve si la entrada es positiva.
command-description-isreal =
    Devuelve si la entrada es puramente real (sin parte imaginaria).
command-description-issubnormal =
    Devuelve si la entrada está en forma subnormal.
command-description-iszero =
    Devuelve si la entrada es cero.
command-description-pow =
    Eleva el operando izquierdo al derecho: x^y.
command-description-sqrt =
    Calcula la raíz cuadrada de la entrada.
command-description-cbrt =
    Calcula la raíz cúbica de la entrada.
command-description-root =
    Calcula la raíz enésima de la entrada.
command-description-hypot =
    Calcula la hipotenusa de un triángulo cuyos lados son A y B.
command-description-sin =
    Calcula el seno de la entrada.
command-description-sinpi =
    Calcula el seno de la entrada multiplicada por pi.
command-description-asin =
    Calcula el arcoseno de la entrada.
command-description-asinpi =
    Calcula el arcoseno de la entrada multiplicada por pi.
command-description-cos =
    Calcula el coseno de la entrada.
command-description-cospi =
    Calcula el coseno de la entrada multiplicada por pi.
command-description-acos =
    Calcula el arcocoseno de la entrada.
command-description-acospi =
    Calcula el arcocoseno de la entrada multiplicada por pi.
command-description-tan =
    Calcula la tangente de la entrada.
command-description-tanpi =
    Calcula la tangente de la entrada multiplicada por pi.
command-description-atan =
    Calcula la arcotangente de la entrada.
command-description-atanpi =
    Calcula la arcotangente de la entrada multiplicada por pi.
command-description-iterate =
    Itera N veces la función indicada sobre la entrada y devuelve una lista de resultados.
    Equivale a aplicar sucesivamente la función a un valor y conservar todos los valores intermedios.
command-description-pick =
    Elige un valor al azar de la entrada.
command-description-tee =
    Bifurca la entrada hacia el bloque indicado e ignora el resultado del bloque.
    En la práctica, permite crear una rama en el código para realizar varias operaciones sobre un mismo valor.
command-description-cmd-info =
    Devuelve un CommandSpec para el comando indicado.
    Por sí solo, esto hace que se muestre el mensaje de ayuda del comando.
command-description-comp-rm =
    Elimina el componente indicado de la entidad.

command-description-overlay-toggle = Activa o desactiva una superposición.
command-description-overlay-add = Añade una superposición si aún no existe.
command-description-overlay-remove = Elimina una superposición.

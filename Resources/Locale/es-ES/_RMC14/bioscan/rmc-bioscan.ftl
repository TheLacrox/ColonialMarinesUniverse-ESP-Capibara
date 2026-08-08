rmc-bioscan-ares-announcement = [color=white][font size=16][bold]APOLLO MK.II - Estado del bioescaneo[/bold][/font][/color][color=red][font size=14][bold]
    {$message}[/bold][/font][/color]

rmc-bioscan-ares = Bioescaneo completado.

  Los sensores detectan { $shipUncontained ->
    [0] ninguna
    *[other] {$shipUncontained}
  } { $shipUncontained ->
    [0] señal
    [1] señal
    *[other] señales
  } de formas de vida desconocidas en la nave{ $shipLocation ->
    [none] {""}
    *[other], incluida una en {$shipLocation},
  } y { $onPlanet ->
    [0] ninguna
    *[other] aproximadamente {$onPlanet}
  } { $onPlanet ->
    [0] señal
    [1] señal
    *[other] señales
  } en otros lugares{ $planetLocation ->
    [none].
    *[other], incluida una en {$planetLocation}.
  }

rmc-bioscan-xeno-announcement = [color=#318850][font size=14][bold]La Reina Madre alcanza vuestra mente desde mundos lejanos.
   {$message}[/bold][/font][/color]

rmc-bioscan-xeno = A mis hijos y a su Reina: percibo { $onShip ->
    [0] ningún huésped
    [1] aproximadamente 1 huésped
    *[other] aproximadamente {$onShip} huéspedes
  } en la colmena de metal{ $shipLocation ->
    [none] {""}
    *[other], incluido uno en {$shipLocation},
  } y {$onPlanet ->
    [0] ninguno más
    *[other] {$onPlanet} dispersos en otros lugares
  }{$planetLocation ->
    [none].
    *[other], incluido uno en {$planetLocation}.
  }

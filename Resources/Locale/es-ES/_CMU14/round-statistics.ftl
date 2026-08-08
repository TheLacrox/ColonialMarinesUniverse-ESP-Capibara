cmu-round-statistics-window-title = Resultados de rondas de CMU
cmu-round-statistics-header-title = Resultados operativos
cmu-round-statistics-waiting = Esperando datos
cmu-round-statistics-refresh = Actualizar
cmu-round-statistics-tab-overview = Resumen
cmu-round-statistics-tab-recent-rounds = Rondas recientes
cmu-round-statistics-summary = { $total } finales registrados · { $decided } victorias decididas
cmu-round-statistics-no-tracked-rounds = Todavía no hay rondas registradas.

cmu-round-statistics-mode-summary = Finales registrados: { $total } · victorias decididas: { $decided } · empates: { $draws } · sin resolver: { $unknown }
cmu-round-statistics-wins = { $count ->
    [one] 1 victoria
   *[other] { $count } victorias
}
cmu-round-statistics-draws = Empates
cmu-round-statistics-unknown = Sin resolver
cmu-round-statistics-excluded = fuera de la tasa de victoria
cmu-round-statistics-recent-ten = Últimas 10
cmu-round-statistics-tracked = { $count ->
    [one] 1 final registrado
   *[other] { $count } finales registrados
}
cmu-round-statistics-current-streak = Racha actual
cmu-round-statistics-longest-streak = Racha más larga
cmu-round-statistics-decided-endings = finales con victoria
cmu-round-statistics-average-duration = Duración media
cmu-round-statistics-no-data = Sin datos
cmu-round-statistics-none = Sin racha
cmu-round-statistics-streak = { $winner } ×{ $count }

cmu-round-statistics-recent-form = Resultados recientes
cmu-round-statistics-recent-form-record = { $sideA } { $winsA } · { $sideB } { $winsB }
cmu-round-statistics-no-recent-rounds = No hay rondas recientes

cmu-round-statistics-outcome-breakdown = Desglose de resultados
cmu-round-statistics-no-outcomes = No se han registrado resultados para este modo.
cmu-round-statistics-outcome-detail = { $winner } · { $rate } de los finales
cmu-round-statistics-manual-ending-reasons = Motivos de finalización manual
cmu-round-statistics-manual-detail = { $rate } de las finalizaciones manuales
cmu-round-statistics-distress-split = Resultados mayores y menores de Señal de socorro
cmu-round-statistics-share-of-endings = { $rate } de los finales

cmu-round-statistics-threat-breakdown = Desglose por amenaza
cmu-round-statistics-planet-breakdown = Desglose por planeta
cmu-round-statistics-average-suffix =  · media { $duration }
cmu-round-statistics-platoon-matchups = Enfrentamientos entre pelotones
cmu-round-statistics-matchup = { $govfor } contra { $opfor }
cmu-round-statistics-player-count-bands = Franjas de población
cmu-round-statistics-player-band = { $band } jugadores
cmu-round-statistics-versus-summary = { $sideA } { $rateA } ({ $winsA }) · { $sideB } { $rateB } ({ $winsB })
cmu-round-statistics-draws-suffix =  · empates: { $count }
cmu-round-statistics-unknown-suffix =  · sin resolver: { $count }

cmu-round-statistics-manual-reason = Motivo manual
cmu-round-statistics-recorded-source = Origen registrado
cmu-round-statistics-round-title = Ronda #{ $round } · { $preset } · { $winner }
cmu-round-statistics-source-detail = { $label }: { $source }
cmu-round-statistics-no-threat = sin amenaza registrada
cmu-round-statistics-no-planet = sin planeta registrado
cmu-round-statistics-round-metadata = { $players } jugadores · { $duration } · { $threat } · { $planet } · { $time } UTC
cmu-round-statistics-threat-unknown = Amenaza sin catalogar
cmu-round-statistics-planet-unknown = Planeta sin catalogar
cmu-round-statistics-platoon-unknown = Pelotón sin catalogar

cmu-round-statistics-preset = { $preset ->
    [DistressSignal] Señal de socorro
    [Insurgency] Insurgencia
    [ColonyFall] Caída de la colonia
   *[other] Modo sin identificar
}
cmu-round-statistics-winner = { $winner ->
    [Xeno] Xenos
    [Govfor] GOVFOR
    [Clf] CLF
    [Colonists] Colonos
    [Threat] Amenaza
    [Draw] Empate
   *[other] Sin determinar
}
cmu-round-statistics-outcome = { $outcome ->
    [XenoMajorHijackWin] Victoria xeno mayor: secuestro de la nave
    [XenoMinorHijackLoss] Victoria xeno menor: secuestro de la nave y eliminación posterior
    [MarineMinorHiveCollapse] Victoria marine menor: colapso de la colmena
    [MarineMajorXenoWipe] Victoria marine mayor: eliminación xeno antes del secuestro
    [DrawAlmayerAutodestruct] Empate: autodestrucción de la Almayer
    [InsurgencyClfVictory] Victoria de la CLF
    [InsurgencyGovforVictory] Victoria de GOVFOR
    [ColonyFallThreatVictory] Victoria de la amenaza
    [ColonyFallSurvivorVictory] Victoria de los colonos
    [Stalemate] Punto muerto
    [ObjectiveVictory] Victoria por objetivos
   *[other] Resultado desconocido o finalización manual
}
cmu-round-statistics-faction = { $faction ->
    [govfor] GOVFOR
    [opfor] OPFOR
    [clf] CLF
    [colony] Colonos
    [threat] Amenaza
    [xeno] Xenos
   *[other] Facción sin identificar
}
cmu-round-statistics-source-withdrawal = Retirada mediante la consola: { $faction }
cmu-round-statistics-source-objective = Objetivo de AU: { $faction }
cmu-round-statistics-source = { $source ->
    [MajorXenoVictory] Resultado automático: victoria xeno mayor
    [MinorXenoVictory] Resultado automático: victoria xeno menor
    [MinorMarineVictory] Resultado automático: victoria marine menor
    [MajorMarineVictory] Resultado automático: victoria marine mayor
    [AllDied] Resultado automático: todas las fuerzas fueron eliminadas
    [KillAllGovforRule] Eliminación de las fuerzas gubernamentales
    [KillAllClfRule] Eliminación de las fuerzas de la CLF
    [KillAllColonistRule] Eliminación de los colonos
    [KillAllHumanRule] Eliminación de las fuerzas humanas
    [ThreatSurviveRule] Supervivencia de la amenaza
    [HiveCollapseRule] Colapso de la colmena
    [KillAllAbominationsRule] Eliminación de las abominaciones
    [KillAllApeRule] Eliminación de los simios
    [KillAllTribeRule] Eliminación de los guerreros tribales
    [KillAllXenoRule] Eliminación de los xenos
    [KillAllYautjaRule] Eliminación de los Yautja
    [WithdrawConsoleStalemate] Punto muerto declarado mediante la consola de retirada
    [NoPendingOutcome] No se registró ningún resultado antes del final de la ronda
    [Unknown] Origen desconocido
   *[other] Origen heredado o administrativo
}

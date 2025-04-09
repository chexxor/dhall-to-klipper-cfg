let KlipperConfig = ../klipperConfig.dhall

let Prelude =
    { Text = https://prelude.dhall-lang.org/Text/package.dhall
    , Natural = https://prelude.dhall-lang.org/Natural/package.dhall
    , Optional = https://prelude.dhall-lang.org/Optional/package.dhall
    , Double = https://prelude.dhall-lang.org/Double/package.dhall
    }

-- The delta_calibrate section enables a DELTA_CALIBRATE extended
-- g-code command that can calibrate the shoulder endstop positions.
let DeltaCalibrateConfig =
    { Type =
        { radius : Double
        , speed : Optional Natural
        , horizontal_move_z : Optional Natural
        }
    , default =
        { speed = None Natural
        , horizontal_move_z = None Natural
        }
    }

let DeltaCalibrateConfigText : Type =
    { radius : Optional Text
    , speed : Optional Text
    , horizontal_move_z : Optional Text
    }

let toDeltaCalibrateConfigText
    : DeltaCalibrateConfig.Type -> DeltaCalibrateConfigText
    = \(deltaCalibrateConfig : DeltaCalibrateConfig.Type) ->
    { radius = Some (Prelude.Double.show deltaCalibrateConfig.radius)
    , speed = Prelude.Optional.map Natural Text Prelude.Natural.show deltaCalibrateConfig.speed
    , horizontal_move_z = Prelude.Optional.map Natural Text Prelude.Natural.show deltaCalibrateConfig.horizontal_move_z
    }

let toKlipperConfigSection
    : DeltaCalibrateConfig.Type -> List KlipperConfig.KlipperConfigSection
    = \(deltaCalibrateConfig : DeltaCalibrateConfig.Type) ->
    let configText = toDeltaCalibrateConfigText deltaCalibrateConfig
    in [ { name = "delta_calibrate"
        , prefix = None Text
        , properties = [ { mapKey = "radius", mapValue = configText.radius }
                      , { mapKey = "speed", mapValue = configText.speed }
                      , { mapKey = "horizontal_move_z", mapValue = configText.horizontal_move_z }
                      ]
        }]

in  { DeltaCalibrateConfig = DeltaCalibrateConfig
    , toKlipperConfigSection = toKlipperConfigSection
    }

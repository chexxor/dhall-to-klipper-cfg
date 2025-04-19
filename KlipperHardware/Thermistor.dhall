let Prelude =
    { Text = https://prelude.dhall-lang.org/Text/package.dhall
    , Natural = https://prelude.dhall-lang.org/Natural/package.dhall
    , Double = https://prelude.dhall-lang.org/Double/package.dhall
    , Bool = https://prelude.dhall-lang.org/Bool/package.dhall
    , Optional = https://prelude.dhall-lang.org/Optional/package.dhall
    }
let KlipperConfig = ./../KlipperConfig.dhall
let PT100 = ./thermistor/pt100.dhall
let ThermistorType = ./thermistor/Type.dhall

-- let HeaterType =
--     { Type = ThermistorType
--     , default =
--         { pin = None KlipperConfig.McuPinInput.Type
--         , type = "pt100"
--         , sensor_type = "PT100"
--         }
--     }

let toKlipperConfigSection
    : ThermistorType
    → List KlipperConfig.KlipperConfigSection
    = \(thermistor : ThermistorType) ->
        merge {
            PT100 = \(pt100 : PT100.PT100.Type) ->
                PT100.toKlipperConfigSection
                    { name = "Undefined"
                    , pt100 = pt100
                    }
            }
            thermistor

in  { toKlipperConfigSection = toKlipperConfigSection
    , ThermistorType = ThermistorType
    , PT100 = PT100
    }
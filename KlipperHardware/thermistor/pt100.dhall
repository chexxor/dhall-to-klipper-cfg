
let KlipperConfig = ./../../KlipperConfig.dhall
let Prelude = https://prelude.dhall-lang.org/package.dhall

let PT100 =
    { Type =
        { type : Text -- what is this?
        , sensor_type : Text
        }
    , default =
        { type = "pt100"
        , sensor_type = "PT100"
        }
    }

let PT100Text =
    { type : Optional Text
    , sensor_type : Optional Text
    }

let toPT100Text
    : PT100.Type -> PT100Text
    = \(pt100 : PT100.Type) ->
    { type = Some pt100.type
    , sensor_type = Some pt100.sensor_type
    }

let NamedPT100 : Type =
    { name : Text
    , pt100 : PT100.Type
    }

let toKlipperConfigSection
    : NamedPT100 -> List KlipperConfig.KlipperConfigSection
    = \(namedPT100 : NamedPT100) ->
        [{ name = "temperature_sensor"
        , prefix = Some (namedPT100.name)
        , properties = toMap (toPT100Text namedPT100.pt100)
        }]

in  { NamedPT100 = NamedPT100
    , PT100 = PT100
    , toKlipperConfigSection = toKlipperConfigSection
    , toPT100Text = toPT100Text
    }

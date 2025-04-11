let KlipperConfig = ../klipperConfig.dhall

let Prelude =
    { Text = https://prelude.dhall-lang.org/Text/package.dhall
    , Natural = https://prelude.dhall-lang.org/Natural/package.dhall
    , Optional = https://prelude.dhall-lang.org/Optional/package.dhall
    }

let McuConfig =
    { Type =
        { serial : Text
        , baud : Optional Natural
        , canbus_uuid : Optional Text
        , canbus_interface : Optional Text
        , restart_method : Optional Text
        }
    , default =
        { baud = None Natural
        , canbus_uuid = None Text
        , canbus_interface = None Text
        , restart_method = None Text
        }
    }

let McuConfigText =
    { serial : Optional Text
    , baud : Optional Text
    , canbus_uuid : Optional Text
    , canbus_interface : Optional Text
    , restart_method : Optional Text
    }

let toMcuConfigText
    : McuConfig.Type -> McuConfigText
    = \(mcuConfig : McuConfig.Type) ->
    { serial = Some mcuConfig.serial
    , baud = Prelude.Optional.map Natural Text Prelude.Natural.show mcuConfig.baud
    , canbus_uuid = mcuConfig.canbus_uuid
    , canbus_interface = mcuConfig.canbus_interface
    , restart_method = mcuConfig.restart_method
    }

let NamedMcu : Type =
    { name : Optional Text
    , mcu : McuConfig.Type
    }

let toKlipperConfigSection
    : NamedMcu -> List KlipperConfig.KlipperConfigSection
    = \(namedMcu : NamedMcu) ->
    [ { name = "mcu"
    , prefix = namedMcu.name
    , properties = toMap (toMcuConfigText namedMcu.mcu)
    } ]

in  { McuConfig = McuConfig
    , NamedMcu = NamedMcu
    , toKlipperConfigSection = toKlipperConfigSection
    }
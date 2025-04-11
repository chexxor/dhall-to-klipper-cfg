let KlipperConfig = ../klipperConfig.dhall

let Prelude =
    { Text = https://prelude.dhall-lang.org/Text/package.dhall
    , Natural = https://prelude.dhall-lang.org/Natural/package.dhall
    , Optional = https://prelude.dhall-lang.org/Optional/package.dhall
    , Double = https://prelude.dhall-lang.org/Double/package.dhall
    , Bool = https://prelude.dhall-lang.org/Bool/package.dhall
    }

let FanConfig =
    { Type =
        { pin : Text
        , max_power : Optional Double
        , shutdown_speed : Optional Double
        , cycle_time : Optional Double
        , hardware_pwm : Optional Bool
        , kick_start_time : Optional Double
        , off_below : Optional Double
        , tachometer_pin : Optional Text
        , tachometer_ppr : Optional Natural
        , tachometer_poll_interval : Optional Double
        , enable_pin : Optional Text
        }
    , default =
        { max_power = None Double
        , shutdown_speed = None Double
        , cycle_time = None Double
        , hardware_pwm = None Bool
        , kick_start_time = None Double
        , off_below = None Double
        , tachometer_pin = None Text
        , tachometer_ppr = None Natural
        , tachometer_poll_interval = None Double
        , enable_pin = None Text
        }
    }

let FanConfigText =
    { pin : Optional Text
    , max_power : Optional Text
    , shutdown_speed : Optional Text
    , cycle_time : Optional Text
    , hardware_pwm : Optional Text
    , kick_start_time : Optional Text
    , off_below : Optional Text
    , tachometer_pin : Optional Text
    , tachometer_ppr : Optional Text
    , tachometer_poll_interval : Optional Text
    , enable_pin : Optional Text
    }

let toFanConfigText
    : FanConfig.Type -> FanConfigText
    = \(fanConfig : FanConfig.Type) ->
    { pin = Some fanConfig.pin
    , max_power = Prelude.Optional.map Double Text Prelude.Double.show fanConfig.max_power
    , shutdown_speed = Prelude.Optional.map Double Text Prelude.Double.show fanConfig.shutdown_speed
    , cycle_time = Prelude.Optional.map Double Text Prelude.Double.show fanConfig.cycle_time
    , hardware_pwm = Prelude.Optional.map Bool Text Prelude.Bool.show fanConfig.hardware_pwm
    , kick_start_time = Prelude.Optional.map Double Text Prelude.Double.show fanConfig.kick_start_time
    , off_below = Prelude.Optional.map Double Text Prelude.Double.show fanConfig.off_below
    , tachometer_pin = fanConfig.tachometer_pin
    , tachometer_ppr = Prelude.Optional.map Natural Text Prelude.Natural.show fanConfig.tachometer_ppr
    , tachometer_poll_interval = Prelude.Optional.map Double Text Prelude.Double.show fanConfig.tachometer_poll_interval
    , enable_pin = fanConfig.enable_pin
    }

let toKlipperConfigSection
    : FanConfig.Type -> List KlipperConfig.KlipperConfigSection
    = \(fanConfig : FanConfig.Type) ->
    [{ name = "fan"
    , prefix = None Text
    , properties = toMap (toFanConfigText fanConfig)
    }]

in  { FanConfig = FanConfig
    , toKlipperConfigSection = toKlipperConfigSection
    }
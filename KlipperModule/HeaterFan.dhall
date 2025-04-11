let KlipperConfig = ../klipperConfig.dhall

let HeaterFanConfig =
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
        , heater : Optional Text
        , heater_temp : Optional Double
        , fan_speed : Optional Double
      }
    , default =
        {
        }
    }

let NamedHeaterFan : Type =
    { name : Optional Text
    , heaterFan : HeaterFanConfig.Type
    }

let toKlipperConfigSection
    : NamedHeaterFan -> KlipperConfig.KlipperConfigSection
    = \(namedHeaterFan : NamedHeaterFan) ->
    KlipperConfig.KlipperConfigSection
        { name = "heater_fan"
        , prefix = namedHeaterFan.name
        , properties = namedHeaterFan.heaterFan.toMap
        }

in  { HeaterFanConfig = HeaterFanConfig
    , NamedHeaterFan = NamedHeaterFan
    , toKlipperConfigSection = toKlipperConfigSection
    }
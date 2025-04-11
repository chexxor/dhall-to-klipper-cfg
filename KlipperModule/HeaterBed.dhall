let KlipperConfig = ../klipperConfig.dhall

let Prelude =
    { Text = https://prelude.dhall-lang.org/Text/package.dhall
    , Natural = https://prelude.dhall-lang.org/Natural/package.dhall
    , Optional = https://prelude.dhall-lang.org/Optional/package.dhall
    , Double = https://prelude.dhall-lang.org/Double/package.dhall
    }

let HeaterBedConfig =
    { Type =
        { heater_pin : Text
        , sensor_type : Text
        , sensor_pin : Text
        , control : Text
        , min_temp : Double
        , max_temp : Double
        , pid_Kp : Optional Double
        , pid_Ki : Optional Double
        , pid_Kd : Optional Double
        }
    , default =
        { pid_Kp = None Double
        , pid_Ki = None Double
        , pid_Kd = None Double
        }
    }

let HeaterBedConfigText =
    { heater_pin : Optional Text
    , sensor_type : Optional Text
    , sensor_pin : Optional Text
    , control : Optional Text
    , min_temp : Optional Text
    , max_temp : Optional Text
    , pid_Kp : Optional Text
    , pid_Ki : Optional Text
    , pid_Kd : Optional Text
    }

let toHeaterBedConfigText
    : HeaterBedConfig.Type -> HeaterBedConfigText
    = \(heaterBed : HeaterBedConfig.Type) ->
        { heater_pin = Some heaterBed.heater_pin
        , sensor_type = Some heaterBed.sensor_type
        , sensor_pin = Some heaterBed.sensor_pin
        , control = Some heaterBed.control
        , min_temp = Some (Prelude.Double.show heaterBed.min_temp)
        , max_temp = Some (Prelude.Double.show heaterBed.max_temp)
        , pid_Kp = Prelude.Optional.map Double Text Prelude.Double.show heaterBed.pid_Kp
        , pid_Ki = Prelude.Optional.map Double Text Prelude.Double.show heaterBed.pid_Ki
        , pid_Kd = Prelude.Optional.map Double Text Prelude.Double.show heaterBed.pid_Kd
        }

let toKlipperConfigSection
    : HeaterBedConfig.Type -> List KlipperConfig.KlipperConfigSection
    = \(heaterBed : HeaterBedConfig.Type) ->
        [{ name = "heater_bed"
        , prefix = None Text
        , properties = toMap (toHeaterBedConfigText heaterBed)
        }]

in  { HeaterBedConfig = HeaterBedConfig
    , toKlipperConfigSection = toKlipperConfigSection
    }
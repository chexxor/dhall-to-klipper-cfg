let Types = ./../types.dhall
let HeaterBedModule = ./../../KlipperModule/HeaterBed.dhall
let KlipperConfig = ./../../KlipperConfig.dhall
let Thermistor = ./../Thermistor.dhall


-- let HeaterBedConfig =
--     { Type =
--         { heater_pin : KlipperConfig.McuPinOutput.Type
--         , sensor_type : Text
--         , sensor_pin : KlipperConfig.McuPinInput.Type
--         , control : Text
--         , min_temp : Double
--         , max_temp : Double
--         , pid_Kp : Optional Double
--         , pid_Ki : Optional Double
--         , pid_Kd : Optional Double
--         }
--     , default =
--         { control = "pid"
--         , min_temp = 0.0
--         , max_temp = 120.0
--         , pid_Kp = None Double
--         , pid_Ki = None Double
--         , pid_Kd = None Double
--         }
--     }

-- let toKlipperConfigSection
--     : HeaterBedConfig.Type
--     -> KlipperConfig.KlipperConfigSection
--     = \(heaterBedConfig : HeaterBedConfig.Type) ->
--     KlipperConfig.KlipperConfigSection::
--         { heater_bed = heaterBedConfig
--         }

-- let HeaterBed = HeaterBedModule.HeaterBedConfig::
--     { heater_pin = "heater_bed"
--     , sensor_type = "PT1000"
--     , sensor_pin = "sensor_bed"
--     , control = "pid"
--     , min_temp = 0.0
--     , max_temp = 120.0
--     }

-- Make a heater bed config connected to the specified MCU
-- using the specified thermistor.
let makeHeaterBed
    : Types.MCU.Type
    -> Thermistor.ThermistorType
    -> HeaterBedModule.HeaterBedConfig.Type
    =
    \(mcu : Types.MCU.Type)
    -> \(thermistor : Thermistor.ThermistorType)
    ->
    let sensorTypeText = merge
        { PT100 = \(pt100 : Thermistor.PT100.PT100.Type) -> pt100.sensor_type
        } thermistor
    in HeaterBedModule.HeaterBedConfig::
        { heater_pin = mcu.bed.heater_pin
        , sensor_pin = mcu.bed.sensor_pin
        , sensor_type = sensorTypeText
    }


in
    { HeaterBed = HeaterBedModule.HeaterBedConfig.Type
    , makeHeaterBed = makeHeaterBed
    }
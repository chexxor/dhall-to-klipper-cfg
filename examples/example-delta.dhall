let KlipperConfig = ../klipperConfig.dhall
let PrinterModule = ./../KlipperConfigModule/Printer.dhall
let StepperModule = ./../KlipperConfigModule/Stepper.dhall
let HeaterBedModule = ./../KlipperConfigModule/HeaterBed.dhall
let ExtruderModule = ./../KlipperConfigModule/Extruder.dhall
let FanModule = ./../KlipperConfigModule/Fan.dhall
let McuModule = ./../KlipperConfigModule/Mcu.dhall
let DeltaCalibrateModule = ./../KlipperConfigModule/DeltaCalibrate.dhall


let printer = PrinterModule.toKlipperConfigSection
    { printer = PrinterModule.Printer::
        { kinematics = PrinterModule.Kinematics.Delta
        , max_velocity = 300
        , max_accel = 3000
        , max_z_velocity = Some 150
        , delta_radius = Some 174.75
        }
    , stepper_1 =
        { name = "stepper_a"
        , stepper = StepperModule.StepperConfig::
            { step_pin = "PF0"
            , dir_pin = "PF1"
            , enable_pin = Some "!PD7"
            , microsteps = 16
            , rotation_distance = 40.0
            , endstop_pin = Some "^PE4"
            , homing_speed = Some 50
            , position_endstop = Some 297.05
            , arm_length = Some 333.0
            }
        }
    , stepper_2 =
        { name = "stepper_b"
        , stepper = StepperModule.StepperConfig::
            { step_pin = "PF6"
            , dir_pin = "PF7"
            , enable_pin = Some "!PD2"
            , microsteps = 16
            , rotation_distance = 40.0
            , endstop_pin = Some "^PJ0"
            }
        }
    , stepper_3 =
        { name = "stepper_c"
        , stepper = StepperModule.StepperConfig::
            { step_pin = "PL3"
            , dir_pin = "PL1"
            , enable_pin = Some "!PK0"
            , microsteps = 16
            , rotation_distance = 40.0
            , endstop_pin = Some "^PD2"
            }
        }
    }

let heaterBed = HeaterBedModule.toKlipperConfigSection HeaterBedModule.HeaterBedConfig::
    { heater_pin = "PH5"
    , sensor_type = "EPCOS 100K B57560G104F"
    , sensor_pin = "PK6"
    , control = "watermark"
    , min_temp = 0.0
    , max_temp = 130.0
    }


let extruder = ExtruderModule.toKlipperConfigSection
    { name = "extruder"
    , extruder = ExtruderModule.ExtruderConfig::
        { step_pin = "PA4"
        , dir_pin = "PA6"
        , enable_pin = Some "!PA2"
        , microsteps = 16
        , rotation_distance = 33.500
        , nozzle_diameter = 0.400
        , filament_diameter = 1.750
        , heater_pin = "PB4"
        , sensor_type = "ATC Semitec 104GT-2"
        , sensor_pin = "PK5"
        , control = "pid"
        , pid_Kp = Some 22.2
        , pid_Ki = Some 1.08
        , pid_Kd = Some 114.0
        , min_temp = 0
        , max_temp = 250
        }
    }

let fan = FanModule.toKlipperConfigSection FanModule.FanConfig::
    { pin = "ar28"
    , kick_start_time = Some 0.5
    , off_below = Some 0.0
    }

let mcu = McuModule.toKlipperConfigSection
    { name = None Text
    , mcu = McuModule.McuConfig::{ serial = "/dev/ttyACM0" }
    }

let extraModules
    : List KlipperConfig.KlipperConfigSection
    =
    DeltaCalibrateModule.toKlipperConfigSection DeltaCalibrateModule.DeltaCalibrateConfig::
        { radius = 50.0
        }

in KlipperConfig.renderKlipperConfig
    (printer
    # heaterBed
    # extruder
    # fan
    # mcu
    # extraModules)
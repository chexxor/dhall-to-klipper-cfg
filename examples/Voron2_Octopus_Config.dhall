let KlipperConfig = ../klipperConfig.dhall
let PrinterModule = ./../KlipperModule/Printer.dhall
let StepperModule = ./../KlipperModule/Stepper.dhall
let HeaterBedModule = ./../KlipperModule/HeaterBed.dhall
let ExtruderModule = ./../KlipperModule/Extruder.dhall
let FanModule = ./../KlipperModule/Fan.dhall
let McuModule = ./../KlipperModule/Mcu.dhall
let McuHardware = ./../KlipperHardware/mcu/octopus_pro_v1.1.dhall


let mcu = McuModule.toKlipperConfigSection
    { name = None Text
    , mcu = McuModule.McuConfig::{ serial = "/dev/ttyACM0" }
    }

let stepper =
    \(name : Text)
    -> \(stepPin : KlipperConfig.McuPinOutput)
    -> \(dirPin : KlipperConfig.McuPinOutput)
    -> \(enablePin : KlipperConfig.McuPinOutput)
    -> \(endstopPin : KlipperConfig.McuPinInput)
    ->
    { name = name
    , stepper = StepperModule.StepperConfig::
        { step_pin = stepPin
        , dir_pin = dirPin
        , enable_pin = Some enablePin
        , endstop_pin = Some endstopPin
        , microsteps = 32
        , rotation_distance = 40.0
        , full_steps_per_rotation = Some 200
        , position_endstop = Some 250.0
        , position_max = Some 250.0
        }
    }

let stepperZ =
    \(name : Text)
    -> \(stepPin : KlipperConfig.McuPinOutput)
    -> \(dirPin : KlipperConfig.McuPinOutput)
    -> \(enablePin : KlipperConfig.McuPinOutput)
    -> \(endstopPin : KlipperConfig.McuPinInput)
    ->
    { name = name
    , stepper = StepperModule.StepperConfig::
        { step_pin = stepPin
        , dir_pin = dirPin
        , enable_pin = Some enablePin
        , endstop_pin = endstopPin
        , microsteps = 32
        , rotation_distance = 40.0
        , gear_ratio = Some "80:16"
        , full_steps_per_rotation = Some 200
        , position_endstop = Some -0.5
        , position_max = Some 210.0
        , position_min = Some -5.0
        , homing_speed = Some 8
        , second_homing_speed = Some 3
        , homing_retract_dist = Some 3.0
        }
    }

-- let printer = PrinterModule.toKlipperConfigSection
let printerCfg =
    { printer = PrinterModule.Printer::
        { kinematics = PrinterModule.Kinematics.CoreXY
        , max_velocity = 300
        , max_accel = 3000
        , max_z_velocity = Some 15
        , max_z_accel = Some 350
        , square_corner_velocity = Some 5.0
        }
    , stepper_1 = (stepper "stepper_x"
        McuHardware.stepper_x.step_pin
        McuHardware.stepper_x.dir_pin
        McuHardware.stepper_x.enable_pin
        McuHardware.stepper_x.endstop_pin)
    , stepper_2 = (stepper "stepper_y"
        McuHardware.stepper_y.step_pin
        McuHardware.stepper_y.dir_pin
        McuHardware.stepper_y.enable_pin
        McuHardware.stepper_y.endstop_pin)
    , stepper_3 = (stepperZ "stepper_z"
        McuHardware.stepper_z.step_pin
        ("!" ++ McuHardware.stepper_z.dir_pin)
        ("!" ++ McuHardware.stepper_z.enable_pin)
        ("!" ++ McuHardware.stepper_z.endstop_pin)
    , stepper_4 = Some (stepperZ "stepper_z1"
        McuHardware.stepper_z1.step_pin
        McuHardware.stepper_z1.dir_pin
        ("!" ++ McuHardware.stepper_z1.enable_pin)
        McuHardware.stepper_z1.endstop_pin)
    , stepper_5 = Some (stepperZ "stepper_z2"
        McuHardware.stepper_z2.step_pin
        ("!" ++ McuHardware.stepper_z2.dir_pin)
        ("!" ++ McuHardware.stepper_z2.enable_pin)
        McuHardware.stepper_z2.endstop_pin)
    , stepper_6 = Some (stepperZ "stepper_z3"
        McuHardware.stepper_z3.step_pin
        McuHardware.stepper_z3.dir_pin
        ("!" ++ McuHardware.stepper_z3.enable_pin)
        McuHardware.stepper_z3.endstop_pin)
    }

let heaterBed = HeaterBedModule.toKlipperConfigSection
    HeaterBedModule.HeaterBedConfig::
    { heater_pin = "ar26"
    , sensor_type = "PT1000"
    , sensor_pin = "ar27"
    , control = "pid"
    , min_temp = 0.0
    , max_temp = 300.0
    , pid_Kp = Some 22.2
    , pid_Ki = Some 1.08
    , pid_Kd = Some 114.0
    }

let extruder = ExtruderModule.toKlipperConfigSection
    { name = "extruder"
    , extruder = ExtruderModule.ExtruderConfig::

        { step_pin = "PE2"
        , dir_pin = "PE3"
        , enable_pin = Some "!PD4"
        , rotation_distance = 22.6789511 -- Bondtech 5mm Drive Gears
        -- Update Gear Ratio depending on your Extruder Type
        -- Use 50:10 for Stealthburner/Clockwork 2
        -- Use 50:17 for Afterburner/Clockwork (BMG Gear Ratio)
        -- Use 80:20 for M4, M3.1
        , gear_ratio = Some "50:10"
        , full_steps_per_rotation = Some 200
        , microsteps = 32
        , nozzle_diameter = 0.400
        , filament_diameter = 1.75
        -- Octopus 1.0 & 1.1.  Octopus PRO 1.0
        , heater_pin = "PA2"
        -- Octopus PRO 1.1
        --heater_pin: PA0
        -- Check what thermistor type you have. See https://www.klipper3d.org/Config_Reference.html#common-thermistors for common thermistor types.
        -- Use "Generic 3950" for NTC 100k 3950 thermistors
        , sensor_type = "Generic 3950"
        , sensor_pin = "PF4"
        , min_temp = 10
        , max_temp = 270
        , max_power = Some 1.0
        , min_extrude_temp = Some 170
        , control = "pid"
        , pid_Kp = Some 26.213
        , pid_Ki = Some 1.304
        , pid_Kd = Some 131.721
        -- Try to keep pressure_advance below 1.0
        , pressure_advance = Some 0.05
        -- Default is 0.040, leave stock
        , pressure_advance_smooth_time = Some 0.040
        }
    }

let fan = FanModule.toKlipperConfigSection FanModule.FanConfig::
    { pin = "PA8"
    , kick_start_time = Some 0.5
    , off_below = Some 0.10
    }

in KlipperConfig.renderKlipperConfig
    (printer
    # heaterBed
    # extruder
    # fan
    )
let Prelude = https://prelude.dhall-lang.org/package.dhall
let KlipperConfig = ../klipperConfig.dhall
let PrinterModule = ./../KlipperModule/Printer.dhall
let StepperModule = ./../KlipperModule/Stepper.dhall
let HeaterBedModule = ./../KlipperModule/HeaterBed.dhall
let ExtruderModule = ./../KlipperModule/Extruder.dhall
let FanModule = ./../KlipperModule/Fan.dhall
let McuModule = ./../KlipperModule/Mcu.dhall
let StepperDriverModule = ./../KlipperModule/StepperDriver.dhall
let StepperDriverHardware = ./../KlipperHardware/StepperDriver.dhall
let McuHardware = ./../KlipperHardware/mcu/octopus_pro_v1.1.dhall
let KlipperHardware = ./../KlipperHardware/types.dhall
let BedHeaterHardware = ./../KlipperHardware/heater/bed.dhall
let StepperHardware = ./../KlipperHardware/stepper/constructor.dhall
let StepperType = ./../KlipperModule/StepperType.dhall
let HardwareTypes = ./../KlipperHardware/types.dhall
let TMC2209Hardware = ./../KlipperHardware/StepperDriver/TMC2209.dhall

let mcu = McuModule.toKlipperConfigSection
    { name = None Text
    , mcu = McuModule.McuConfig::{ serial = "/dev/ttyACM0" }
    }

let stepper
    : Text
    -> HardwareTypes.StepperConnector.Type
    -> StepperType.Type
    = \(name : Text)
    -> \(stepperConnector : HardwareTypes.StepperConnector.Type)
    -> StepperHardware.stepperConfigFromMcuHardware
        -- MCU Stepper
        stepperConnector
        -- Stepper Angle
        StepperHardware.StepperAngle.OnePointEightDegrees

let stepperDriver
    : HardwareTypes.StepperConnector.Type
    -> StepperDriverModule.StepperDriver
    = \(stepperConnector : HardwareTypes.StepperConnector.Type)
    -> TMC2209Hardware.stepperDriverConfigFromMcuHardware stepperConnector

let namedStepper
    : Text
    -> HardwareTypes.StepperConnector.Type
    -> StepperModule.NamedStepper
    = \(name : Text)
    -> \(stepperConnector : HardwareTypes.StepperConnector.Type)
    ->
    { name = name
    , stepper = stepper name stepperConnector
    , stepper_driver = stepperDriver stepperConnector
    }

let stepperZ
    : Text
    -> HardwareTypes.StepperConnector.Type
    -> StepperModule.NamedStepper
    = \(name : Text)
    -> \(stepperConnector : HardwareTypes.StepperConnector.Type)
    -> namedStepper name stepperConnector

let stepperX = namedStepper "stepper_x" McuHardware.stepper_x
    -- // {
    --     stepper =
    --         { position_endstop = Some 250.0
    --         , position_max = Some 250.0
    --         }
    --     , stepper_driver =
    --         { run_current = 0.8
    --         , sense_resistor = Some 0.110
    --         , stealthchop_threshold = Some 0.0
    --         }
    --     }

let stepperY = namedStepper "stepper_y" McuHardware.stepper_y

let stepperZ0 = namedStepper "stepper_z" McuHardware.stepper_z

let stepperZ1 = Prelude.Optional.map
    KlipperHardware.StepperConnector.Type StepperModule.NamedStepper
    (\(stepper : KlipperHardware.StepperConnector.Type)
    -> stepperZ "stepper_z1" stepper)
    McuHardware.stepper_z1

let stepperZ2 = Prelude.Optional.map
    KlipperHardware.StepperConnector.Type StepperModule.NamedStepper
    (\(stepper : KlipperHardware.StepperConnector.Type)
    -> stepperZ "stepper_z2" stepper)
    McuHardware.stepper_z2

let stepperZ3 = Prelude.Optional.map
    KlipperHardware.StepperConnector.Type StepperModule.NamedStepper
    (\(stepper : KlipperHardware.StepperConnector.Type)
    -> stepperZ "stepper_z3" stepper)
    McuHardware.stepper_z3

let printer = PrinterModule.toKlipperConfigSection
    { printer = PrinterModule.Printer::
        { kinematics = PrinterModule.Kinematics.CoreXY
        , max_velocity = 300
        , max_accel = 3000
        , max_z_velocity = Some 15
        , max_z_accel = Some 350
        , square_corner_velocity = Some 5.0
        }
    , stepper_1 = stepperX
    , stepper_2 = stepperY
    , stepper_3 = stepperZ0
    , stepper_4 = stepperZ1
    , stepper_5 = stepperZ2
    , stepper_6 = stepperZ3
    }

let ThermistorModule = ../KlipperHardware/Thermistor.dhall
let PT100 = ../KlipperHardware/thermistor/pt100.dhall

let heaterBed =
    HeaterBedModule.toKlipperConfigSection
        (BedHeaterHardware.makeHeaterBed
            McuHardware
            (ThermistorModule.ThermistorType.PT100 ThermistorModule.PT100.PT100.default)
        )

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
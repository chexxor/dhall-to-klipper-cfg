let Prelude = https://prelude.dhall-lang.org/package.dhall
let KlipperConfig = ../klipperConfig.dhall
let PrinterModule = ./../KlipperModule/Printer.dhall
let StepperModule = ./../KlipperModule/Stepper.dhall
let HeaterBedModule = ./../KlipperModule/HeaterBed.dhall
let ExtruderModule = ./../KlipperModule/Extruder.dhall
let FanModule = ./../KlipperModule/Fan.dhall
let McuModule = ./../KlipperModule/Mcu.dhall
let McuHardware = ./../KlipperHardware/mcu/octopus_pro_v1.1.dhall
let KlipperHardware = ./../KlipperHardware/types.dhall
let StepperDriverModule = ./../KlipperModule/StepperDriver.dhall

let mcu = McuModule.toKlipperConfigSection
    { name = None Text
    , mcu = McuModule.McuConfig::{ serial = "/dev/ttyACM0" }
    }

let stepper
    : { name : Text
    , step_pin : KlipperConfig.McuPinOutput.Type
    , dir_pin : KlipperConfig.McuPinOutput.Type
    , enable_pin : Optional KlipperConfig.McuPinOutput.Type
    , endstop_pin : Optional KlipperConfig.McuPinInput.Type
    , uart_pin : Optional KlipperConfig.McuPinOutput.Type
    }
    -> StepperModule.NamedStepper
    =
    \(params : { name : Text
               , step_pin : KlipperConfig.McuPinOutput.Type
               , dir_pin : KlipperConfig.McuPinOutput.Type
               , enable_pin : Optional KlipperConfig.McuPinOutput.Type
               , endstop_pin : Optional KlipperConfig.McuPinInput.Type
               , uart_pin : Optional KlipperConfig.McuPinOutput.Type
               })
    ->
    { name = params.name
    , stepper = StepperModule.StepperConfig::
        { step_pin = params.step_pin
        , dir_pin = params.dir_pin
        , enable_pin = params.enable_pin
        , endstop_pin = params.endstop_pin
        , microsteps = 32
        , rotation_distance = 40.0
        , full_steps_per_rotation = Some 200
        , position_endstop = Some 250.0
        , position_max = Some 250.0
        }
    , stepper_driver = StepperDriverModule.StepperDriver.TMC2209 StepperDriverModule.TMC2209.TMC2209::
        { uart_pin = Prelude.Optional.default KlipperConfig.McuPinOutput.Type
            KlipperConfig.McuPinOutput::{
                hardware_name = "mcu_has_no_uart_pin"
            }
            params.uart_pin
        , interpolate = Some False
        , run_current = 0.8
        , sense_resistor = Some 0.110
        , stealthchop_threshold = Some 0.0
        }
    }

let stepperZ
    : { name : Text
    , step_pin : KlipperConfig.McuPinOutput.Type
    , dir_pin : KlipperConfig.McuPinOutput.Type
    , enable_pin : Optional KlipperConfig.McuPinOutput.Type
    , endstop_pin : Optional KlipperConfig.McuPinInput.Type
    , uart_pin : Optional KlipperConfig.McuPinOutput.Type
    }
    -> StepperModule.NamedStepper
    =
    \(params : { name : Text
               , step_pin : KlipperConfig.McuPinOutput.Type
               , dir_pin : KlipperConfig.McuPinOutput.Type
               , enable_pin : Optional KlipperConfig.McuPinOutput.Type
               , endstop_pin : Optional KlipperConfig.McuPinInput.Type
               , uart_pin : Optional KlipperConfig.McuPinOutput.Type
               })
    ->
    { name = params.name
    , stepper = StepperModule.StepperConfig::
        { step_pin = params.step_pin
        , dir_pin = params.dir_pin
        , enable_pin = params.enable_pin
        , endstop_pin = params.endstop_pin
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
    , stepper_driver = StepperDriverModule.StepperDriver.TMC2209 StepperDriverModule.TMC2209.TMC2209::
        { uart_pin = Prelude.Optional.default KlipperConfig.McuPinOutput.Type
            KlipperConfig.McuPinOutput::{
                hardware_name = "mcu_has_no_uart_pin"
            }
            params.uart_pin
        , interpolate = Some False
        , run_current = 0.8
        , sense_resistor = Some 0.110
        , stealthchop_threshold = Some 0.0
        }
    }

let stepperX = stepper {
    name = "stepper_x"
    , step_pin = McuHardware.stepper_x.step_pin
    , dir_pin = McuHardware.stepper_x.dir_pin
    , enable_pin = McuHardware.stepper_x.enable_pin
    , endstop_pin = McuHardware.stepper_x.endstop_pin
    , uart_pin = McuHardware.stepper_x.uart_pin
}

let stepperY = stepper {
    name = "stepper_y"
    , step_pin = McuHardware.stepper_y.step_pin
    , dir_pin = McuHardware.stepper_y.dir_pin
    , enable_pin = McuHardware.stepper_y.enable_pin
    , endstop_pin = McuHardware.stepper_y.endstop_pin
    , uart_pin = McuHardware.stepper_y.uart_pin
}

let stepperZ0 = stepperZ {
    name = "stepper_z"
    , step_pin = McuHardware.stepper_z.step_pin
    , dir_pin = McuHardware.stepper_z.dir_pin
    , enable_pin = McuHardware.stepper_z.enable_pin
    , endstop_pin = McuHardware.stepper_z.endstop_pin
    , uart_pin = McuHardware.stepper_z.uart_pin
}

let stepperZ1 = Prelude.Optional.map
    KlipperHardware.StepperConnector.Type StepperModule.NamedStepper
    (\(stepper : KlipperHardware.StepperConnector.Type)
    -> stepperZ {
        name = "stepper_z1"
        , step_pin = stepper.step_pin
        , dir_pin = stepper.dir_pin
        , enable_pin = stepper.enable_pin
        , endstop_pin = stepper.endstop_pin
        , uart_pin = stepper.uart_pin
    })
    McuHardware.stepper_z1

let stepperZ2 = Prelude.Optional.map
    KlipperHardware.StepperConnector.Type StepperModule.NamedStepper
    (\(stepper : KlipperHardware.StepperConnector.Type)
    -> stepperZ {
        name = "stepper_z2"
        , step_pin = stepper.step_pin
        , dir_pin = stepper.dir_pin
        , enable_pin = stepper.enable_pin
        , endstop_pin = stepper.endstop_pin
        , uart_pin = stepper.uart_pin
    })
    McuHardware.stepper_z2

let stepperZ3 = Prelude.Optional.map
    KlipperHardware.StepperConnector.Type StepperModule.NamedStepper
    (\(stepper : KlipperHardware.StepperConnector.Type)
    -> stepperZ {
        name = "stepper_z3"
        , step_pin = stepper.step_pin
        , dir_pin = stepper.dir_pin
        , enable_pin = stepper.enable_pin
        , endstop_pin = stepper.endstop_pin
        , uart_pin = stepper.uart_pin
    })
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
let Types = ./../types.dhall

-- let McuPin = {
--     hardware_name: Text,
--     reverse_polarity: Optional Bool,
--     pull_up: Optional Bool,
--     pull_down: Optional Bool,
-- }

-- let StepperInterface = {
--     step_pin: McuPin,
--     dir_pin: McuPin,
--     enable_pin: McuPin,
--     endstop_pin: McuPin
-- }

-- let ExtruderInterface = {
--     stepper: StepperInterface,
--     heater: HeaterInterface,
--     fan: FanInterface
-- }

-- let HeaterInterface = {
--     heater_pin: McuPin,
--     sensor_pin: McuPin
-- }

-- let FanInterface = {
--     pin: McuPin
-- }
-- let MCU = {
--     Type = {
--         -- Basic MCU configuration
--         serial: Text,
--         baudrate: Natural,
--         restart_method: Text,
--         -- Stepper motor pins
--         stepper_x : StepperInterface,
--         stepper_y : StepperInterface,
--         stepper_z : StepperInterface,
--         stepper_z1 : Optional StepperInterface,
--         stepper_z2 : Optional StepperInterface,
--         stepper_z3 : Optional StepperInterface,
--         -- Extruder pins
--         extruder: ExtruderInterface,
--         -- Bed pins
--         bed: HeaterInterface,
--         -- Fan pins
--         part_cooling_fan_pin: McuPin,
--         heater_cooling_fan_pin: McuPin,
--         controller_fan_pin: McuPin,
--         extra_fans: Optional (List McuPin),
--         -- Probe pins
--         probe_signal_pin: McuPin,
--         probe_servo_pin: McuPin,
        
--         neopixel_pin: Optional McuPin,
--         filament_sensor_pin: Optional McuPin,
--         power_monitor_pin: Optional McuPin,

--         -- Board pin aliases (optional)
--         pin_aliases: Optional (Map Text)
--     }
--     default = {
--         pin_aliases = None (Map Text),
--         stepper_z1 = None StepperInterface,
--         stepper_z2 = None StepperInterface,
--         stepper_z3 = None StepperInterface,
--         extra_fans = None (List McuPin),
--         pin_aliases = None (Map Text)
--     }
-- }

let OctopusProV11MCU = Types.MCU::{
    -- Basic MCU configuration
    serial: "/dev/serial/by-id/usb-Klipper_Klipper_firmware_12345-if00",
    baudrate: 250000,
    restart_method: "command",

    -- Stepper motor pins
    stepper_x : Types.StepperInterface::{
        step_pin: Types.McuPinOutput::{
            hardware_name = "PF13",
        },
        dir_pin: Types.McuPinOutput::{
            hardware_name = "PF12"
        },
        enable_pin: Some Types.McuPinOutput::{
            hardware_name = "PF14",
            reverse_polarity = True,
        },
        endstop_pin: Some Types.McuPinInput::{
            hardware_name = "PG6"
        }
    },
    stepper_y : Types.StepperInterface::{
        step_pin: Types.McuPinOutput::{
            hardware_name = "PG0",
        },
        dir_pin: Types.McuPinOutput::{
            hardware_name = "PG1"
        },
        enable_pin: Some Types.McuPinOutput::{
            hardware_name = "PF15",
            reverse_polarity = True,
        },
        endstop_pin: Some Types.McuPinInput::{
            hardware_name = "PG9"
        }
    },
    stepper_z : Types.StepperInterface::{
        step_pin: Types.McuPinOutput::{
            hardware_name = "PF11",
        },
        dir_pin: Types.McuPinOutput::{
            hardware_name = "PG3"
        },
        enable_pin: Some Types.McuPinOutput::{
            hardware_name = "PG5",
            reverse_polarity = True
        },
        endstop_pin: Some Types.McuPinInput::{
            hardware_name = "PG10"
        }
    },
    stepper_z1 : Types.StepperInterface::{
        step_pin: Types.McuPinOutput::{
            hardware_name = "PG4",
        },
        dir_pin: Types.McuPinOutput::{
            hardware_name = "PC1"
        },
        enable_pin: Some Types.McuPinOutput::{
            hardware_name = "PA2",
            reverse_polarity = True
        }
    },
    stepper_z2 : Types.StepperInterface::{
        step_pin: Types.McuPinOutput::{
            hardware_name = "PF9",
        },
        dir_pin: Types.McuPinOutput::{
            hardware_name = "PF10",
            reverse_polarity = True
        },
        enable_pin: Some Types.McuPinOutput::{
            hardware_name = "PG2",
            reverse_polarity = True
        }
    },
    stepper_z3 : Types.StepperInterface::{
        step_pin: Types.McuPinOutput::{
            hardware_name = "PC13",
        },
        dir_pin: Types.McuPinOutput::{
            hardware_name = "PF0",
        },
        enable_pin: Types.McuPinOutput::{
            hardware_name = "PG1",
            reverse_polarity = True
        }
    },
    
    -- Extruder pins
    extruder: {
        stepper: Types.StepperInterface::{
            step_pin: Types.McuPinOutput::{
                hardware_name = "PE2",
            },
            dir_pin: Types.McuPinOutput::{
                hardware_name = "PE3",
            },
            enable_pin: Some Types.McuPinOutput::{
                hardware_name = "PD4",
                reverse_polarity = True
            }
        },
        heater: Types.HeaterInterface::{
            heater_pin: Types.McuPinOutput::{
                hardware_name = "PA0",
            },
            sensor_pin: Types.McuPinInput::{
                hardware_name = "PF4",
            },
        },
        fan: Types.FanInterface::{
            pin: Types.McuPinOutput::{
                hardware_name = "PA8",
            },
        }
    },
    extruder_step_pin: "PF11",
    extruder_dir_pin: "!PG3",
    extruder_enable_pin: "!PG5",
    extruder_heater_pin: "PA2",
    extruder_sensor_pin: "PF4",
    -- Bed pins
    bed_heater_pin: "PA1",
    bed_sensor_pin: "PF3",
    -- Fan pins
    part_cooling_fan_pin: "PA8",
    heater_cooling_fan_pin: "PA0",
    controller_fan_pin: "PA3",
    -- Probe pins
    probe_signal_pin: "PC14",
    probe_servo_pin: "PC6",

    -- Optional features
    neopixel_pin: "PC7",
    filament_sensor_pin: "PG11",
    power_monitor_pin: "PC4",

    -- Display configuration
    display: Some {
        spi_bus: "spi1",
        cs_pin: "PE14",
        dc_pin: "PE13",
        reset_pin: "PE15"
    },

    -- Board pin aliases (for EXP headers)
    pin_aliases: Some {
        -- EXP1 header
        EXP1_1: "PE8",
        EXP1_3: "PE9",
        EXP1_5: "PE12",
        EXP1_7: "PE14",
        EXP1_9: "<GND>",
        EXP1_2: "PE7",
        EXP1_4: "PE10",
        EXP1_6: "PE13",
        EXP1_8: "PE15",
        EXP1_10: "<5V>",
        -- EXP2 header
        EXP2_1: "PA6",
        EXP2_3: "PB1",
        EXP2_5: "PB2",
        EXP2_7: "PC15",
        EXP2_9: "<GND>",
        EXP2_2: "PA5",
        EXP2_4: "PA4",
        EXP2_6: "PA7",
        EXP2_8: "<RST>",
        EXP2_10: "PC5"
    }
}
in OctopusProV11MCU
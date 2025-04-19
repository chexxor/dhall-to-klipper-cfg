let HardwareTypes = ./../types.dhall
let KlipperConfig = ./../../klipperConfig.dhall

let OctopusProV11MCU = HardwareTypes.MCU::{
    -- Basic MCU configuration
    serial = "/dev/serial/by-id/usb-Klipper_Klipper_firmware_12345-if00",
    baudrate = 250000,
    restart_method = "command",

    -- Stepper motor pins
    stepper_x = HardwareTypes.StepperConnector::{
        step_pin = KlipperConfig.McuPinOutput::{
            hardware_name = "PF13"
        },
        dir_pin = KlipperConfig.McuPinOutput::{
            hardware_name = "PF12"
        },
        enable_pin = Some KlipperConfig.McuPinOutput::{
            hardware_name = "PF14",
            reverse_polarity = True
        },
        endstop_pin = Some KlipperConfig.McuPinInput::{
            hardware_name = "PG6"
        },
        uart_pin = Some KlipperConfig.McuPinOutput::{
            hardware_name = "PC4"
        }
    },
    stepper_y = HardwareTypes.StepperConnector::{
        step_pin = KlipperConfig.McuPinOutput::{
            hardware_name = "PG0"
        },
        dir_pin = KlipperConfig.McuPinOutput::{
            hardware_name = "PG1"
        },
        enable_pin = Some KlipperConfig.McuPinOutput::{
            hardware_name = "PF15",
            reverse_polarity = True
        },
        endstop_pin = Some KlipperConfig.McuPinInput::{
            hardware_name = "PG9"
        },
        uart_pin = Some KlipperConfig.McuPinOutput::{
            hardware_name = "PD11"
        }
    },
    stepper_z = HardwareTypes.StepperConnector::{
        step_pin = KlipperConfig.McuPinOutput::{
            hardware_name = "PF11"
        },
        dir_pin = KlipperConfig.McuPinOutput::{
            hardware_name = "PG3"
        },
        enable_pin = Some KlipperConfig.McuPinOutput::{
            hardware_name = "PG5",
            reverse_polarity = True
        },
        endstop_pin = Some KlipperConfig.McuPinInput::{
            hardware_name = "PG10"
        },
        uart_pin = Some KlipperConfig.McuPinOutput::{
            hardware_name = "PC6"
        }
    },
    stepper_z1 = Some HardwareTypes.StepperConnector::{
        step_pin = KlipperConfig.McuPinOutput::{
            hardware_name = "PG4"
        },
        dir_pin = KlipperConfig.McuPinOutput::{
            hardware_name = "PC1"
        },
        enable_pin = Some KlipperConfig.McuPinOutput::{
            hardware_name = "PA2",
            reverse_polarity = True
        },
        uart_pin = Some KlipperConfig.McuPinOutput::{
            hardware_name = "PC7"
        }
    },
    stepper_z2 = Some HardwareTypes.StepperConnector::{
        step_pin = KlipperConfig.McuPinOutput::{
            hardware_name = "PF9"
        },
        dir_pin = KlipperConfig.McuPinOutput::{
            hardware_name = "PF10",
            reverse_polarity = True
        },
        enable_pin = Some KlipperConfig.McuPinOutput::{
            hardware_name = "PG2",
            reverse_polarity = True
        },
        uart_pin = Some KlipperConfig.McuPinOutput::{
            hardware_name = "PF2"
        }
    },
    stepper_z3 = Some HardwareTypes.StepperConnector::{
        step_pin = KlipperConfig.McuPinOutput::{
            hardware_name = "PC13"
        },
        dir_pin = KlipperConfig.McuPinOutput::{
            hardware_name = "PF0"
        },
        enable_pin = Some KlipperConfig.McuPinOutput::{
            hardware_name = "PG1",
            reverse_polarity = True
        },
        uart_pin = Some KlipperConfig.McuPinOutput::{
            hardware_name = "PE4"
        }
    },

    -- Extruder pins
    extruder = {
        stepper = HardwareTypes.StepperConnector::{
            step_pin = KlipperConfig.McuPinOutput::{
                hardware_name = "PF11"
            },
            dir_pin = KlipperConfig.McuPinOutput::{
                hardware_name = "PG3",
                reverse_polarity = True
            },
            enable_pin = Some KlipperConfig.McuPinOutput::{
                hardware_name = "PG5",
                reverse_polarity = True
            }
        },
        heater = {
            heater_pin = KlipperConfig.McuPinOutput::{
                hardware_name = "PA2"
            },
            sensor_pin = KlipperConfig.McuPinInput::{
                hardware_name = "PF4"
            }
        },
        fan = {
            pin = KlipperConfig.McuPinOutput::{
                hardware_name = "PA8"
            }
        }
    },
    bed = {
        heater_pin = KlipperConfig.McuPinOutput::{
            hardware_name = "PA1"
        },
        sensor_pin = KlipperConfig.McuPinInput::{
            hardware_name = "PF3"
        }
    },
    -- Fan pins
    part_cooling_fan_pin = KlipperConfig.McuPinOutput::{
        hardware_name = "PA8"
    },
    heater_cooling_fan_pin = KlipperConfig.McuPinOutput::{
        hardware_name = "PA0"
    },
    controller_fan_pin = KlipperConfig.McuPinOutput::{
        hardware_name = "PA3"
    },
    -- Probe pins
    probe_signal_pin = KlipperConfig.McuPinInput::{
        hardware_name = "PC14"
    },
    probe_servo_pin = KlipperConfig.McuPinOutput::{
        hardware_name = "PC6"
    },

    -- Optional features
    neopixel_pin = Some KlipperConfig.McuPinOutput::{
        hardware_name = "PC7"
    },
    filament_sensor_pin = Some KlipperConfig.McuPinInput::{
        hardware_name = "PG11"
    },
    power_monitor_pin = Some KlipperConfig.McuPinInput::{
        hardware_name = "PC4"
    },

    -- Board pin aliases (for EXP headers)
    pin_aliases = Some (toMap {
        -- EXP1 header
        EXP1_1 = "PE8",
        EXP1_3 = "PE9",
        EXP1_5 = "PE12",
        EXP1_7 = "PE14",
        EXP1_9 = "<GND>",
        EXP1_2 = "PE7",
        EXP1_4 = "PE10",
        EXP1_6 = "PE13",
        EXP1_8 = "PE15",
        EXP1_10 = "<5V>",
        -- EXP2 header
        EXP2_1 = "PA6",
        EXP2_3 = "PB1",
        EXP2_5 = "PB2",
        EXP2_7 = "PC15",
        EXP2_9 = "<GND>",
        EXP2_2 = "PA5",
        EXP2_4 = "PA4",
        EXP2_6 = "PA7",
        EXP2_8 = "<RST>",
        EXP2_10 = "PC5"
    })
}
in OctopusProV11MCU
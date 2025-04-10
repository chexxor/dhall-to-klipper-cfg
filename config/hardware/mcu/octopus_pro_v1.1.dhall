let Types = ./../../types.dhall

let OctopusProV11MCU = Types.MCU::{
    # Basic MCU configuration
    serial: "/dev/serial/by-id/usb-Klipper_Klipper_firmware_12345-if00",
    baudrate: 250000,
    restart_method: "command",

    # Pin mappings for required components
    pins: {
        # Stepper motor pins
        stepperXStep: "PF13",
        stepperXDir: "!PF12",
        stepperXEnable: "!PF14",
        stepperXEndstop: "!PG6",
        stepperYStep: "PG0",
        stepperYDir: "PG1",
        stepperYEnable: "!PF15",
        stepperYEndstop: "!PG9",
        stepperZStep: "PC13",
        stepperZDir: "!PF0",
        stepperZEnable: "!PF1",
        stepperZEndstop: "!PG10",
        # Extruder pins
        extruderStep: "PF11",
        extruderDir: "!PG3",
        extruderEnable: "!PG5",
        extruderHeater: "PA2",
        extruderSensor: "PF4",
        # Bed pins
        bedHeater: "PA1",
        bedSensor: "PF3",
        # Fan pins
        partCoolingFan: "PA8",
        heaterCoolingFan: "PA0",
        controllerFan: "PA3",
        # Probe pins
        probeSignal: "PC14",
        probeServo: "PC6"
    },

    # Optional features
    optional_pins: Some {
        neopixelPin: "PC7",
        filamentSensorPin: "PG11",
        powerMonitorPin: "PC4"
    },

    # Display configuration
    display: Some {
        spi_bus: "spi1",
        cs_pin: "PE14",
        dc_pin: "PE13",
        reset_pin: "PE15"
    },

    # Board pin aliases (for EXP headers)
    pin_aliases: Some {
        # EXP1 header
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
        # EXP2 header
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
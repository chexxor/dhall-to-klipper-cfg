let Types = ./../../types.dhall

let SKRatV10MCU = {
    type: "mcu",
    serial: "/dev/serial/by-id/usb-Klipper_Klipper_firmware_12345-if00",
    baudrate: 250000,
    restart_method: "command",
    board_pins: {
        aliases: {
            # EXP1 header
            EXP1_1: "PC13",
            EXP1_3: "PC3",
            EXP1_5: "PB1",
            EXP1_7: "PC5",
            EXP1_9: "<GND>",
            EXP1_2: "PF3",
            EXP1_4: "PC2",
            EXP1_6: "PB0",
            EXP1_8: "PC4",
            EXP1_10: "<5V>",
            # EXP2 header
            EXP2_1: "PA6",
            EXP2_3: "PE7",
            EXP2_5: "PE8",
            EXP2_7: "PE10",
            EXP2_9: "<GND>",
            EXP2_2: "PA5",
            EXP2_4: "PF7",
            EXP2_6: "PA7",
            EXP2_8: "<RST>",
            EXP2_10: "<NC>"
        }
    }
}
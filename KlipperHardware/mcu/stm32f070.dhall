let Types = ./../../types.dhall

let STM32F070MCU = {
    type: "mcu",
    serial: "/dev/ttyACM0",
    baudrate: 250000,
    restart_method: "command"
}
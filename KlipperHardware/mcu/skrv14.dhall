let Types = ./../../types.dhall

let SKRV14MCU = {
    type: "mcu",
    serial: "/dev/serial/by-id/usb-Klipper_stm32f407xx_*",
    baudrate: 250000,
    restart_method: "command"
}
let Klipper = ./../../klipper.dhall

let TMC2209 = {
    # Driver-specific settings for TMC2209
    settings: {
        microsteps: 64,
        stealthchop: True,
        interpolate: True,
        holdCurrent: 0.5,
        runCurrent: 0.8,
        # TMC2209 specific settings
        uartAddress: 0,
        uartBaudrate: 250000,
        uartRxPin: "PC11",
        uartTxPin: "PC10"
    }
}
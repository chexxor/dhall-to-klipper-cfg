let Klipper = ./../../klipper.dhall

let TMC2130 = {
    # Driver-specific settings for TMC2130
    settings: {
        microsteps: 64,
        stealthchop: True,
        interpolate: True,
        holdCurrent: 0.5,
        runCurrent: 0.8,
        # TMC2130 specific settings
        senseResistor: 0.11,
        stallGuardThreshold: 0,
        # SPI settings
        csPin: "PC4",
        spiBus: "spi1"
    }
}
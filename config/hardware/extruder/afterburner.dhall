let Klipper = ./../../klipper.dhall
let BaseExtruder = ./base.dhall

let Afterburner = BaseExtruder with {
    # Afterburner specific parameters
    rotationDistance: 22.6789511,  # Standard value for Afterburner with BMG gears
    pressureAdvance: 0.0,  # Default value, should be tuned
    smoothTime: 0.04
}
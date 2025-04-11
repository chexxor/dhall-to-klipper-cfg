let Klipper = ./../../klipper.dhall
let BaseExtruder = ./base.dhall

let Orbiter2 = BaseExtruder with {
    # Orbiter 2.0 specific parameters
    rotationDistance: 7.5,  # Standard value for Orbiter 2.0
    pressureAdvance: 0.0,  # Default value, should be tuned
    smoothTime: 0.04
}
let Klipper = ./../../klipper.dhall
let BaseExtruder = ./base.dhall

let DirectDrive = BaseExtruder with {
    # Direct drive specific parameters
    rotationDistance: 33.500,  # Common value for BMG-style gears
    pressureAdvance: 0.0,
    smoothTime: 0.04
}
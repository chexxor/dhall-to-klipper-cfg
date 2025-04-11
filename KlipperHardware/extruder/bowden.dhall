let Klipper = ./../../klipper.dhall
let BaseExtruder = ./base.dhall

let Bowden = BaseExtruder with {
    # Bowden specific parameters
    rotationDistance: 33.500,  # Common value for BMG-style gears
    pressureAdvance: 0.5,  # Higher value for Bowden setups
    smoothTime: 0.04
}
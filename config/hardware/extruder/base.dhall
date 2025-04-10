let Klipper = ./../../klipper.dhall

let BaseExtruder = Klipper.Extruder::{
    # Common extruder parameters
    nozzleDiameter: 0.4,
    filamentDiameter: 1.75,
    maxExtrudeOnlyDistance: 50.0,
    maxExtrudeOnlyVelocity: 50,
    maxExtrudeOnlyAccel: 500,
    # These will be overridden by the constructor
    stepPin: "",
    dirPin: "",
    enablePin: "",
    microsteps: 16,
    rotationDistance: 0.0
}
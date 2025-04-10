let Klipper = ./../../klipper.dhall

let BaseStepper = {
    # Common homing parameters that apply to all stepper types
    homing: {
        speed: 50,
        retractDist: 5.0,
        positiveDir: True
    },
    # Common position limits that apply to all stepper types
    position: {
        endstop: 0.0,
        min: 0.0,
        max: 300.0
    }
}
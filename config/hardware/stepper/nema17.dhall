let Klipper = ./../../klipper.dhall
let BaseStepper = ./base.dhall

let NEMA17 = {
    # Physical characteristics of NEMA17 steppers
    physical: {
        stepAngle: 1.8,  # degrees per step
        holdingTorque: 0.4,  # Nm
        ratedCurrent: 1.7,  # A
        resistance: 1.5,  # ohms
        inductance: 2.8  # mH
    },
    # Common values for belt-driven axes with NEMA17
    beltDriven: {
        rotationDistance: 40.0,
        homing: BaseStepper.homing,
        position: BaseStepper.position
    },
    # Common values for leadscrew-driven Z axis with NEMA17
    leadscrewDriven: {
        rotationDistance: 8.0,
        homing: BaseStepper.homing,
        position: BaseStepper.position
    }
}
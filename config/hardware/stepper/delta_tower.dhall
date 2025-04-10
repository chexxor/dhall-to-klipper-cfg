let Types = ./../../types.dhall

let DeltaTowerStepper = {
    stepper: Text,
    endstop: Text,
    steps_per_mm: 40,
    max_velocity: 300,
    max_accel: 3000,
    max_position: 297.05,
    arm_length: 333.0
}
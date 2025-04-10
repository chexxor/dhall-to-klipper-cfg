let Klipper = ./../klipper.dhall

let DeltaConfig = Klipper.Printer::{
    name = "Monoprice Mini Delta 2017",
    kinematics = Klipper.Kinematics.Delta,
    maxVelocity = 150,
    maxAccel = 1200,
    maxZVelocity = 5,
    maxZAccel = 100,
    stepperX = Some Klipper.Stepper::{
        stepPin = "PA0",
        dirPin = "PA1",
        enablePin = "!PA2",
        microsteps = 16,
        rotationDistance = 40.0,
        positionEndstop = 0.0,
        positionMin = 0.0,
        positionMax = 125.0,
        homingSpeed = 50,
        homingRetractDist = 5.0,
        homingPositiveDir = True
    },
    stepperY = Some Klipper.Stepper::{
        stepPin = "PA3",
        dirPin = "PA4",
        enablePin = "!PA5",
        microsteps = 16,
        rotationDistance = 40.0,
        positionEndstop = 0.0,
        positionMin = 0.0,
        positionMax = 125.0,
        homingSpeed = 50,
        homingRetractDist = 5.0,
        homingPositiveDir = True
    },
    stepperZ = Some Klipper.Stepper::{
        stepPin = "PA6",
        dirPin = "PA7",
        enablePin = "!PA8",
        microsteps = 16,
        rotationDistance = 40.0,
        positionEndstop = 0.0,
        positionMin = 0.0,
        positionMax = 125.0,
        homingSpeed = 50,
        homingRetractDist = 5.0,
        homingPositiveDir = True
    },
    extruder = Some Klipper.Extruder::{
        stepPin = "PB0",
        dirPin = "PB1",
        enablePin = "!PB2",
        microsteps = 16,
        rotationDistance = 65.984,
        nozzleDiameter = 0.4,
        filamentDiameter = 1.75,
        maxExtrudeOnlyDistance = 50.0,
        maxExtrudeOnlyVelocity = 50,
        maxExtrudeOnlyAccel = 1000
    },
    heaterBed = Some Klipper.Heater::{
        heaterPin = "PB3",
        sensorType = "ATC Semitec 104GT-2",
        sensorPin = "PB4",
        control = "pid",
        pidKp = 54.027,
        pidKi = 0.770,
        pidKd = 948.182,
        minTemp = 0.0,
        maxTemp = 130.0
    },
    fan = Some Klipper.Fan::{
        pin = "PB5",
        kickStartTime = Some 0.5,
        offBelow = Some 0.0
    },
    deltaParams = Some Klipper.DeltaParams::{
        deltaRadius = 130.0,
        armLength = 250.0,
        towerAngles = [ 210.0, 330.0, 90.0 ],
        endstopAdjustments = [ 0.0, 0.0, 0.0 ],
        angleCorrections = [ 0.0, 0.0, 0.0 ],
        radiusCorrection = 0.0,
        printRadius = 100.0,
        maxZHeight = 125.0
    }
}

in Klipper.renderConfig DeltaConfig
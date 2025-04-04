let Klipper = ../klipper.dhall

let stepper = \(name : Text) -> \(stepPin : Text) -> \(dirPin : Text) -> \(enablePin : Text) ->
    Klipper.Stepper::{
    , stepPin = stepPin
    , dirPin = dirPin
    , enablePin = enablePin
    , microsteps = 16
    , rotationDistance = 40.0
    , positionEndstop = 0.0
    , positionMin = 0.0
    , positionMax = 350.0
    , homingSpeed = 50
    , homingRetractDist = 5.0
    , homingPositiveDir = True
    }

let heater = \(name : Text) -> \(heaterPin : Text) -> \(sensorPin : Text) ->
    Klipper.Heater::{
    , heaterPin = heaterPin
    , sensorType = "PT1000"
    , sensorPin = sensorPin
    , control = "pid"
    , pidKp = 22.2
    , pidKi = 1.08
    , pidKd = 114.0
    , minTemp = 0.0
    , maxTemp = 300.0
    }

let printer = Klipper.Printer::{
    , name = "Voron 2.4"
    , kinematics = Klipper.Kinematics.Cartesian
    , maxVelocity = 300
    , maxAccel = 3000
    , maxZVelocity = 5
    , maxZAccel = 100
    , stepperX = Some (stepper "x" "ar2" "ar5" "!ar8")
    , stepperY = Some (stepper "y" "ar3" "ar6" "!ar9")
    , stepperZ = Some (stepper "z" "ar4" "ar7" "!ar10")
    , extruder = Some Klipper.Extruder::{
        , stepPin = "ar23"
        , dirPin = "ar24"
        , enablePin = "!ar25"
        , microsteps = 16
        , rotationDistance = 22.6789511
        , nozzleDiameter = 0.4
        , filamentDiameter = 1.75
        , maxExtrudeOnlyDistance = 50.0
        , maxExtrudeOnlyVelocity = 50
        , maxExtrudeOnlyAccel = 500
    }
    , heaterBed = Some (heater "bed" "ar26" "ar27")
    , fan = Some Klipper.Fan::{
        , pin = "ar28"
        , kickStartTime = Some 0.5
        , offBelow = Some 0.0
    }
}

in Klipper.renderConfig printer 
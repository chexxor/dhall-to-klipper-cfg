let Klipper = ./../../klipper.dhall

let buildExtruder = \(motor : { physical : { stepAngle : Double, holdingTorque : Double, ratedCurrent : Double, resistance : Double, inductance : Double } })
                 -> \(driver : { settings : { microsteps : Natural, stealthchop : Bool, interpolate : Bool, holdCurrent : Double, runCurrent : Double } })
                 -> \(extruderType : { rotationDistance : Double
                                    , pressureAdvance : Double
                                    , smoothTime : Double
                                    , nozzleDiameter : Double
                                    , filamentDiameter : Double
                                    , maxExtrudeOnlyDistance : Double
                                    , maxExtrudeOnlyVelocity : Natural
                                    , maxExtrudeOnlyAccel : Natural
                                    })
                 -> \(pins : { stepPin : Text, dirPin : Text, enablePin : Text })
                 -> Klipper.Extruder::{
                        stepPin: pins.stepPin,
                        dirPin: pins.dirPin,
                        enablePin: pins.enablePin,
                        microsteps: driver.settings.microsteps,
                        rotationDistance: extruderType.rotationDistance,
                        nozzleDiameter: extruderType.nozzleDiameter,
                        filamentDiameter: extruderType.filamentDiameter,
                        maxExtrudeOnlyDistance: extruderType.maxExtrudeOnlyDistance,
                        maxExtrudeOnlyVelocity: extruderType.maxExtrudeOnlyVelocity,
                        maxExtrudeOnlyAccel: extruderType.maxExtrudeOnlyAccel
                    }
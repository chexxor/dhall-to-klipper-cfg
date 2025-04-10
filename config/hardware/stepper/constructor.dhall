let Klipper = ./../../klipper.dhall

let buildStepper = \(motor : { physical : { stepAngle : Double, holdingTorque : Double, ratedCurrent : Double, resistance : Double, inductance : Double }
                            , beltDriven : { rotationDistance : Double, homing : { speed : Natural, retractDist : Double, positiveDir : Bool }, position : { endstop : Double, min : Double, max : Double } }
                            , leadscrewDriven : { rotationDistance : Double, homing : { speed : Natural, retractDist : Double, positiveDir : Bool }, position : { endstop : Double, min : Double, max : Double } }
                            })
                 -> \(driver : { settings : { microsteps : Natural, stealthchop : Bool, interpolate : Bool, holdCurrent : Double, runCurrent : Double } })
                 -> \(pins : { stepPin : Text, dirPin : Text, enablePin : Text })
                 -> \(isLeadscrew : Bool)
                 -> Klipper.Stepper::{
                        stepPin: pins.stepPin,
                        dirPin: pins.dirPin,
                        enablePin: pins.enablePin,
                        microsteps: driver.settings.microsteps,
                        rotationDistance: if isLeadscrew then motor.leadscrewDriven.rotationDistance else motor.beltDriven.rotationDistance,
                        positionEndstop: if isLeadscrew then motor.leadscrewDriven.position.endstop else motor.beltDriven.position.endstop,
                        positionMin: if isLeadscrew then motor.leadscrewDriven.position.min else motor.beltDriven.position.min,
                        positionMax: if isLeadscrew then motor.leadscrewDriven.position.max else motor.beltDriven.position.max,
                        homingSpeed: if isLeadscrew then motor.leadscrewDriven.homing.speed else motor.beltDriven.homing.speed,
                        homingRetractDist: if isLeadscrew then motor.leadscrewDriven.homing.retractDist else motor.beltDriven.homing.retractDist,
                        homingPositiveDir: if isLeadscrew then motor.leadscrewDriven.homing.positiveDir else motor.beltDriven.homing.positiveDir
                    }
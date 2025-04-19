let StepperType = ./../../KlipperModule/StepperType.dhall
let HardwareTypes = ./../types.dhall
-- let Klipper = ./../../Klipper.dhall

let StepperAngle = < OnePointEightDegrees | ZeroPointNineDegrees >

-- rotation_distance: Read this doc page to calculate a precise value:
--   https://www.klipper3d.org/Rotation_Distance.html
let stepperConfigFromMcuHardware
    : HardwareTypes.StepperConnector.Type
    -> StepperAngle
    -> StepperType.Type
    = \(stepperConnector : HardwareTypes.StepperConnector.Type)
    -> \(stepperAngle : StepperAngle)
    -> let defaultsForAngle = merge
            { OnePointEightDegrees =
                { microsteps = 32
                , full_steps_per_rotation = Some 200
                , rotation_distance = 40.0
                }
            , ZeroPointNineDegrees =
                { microsteps = 16
                , full_steps_per_rotation = Some 400
                , rotation_distance = 20.0
                }
            } stepperAngle
        in StepperType::
            { step_pin = stepperConnector.step_pin
            , dir_pin = stepperConnector.dir_pin
            , enable_pin = stepperConnector.enable_pin
            , endstop_pin = stepperConnector.endstop_pin
            , microsteps = defaultsForAngle.microsteps
            , full_steps_per_rotation = defaultsForAngle.full_steps_per_rotation
            , rotation_distance = defaultsForAngle.rotation_distance
            }

let addStepperConnector
    : HardwareTypes.StepperConnector.Type
    -> StepperType.Type
    -> StepperType.Type
    = \(stepperConnector : HardwareTypes.StepperConnector.Type)
    -> \(stepperConfig : StepperType.Type)
    -> { step_pin = stepperConnector.step_pin
        , dir_pin = stepperConnector.dir_pin
        , enable_pin = stepperConnector.enable_pin
        , endstop_pin = stepperConnector.endstop_pin
        } // stepperConfig

-- let addHardware
--     : Text -> McuModule.McuConfig.Type
--     -> StepperDriverModule.Type
--     -> StepperModule.Type
--     -> StepperModule.Type
--     = (name : Text)
--         -> (mcu : McuModule.McuConfig.Type)
--         -> (stepperDriverConfig : StepperDriverModule.Type)
--         -> (stepperConfig : StepperModule.Type)
--         -> { name = name
--             , stepper = stepperConfig
--             , stepper_driver = McuModule.stepperDriverWithHardware name mcu
--             } // stepperConfig

-- let buildStepper = \(motor : { physical : { stepAngle : Double, holdingTorque : Double, ratedCurrent : Double, resistance : Double, inductance : Double }
--                             , beltDriven : { rotationDistance : Double, homing : { speed : Natural, retractDist : Double, positiveDir : Bool }, position : { endstop : Double, min : Double, max : Double } }
--                             , leadscrewDriven : { rotationDistance : Double, homing : { speed : Natural, retractDist : Double, positiveDir : Bool }, position : { endstop : Double, min : Double, max : Double } }
--                             })
--                  -> \(driver : { settings : { microsteps : Natural, stealthchop : Bool, interpolate : Bool, holdCurrent : Double, runCurrent : Double } })
--                  -> \(pins : { stepPin : Text, dirPin : Text, enablePin : Text })
--                  -> \(isLeadscrew : Bool)
--                  -> Klipper.Stepper::{
--                         stepPin: pins.stepPin,
--                         dirPin: pins.dirPin,
--                         enablePin: pins.enablePin,
--                         microsteps: driver.settings.microsteps,
--                         rotationDistance: if isLeadscrew then motor.leadscrewDriven.rotationDistance else motor.beltDriven.rotationDistance,
--                         positionEndstop: if isLeadscrew then motor.leadscrewDriven.position.endstop else motor.beltDriven.position.endstop,
--                         positionMin: if isLeadscrew then motor.leadscrewDriven.position.min else motor.beltDriven.position.min,
--                         positionMax: if isLeadscrew then motor.leadscrewDriven.position.max else motor.beltDriven.position.max,
--                         homingSpeed: if isLeadscrew then motor.leadscrewDriven.homing.speed else motor.beltDriven.homing.speed,
--                         homingRetractDist: if isLeadscrew then motor.leadscrewDriven.homing.retractDist else motor.beltDriven.homing.retractDist,
--                         homingPositiveDir: if isLeadscrew then motor.leadscrewDriven.homing.positiveDir else motor.beltDriven.homing.positiveDir
--                     }

in
    { addStepperConnector = addStepperConnector
    , stepperConfigFromMcuHardware = stepperConfigFromMcuHardware
    -- , buildStepper = buildStepper
    , StepperAngle = StepperAngle
    }
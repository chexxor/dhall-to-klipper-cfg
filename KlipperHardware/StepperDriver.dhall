let StepperDriverType = ../KlipperModule/StepperDriverType.dhall
let HardwareTypes = ./types.dhall
let TMC2209Hardware = ./StepperDriver/TMC2209.dhall

let stepperDriverConfigFromMcuHardware
    : HardwareTypes.StepperConnector.Type
    -> StepperDriverType.StepperDriver
    -> StepperDriverType.StepperDriver
    = \(stepperConnector : HardwareTypes.StepperConnector.Type)
    -> \(stepperDriverType : StepperDriverType.StepperDriver)
    -> merge
        {
            TMC2209 = \(tmc2209Config : StepperDriverType.TMC2209.Type)
                -> (TMC2209Hardware.stepperDriverConfigFromMcuHardware
                    stepperConnector)
        } stepperDriverType

in
    { stepperDriverConfigFromMcuHardware = stepperDriverConfigFromMcuHardware
    }
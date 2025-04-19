let KlipperConfig = ./../../KlipperConfig.dhall
let KlipperConfigSection = ./../../KlipperConfigSection.dhall
let StepperDriverModule = ./../../KlipperModule/StepperDriver.dhall
let TMC2209Module = ./../../KlipperModule/StepperDriver/TMC2209.dhall
let McuModule = ./../../KlipperModule/Mcu.dhall
let StepperModule = ./../../KlipperModule/StepperType.dhall
let HardwareTypes = ./../types.dhall

-- let TMC2209Type = StepperDriverModule.StepperDriver.TMC2209 TMC2209Module.Type
-- let TMC2209default = StepperDriverModule.StepperDriver.TMC2209 TMC2209Module.default

let stepperDriverConfigFromMcuHardware
    : HardwareTypes.StepperConnector.Type
    -> StepperDriverModule.StepperDriver
    = \(stepperDriverConnector : HardwareTypes.StepperConnector.Type)
    ->
    let tmc2209Config = TMC2209Module::
        { uart_pin = merge
            { None = KlipperConfig.McuPinOutput::{ hardware_name = "" }
            , Some = \(x : KlipperConfig.McuPinOutput.Type) -> x
            }
            stepperDriverConnector.uart_pin
        , tx_pin = stepperDriverConnector.tx_pin
        , run_current = 0.5
        }
    in StepperDriverModule.StepperDriver.TMC2209 tmc2209Config

in
    -- { Type = TMC2209Type
    -- , default = TMC2209default
    -- , stepperDriverConfigFromMcuHardware = stepperDriverConfigFromMcuHardware
    -- }
    { stepperDriverConfigFromMcuHardware = stepperDriverConfigFromMcuHardware
    }
let Klipper = ./../klipper.dhall
let KlipperConfig = ./../klipperConfig.dhall
let PrinterModule = ./../config/modules/printer.dhall
let MCU = ./../config/hardware/mcu/octopus_pro_v1.1.dhall
let NEMA17 = ./../config/hardware/stepper/nema17.dhall
let TMC2209 = ./../config/hardware/driver/tmc2209.dhall
let buildStepper = ./../config/hardware/stepper/constructor.dhall
let DirectDrive = ./../config/hardware/extruder/direct_drive.dhall
let buildExtruder = ./../config/hardware/extruder/constructor.dhall

let PrinterModule = ./../KlipperConfigModule/Printer.dhall

let printer = PrinterModule.cartesianPrinter
    { max_velocity = 300
    , max_accel = 3000
    } :: {
        max_velocity = 500
    }

let stepperX = StepperModule.Stepper::
    { name = "stepper_x"
    , step_pin = MCU.hardware_interface.stepperXStep
    , dir_pin = MCU.hardware_interface.stepperXDir
    , enable_pin = MCU.hardware_interface.stepperXEnable
    }


KlipperConfig.renderKlipperConfigModules [
    printer
]



let RatRigVMinionConfig = PrinterModule.Printer::{
    name: "RatRig V-Minion",
    kinematics: Klipper.Kinematics.Cartesian,
    maxVelocity: 300,
    maxAccel: 3000,
    maxZVelocity: 5,
    maxZAccel: 100,
    stepperX: Some (buildStepper NEMA17 TMC2209 {
        stepPin: MCU.hardware_interface.stepperXStep,
        dirPin: MCU.hardware_interface.stepperXDir,
        enablePin: MCU.hardware_interface.stepperXEnable
    } False),
    stepperY: Some (buildStepper NEMA17 TMC2209 {
        stepPin: MCU.hardware_interface.stepperYStep,
        dirPin: MCU.hardware_interface.stepperYDir,
        enablePin: MCU.hardware_interface.stepperYEnable
    } False),
    stepperZ: Some (buildStepper NEMA17 TMC2209 {
        stepPin: MCU.hardware_interface.stepperZStep,
        dirPin: MCU.hardware_interface.stepperZDir,
        enablePin: MCU.hardware_interface.stepperZEnable
    } True),
    extruder: Some (buildExtruder NEMA17 TMC2209 DirectDrive {
        stepPin: MCU.hardware_interface.extruderStep,
        dirPin: MCU.hardware_interface.extruderDir,
        enablePin: MCU.hardware_interface.extruderEnable
    }),
    heaterBed: Some Klipper.Heater::{
        heaterPin: MCU.hardware_interface.bedHeater,
        sensorType: "PT1000",
        sensorPin: MCU.hardware_interface.bedSensor,
        control: "pid",
        pidKp: 22.2,
        pidKi: 1.08,
        pidKd: 114,
        minTemp: 0,
        maxTemp: 130
    },
    fan: Some Klipper.Fan::{
        pin: MCU.hardware_interface.partCoolingFan,
        kickStartTime: Some 0.5,
        offBelow: Some 0.0
    }
}

in Klipper.renderConfig RatRigVMinionConfig
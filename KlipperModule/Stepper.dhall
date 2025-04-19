let KlipperConfig = ../klipperConfig.dhall
let StepperType = ./StepperType.dhall
let Prelude =
    { Text = https://prelude.dhall-lang.org/Text/package.dhall
    , List = https://prelude.dhall-lang.org/List/package.dhall
    , Natural = https://prelude.dhall-lang.org/Natural/package.dhall
    , Double = https://prelude.dhall-lang.org/Double/package.dhall
    , Bool = https://prelude.dhall-lang.org/Bool/package.dhall
    , Optional = https://prelude.dhall-lang.org/Optional/package.dhall
    , Map = https://prelude.dhall-lang.org/Map/package.dhall
    }

let StepperDriverModule = ./StepperDriver.dhall

-- let StepperConfig =
--     { Type =
--         -- Step GPIO pin (triggered high).
--         { step_pin : KlipperConfig.McuPinOutput.Type
--         -- Direction GPIO pin (high indicates positive direction).
--         , dir_pin : KlipperConfig.McuPinOutput.Type
--         -- Enable pin (default is enable high; use ! to indicate enable low).
--         , enable_pin : Optional KlipperConfig.McuPinOutput.Type
--         -- Endstop switch detection pin. If this endstop pin is on a
--         -- different mcu than the stepper motor then it enables "multi-mcu-homing".
--         , endstop_pin: Optional KlipperConfig.McuPinInput.Type
--         -- Distance (in mm) that the axis travels with one full rotation of
--         -- the stepper motor (or final gear if gear_ratio is specified).
--         , rotation_distance : Double
--         -- The number of microsteps the stepper motor driver uses.
--         , microsteps : Natural
--         -- The number of full steps for one rotation of the stepper motor.
--         -- Set this to 200 for a 1.8 degree stepper motor or set to 400 for a
--         -- 0.9 degree motor. The default is 200.
--         , full_steps_per_rotation: Optional Natural
--         -- The gear ratio if the stepper motor is connected to the axis via a
--         -- gearbox. For example, one may specify "5:1" if a 5 to 1 gearbox is in use.
--         , gear_ratio: Optional Text
--         -- The minimum time between the step pulse signal edge and the
--         -- following "unstep" signal edge.
--         -- The default is 0.000000100 (100ns) for TMC steppers that are
--         -- configured in UART or SPI mode, and the default is 0.000002 (which
--         -- is 2us) for all other steppers.
--         , step_pulse_duration: Optional Double
--         , position_endstop : Optional Double
--         , position_min : Optional Double
--         , position_max : Optional Double
--         , homing_speed : Optional Natural
--         , homing_retract_dist : Optional Double
--         , homing_positive_dir : Optional Bool
--         , homing_retract_speed : Optional Natural
--         , second_homing_speed : Optional Natural
--         , second_homing_positive_dir : Optional Bool
--         , arm_length : Optional Double
--         , angle : Optional Double
--       }
--     , default =
--         { enable_pin = None KlipperConfig.McuPinOutput.Type
--         , endstop_pin = None KlipperConfig.McuPinInput.Type
--         , full_steps_per_rotation = None Natural
--         , gear_ratio = None Text
--         , step_pulse_duration = None Double
--         , position_endstop = None Double
--         , position_min = None Double
--         , position_max = None Double
--         , homing_speed = None Natural
--         , homing_retract_dist = None Double
--         , homing_positive_dir = None Bool
--         , homing_retract_speed = None Natural
--         , second_homing_speed = None Natural
--         , second_homing_positive_dir = None Bool
--         , arm_length = None Double
--         , angle = None Double
--       }
--     }

-- let makeStepperConfig
--     : Text
--     -> StepperDriverModule.StepperDriver
--     -> StepperConfig.Type
--     = \(stepperDriver : StepperDriverModule.StepperDriver) ->
--     StepperConfig::
--     { step_pin = Some (KlipperConfig.renderMcuPinOutput stepperDriver.step_pin)
--     , dir_pin = Some (KlipperConfig.renderMcuPinOutput stepperDriver.dir_pin)
--     , enable_pin = Prelude.Optional.map KlipperConfig.McuPinOutput.Type Text KlipperConfig.renderMcuPinOutput stepperDriver.enable_pin
--     }

-- let toKlipperConfigSection
--     : StepperType.NamedStepper -> List KlipperConfig.KlipperConfigSection
--     = \(namedStepper : StepperType.NamedStepper) ->
--         StepperType.toKlipperConfigSection
--             { name = namedStepper.name
--             , stepper = namedStepper.stepper
--             , stepper_driver = namedStepper.stepper_driver
--             }
--             #
--             StepperDriverModule.toKlipperConfigSection
--                 { name = namedStepper.name
--                 , stepper_driver = namedStepper.stepper_driver
--                 }

in
    { NamedStepper = StepperType.NamedStepper
    , StepperConfig = StepperType
    , toKlipperConfigSection = StepperType.toKlipperConfigSection
    }
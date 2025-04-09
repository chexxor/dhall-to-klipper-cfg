let KlipperConfig = ../klipperConfig.dhall
let Prelude =
    { Text = https://prelude.dhall-lang.org/Text/package.dhall
    , List = https://prelude.dhall-lang.org/List/package.dhall
    , Natural = https://prelude.dhall-lang.org/Natural/package.dhall
    , Double = https://prelude.dhall-lang.org/Double/package.dhall
    , Bool = https://prelude.dhall-lang.org/Bool/package.dhall
    , Optional = https://prelude.dhall-lang.org/Optional/package.dhall
    , Map = https://prelude.dhall-lang.org/Map/package.dhall
    }

let StepperConfig =
    { Type =
        { step_pin : Text
        , dir_pin : Text
        , enable_pin : Optional Text
        , endstop_pin: Optional Text
        , rotation_distance : Double
        , microsteps : Natural
        , full_steps_per_rotation: Optional Natural
        , gear_ratio: Optional Text
        , step_pulse_duration: Optional Double
        , position_endstop : Optional Double
        , position_min : Optional Double
        , position_max : Optional Double
        , homing_speed : Optional Natural
        , homing_retract_dist : Optional Double
        , homing_positive_dir : Optional Bool
        , homing_retract_speed : Optional Natural
        , second_homing_speed : Optional Natural
        , second_homing_positive_dir : Optional Bool
        , arm_length : Optional Double
        , angle : Optional Double
      }
    , default =
        { enable_pin = None Text
        , endstop_pin = None Text
        , full_steps_per_rotation = None Natural
        , gear_ratio = None Text
        , step_pulse_duration = None Double
        , position_endstop = None Double
        , position_min = None Double
        , position_max = None Double
        , homing_speed = None Natural
        , homing_retract_dist = None Double
        , homing_positive_dir = None Bool
        , homing_retract_speed = None Natural
        , second_homing_speed = None Natural
        , second_homing_positive_dir = None Bool
        , arm_length = None Double
        , angle = None Double
      }
    }


let StepperConfigText =
    { step_pin : Optional Text
    , dir_pin : Optional Text
    , enable_pin : Optional Text
    , endstop_pin: Optional Text
    , rotation_distance : Optional Text
    , microsteps : Optional Text
    , full_steps_per_rotation: Optional Text
    , gear_ratio: Optional Text
    , step_pulse_duration: Optional Text
    , position_endstop : Optional Text
    , position_min : Optional Text
    , position_max : Optional Text
    , homing_speed : Optional Text
    , homing_retract_dist : Optional Text
    , homing_positive_dir : Optional Text
    , homing_retract_speed : Optional Text
    , second_homing_speed : Optional Text
    , second_homing_positive_dir : Optional Text
    , arm_length : Optional Text
    , angle : Optional Text
    }

let NamedStepper : Type =
    { name : Text
    , stepper : StepperConfig.Type
    }

let toStepperConfigText
    : StepperConfig.Type -> StepperConfigText
    = \(stepperConfig : StepperConfig.Type) ->
    { step_pin = Some stepperConfig.step_pin
    , dir_pin = Some stepperConfig.dir_pin
    , enable_pin = stepperConfig.enable_pin
    , endstop_pin = stepperConfig.endstop_pin
    , rotation_distance = Some (Prelude.Double.show stepperConfig.rotation_distance)
    , microsteps = Some (Prelude.Natural.show stepperConfig.microsteps)
    , full_steps_per_rotation = Prelude.Optional.map Natural Text Prelude.Natural.show stepperConfig.full_steps_per_rotation
    , gear_ratio = stepperConfig.gear_ratio
    , step_pulse_duration = Prelude.Optional.map Double Text Prelude.Double.show stepperConfig.step_pulse_duration
    , position_endstop = Prelude.Optional.map Double Text Prelude.Double.show stepperConfig.position_endstop
    , position_min = Prelude.Optional.map Double Text Prelude.Double.show stepperConfig.position_min
    , position_max = Prelude.Optional.map Double Text Prelude.Double.show stepperConfig.position_max
    , homing_speed = Prelude.Optional.map Natural Text Prelude.Natural.show stepperConfig.homing_speed
    , homing_retract_dist = Prelude.Optional.map Double Text Prelude.Double.show stepperConfig.homing_retract_dist
    , homing_positive_dir = Prelude.Optional.map Bool Text Prelude.Bool.show stepperConfig.homing_positive_dir
    , homing_retract_speed = Prelude.Optional.map Natural Text Prelude.Natural.show stepperConfig.homing_retract_speed
    , second_homing_speed = Prelude.Optional.map Natural Text Prelude.Natural.show stepperConfig.second_homing_speed
    , second_homing_positive_dir = Prelude.Optional.map Bool Text Prelude.Bool.show stepperConfig.second_homing_positive_dir
    , arm_length = Prelude.Optional.map Double Text Prelude.Double.show stepperConfig.arm_length
    , angle = Prelude.Optional.map Double Text Prelude.Double.show stepperConfig.angle
    }

let toKlipperConfigSection
    : NamedStepper -> List KlipperConfig.KlipperConfigSection
    = \(namedStepper : NamedStepper) ->
        [{ name = namedStepper.name
        , prefix = None Text
        , properties = toMap (toStepperConfigText namedStepper.stepper)
        }]

in  { NamedStepper = NamedStepper
    , StepperConfig = StepperConfig
    , toKlipperConfigSection = toKlipperConfigSection
    }
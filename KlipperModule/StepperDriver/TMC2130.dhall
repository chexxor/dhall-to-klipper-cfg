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


let TMC2130 =
    { Type =
        { cs_pin : KlipperConfig.McuPinOutput.Type
        , spi_speed : Optional Natural
        , spi_bus : Optional Text
        , spi_software_sclk_pin : Optional KlipperConfig.McuPinOutput.Type
        , spi_software_mosi_pin : Optional KlipperConfig.McuPinOutput.Type
        , spi_software_miso_pin : Optional KlipperConfig.McuPinInput.Type
        , chain_position : Optional Natural
        , chain_length : Optional Natural
        , interpolate : Bool
        , run_current : Double
        , hold_current : Optional Double
        , sense_resistor : Double
        , stealthchop_threshold : Double
        , coolstep_threshold : Optional Double
        , high_velocity_threshold : Optional Double
        , driver_MSLUT0 : Optional Natural
        , driver_MSLUT1 : Optional Natural
        , driver_MSLUT2 : Optional Natural
        , driver_MSLUT3 : Optional Natural
        , driver_MSLUT4 : Optional Natural
        , driver_MSLUT5 : Optional Natural
        , driver_MSLUT6 : Optional Natural
        , driver_MSLUT7 : Optional Natural
        , driver_W0 : Optional Natural
        , driver_W1 : Optional Natural
        , driver_W2 : Optional Natural
        , driver_W3 : Optional Natural
        , driver_X1 : Optional Natural
        , driver_X2 : Optional Natural
        , driver_X3 : Optional Natural
        , driver_START_SIN : Optional Natural
        , driver_START_SIN90 : Optional Natural
        , driver_IHOLDDELAY : Optional Natural
        , driver_TPOWERDOWN : Optional Natural
        , driver_TBL : Optional Natural
        , driver_TOFF : Optional Natural
        , driver_HEND : Optional Natural
        , driver_HSTRT : Optional Natural
        , driver_VHIGHFS : Optional Natural
        , driver_VHIGHCHM : Optional Natural
        , driver_PWM_AUTOSCALE : Optional Bool
        , driver_PWM_FREQ : Optional Natural
        , driver_PWM_GRAD : Optional Natural
        , driver_PWM_AMPL : Optional Natural
        , driver_SGT : Optional Natural
        , driver_SEMIN : Optional Natural
        , driver_SEUP : Optional Natural
        , driver_SEMAX : Optional Natural
        , driver_SEDN : Optional Natural
        , driver_SEIMIN : Optional Natural
        , driver_SFILT : Optional Natural
        , diag0_pin : Optional KlipperConfig.McuPinInput.Type
        , diag1_pin : Optional KlipperConfig.McuPinInput.Type
        }
    , default =
        { spi_speed = None Natural
        , spi_bus = None Text
        , spi_software_sclk_pin = None KlipperConfig.McuPinOutput.Type
        , spi_software_mosi_pin = None KlipperConfig.McuPinOutput.Type
        , spi_software_miso_pin = None KlipperConfig.McuPinInput.Type
        , chain_position = None Natural
        , chain_length = None Natural
        , interpolate = True
        , hold_current = None Double
        , sense_resistor = 0.110
        , stealthchop_threshold = 0.0
        , coolstep_threshold = None Double
        , high_velocity_threshold = None Double
        , driver_MSLUT0 = None Natural
        , driver_MSLUT1 = None Natural
        , driver_MSLUT2 = None Natural
        , driver_MSLUT3 = None Natural
        , driver_MSLUT4 = None Natural
        , driver_MSLUT5 = None Natural
        , driver_MSLUT6 = None Natural
        , driver_MSLUT7 = None Natural
        , driver_W0 = None Natural
        , driver_W1 = None Natural
        , driver_W2 = None Natural
        , driver_W3 = None Natural
        , driver_X1 = None Natural
        , driver_X2 = None Natural
        , driver_X3 = None Natural
        , driver_START_SIN = None Natural
        , driver_START_SIN90 = None Natural
        , driver_IHOLDDELAY = None Natural
        , driver_TPOWERDOWN = None Natural
        , driver_TBL = None Natural
        , driver_TOFF = None Natural
        , driver_HEND = None Natural
        , driver_HSTRT = None Natural
        , driver_VHIGHFS = None Natural
        , driver_VHIGHCHM = None Natural
        , driver_PWM_AUTOSCALE = None Bool
        , driver_PWM_FREQ = None Natural
        , driver_PWM_GRAD = None Natural
        , driver_PWM_AMPL = None Natural
        , driver_SGT = None Natural
        , driver_SEMIN = None Natural
        , driver_SEUP = None Natural
        , driver_SEMAX = None Natural
        , driver_SEDN = None Natural
        , driver_SEIMIN = None Natural
        , driver_SFILT = None Natural
        , diag0_pin = None KlipperConfig.McuPinInput.Type
        , diag1_pin = None KlipperConfig.McuPinInput.Type
        }
    }

let StepperDriverText =
    { cs_pin : Optional Text
    , spi_speed : Optional Text
    , spi_bus : Optional Text
    , spi_software_sclk_pin : Optional Text
    , spi_software_mosi_pin : Optional Text
    , spi_software_miso_pin : Optional Text
    , chain_position : Optional Text
    , chain_length : Optional Text
    , interpolate : Optional Text
    , run_current : Optional Text
    , hold_current : Optional Text
    , sense_resistor : Optional Text
    , stealthchop_threshold : Optional Text
    , coolstep_threshold : Optional Text
    , high_velocity_threshold : Optional Text
    , driver_MSLUT0 : Optional Text
    , driver_MSLUT1 : Optional Text
    , driver_MSLUT2 : Optional Text
    , driver_MSLUT3 : Optional Text
    , driver_MSLUT4 : Optional Text
    , driver_MSLUT5 : Optional Text
    , driver_MSLUT6 : Optional Text
    , driver_MSLUT7 : Optional Text
    , driver_W0 : Optional Text
    , driver_W1 : Optional Text
    , driver_W2 : Optional Text
    , driver_W3 : Optional Text
    , driver_X1 : Optional Text
    , driver_X2 : Optional Text
    , driver_X3 : Optional Text
    , driver_START_SIN : Optional Text
    , driver_START_SIN90 : Optional Text
    , driver_IHOLDDELAY : Optional Text
    , driver_TPOWERDOWN : Optional Text
    , driver_TBL : Optional Text
    , driver_TOFF : Optional Text
    , driver_HEND : Optional Text
    , driver_HSTRT : Optional Text
    , driver_VHIGHFS : Optional Text
    , driver_VHIGHCHM : Optional Text
    , driver_PWM_AUTOSCALE : Optional Text
    , driver_PWM_FREQ : Optional Text
    , driver_PWM_GRAD : Optional Text
    , driver_PWM_AMPL : Optional Text
    , driver_SGT : Optional Text
    , driver_SEMIN : Optional Text
    , driver_SEUP : Optional Text
    , driver_SEMAX : Optional Text
    , driver_SEDN : Optional Text
    , driver_SEIMIN : Optional Text
    , driver_SFILT : Optional Text
    , diag0_pin : Optional Text
    , diag1_pin : Optional Text
    }

let NamedStepper : Type =
    { name : Text
    , stepper : StepperConfig.Type
    , stepper_driver : KlipperHardware.StepperDriver.Type
    }

let toStepperConfigText
    : StepperConfig.Type -> StepperConfigText
    = \(stepperConfig : StepperConfig.Type) ->
    { step_pin = Some (KlipperConfig.renderMcuPinOutput stepperConfig.step_pin)
    , dir_pin = Some (KlipperConfig.renderMcuPinOutput stepperConfig.dir_pin)
    , enable_pin = Prelude.Optional.map KlipperConfig.McuPinOutput.Type Text KlipperConfig.renderMcuPinOutput stepperConfig.enable_pin
    , endstop_pin = Prelude.Optional.map KlipperConfig.McuPinInput.Type Text KlipperConfig.renderMcuPinInput stepperConfig.endstop_pin
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
let KlipperConfig = ../../klipperConfig.dhall
let Prelude =
    { Text = https://prelude.dhall-lang.org/Text/package.dhall
    , List = https://prelude.dhall-lang.org/List/package.dhall
    , Natural = https://prelude.dhall-lang.org/Natural/package.dhall
    , Double = https://prelude.dhall-lang.org/Double/package.dhall
    , Bool = https://prelude.dhall-lang.org/Bool/package.dhall
    , Optional = https://prelude.dhall-lang.org/Optional/package.dhall
    , Map = https://prelude.dhall-lang.org/Map/package.dhall
    }

let TMC2209 =
    { Type =
        -- The pin connected to the TMC2208 PDN_UART line.
        { uart_pin : KlipperConfig.McuPinOutput.Type
        -- If using separate receive and transmit lines to communicate with
        --   the driver then set uart_pin to the receive pin and tx_pin to the
        --   transmit pin.
        -- The default is to use uart_pin for both reading and writing.
        , tx_pin : Optional KlipperConfig.McuPinOutput.Type
        -- A comma separated list of pins to set prior to accessing the
        --   tmc2208 UART. This may be useful for configuring an analog mux for
        --   UART communication.
        -- The default is to not configure any pins.
        , select_pins : Optional Text
        -- If true, enable step interpolation (the driver will internally
        --   step at a rate of 256 micro-steps). This interpolation does
        --   introduce a small systemic positional deviation - see
        --   TMC_Drivers.md for details.
        -- The default is True.
        , interpolate : Optional Bool
        -- The amount of current (in amps RMS) to configure the driver to use
        --   during stepper movement.
        , run_current : Double
        -- The amount of current (in amps RMS) to configure the driver to use
        --   when the stepper is not moving.
        -- Setting a hold_current is not recommended (see TMC_Drivers.md for
        --   details).
        -- The default is to not reduce the current.
        , hold_current : Optional Double
        -- The resistance (in ohms) of the motor sense resistor.
        -- The default is 0.110 ohms.
        , sense_resistor : Optional Double
        -- The velocity (in mm/s) to set the "stealthChop" threshold to. When
        --   set, "stealthChop" mode will be enabled if the stepper motor
        --   velocity is below this value. Note that the "sensorless homing"
        --   code may temporarily override this setting during homing
        --   operations.
        -- The default is 0, which disables "stealthChop" mode.
        , stealthchop_threshold : Optional Double
        -- The velocity (in mm/s) to set the TMC driver internal "CoolStep"
        --   threshold to. If set, the coolstep feature will be enabled when
        --   the stepper motor velocity is near or above this value.
        --   Important: If coolstep_threshold is set and "sensorless homing" is
        --   used, then one must ensure that the homing speed is above the
        --   coolstep threshold!
        -- The default is to not enable the coolstep feature.
        , coolstep_threshold : Optional Double
        -- The address of the TMC2209 chip for UART messages (an integer
        --   between 0 and 3). This is typically used when multiple TMC2209
        --   chips are connected to the same UART pin.
        -- The default is zero.
        , uart_address : Optional Natural

        -- For the following parameters:
        -- Set the given register during the configuration of the TMC2209
        --   chip. This may be used to set custom motor parameters. The
        --   defaults for each parameter are next to the parameter name in the
        --   above list.

        , driver_MULTISTEP_FILT : Optional Bool
        , driver_IHOLDDELAY : Optional Natural
        , driver_TPOWERDOWN : Optional Natural
        , driver_TBL : Optional Natural
        , driver_TOFF : Optional Natural
        , driver_HEND : Optional Natural
        , driver_HSTRT : Optional Natural
        , driver_PWM_AUTOGRAD : Optional Bool
        , driver_PWM_AUTOSCALE : Optional Bool
        , driver_PWM_LIM : Optional Natural
        , driver_PWM_REG : Optional Natural
        , driver_PWM_FREQ : Optional Natural
        , driver_PWM_GRAD : Optional Natural
        , driver_PWM_OFS : Optional Natural
        , driver_SGTHRS : Optional Natural
        , driver_SEMIN : Optional Natural
        , driver_SEUP : Optional Natural
        , driver_SEMAX : Optional Natural
        , driver_SEDN : Optional Natural
        , driver_SEIMIN : Optional Natural
        -- The micro-controller pin attached to the DIAG line of the TMC2209 chip.
        -- The pin is normally prefaced with "^" to enable a pullup.
        -- Setting this creates a "tmc2209_stepper_x:virtual_endstop" virtual
        --   pin which may be used as the stepper's endstop_pin. Doing this
        --   enables "sensorless homing". (Be sure to also set driver_SGTHRS
        --   to an appropriate sensitivity value.)
        -- The default is to not enable sensorless homing.
        , diag_pin : Optional KlipperConfig.McuPinInput.Type
        }
    , default =
        { tx_pin = None KlipperConfig.McuPinOutput.Type
        , select_pins = None Text
        , interpolate = None Bool
        , hold_current = None Double
        , sense_resistor = None Double
        , stealthchop_threshold = None Double
        , coolstep_threshold = None Double
        , uart_address = None Natural
        , driver_MULTISTEP_FILT = None Bool
        , driver_IHOLDDELAY = None Natural
        , driver_TPOWERDOWN = None Natural
        , driver_TBL = None Natural
        , driver_TOFF = None Natural
        , driver_HEND = None Natural
        , driver_HSTRT = None Natural
        , driver_PWM_AUTOGRAD = None Bool
        , driver_PWM_AUTOSCALE = None Bool
        , driver_PWM_LIM = None Natural
        , driver_PWM_REG = None Natural
        , driver_PWM_FREQ = None Natural
        , driver_PWM_GRAD = None Natural
        , driver_PWM_OFS = None Natural
        , driver_SGTHRS = None Natural
        , driver_SEMIN = None Natural
        , driver_SEUP = None Natural
        , driver_SEMAX = None Natural
        , driver_SEDN = None Natural
        , driver_SEIMIN = None Natural
        , diag_pin = None KlipperConfig.McuPinInput.Type
        }
    }

let TMC2209Text =
    { uart_pin : Optional Text
    , tx_pin : Optional Text
    , select_pins : Optional Text
    , interpolate : Optional Text
    , run_current : Optional Text
    , hold_current : Optional Text
    , sense_resistor : Optional Text
    , stealthchop_threshold : Optional Text
    , coolstep_threshold : Optional Text
    , uart_address : Optional Text
    , driver_MULTISTEP_FILT : Optional Text
    , driver_IHOLDDELAY : Optional Text
    , driver_TPOWERDOWN : Optional Text
    , driver_TBL : Optional Text
    , driver_TOFF : Optional Text
    , driver_HEND : Optional Text
    , driver_HSTRT : Optional Text
    , driver_PWM_AUTOGRAD : Optional Text
    , driver_PWM_AUTOSCALE : Optional Text
    , driver_PWM_LIM : Optional Text
    , driver_PWM_REG : Optional Text
    , driver_PWM_FREQ : Optional Text
    , driver_PWM_GRAD : Optional Text
    , driver_PWM_OFS : Optional Text
    , driver_SGTHRS : Optional Text
    , driver_SEMIN : Optional Text
    , driver_SEUP : Optional Text
    , driver_SEMAX : Optional Text
    , driver_SEDN : Optional Text
    , driver_SEIMIN : Optional Text
    , diag_pin : Optional Text
    }




let toTMC2209Text
    : TMC2209.Type -> TMC2209Text
    = \(tmc2209 : TMC2209.Type) ->
    { uart_pin = Some (KlipperConfig.renderMcuPinOutput tmc2209.uart_pin)
    , tx_pin = Prelude.Optional.map KlipperConfig.McuPinOutput.Type Text KlipperConfig.renderMcuPinOutput tmc2209.tx_pin
    , select_pins = tmc2209.select_pins
    , interpolate = Prelude.Optional.map Bool Text Prelude.Bool.show tmc2209.interpolate
    , run_current = Some (Prelude.Double.show tmc2209.run_current)
    , hold_current = Prelude.Optional.map Double Text Prelude.Double.show tmc2209.hold_current
    , sense_resistor = Prelude.Optional.map Double Text Prelude.Double.show tmc2209.sense_resistor
    , stealthchop_threshold = Prelude.Optional.map Double Text Prelude.Double.show tmc2209.stealthchop_threshold
    , coolstep_threshold = Prelude.Optional.map Double Text Prelude.Double.show tmc2209.coolstep_threshold
    , uart_address = Prelude.Optional.map Natural Text Prelude.Natural.show tmc2209.uart_address
    , driver_MULTISTEP_FILT = Prelude.Optional.map Bool Text Prelude.Bool.show tmc2209.driver_MULTISTEP_FILT
    , driver_IHOLDDELAY = Prelude.Optional.map Natural Text Prelude.Natural.show tmc2209.driver_IHOLDDELAY
    , driver_TPOWERDOWN = Prelude.Optional.map Natural Text Prelude.Natural.show tmc2209.driver_TPOWERDOWN
    , driver_TBL = Prelude.Optional.map Natural Text Prelude.Natural.show tmc2209.driver_TBL
    , driver_TOFF = Prelude.Optional.map Natural Text Prelude.Natural.show tmc2209.driver_TOFF
    , driver_HEND = Prelude.Optional.map Natural Text Prelude.Natural.show tmc2209.driver_HEND
    , driver_HSTRT = Prelude.Optional.map Natural Text Prelude.Natural.show tmc2209.driver_HSTRT
    , driver_PWM_AUTOGRAD = Prelude.Optional.map Bool Text Prelude.Bool.show tmc2209.driver_PWM_AUTOGRAD
    , driver_PWM_AUTOSCALE = Prelude.Optional.map Bool Text Prelude.Bool.show tmc2209.driver_PWM_AUTOSCALE
    , driver_PWM_LIM = Prelude.Optional.map Natural Text Prelude.Natural.show tmc2209.driver_PWM_LIM
    , driver_PWM_REG = Prelude.Optional.map Natural Text Prelude.Natural.show tmc2209.driver_PWM_REG
    , driver_PWM_FREQ = Prelude.Optional.map Natural Text Prelude.Natural.show tmc2209.driver_PWM_FREQ
    , driver_PWM_GRAD = Prelude.Optional.map Natural Text Prelude.Natural.show tmc2209.driver_PWM_GRAD
    , driver_PWM_OFS = Prelude.Optional.map Natural Text Prelude.Natural.show tmc2209.driver_PWM_OFS
    , driver_SGTHRS = Prelude.Optional.map Natural Text Prelude.Natural.show tmc2209.driver_SGTHRS
    , driver_SEMIN = Prelude.Optional.map Natural Text Prelude.Natural.show tmc2209.driver_SEMIN
    , driver_SEUP = Prelude.Optional.map Natural Text Prelude.Natural.show tmc2209.driver_SEUP
    , driver_SEMAX = Prelude.Optional.map Natural Text Prelude.Natural.show tmc2209.driver_SEMAX
    , driver_SEDN = Prelude.Optional.map Natural Text Prelude.Natural.show tmc2209.driver_SEDN
    , driver_SEIMIN = Prelude.Optional.map Natural Text Prelude.Natural.show tmc2209.driver_SEIMIN
    , diag_pin = Prelude.Optional.map KlipperConfig.McuPinInput.Type Text KlipperConfig.renderMcuPinInput tmc2209.diag_pin
    }

let NamedTMC2209 : Type =
    { name : Text
    , tmc2209 : TMC2209.Type
    }

let toKlipperConfigSection
    : NamedTMC2209 -> List KlipperConfig.KlipperConfigSection
    = \(namedTMC2209 : NamedTMC2209) ->
        [{ name = "tmc2209"
        , prefix = Some (namedTMC2209.name)
        , properties = toMap (toTMC2209Text namedTMC2209.tmc2209)
        }]

in  { NamedTMC2209 = NamedTMC2209
    , TMC2209 = TMC2209
    , toKlipperConfigSection = toKlipperConfigSection
    , toTMC2209Text = toTMC2209Text
    }
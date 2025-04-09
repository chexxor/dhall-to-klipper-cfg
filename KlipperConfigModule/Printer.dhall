let Stepper = ./Stepper.dhall
let KlipperConfig = ../klipperConfig.dhall

let Prelude =
    { Text = https://prelude.dhall-lang.org/Text/package.dhall
    , Natural = https://prelude.dhall-lang.org/Natural/package.dhall
    , Optional = https://prelude.dhall-lang.org/Optional/package.dhall
    , Double = https://prelude.dhall-lang.org/Double/package.dhall
    }

let Kinematics =
    < Cartesian
    | Delta
    | Deltesian
    | CoreXY
    | CoreXZ
    | HybridCoreXY
    | HybridCoreXZ
    | Polar
    | RotaryDelta
    | Winch
    | None
    >

let renderKinematics = \(kinematics : Kinematics) ->
    merge
        { Cartesian = "cartesian"
        , Delta = "delta"
        , Deltesian = "deltesian"
        , CoreXY = "corexy"
        , CoreXZ = "corexz"
        , HybridCoreXY = "hybrid_corexy"
        , HybridCoreXZ = "hybrid_corexz"
        , Polar = "polar"
        , RotaryDelta = "rotary_delta"
        , Winch = "winch"
        , None = "none"
        }
        kinematics

let Printer =
    { Type = {
        kinematics : Kinematics,
        max_velocity : Natural,
        max_accel : Natural,
        minimum_cruise_ratio : Optional Double,
        square_corner_velocity : Optional Double,
        max_z_velocity : Optional Natural,
        max_z_accel : Optional Natural,
        minimum_z_position : Optional Natural,
        delta_radius : Optional Double,
        print_radius : Optional Natural,
        min_angle : Optional Natural,
        print_width : Optional Natural,
        slow_ratio : Optional Natural,
        shoulder_radius : Optional Natural,
        shoulder_height : Optional Natural,
      }
    , default = {
        max_velocity = 200,
        max_accel = 3000,
        minimum_cruise_ratio = None Double,
        square_corner_velocity = None Double,
        max_z_velocity = None Natural,
        max_z_accel = None Natural,
        minimum_z_position = None Natural,
        delta_radius = None Double,
        print_radius = None Natural,
        min_angle = None Natural,
        print_width = None Natural,
        slow_ratio = None Natural,
        shoulder_radius = None Natural,
        shoulder_height = None Natural,
      }
    }

let PrinterText =
    { kinematics : Optional Text
    , max_velocity : Optional Text
    , max_accel : Optional Text
    , minimum_cruise_ratio : Optional Text
    , square_corner_velocity : Optional Text
    , max_z_velocity : Optional Text
    , max_z_accel : Optional Text
    , minimum_z_position : Optional Text
    , delta_radius : Optional Text
    , print_radius : Optional Text
    , min_angle : Optional Text
    , print_width : Optional Text
    , slow_ratio : Optional Text
    , shoulder_radius : Optional Text
    , shoulder_height : Optional Text
    }

let toPrinterText
    : Printer.Type -> PrinterText
    = \(printer : Printer.Type) ->
    { kinematics = Some (renderKinematics printer.kinematics)
    , max_velocity = Some (Prelude.Natural.show printer.max_velocity)
    , max_accel = Some (Prelude.Natural.show printer.max_accel)
    , minimum_cruise_ratio = Prelude.Optional.map Double Text Prelude.Double.show printer.minimum_cruise_ratio
    , square_corner_velocity = Prelude.Optional.map Double Text Prelude.Double.show printer.square_corner_velocity
    , max_z_velocity = Prelude.Optional.map Natural Text Prelude.Natural.show printer.max_z_velocity
    , max_z_accel = Prelude.Optional.map Natural Text Prelude.Natural.show printer.max_z_accel
    , minimum_z_position = Prelude.Optional.map Natural Text Prelude.Natural.show printer.minimum_z_position
    , delta_radius = Prelude.Optional.map Double Text Prelude.Double.show printer.delta_radius
    , print_radius = Prelude.Optional.map Natural Text Prelude.Natural.show printer.print_radius
    , min_angle = Prelude.Optional.map Natural Text Prelude.Natural.show printer.min_angle
    , print_width = Prelude.Optional.map Natural Text Prelude.Natural.show printer.print_width
    , slow_ratio = Prelude.Optional.map Natural Text Prelude.Natural.show printer.slow_ratio
    , shoulder_radius = Prelude.Optional.map Natural Text Prelude.Natural.show printer.shoulder_radius
    , shoulder_height = Prelude.Optional.map Natural Text Prelude.Natural.show printer.shoulder_height
    }

let PrinterWithSteppers =
    { printer : Printer.Type
    , stepper_1 : Stepper.NamedStepper
    , stepper_2 : Stepper.NamedStepper
    , stepper_3 : Stepper.NamedStepper
    , stepper_4 : Optional Stepper.NamedStepper
    , stepper_5 : Optional Stepper.NamedStepper
    , stepper_6 : Optional Stepper.NamedStepper
    }

let optionalStepperToKlipperConfigSection
    : Optional Stepper.NamedStepper -> List KlipperConfig.KlipperConfigSection
    = \(stepper : Optional Stepper.NamedStepper) ->
        Prelude.Optional.default (List KlipperConfig.KlipperConfigSection)
            ([] : List KlipperConfig.KlipperConfigSection)
            (Prelude.Optional.map
                Stepper.NamedStepper (List KlipperConfig.KlipperConfigSection)
                Stepper.toKlipperConfigSection
                stepper)

let toKlipperConfigSection
    : PrinterWithSteppers -> List KlipperConfig.KlipperConfigSection
    = \(printerWithSteppers : PrinterWithSteppers) ->
        [{ name = "printer"
        , prefix = None Text
        , properties = toMap (toPrinterText printerWithSteppers.printer)
        }]
        # Stepper.toKlipperConfigSection printerWithSteppers.stepper_1
        # Stepper.toKlipperConfigSection printerWithSteppers.stepper_2
        # Stepper.toKlipperConfigSection printerWithSteppers.stepper_3
        # optionalStepperToKlipperConfigSection printerWithSteppers.stepper_4
        # optionalStepperToKlipperConfigSection printerWithSteppers.stepper_5
        # optionalStepperToKlipperConfigSection printerWithSteppers.stepper_6

-- Convenience functions for building a Printer module of a certain kinematics type.
-- Each kinematics type has a different set of required properties.
-- These functions ensure that the correct properties are set for the given kinematics type.

let cartesianPrinter
    : { max_velocity: Natural, max_accel: Natural }
    -> Stepper.NamedStepper
    -> Stepper.NamedStepper
    -> Stepper.NamedStepper
    -> PrinterWithSteppers
    = \(config : { max_velocity: Natural, max_accel: Natural })
    -> \(stepper_1 : Stepper.NamedStepper)
    -> \(stepper_2 : Stepper.NamedStepper)
    -> \(stepper_3 : Stepper.NamedStepper)
    -> { printer = Printer::
            { kinematics = Kinematics.Cartesian
            , max_velocity = config.max_velocity
            , max_accel = config.max_accel
            }
        , stepper_1 = stepper_1
        , stepper_2 = stepper_2
        , stepper_3 = stepper_3
        , stepper_4 = None Stepper.NamedStepper
        , stepper_5 = None Stepper.NamedStepper
        , stepper_6 = None Stepper.NamedStepper
        }

let linearDeltaPrinter
    : { max_velocity: Natural
      , max_accel: Natural
      , delta_radius: Double
      , print_radius: Natural
      }
    -> Stepper.NamedStepper
    -> Stepper.NamedStepper
    -> Stepper.NamedStepper
    -> PrinterWithSteppers
    = \(config : { max_velocity: Natural
                 , max_accel: Natural
                 , delta_radius: Double
                 , print_radius: Natural
                 })
    -> \(stepper_1 : Stepper.NamedStepper)
    -> \(stepper_2 : Stepper.NamedStepper)
    -> \(stepper_3 : Stepper.NamedStepper)
    -> { printer = Printer::
            { kinematics = Kinematics.Delta
            , max_velocity = config.max_velocity
            , max_accel = config.max_accel
            , delta_radius = Some config.delta_radius
            , print_radius = Some config.print_radius
            }
        , stepper_1 = stepper_1
        , stepper_2 = stepper_2
        , stepper_3 = stepper_3
        , stepper_4 = None Stepper.NamedStepper
        , stepper_5 = None Stepper.NamedStepper
        , stepper_6 = None Stepper.NamedStepper
        }

let deltesianPrinter
    : { max_z_velocity: Natural
      , max_z_accel: Natural
      , minimum_z_position: Natural
      , print_width: Natural
      , slow_ratio: Natural
      }
    -> Stepper.NamedStepper
    -> Stepper.NamedStepper
    -> Stepper.NamedStepper
    -> PrinterWithSteppers
    = \(config : { max_z_velocity: Natural
                 , max_z_accel: Natural
                 , minimum_z_position: Natural
                 , print_width: Natural
                 , slow_ratio: Natural
                 })
    -> \(stepper_1 : Stepper.NamedStepper)
    -> \(stepper_2 : Stepper.NamedStepper)
    -> \(stepper_3 : Stepper.NamedStepper)
    -> { printer = Printer::
            { kinematics = Kinematics.Deltesian
            , max_z_velocity = Some config.max_z_velocity
            , max_z_accel = Some config.max_z_accel
            , minimum_z_position = Some config.minimum_z_position
            , print_width = Some config.print_width
            , slow_ratio = Some config.slow_ratio
            }
        , stepper_1 = stepper_1
        , stepper_2 = stepper_2
        , stepper_3 = stepper_3
        , stepper_4 = None Stepper.NamedStepper
        , stepper_5 = None Stepper.NamedStepper
        , stepper_6 = None Stepper.NamedStepper
        }

    -- Types
in  { Kinematics = Kinematics
    , Printer = Printer
    , PrinterWithSteppers = PrinterWithSteppers

    -- Interface
    , toKlipperConfigSection = toKlipperConfigSection

    -- Convenience functions for building a Printer module of a certain kinematics type.
    , cartesianPrinter = cartesianPrinter
    , linearDeltaPrinter = linearDeltaPrinter
    , deltesianPrinter = deltesianPrinter
    }
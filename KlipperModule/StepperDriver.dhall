let Prelude =
    { Text = https://prelude.dhall-lang.org/Text/package.dhall
    , List = https://prelude.dhall-lang.org/List/package.dhall
    , Natural = https://prelude.dhall-lang.org/Natural/package.dhall
    , Double = https://prelude.dhall-lang.org/Double/package.dhall
    , Bool = https://prelude.dhall-lang.org/Bool/package.dhall
    , Optional = https://prelude.dhall-lang.org/Optional/package.dhall
    , Map = https://prelude.dhall-lang.org/Map/package.dhall
    }

let KlipperConfig = ../klipperConfig.dhall
let TMC2209Module = ./StepperDriver/TMC2209.dhall

let StepperDriver =
    <
        TMC2209 : TMC2209Module.Type
    >

let NamedStepperDriver : Type =
    { name : Text
    , stepper_driver : StepperDriver
    }

-- let NamedTMC2209 : Type =
--     { name : Text
--     , tmc2209 : TMC2209.Type
--     }

let toKlipperConfigSection
    : NamedStepperDriver -> List KlipperConfig.KlipperConfigSection
    = \(namedStepperDriver : NamedStepperDriver) ->
        ([] : List KlipperConfig.KlipperConfigSection)
            # (merge {
                TMC2209 = \(tmc2209Config : TMC2209Module.Type) ->
                    TMC2209Module.toKlipperConfigSection
                        { name = namedStepperDriver.name
                        , tmc2209 = tmc2209Config
                        }
                }
                namedStepperDriver.stepper_driver
            )

in  { NamedStepperDriver = NamedStepperDriver
    , StepperDriver = StepperDriver
    , toKlipperConfigSection = toKlipperConfigSection
    , TMC2209 = TMC2209Module
    }
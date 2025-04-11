let Prelude =
    { Text = https://prelude.dhall-lang.org/Text/package.dhall
    , List = https://prelude.dhall-lang.org/List/package.dhall
    , Natural = https://prelude.dhall-lang.org/Natural/package.dhall
    , Double = https://prelude.dhall-lang.org/Double/package.dhall
    , Bool = https://prelude.dhall-lang.org/Bool/package.dhall
    , Optional = https://prelude.dhall-lang.org/Optional/package.dhall
    , Map = https://prelude.dhall-lang.org/Map/package.dhall
    }


let KlipperConfigProperty : Type = { mapKey : Text, mapValue : Optional Text }

let renderKlipperConfigProperty
    : KlipperConfigProperty -> Text
    = \(property : KlipperConfigProperty) ->
    let propertyValueText = Prelude.Optional.default Text "" property.mapValue
    in "${property.mapKey}: ${propertyValueText}"

-- [name prefix]
-- properties
-- Example: Value
-- [fan my_fan]
-- pin: my_pin
-- min_speed: 100
let KlipperConfigSection = {
    name: Text,
    prefix: Optional Text,
    properties: List KlipperConfigProperty
}

let renderKlipperConfigSection = \(section : KlipperConfigSection) ->
    let sectionPrefix = Prelude.Optional.default Text "" section.prefix
    let sectionTitle =
        if Prelude.Optional.null Text section.prefix
        then section.name
        else "${section.name} ${sectionPrefix}"

    let nonNullPropertyLinesText = Prelude.List.filterMap
        KlipperConfigProperty
        Text
        (\(property : KlipperConfigProperty) ->
            if Prelude.Optional.null Text property.mapValue
            then None Text
            else Some (renderKlipperConfigProperty property)
        )
        section.properties

    let nonNullPropertiesText = Prelude.Text.concatSep "\n" nonNullPropertyLinesText
    in "[${sectionTitle}]\n${nonNullPropertiesText}"


let KlipperConfig = List KlipperConfigSection

let renderKlipperConfig
    : KlipperConfig -> Text
    = \(config : KlipperConfig) ->
        Prelude.Text.concatSep "\n\n" (
            Prelude.List.map KlipperConfigSection Text renderKlipperConfigSection config
        )

-- Klipper uses the hardware names for these pins - for example PA4.
-- Pin names may be preceded by ! to indicate that a reverse polarity
-- should be used (eg, trigger on low instead of high).
-- Input pins may be preceded by ^ to indicate that a hardware pull-up
-- resistor should be enabled for the pin.
-- If the micro-controller supports pull-down resistors then an input
-- pin may alternatively be preceded by ~.
let McuPinResistor = < PullUp | PullDown | None >
let McuPinInput = {
    Type = {
        hardware_name: Text,
        reverse_polarity: Bool, -- to specify !
        resistor: McuPinResistor, -- to specify ^ or ~
    },
    default = {
        reverse_polarity = False, -- !
        resistor = McuPinResistor.None, -- exclude ^ or ~
    }
}
let McuPinOutput = {
    Type = {
        hardware_name: Text,
        reverse_polarity: Bool, -- to specify !
    },
    default = {
        reverse_polarity = False, -- without !
    }
}

let renderMcuPin
    : McuPin -> Text
    = \(pin : McuPin) ->
    let polarityText = if pin.reverse_polarity then "!" else ""
    let resistorText =
        merge
        { PullUp = "^"
        , PullDown = "~"
        , None = ""
        } pin.resistor
    in "${polarityText}${resistorText}${pin.hardware_name}"


in  { KlipperConfigProperty = KlipperConfigProperty
    , KlipperConfigSection = KlipperConfigSection
    , KlipperConfig = KlipperConfig
    , renderKlipperConfig = renderKlipperConfig

    , McuPinResistor = McuPinResistor
    , McuPinInput = McuPinInput
    , McuPinOutput = McuPinOutput
    , renderMcuPin = renderMcuPin
    }
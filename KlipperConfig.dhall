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
-- Example:
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

in  { KlipperConfigProperty = KlipperConfigProperty
    , KlipperConfigSection = KlipperConfigSection
    , KlipperConfig = KlipperConfig
    , renderKlipperConfig = renderKlipperConfig
    }
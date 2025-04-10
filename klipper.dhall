let Prelude =
    { Text = https://prelude.dhall-lang.org/Text/package.dhall
    , Natural = https://prelude.dhall-lang.org/Natural/package.dhall
    , Double = https://prelude.dhall-lang.org/Double/package.dhall
    , Bool = https://prelude.dhall-lang.org/Bool/package.dhall
    , Optional = https://prelude.dhall-lang.org/Optional/package.dhall
    }

let PrinterModule = ./config/modules/printer.dhall


let MCU =
    { Type = {
        -- Basic MCU configuration
        serial: Text,
        baudrate: Natural,
        restart_method: Text,

        -- Pin mappings for required components
        pins: {
            -- Stepper motor pins
            stepperXStep: Text,
            stepperXDir: Text,
            stepperXEnable: Text,
            stepperXEndstop: Text,
            stepperYStep: Text,
            stepperYDir: Text,
            stepperYEnable: Text,
            stepperYEndstop: Text,
            stepperZStep: Text,
            stepperZDir: Text,
            stepperZEnable: Text,
            stepperZEndstop: Text,
            -- Extruder pins
            extruderStep: Text,
            extruderDir: Text,
            extruderEnable: Text,
            extruderHeater: Text,
            extruderSensor: Text,
            -- Bed pins
            bedHeater: Text,
            bedSensor: Text,
            -- Fan pins
            partCoolingFan: Text,
            heaterCoolingFan: Text,
            controllerFan: Text,
            -- Probe pins
            probeSignal: Text,
            probeServo: Text
        },

        -- Optional features (all optional)
        optional_pins: Optional {
            neopixelPin: Text,
            filamentSensorPin: Text,
            powerMonitorPin: Text
        },

        -- Display configuration (all optional)
        display: Optional {
            spi_bus: Text,
            cs_pin: Text,
            dc_pin: Text,
            reset_pin: Text
        },

        -- Board pin aliases (optional)
        pin_aliases: Optional {
            -- Any number of pin aliases can be defined
            _: Text
        }
      }
    , default = {
        baudrate = 250000,
        restart_method = "command"
      }
    }




let Extruder =
    { Type = {
        stepPin : Text,
        dirPin : Text,
        enablePin : Text,
        microsteps : Natural,
        rotationDistance : Double,
        nozzleDiameter : Double,
        filamentDiameter : Double,
        maxExtrudeOnlyDistance : Double,
        maxExtrudeOnlyVelocity : Natural,
        maxExtrudeOnlyAccel : Natural
      }
    , default = {
        microsteps = 16,
        nozzleDiameter = 0.4,
        filamentDiameter = 1.75,
        maxExtrudeOnlyDistance = 50.0,
        maxExtrudeOnlyVelocity = 50,
        maxExtrudeOnlyAccel = 500
      }
    }

let Heater =
    { Type = {
        heaterPin : Text,
        sensorType : Text,
        sensorPin : Text,
        control : Text,
        pidKp : Double,
        pidKi : Double,
        pidKd : Double,
        minTemp : Double,
        maxTemp : Double
      }
    , default = {
        control = "pid",
        minTemp = 0.0,
        maxTemp = 300.0
      }
    }

let Fan =
    { Type = {
        pin : Text,
        kickStartTime : Optional Double,
        offBelow : Optional Double
      }
    , default = {
        kickStartTime = None Double,
        offBelow = None Double
      }
    }

let DeltaParams =
    { Type = {
        deltaRadius : Double,
        armLength : Double,
        towerAngles : List Double,
        endstopAdjustments : List Double,
        angleCorrections : List Double,
        radiusCorrection : Double,
        printRadius : Double,
        maxZHeight : Double
      }
    , default = {
        deltaRadius = 130.0,
        armLength = 250.0,
        towerAngles = [ 210.0, 330.0, 90.0 ],
        endstopAdjustments = [ 0.0, 0.0, 0.0 ],
        angleCorrections = [ 0.0, 0.0, 0.0 ],
        radiusCorrection = 0.0,
        printRadius = 100.0,
        maxZHeight = 200.0
      }
    }

let convertToKlipperFields = \(record : { _ : { _ : Text } }) ->
    let convertFieldName = \(name : Text) ->
        Prelude.Text.lowerASCII (Prelude.Text.replace "([A-Z])" ("_" ++ "${1}") name)

    let convertValue = \(value : { _ : Text }) ->
        merge
            { Text = \(x : Text) -> x
            , Natural = \(x : Natural) -> Prelude.Natural.show x
            , Double = \(x : Double) -> Prelude.Double.show x
            , Bool = \(x : Bool) -> Prelude.Bool.show x
            , List = \(x : List { _ : Text }) ->
                Prelude.Text.concatMapSep ", " { _ : Text } (\(y : { _ : Text }) ->
                    convertValue y
                ) x
            }
            value

    let example0 = assert : convertFieldName "maxVelocity" ≡ "max_velocity"
    let example1 = assert : convertFieldName "stepperXStep" ≡ "stepper_x_step"
    let example2 = assert : convertFieldName "nozzleDiameter" ≡ "nozzle_diameter"
    let example3 = assert : convertFieldName "PIDKp" ≡ "pid_kp"
    let example4 = assert : convertFieldName "endstopAdjustments" ≡ "endstop_adjustments"

    let textRecord = record // { _ = Text }
    in Prelude.List.fold
        { mapKey : Text, mapValue : Text }
        (List { mapKey : Text, mapValue : Text })
        (\(field : { mapKey : Text, mapValue : Text }) -> \(acc : List { mapKey : Text, mapValue : Text }) ->
            acc # [ { mapKey = convertFieldName field.mapKey, mapValue = field.mapValue } ]
        )
        ([] : List { mapKey : Text, mapValue : Text })
        (toMap textRecord)

let renderSection = \(module : Text) -> \(prefix : Text) -> \(fields : List { mapKey : Text, mapValue : Text }) ->
    let renderField = \(field : { mapKey : Text, mapValue : Text }) ->
        "${field.mapKey}: ${field.mapValue}"
    in  ''
        [${module} ${prefix}]
        ${Prelude.Text.concatMapSep "\n" { mapKey : Text, mapValue : Text } renderField fields}
        ''

let renderStepper = \(name : Text) -> \(stepper : Stepper.Type) ->
    let fields = convertToKlipperFields stepper
    in renderSection "stepper" name fields

let renderExtruder = \(extruder : Extruder.Type) ->
    let fields = convertToKlipperFields extruder
    in renderSection "extruder" "" fields

let renderHeater = \(name : Text) -> \(heater : Heater.Type) ->
    let fields = convertToKlipperFields heater
    in renderSection "heater" name fields

let renderFan = \(name : Text) -> \(fan : Fan.Type) ->
    let baseFields = [ { mapKey = "pin", mapValue = fan.pin } ]
    let kickStartField =
        if Prelude.Optional.null Double fan.kickStartTime
        then [] : List { mapKey : Text, mapValue : Text }
        else [ { mapKey = "kick_start_time", mapValue = Prelude.Double.show (Prelude.Optional.default Double 0.0 fan.kickStartTime) } ]
    let offBelowField =
        if Prelude.Optional.null Double fan.offBelow
        then [] : List { mapKey : Text, mapValue : Text }
        else [ { mapKey = "off_below", mapValue = Prelude.Double.show (Prelude.Optional.default Double 0.0 fan.offBelow) } ]
    let allFields = baseFields # kickStartField # offBelowField
    in renderSection "fan" name allFields

let renderDeltaParams = \(params : DeltaParams.Type) ->
    let fields = convertToKlipperFields params
    in renderSection "delta" "" fields

let renderMCU = \(name : Text) -> \(mcu : MCU.Type) ->
    let basicFields = [
        { mapKey = "serial", mapValue = mcu.serial },
        { mapKey = "baudrate", mapValue = Prelude.Natural.show mcu.baudrate },
        { mapKey = "restart_method", mapValue = mcu.restart_method }
    ]

    let renderRecord = \(record : { _ : Text }) ->
        toMap record

    let renderOptionalRecord = \(record : Optional { _ : Text }) ->
        if Prelude.Optional.null { _ : Text } record
        then [] : List { mapKey : Text, mapValue : Text }
        else renderRecord (Prelude.Optional.default { _ : Text } {=} record)

    let renderDisplay = \(display : Optional { spi_bus : Text, cs_pin : Text, dc_pin : Text, reset_pin : Text }) ->
        if Prelude.Optional.null { spi_bus : Text, cs_pin : Text, dc_pin : Text, reset_pin : Text } display
        then [] : List { mapKey : Text, mapValue : Text }
        else renderRecord (Prelude.Optional.default { spi_bus : Text, cs_pin : Text, dc_pin : Text, reset_pin : Text } { spi_bus = "", cs_pin = "", dc_pin = "", reset_pin = "" } display)

    let allFields = basicFields
        # renderRecord mcu.pins
        # renderOptionalRecord mcu.optional_pins
        # renderDisplay mcu.display
        # renderOptionalRecord mcu.pin_aliases

    renderSection "mcu" name allFields

let renderOptional = \(a : Type) -> \(f : a -> Text) -> \(optional : Optional a) ->
    Prelude.Optional.fold a optional Text f ""

let renderOptionalStepper = \(name : Text) ->
    renderOptional Stepper.Type (\(stepper : Stepper.Type) -> renderStepper name stepper)

let renderOptionalExtruder =
    renderOptional Extruder.Type renderExtruder

let renderOptionalHeater = \(name : Text) ->
    renderOptional Heater.Type (\(heater : Heater.Type) -> renderHeater name heater)

let renderOptionalFan = \(name : Text) ->
    renderOptional Fan.Type (\(fan : Fan.Type) -> renderFan name fan)

let renderOptionalDeltaParams =
    renderOptional DeltaParams.Type renderDeltaParams

let renderOptionalMCU = \(name : Text) ->
    renderOptional MCU.Type (\(mcu : MCU.Type) -> renderMCU name mcu)

let renderConfig2 = \(printer : PrinterModule.Printer.Type) ->
    Prelude.Text.concatSep "\n\n" (
        Prelude.List.filter Text (\(x : Text) -> x != "") [
            PrinterModule.renderPrinter printer,
            renderOptionalStepper "x" printer.stepperX,
            renderOptionalStepper "y" printer.stepperY,
            renderOptionalStepper "z" printer.stepperZ,
            renderOptionalExtruder printer.extruder,
            renderOptionalHeater "bed" printer.heaterBed,
            renderOptionalFan "general" printer.fan,
            renderOptionalDeltaParams printer.deltaParams,
            renderOptionalMCU "mcu" printer.mcu
        ]
    )

let renderConfig = \(printer : Printer.Type) ->
    let sections = [ renderPrinter printer ]
    let sections = sections # Prelude.Optional.fold Stepper.Type printer.stepperX (List Text) (\(x : Stepper.Type) -> [ renderStepper "x" x ]) ([] : List Text)
    let sections = sections # Prelude.Optional.fold Stepper.Type printer.stepperY (List Text) (\(y : Stepper.Type) -> [ renderStepper "y" y ]) ([] : List Text)
    let sections = sections # Prelude.Optional.fold Stepper.Type printer.stepperZ (List Text) (\(z : Stepper.Type) -> [ renderStepper "z" z ]) ([] : List Text)
    let sections = sections # Prelude.Optional.fold Extruder.Type printer.extruder (List Text) (\(extruder : Extruder.Type) -> [ renderExtruder extruder ]) ([] : List Text)
    let sections = sections # Prelude.Optional.fold Heater.Type printer.heaterBed (List Text) (\(heater : Heater.Type) -> [ renderHeater "bed" heater ]) ([] : List Text)
    let sections = sections # Prelude.Optional.fold Fan.Type printer.fan (List Text) (\(fan : Fan.Type) -> [ renderFan "general" fan ]) ([] : List Text)
    let sections = sections # Prelude.Optional.fold DeltaParams.Type printer.deltaParams (List Text) (\(params : DeltaParams.Type) -> [ renderDeltaParams params ]) ([] : List Text)
    let sections = sections # Prelude.Optional.fold MCU.Type printer.mcu (List Text) (\(mcu : MCU.Type) -> [ renderMCU "mcu" mcu ]) ([] : List Text)
    in Prelude.Text.concatSep "\n\n" sections

in  { Printer = Printer
    , Stepper = Stepper
    , Extruder = Extruder
    , Heater = Heater
    , Fan = Fan
    , DeltaParams = DeltaParams
    , MCU = MCU
    , Kinematics = Kinematics
    , renderConfig = renderConfig
    }
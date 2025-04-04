let Prelude =
    { Text = https://prelude.dhall-lang.org/Text/package.dhall
    , Natural = https://prelude.dhall-lang.org/Natural/package.dhall
    , Double = https://prelude.dhall-lang.org/Double/package.dhall
    , Bool = https://prelude.dhall-lang.org/Bool/package.dhall
    , Optional = https://prelude.dhall-lang.org/Optional/package.dhall
    }

let Kinematics = < Cartesian | CoreXY | Delta | HybridCoreXY | HybridDelta >

let showKinematics = \(k : Kinematics) ->
    merge
        { Cartesian = "cartesian"
        , CoreXY = "corexy"
        , Delta = "delta"
        , HybridCoreXY = "hybrid_corexy"
        , HybridDelta = "hybrid_delta"
        }
        k

let Stepper =
    { Type = {
        stepPin : Text,
        dirPin : Text,
        enablePin : Text,
        microsteps : Natural,
        rotationDistance : Double,
        positionEndstop : Double,
        positionMin : Double,
        positionMax : Double,
        homingSpeed : Natural,
        homingRetractDist : Double,
        homingPositiveDir : Bool
      }
    , default = {
        microsteps = 16,
        homingSpeed = 50,
        homingRetractDist = 5.0,
        homingPositiveDir = True
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

let Printer =
    { Type = {
        name : Text,
        kinematics : Kinematics,
        maxVelocity : Natural,
        maxAccel : Natural,
        maxZVelocity : Natural,
        maxZAccel : Natural,
        stepperX : Optional Stepper.Type,
        stepperY : Optional Stepper.Type,
        stepperZ : Optional Stepper.Type,
        extruder : Optional Extruder.Type,
        heaterBed : Optional Heater.Type,
        fan : Optional Fan.Type
      }
    , default = {
        maxVelocity = 200,
        maxAccel = 3000,
        maxZVelocity = 5,
        maxZAccel = 100,
        stepperX = None Stepper.Type,
        stepperY = None Stepper.Type,
        stepperZ = None Stepper.Type,
        extruder = None Extruder.Type,
        heaterBed = None Heater.Type,
        fan = None Fan.Type
      }
    }

let renderSection = \(name : Text) -> \(fields : List { mapKey : Text, mapValue : Text }) ->
    let renderField = \(field : { mapKey : Text, mapValue : Text }) ->
        "${field.mapKey}: ${field.mapValue}"
    in  ''
        [${name}]
        ${Prelude.Text.concatMapSep "\n" { mapKey : Text, mapValue : Text } renderField fields}
        ''

let renderPrinter = \(printer : Printer.Type) ->
    let printerFields = [
        { mapKey = "name", mapValue = printer.name },
        { mapKey = "kinematics", mapValue = showKinematics printer.kinematics },
        { mapKey = "max_velocity", mapValue = Prelude.Natural.show printer.maxVelocity },
        { mapKey = "max_accel", mapValue = Prelude.Natural.show printer.maxAccel },
        { mapKey = "max_z_velocity", mapValue = Prelude.Natural.show printer.maxZVelocity },
        { mapKey = "max_z_accel", mapValue = Prelude.Natural.show printer.maxZAccel }
    ]
    in  renderSection "printer" printerFields

let renderStepper = \(name : Text) -> \(stepper : Stepper.Type) ->
    let stepperFields = [
        { mapKey = "step_pin", mapValue = stepper.stepPin },
        { mapKey = "dir_pin", mapValue = stepper.dirPin },
        { mapKey = "enable_pin", mapValue = stepper.enablePin },
        { mapKey = "microsteps", mapValue = Prelude.Natural.show stepper.microsteps },
        { mapKey = "rotation_distance", mapValue = Prelude.Double.show stepper.rotationDistance },
        { mapKey = "position_endstop", mapValue = Prelude.Double.show stepper.positionEndstop },
        { mapKey = "position_min", mapValue = Prelude.Double.show stepper.positionMin },
        { mapKey = "position_max", mapValue = Prelude.Double.show stepper.positionMax },
        { mapKey = "homing_speed", mapValue = Prelude.Natural.show stepper.homingSpeed },
        { mapKey = "homing_retract_dist", mapValue = Prelude.Double.show stepper.homingRetractDist },
        { mapKey = "homing_positive_dir", mapValue = Prelude.Bool.show stepper.homingPositiveDir }
    ]
    in  renderSection "stepper_${name}" stepperFields

let renderExtruder = \(extruder : Extruder.Type) ->
    let extruderFields = [
        { mapKey = "step_pin", mapValue = extruder.stepPin },
        { mapKey = "dir_pin", mapValue = extruder.dirPin },
        { mapKey = "enable_pin", mapValue = extruder.enablePin },
        { mapKey = "microsteps", mapValue = Prelude.Natural.show extruder.microsteps },
        { mapKey = "rotation_distance", mapValue = Prelude.Double.show extruder.rotationDistance },
        { mapKey = "nozzle_diameter", mapValue = Prelude.Double.show extruder.nozzleDiameter },
        { mapKey = "filament_diameter", mapValue = Prelude.Double.show extruder.filamentDiameter },
        { mapKey = "max_extrude_only_distance", mapValue = Prelude.Double.show extruder.maxExtrudeOnlyDistance },
        { mapKey = "max_extrude_only_velocity", mapValue = Prelude.Natural.show extruder.maxExtrudeOnlyVelocity },
        { mapKey = "max_extrude_only_accel", mapValue = Prelude.Natural.show extruder.maxExtrudeOnlyAccel }
    ]
    in  renderSection "extruder" extruderFields

let renderHeater = \(name : Text) -> \(heater : Heater.Type) ->
    let heaterFields = [
        { mapKey = "heater_pin", mapValue = heater.heaterPin },
        { mapKey = "sensor_type", mapValue = heater.sensorType },
        { mapKey = "sensor_pin", mapValue = heater.sensorPin },
        { mapKey = "control", mapValue = heater.control },
        { mapKey = "pid_Kp", mapValue = Prelude.Double.show heater.pidKp },
        { mapKey = "pid_Ki", mapValue = Prelude.Double.show heater.pidKi },
        { mapKey = "pid_Kd", mapValue = Prelude.Double.show heater.pidKd },
        { mapKey = "min_temp", mapValue = Prelude.Double.show heater.minTemp },
        { mapKey = "max_temp", mapValue = Prelude.Double.show heater.maxTemp }
    ]
    in  renderSection "heater_${name}" heaterFields

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
    in  renderSection "fan_${name}" allFields

let renderConfig = \(printer : Printer.Type) ->
    let sections = [ renderPrinter printer ]
    let sections = sections # Prelude.Optional.fold Stepper.Type printer.stepperX (List Text) (\(x : Stepper.Type) -> [ renderStepper "x" x ]) ([] : List Text)
    let sections = sections # Prelude.Optional.fold Stepper.Type printer.stepperY (List Text) (\(y : Stepper.Type) -> [ renderStepper "y" y ]) ([] : List Text)
    let sections = sections # Prelude.Optional.fold Stepper.Type printer.stepperZ (List Text) (\(z : Stepper.Type) -> [ renderStepper "z" z ]) ([] : List Text)
    let sections = sections # Prelude.Optional.fold Extruder.Type printer.extruder (List Text) (\(extruder : Extruder.Type) -> [ renderExtruder extruder ]) ([] : List Text)
    let sections = sections # Prelude.Optional.fold Heater.Type printer.heaterBed (List Text) (\(heater : Heater.Type) -> [ renderHeater "bed" heater ]) ([] : List Text)
    let sections = sections # Prelude.Optional.fold Fan.Type printer.fan (List Text) (\(fan : Fan.Type) -> [ renderFan "general" fan ]) ([] : List Text)
    in Prelude.Text.concatSep "\n\n" sections

in  { Printer = Printer
    , Stepper = Stepper
    , Extruder = Extruder
    , Heater = Heater
    , Fan = Fan
    , Kinematics = Kinematics
    , renderConfig = renderConfig
    } 
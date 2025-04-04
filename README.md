# Dhall to Klipper Config

This project allows you to write your Klipper 3D printer configuration using the Dhall configuration language. Dhall provides type safety, code reuse, and better maintainability for your Klipper configuration.

## Features

- Type-safe Klipper configuration
- Reusable configuration components
- Validation at compile time
- Easy to maintain and refactor
- Support for all Klipper configuration sections

## Example Usage

```dhall
let Klipper = ./klipper.dhall

let stepper = \(name : Text) -> \(stepPin : Text) -> \(dirPin : Text) -> \(enablePin : Text) ->
    Klipper.Stepper::{
    , stepPin = stepPin
    , dirPin = dirPin
    , enablePin = enablePin
    , microsteps = 16
    , rotationDistance = 40.0
    , positionEndstop = 0.0
    , positionMin = 0.0
    , positionMax = 350.0
    , homingSpeed = 50
    , homingRetractDist = 5.0
    , homingPositiveDir = True
    }

let printer = Klipper.Printer::{
    , name = "My Printer"
    , kinematics = Klipper.Kinematics.Cartesian
    , maxVelocity = 200
    , maxAccel = 3000
    , maxZVelocity = 5
    , maxZAccel = 100
    , stepperX = Some (stepper "x" "ar2" "ar5" "!ar8")
    , stepperY = Some (stepper "y" "ar3" "ar6" "!ar9")
    , stepperZ = Some (stepper "z" "ar4" "ar7" "!ar10")
}

in Klipper.renderConfig printer
```

## Installation

1. Install Dhall: https://docs.dhall-lang.org/tutorials/Getting-started_Generate-JSON-or-YAML.html#installation
2. Clone this repository
3. Use the provided Dhall expressions to create your configuration

## Building

To convert your Dhall configuration to Klipper config:

```bash
.\bin\dhall.exe text --file your-config.dhall --output printer.cfg
```

For example, to convert the Voron 2.4 example configuration:

```bash
.\bin\dhall.exe text --file .\examples\voron2.4.dhall --output .\printer.cfg
```

## Project Structure

- `klipper.dhall` - Core types and functions for Klipper configuration
- `examples/` - Example configurations\
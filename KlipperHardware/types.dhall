let Prelude = https://prelude.dhall-lang.org/package.dhall
let McuModule = ../KlipperModule/Mcu.dhall
let KlipperConfig = ../KlipperConfig.dhall

let StepperInterface = {
    Type = {
        -- Step GPIO pin (triggered high).
        step_pin: KlipperConfig.McuPinOutput.Type,
        -- Direction GPIO pin (high indicates positive direction).
        dir_pin: KlipperConfig.McuPinOutput.Type,
        -- Enable pin (default is enable high; use ! to indicate enable
        -- low). If this parameter is not provided then the stepper motor
        -- driver must always be enabled.
        enable_pin: Optional KlipperConfig.McuPinOutput.Type,
        -- Endstop switch detection pin. If this endstop pin is on a
        -- different mcu than the stepper motor then it enables "multi-mcu-homing".
        endstop_pin: Optional KlipperConfig.McuPinInput.Type
    },
    default = {
        enable_pin = None KlipperConfig.McuPinOutput.Type,
        endstop_pin = None KlipperConfig.McuPinInput.Type
    }
}

let HeaterInterface = {
    heater_pin: KlipperConfig.McuPinOutput.Type,
    sensor_pin: KlipperConfig.McuPinInput.Type
}

let FanInterface = {
    pin: KlipperConfig.McuPinOutput.Type
}

let ExtruderInterface = {
    stepper: StepperInterface.Type,
    heater: HeaterInterface,
    fan: FanInterface
}


let MCU = {
    Type = {
        -- Basic MCU configuration
        serial: Text,
        baudrate: Natural,
        restart_method: Text,
        -- Stepper motor pins
        stepper_x : StepperInterface.Type,
        stepper_y : StepperInterface.Type,
        stepper_z : StepperInterface.Type,
        stepper_z1 : Optional StepperInterface.Type,
        stepper_z2 : Optional StepperInterface.Type,
        stepper_z3 : Optional StepperInterface.Type,
        -- Extruder pins
        extruder: ExtruderInterface,
        -- Bed pins
        bed: HeaterInterface,
        -- Fan pins
        part_cooling_fan_pin: KlipperConfig.McuPinOutput.Type,
        heater_cooling_fan_pin: KlipperConfig.McuPinOutput.Type,
        controller_fan_pin: KlipperConfig.McuPinOutput.Type,
        extra_fans: Optional (List KlipperConfig.McuPinOutput.Type),
        -- Probe pins
        probe_signal_pin: KlipperConfig.McuPinInput.Type,
        probe_servo_pin: KlipperConfig.McuPinOutput.Type,

        neopixel_pin: Optional KlipperConfig.McuPinOutput.Type,
        filament_sensor_pin: Optional KlipperConfig.McuPinInput.Type,
        power_monitor_pin: Optional KlipperConfig.McuPinInput.Type,

        -- Board pin aliases (optional)
        pin_aliases: Optional (Prelude.Map.Type Text Text)
    },
    default = {
        stepper_z1 = None StepperInterface.Type,
        stepper_z2 = None StepperInterface.Type,
        stepper_z3 = None StepperInterface.Type,
        extra_fans = None (List KlipperConfig.McuPinOutput.Type),
        pin_aliases = None (Prelude.Map.Type Text Text),
    }
}

-- let mcuToKlipperModule
--     : MCU -> McuModule.McuConfig
--     = \(mcu : MCU) ->
--     let mcuConfig = McuModule.McuConfig::
--         { serial = mcu.serial
--         , baud = mcu.baudrate
--         , restart_method = mcu.restart_method
--         }


-- let Axis = {
--     stepper: Text,
--     endstop: Text,
--     steps_per_mm: Natural,
--     max_velocity: Natural,
--     max_accel: Natural,
--     max_position: Natural
-- }

-- let Extruder = {
--     stepper: Text,
--     steps_per_mm: Natural,
--     max_velocity: Natural,
--     max_accel: Natural,
--     nozzle_diameter: Natural,
--     max_extrude_only_distance: Natural
-- }

-- let Bed = {
--     type: Text,
--     heater: Text,
--     sensor: Text,
--     max_temp: Natural,
--     min_temp: Natural
-- }

-- let Probe = {
--     type: Text,
--     pin: Text,
--     x_offset: Natural,
--     y_offset: Natural,
--     z_offset: Natural
-- }

-- let Fan = {
--     type: Text,
--     pin: Text,
--     max_power: Natural,
--     min_power: Natural,
--     kick_start_time: Natural
-- }

-- let Heater = {
--     type: Text,
--     pin: Text,
--     max_temp: Natural,
--     min_temp: Natural,
--     max_power: Natural
-- }

-- let TemperatureSensor = {
--     type: Text,
--     sensor_type: Text,
--     pin: Text
-- }

-- let Hardware = {
--     mcu: MCU,
--     axes: List Axis,
--     extruder: Extruder,
--     bed: Bed,
--     probe: Optional Probe,
--     fans: List Fan,
--     heaters: List Heater,
--     temperature_sensors: List TemperatureSensor
-- }

-- let Software = {
--     macros: List Text,
--     moonraker: Bool,
--     virtual_sdcard: Bool
-- }

-- let Kinematics = < CoreXY | Delta | Cartesian >

-- let MachineConfig = {
--     kinematics: Kinematics,
--     hardware: Hardware,
--     software: Software
-- }

in {
    StepperInterface = StepperInterface,
    ExtruderInterface = ExtruderInterface,
    HeaterInterface = HeaterInterface,
    FanInterface = FanInterface,
    MCU = MCU
}
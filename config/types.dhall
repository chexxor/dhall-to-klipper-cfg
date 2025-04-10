let Kinematics = < CoreXY | Delta | Cartesian >

let MCU = {
    # Basic MCU configuration
    serial: Text,
    baudrate: Natural,
    restart_method: Text,

    # Pin mappings for required components
    pins: {
        # Stepper motor pins
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
        # Extruder pins
        extruderStep: Text,
        extruderDir: Text,
        extruderEnable: Text,
        extruderHeater: Text,
        extruderSensor: Text,
        # Bed pins
        bedHeater: Text,
        bedSensor: Text,
        # Fan pins
        partCoolingFan: Text,
        heaterCoolingFan: Text,
        controllerFan: Text,
        # Probe pins
        probeSignal: Text,
        probeServo: Text
    },

    # Optional features (all optional)
    optional_pins: Optional {
        neopixelPin: Text,
        filamentSensorPin: Text,
        powerMonitorPin: Text
    },

    # Display configuration (all optional)
    display: Optional {
        spi_bus: Text,
        cs_pin: Text,
        dc_pin: Text,
        reset_pin: Text
    },

    # Board pin aliases (optional)
    pin_aliases: Optional {
        # Any number of pin aliases can be defined
        _: Text
    }
}

let Axis = {
    stepper: Text,
    endstop: Text,
    steps_per_mm: Natural,
    max_velocity: Natural,
    max_accel: Natural,
    max_position: Natural
}

let Extruder = {
    stepper: Text,
    steps_per_mm: Natural,
    max_velocity: Natural,
    max_accel: Natural,
    nozzle_diameter: Natural,
    max_extrude_only_distance: Natural
}

let Bed = {
    type: Text,
    heater: Text,
    sensor: Text,
    max_temp: Natural,
    min_temp: Natural
}

let Probe = {
    type: Text,
    pin: Text,
    x_offset: Natural,
    y_offset: Natural,
    z_offset: Natural
}

let Fan = {
    type: Text,
    pin: Text,
    max_power: Natural,
    min_power: Natural,
    kick_start_time: Natural
}

let Heater = {
    type: Text,
    pin: Text,
    max_temp: Natural,
    min_temp: Natural,
    max_power: Natural
}

let TemperatureSensor = {
    type: Text,
    sensor_type: Text,
    pin: Text
}

let Hardware = {
    mcu: MCU,
    axes: List Axis,
    extruder: Extruder,
    bed: Bed,
    probe: Optional Probe,
    fans: List Fan,
    heaters: List Heater,
    temperature_sensors: List TemperatureSensor
}

let Software = {
    macros: List Text,
    moonraker: Bool,
    virtual_sdcard: Bool
}

let MachineConfig = {
    kinematics: Kinematics,
    hardware: Hardware,
    software: Software
}
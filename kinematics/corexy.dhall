let Kinematics = ./../types.dhall
let RaspberryPiMCU = ./../hardware/mcu/raspberry_pi.dhall
let SKRV14MCU = ./../hardware/mcu/skrv14.dhall
let BLTouchProbe = ./../hardware/probe/bltouch.dhall
let DirectDriveExtruder = ./../hardware/extruder/direct_drive.dhall
let Thermistor = ./../hardware/sensor/thermistor.dhall
let PartCoolingFan = ./../hardware/fan/part_cooling.dhall
let HeaterCoolingFan = ./../hardware/fan/heater_cooling.dhall
let HotendHeater = ./../hardware/heater/hotend.dhall
let BedHeater = ./../hardware/heater/bed.dhall

let CoreXYConfig = {
    kinematics: Kinematics.Kinematics.CoreXY,
    hardware: {
        mcu: SKRV14MCU.SKRV14MCU,
        axes: [
            {
                stepper: "stepper_x",
                endstop: "x_endstop",
                steps_per_mm: 80,
                max_velocity: 300,
                max_accel: 3000,
                max_position: 300
            },
            {
                stepper: "stepper_y",
                endstop: "y_endstop",
                steps_per_mm: 80,
                max_velocity: 300,
                max_accel: 3000,
                max_position: 300
            },
            {
                stepper: "stepper_z",
                endstop: "z_endstop",
                steps_per_mm: 400,
                max_velocity: 5,
                max_accel: 100,
                max_position: 400
            }
        ],
        extruder: DirectDriveExtruder.DirectDriveExtruder,
        bed: {
            type: "heated_bed",
            heater: "heater_bed",
            sensor: "temperature_sensor_bed",
            max_temp: 100,
            min_temp: 0
        },
        probe: Some BLTouchProbe.BLTouchProbe,
        fans: [
            PartCoolingFan.PartCoolingFan,
            HeaterCoolingFan.HeaterCoolingFan
        ],
        heaters: [
            HotendHeater.HotendHeater,
            BedHeater.BedHeater
        ],
        temperature_sensors: [
            Thermistor.Thermistor
        ]
    },
    software: {
        macros: [
            "START_PRINT",
            "END_PRINT",
            "PAUSE",
            "RESUME",
            "CANCEL_PRINT"
        ],
        moonraker: True,
        virtual_sdcard: True
    }
}
let Types = ./../../types.dhall

let HeaterCoolingFan = {
    type: "heater_cooling",
    pin: "heater_fan",
    max_power: 255,
    min_power: 0,
    kick_start_time: 0.5
}
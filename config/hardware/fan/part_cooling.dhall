let Types = ./../../types.dhall

let PartCoolingFan = {
    type: "part_cooling",
    pin: "fan",
    max_power: 255,
    min_power: 0,
    kick_start_time: 0.5
}
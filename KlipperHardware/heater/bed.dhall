let Types = ./../../types.dhall

let BedHeater = {
    type: "bed",
    pin: "heater_bed",
    max_temp: 120,
    min_temp: 0,
    max_power: 255
}
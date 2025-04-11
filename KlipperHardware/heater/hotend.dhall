let Types = ./../../types.dhall

let HotendHeater = {
    type: "hotend",
    pin: "heater0",
    max_temp: 300,
    min_temp: 0,
    max_power: 255
}

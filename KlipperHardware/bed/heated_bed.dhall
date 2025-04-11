let Types = ./../../types.dhall

let HeatedBed = {
    type: "heated_bed",
    heater: Text,
    sensor: Text,
    max_temp: 130,
    min_temp: 0
}
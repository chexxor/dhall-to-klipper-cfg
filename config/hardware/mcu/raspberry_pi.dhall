let McuModule = ./../KlipperConfigModule/Mcu.dhall

let mcu = McuModule.McuConfig::
    { serial = "/tmp/klipper_host_mcu"
    , baud = Some 250000
    , restart_method = Some "command"
    }
in mcu
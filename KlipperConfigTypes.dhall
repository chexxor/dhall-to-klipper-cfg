let Prelude =
    { Text = https://prelude.dhall-lang.org/Text/package.dhall
    , List = https://prelude.dhall-lang.org/List/package.dhall
    , Natural = https://prelude.dhall-lang.org/Natural/package.dhall
    , Double = https://prelude.dhall-lang.org/Double/package.dhall
    , Bool = https://prelude.dhall-lang.org/Bool/package.dhall
    , Optional = https://prelude.dhall-lang.org/Optional/package.dhall
    }
let KlipperConfig = ./KlipperConfig.dhall

let SoftwareSPI =
    { Type =
        { sclk_pin : KlipperConfig.McuPinOutput.Type
        , mosi_pin : KlipperConfig.McuPinOutput.Type
        , miso_pin : KlipperConfig.McuPinInput.Type
        }
    , default =
        { }
    }

let SPIBus =
    { Type =
        -- The SPI speed (in hz) to use when communicating with the device.
        -- The default depends on the type of device.
        { spi_speed : Natural
        -- If the micro-controller supports multiple SPI busses then one may
        --   specify the micro-controller bus name here.
        -- The default depends on the type of micro-controller.
        , spi_bus : Text
        -- Specify the following parameter to use "software based SPI".
        -- This mode does not require micro-controller hardware support
        -- (typically any general purpose pins may be used).
        -- The default is to not use "software spi".
        , spi_software : Optional SoftwareSPI.Type
        }
    , default =
        { spi_software = None SoftwareSPI.Type
        }
    }

let SPIBusText =
    { spi_speed : Optional Text
    , spi_bus : Optional Text
    , spi_software_sclk_pin : Optional Text
    , spi_software_mosi_pin : Optional Text
    , spi_software_miso_pin : Optional Text
    }

let toSPIBusText
    : SPIBus.Type -> SPIBusText
    = \(spiBus : SPIBus.Type) ->
    { spi_speed = Some (Prelude.Natural.show spiBus.spi_speed)
    , spi_bus = Some spiBus.spi_bus
    , spi_software_sclk_pin = Some (KlipperConfig.renderMcuPinOutput spiBus.spi_software_sclk_pin)
    , spi_software_mosi_pin = Some (KlipperConfig.renderMcuPinOutput spiBus.spi_software_mosi_pin)
    , spi_software_miso_pin = Some (KlipperConfig.renderMcuPinInput spiBus.spi_software_miso_pin)
    }

in  {
    SPIBus = SPIBus
    , SPIBusText = SPIBusText
    , SoftwareSPI = SoftwareSPI
    , toSPIBusText = toSPIBusText
    }
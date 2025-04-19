let KlipperConfig = ./KlipperConfig.dhall

in \(t : Type)
    -> { toKlipperConfigSection :
        ∀(a : Type)
        → ∀(t : a)
        → List KlipperConfig.KlipperConfigSection
        }
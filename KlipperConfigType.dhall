let KlipperConfigType
    : Type → List KlipperConfig.KlipperConfigSection
    = λ(t : Type)
    →   { toKlipperConfigSection :
            ∀(a : Type)
            → ∀(t : a)
            → List KlipperConfig.KlipperConfigSection
        }

let toKlipperConfigSection
    : NamedStepper -> List KlipperConfig.KlipperConfigSection

in KlipperConfigType

-- let KlipperConfigType = ./../KlipperConfigType

-- let x = λ(m : Type)
--     → λ(monoid : Monoid m)
--     → λ(t : Type → Type)
--     → λ(foldable : Foldable t)
--     → λ(a : Type)
--     → λ(f : a → m)
--     → λ(ts : t a)
--     → foldable.fold a ts m (λ(x : a) → λ(y : m) → monoid.op (f x) y) monoid.unit

-- in
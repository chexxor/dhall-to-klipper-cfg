let CoreXY = ./kinematics/corexy.dhall
let Delta = ./kinematics/delta.dhall

-- Select your kinematics type here
let selectedKinematics = CoreXY.CoreXYConfig

in  selectedKinematics
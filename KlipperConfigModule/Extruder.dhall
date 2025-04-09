let KlipperConfig = ../klipperConfig.dhall

let Prelude =
    { Text = https://prelude.dhall-lang.org/Text/package.dhall
    , Natural = https://prelude.dhall-lang.org/Natural/package.dhall
    , Optional = https://prelude.dhall-lang.org/Optional/package.dhall
    , Double = https://prelude.dhall-lang.org/Double/package.dhall
    }

let ExtruderConfig =
    { Type =
        { step_pin : Text
        , dir_pin : Text
        , enable_pin : Optional Text
        , microsteps : Natural
        , rotation_distance : Double
        , full_steps_per_rotation : Optional Natural
        , gear_ratio : Optional Text
        -- See the "stepper" section for a description of the above
        -- parameters. If none of the above parameters are specified then no
        -- stepper will be associated with the nozzle hotend (though a
        -- SYNC_EXTRUDER_MOTION command may associate one at run-time).

        -- Diameter of the nozzle orifice (in mm). This parameter must be
        -- provided.
        , nozzle_diameter : Double
        -- The nominal diameter of the raw filament (in mm) as it enters the
        -- extruder. This parameter must be provided.
        , filament_diameter : Double
        -- Maximum area (in mm^2) of an extrusion cross section (eg,
        -- extrusion width multiplied by layer height). This setting prevents
        -- excessive amounts of extrusion during relatively small XY moves.
        -- If a move requests an extrusion rate that would exceed this value
        -- it will cause an error to be returned. The default is: 4.0 *
        -- nozzle_diameter^2
        , max_extrude_cross_section : Optional Double
        -- The maximum instantaneous velocity change (in mm/s) of the
        -- extruder during the junction of two moves. The default is 1mm/s.
        , instantaneous_corner_velocity : Optional Double
        -- Maximum length (in mm of raw filament) that a retraction or
        -- extrude-only move may have. If a retraction or extrude-only move
        -- requests a distance greater than this value it will cause an error
        -- to be returned. The default is 50mm.
        , max_extrude_only_distance : Optional Double
        , max_extrude_only_velocity : Optional Natural
        -- Maximum velocity (in mm/s) and acceleration (in mm/s^2) of the
        -- extruder motor for retractions and extrude-only moves. These
        -- settings do not have any impact on normal printing moves. If not
        -- specified then they are calculated to match the limit an XY
        -- printing move with a cross section of 4.0*nozzle_diameter^2 would
        -- have.
        , max_extrude_only_accel : Optional Natural
        -- The amount of raw filament to push into the extruder during
        -- extruder acceleration. An equal amount of filament is retracted
        -- during deceleration. It is measured in millimeters per
        -- millimeter/second. The default is 0, which disables pressure
        -- advance.
        , pressure_advance : Optional Double
        -- A time range (in seconds) to use when calculating the average
        -- extruder velocity for pressure advance. A larger value results in
        -- smoother extruder movements. This parameter may not exceed 200ms.
        -- This setting only applies if pressure_advance is non-zero. The
        -- default is 0.040 (40 milliseconds).
        , pressure_advance_smooth_time : Optional Double

        -- The remaining variables describe the extruder heater.

        -- PWM output pin controlling the heater. This parameter must be
        -- provided.
        , heater_pin : Text
        -- The maximum power (expressed as a value from 0.0 to 1.0) that the
        -- heater_pin may be set to. The value 1.0 allows the pin to be set
        -- fully enabled for extended periods, while a value of 0.5 would
        -- allow the pin to be enabled for no more than half the time. This
        -- setting may be used to limit the total power output (over extended
        -- periods) to the heater. The default is 1.0.
        , max_power : Optional Double
        -- Type of sensor - common thermistors are "EPCOS 100K B57560G104F",
        -- "ATC Semitec 104GT-2", "ATC Semitec 104NT-4-R025H42G", "Generic
        -- 3950","Honeywell 100K 135-104LAG-J01", "NTC 100K MGB18-104F39050L32",
        -- "SliceEngineering 450", and "TDK NTCG104LH104JT1". See the
        -- "Temperature sensors" section for other sensors. This parameter
        -- must be provided.
        , sensor_type : Text
        -- Analog input pin connected to the sensor. This parameter must be
        -- provided.
        , sensor_pin : Text
        -- The resistance (in ohms) of the pullup attached to the thermistor.
        -- This parameter is only valid when the sensor is a thermistor. The
        -- default is 4700 ohms.
        , pullup_resistor : Optional Natural
        -- A time value (in seconds) over which temperature measurements will
        -- be provided.
        , smooth_time : Optional Double
        -- Control algorithm (either pid or watermark). This parameter must
        -- be provided.
        , control : Text
        -- The proportional (pid_Kp), integral (pid_Ki), and derivative
        -- (pid_Kd) settings for the PID feedback control system. Klipper
        -- evaluates the PID settings with the following general formula:
        --     heater_pwm = (Kp*error + Ki*integral(error) - Kd*derivative(error)) / 255
        -- Where "error" is "requested_temperature - measured_temperature"
        -- and "heater_pwm" is the requested heating rate with 0.0 being full
        -- off and 1.0 being full on. Consider using the PID_CALIBRATE
        -- command to obtain these parameters. The pid_Kp, pid_Ki, and pid_Kd
        -- parameters must be provided for PID heaters.
        , pid_Kp : Optional Double
        , pid_Ki : Optional Double
        , pid_Kd : Optional Double
        -- On 'watermark' controlled heaters this is the number of degrees in
        -- Celsius above the target temperature before disabling the heater
        -- as well as the number of degrees below the target before
        -- re-enabling the heater. The default is 2 degrees Celsius.
        , max_delta : Optional Double
        -- Time in seconds for each software PWM cycle of the heater. It is
        -- not recommended to set this unless there is an electrical
        -- requirement to switch the heater faster than 10 times a second.
        -- The default is 0.100 seconds.
        , pwm_cycle_time : Optional Double
        -- The minimum temperature (in Celsius) at which extruder move
        -- commands may be issued. The default is 170 Celsius.
        , min_extrude_temp : Optional Natural
        -- The maximum range of valid temperatures (in Celsius) that the
        -- heater must remain within. This controls a safety feature
        -- implemented in the micro-controller code - should the measured
        -- temperature ever fall outside this range then the micro-controller
        -- will go into a shutdown state. This check can help detect some
        -- heater and sensor hardware failures. Set this range just wide
        -- enough so that reasonable temperatures do not result in an error.
        -- These parameters must be provided.
        , min_temp : Natural
        , max_temp : Natural
      }
    , default =
        { enable_pin = None Text
        , full_steps_per_rotation = None Natural
        , gear_ratio = None Text
        , max_extrude_cross_section = None Double
        , instantaneous_corner_velocity = None Double
        , max_extrude_only_distance = None Double
        , max_extrude_only_velocity = None Natural
        , max_extrude_only_accel = None Natural
        , pressure_advance = None Double
        , pressure_advance_smooth_time = None Double
        , max_power = None Double
        , pullup_resistor = None Natural
        , smooth_time = None Double
        , pid_Kp = None Double
        , pid_Ki = None Double
        , pid_Kd = None Double
        , max_delta = None Double
        , pwm_cycle_time = None Double
        , min_extrude_temp = None Natural
        }
    }

let NamedExtruder : Type =
    { name : Text
    , extruder : ExtruderConfig.Type
    }

let ExtruderConfigText =
    { step_pin : Optional Text
    , dir_pin : Optional Text
    , enable_pin : Optional Text
    , microsteps : Optional Text
    , rotation_distance : Optional Text
    , full_steps_per_rotation : Optional Text
    , gear_ratio : Optional Text
    , nozzle_diameter : Optional Text
    , filament_diameter : Optional Text
    , max_extrude_cross_section : Optional Text
    , instantaneous_corner_velocity : Optional Text
    , max_extrude_only_distance : Optional Text
    , max_extrude_only_velocity : Optional Text
    , max_extrude_only_accel : Optional Text
    , pressure_advance : Optional Text
    , pressure_advance_smooth_time : Optional Text
    , heater_pin : Optional Text
    , max_power : Optional Text
    , sensor_type : Optional Text
    , sensor_pin : Optional Text
    , pullup_resistor : Optional Text
    , smooth_time : Optional Text
    , control : Optional Text
    , pid_Kp : Optional Text
    , pid_Ki : Optional Text
    , pid_Kd : Optional Text
    , max_delta : Optional Text
    , pwm_cycle_time : Optional Text
    , min_extrude_temp : Optional Text
    , min_temp : Optional Text
    , max_temp : Optional Text
    }

let toExtruderConfigText
    : ExtruderConfig.Type -> ExtruderConfigText
    = \(extruder : ExtruderConfig.Type) ->
    { step_pin = Some extruder.step_pin
    , dir_pin = Some extruder.dir_pin
    , enable_pin = extruder.enable_pin
    , microsteps = Some (Prelude.Natural.show extruder.microsteps)
    , rotation_distance = Some (Prelude.Double.show extruder.rotation_distance)
    , full_steps_per_rotation = Prelude.Optional.map Natural Text Prelude.Natural.show extruder.full_steps_per_rotation
    , gear_ratio = extruder.gear_ratio
    , nozzle_diameter = Some (Prelude.Double.show extruder.nozzle_diameter)
    , filament_diameter = Some (Prelude.Double.show extruder.filament_diameter)
    , max_extrude_cross_section = Prelude.Optional.map Double Text Prelude.Double.show extruder.max_extrude_cross_section
    , instantaneous_corner_velocity = Prelude.Optional.map Double Text Prelude.Double.show extruder.instantaneous_corner_velocity
    , max_extrude_only_distance = Prelude.Optional.map Double Text Prelude.Double.show extruder.max_extrude_only_distance
    , max_extrude_only_velocity = Prelude.Optional.map Natural Text Prelude.Natural.show extruder.max_extrude_only_velocity
    , max_extrude_only_accel = Prelude.Optional.map Natural Text Prelude.Natural.show extruder.max_extrude_only_accel
    , pressure_advance = Prelude.Optional.map Double Text Prelude.Double.show extruder.pressure_advance
    , pressure_advance_smooth_time = Prelude.Optional.map Double Text Prelude.Double.show extruder.pressure_advance_smooth_time
    , heater_pin = Some extruder.heater_pin
    , max_power = Prelude.Optional.map Double Text Prelude.Double.show extruder.max_power
    , sensor_type = Some extruder.sensor_type
    , sensor_pin = Some extruder.sensor_pin
    , pullup_resistor = Prelude.Optional.map Natural Text Prelude.Natural.show extruder.pullup_resistor
    , smooth_time = Prelude.Optional.map Double Text Prelude.Double.show extruder.smooth_time
    , control = Some extruder.control
    , pid_Kp = Prelude.Optional.map Double Text Prelude.Double.show extruder.pid_Kp
    , pid_Ki = Prelude.Optional.map Double Text Prelude.Double.show extruder.pid_Ki
    , pid_Kd = Prelude.Optional.map Double Text Prelude.Double.show extruder.pid_Kd
    , max_delta = Prelude.Optional.map Double Text Prelude.Double.show extruder.max_delta
    , pwm_cycle_time = Prelude.Optional.map Double Text Prelude.Double.show extruder.pwm_cycle_time
    , min_extrude_temp = Prelude.Optional.map Natural Text Prelude.Natural.show extruder.min_extrude_temp
    , min_temp = Some (Prelude.Natural.show extruder.min_temp)
    , max_temp = Some (Prelude.Natural.show extruder.max_temp)
    }

let toKlipperConfigSection
    : NamedExtruder -> List KlipperConfig.KlipperConfigSection
    = \(namedExtruder : NamedExtruder) ->
    [{ name = namedExtruder.name
    , prefix = None Text
    , properties = toMap (toExtruderConfigText namedExtruder.extruder)
    }]

in  { ExtruderConfig = ExtruderConfig
    , NamedExtruder = NamedExtruder
    , toKlipperConfigSection = toKlipperConfigSection
    }
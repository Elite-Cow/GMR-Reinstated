GM.DefaultJeep = [[
"vehicle"
{
	"wheelsperaxle"	"2"
	"body"
	{
		"countertorquefactor"	"0.9"
		"massCenterOverride"	"0 -30 12"
		"massoverride"			"&VEHICLEWEIGHT&"		// kg
		"addgravity"			"1"
		"maxAngularVelocity"	"720"
	}
	"engine"
	{
		"horsepower"		"&HORSEPOWER&"
		"maxrpm"		"4200"
		"maxspeed"		"&MAXFORWARDSPEED&"		// mph
		"maxReverseSpeed"	"&MAXREVERSESPEED&"		// mph
		"autobrakeSpeedGain"	"&AUTOBRAKEMAXSPEED&"		// 10% speed gain while coasting, put on the brakes after that
		"autobrakeSpeedFactor"	"3.0"		// Brake is this times the speed gain
		"autotransmission"	"1"
		"axleratio"		"4.56"
		"gear"			"3.2"		// 1st gear
		"gear"			"2.4"		// 2nd gear
		"gear"			"1.5"		// 3rd gear
		"gear"			"1.0"		// 4th gear
		"gear"			"0.84"		// 5th gear
		"shiftuprpm"		"3800"
		"shiftdownrpm"		"1600"

		"boost"
		{
			"force"		"&BOOSTFORCE&"	// 1.5 car body mass * gravity * inches / second ^ 2
			"duration"	"&BOOSTDURATION&"	// 3.0 second of boost
			"delay"		"&BOOSTDELAY&"	// 3 seconds before you can use it again
			"torqueboost"	"0"	// enable "sprint" mode of vehicle, not	force type booster		
			"maxspeed"	"&BOOSTMAXSPEED&"	// maximum turbo speed
		}
	}
	"steering"
	{
		"degreesSlow"		"&SLOWTURNDEGREE&"	// steering cone at zero to slow speed
		"degreesFast"		"&FASTTURNDEGREE&"	// steering cone at fast speed to max speed
		"degreesBoost"		"&BOOSTTURNDEGREE&"	// steering cone at max boost speed (blend toward this after max speed)
		"steeringExponent"	"1.4"	// steering function is linear, then raised to this power to be slower at the beginning of the curve, faster at the end
		"slowcarspeed"		"&SLOWCARSPEED&" // 14
		"fastcarspeed"		"&FASTCARSPEED&" // 20
		"slowSteeringRate"	"4.0"		
		"fastSteeringRate"	"2.0"
		"steeringRestRateSlow"	"4.0"
		"steeringRestRateFast"	"2.0"
		"turnThrottleReduceSlow" "0.01"
		"turnThrottleReduceFast" "2.0"
		"brakeSteeringRateFactor"	"6"
		"throttleSteeringRestRateFactor"	"2"
		"boostSteeringRestRateFactor"	"1.7"
		"boostSteeringRateFactor"	"1.7"

		"powerSlideAccel"	"250"

		"skidallowed"		"1"
		"dustcloud"		"0"

	}

	// front axle
	"axle"
	{
		"wheel"
		{
			"radius"	"18"
			"mass"		"100"
			"damping"	"0"
			"rotdamping"	"0.0"
			"material"	"jeeptire"
			"skidmaterial"	"slidingrubbertire"
			"brakematerial" "brakingrubbertire"
		}
		"suspension"
		{
			"springConstant"		"40"
			"springDamping"			"0.7"
			"stabilizerConstant"		"10"
			"springDampingCompression"	"9"
			"maxBodyForce"			"9"
		}

		"torquefactor"	"0.3"
		"brakefactor"	"&FORWARDAXILBRAKE&"
	}

	// rear axle
	"axle"
	{
		"wheel"
		{
			"radius"	"22"
			"mass"		"100"
			"damping"	"0"
			"rotdamping"	"0.0"
			"material"	"jeeptire"
			"skidmaterial"	"slidingrubbertire"
			"brakematerial" "brakingrubbertire"
		}
		"suspension"
		{
			"springConstant"		"40"
			"springDamping"			"0.7"
			"stabilizerConstant"		"10"
			"springDampingCompression"	"9"
			"maxBodyForce"			"9"
		}
		"torquefactor"	"0.7"
		"brakefactor"	"&REARAXILBRAKE&"
	}
}

"vehicle_sounds"
{
	// List gears in order from lowest speed to highest speed

	"gear"
	{
		"max_speed"		"0.27"
		"speed_approach_factor" "1.0"
	}

	"gear"
	{
		"max_speed"		"0.5"
		"speed_approach_factor" "0.05"
	}
	"gear"
	{
		"max_speed"		"0.75"
		"speed_approach_factor" "0.052"
	}
	"gear"
	{
		"max_speed"		"0.95"
		"speed_approach_factor" "0.034"
	}
	"gear"
	{
		"max_speed"		"1.5"
		"speed_approach_factor" "0.033"
	}
	"gear"
	{
		"max_speed"		"2.0"
		"speed_approach_factor" "0.03"
	}
	"state"
	{
		"name"		"SS_START_WATER"
		"sound"		"ATV_start_in_water"
	}

	"state"
	{
		"name"		"SS_START_IDLE"
		"sound"		"&PREFIX&_engine_start"
		"min_time"	"4.0"
	}
	"state"
	{
		"name"		"SS_SHUTDOWN_WATER"
		"sound"		"ATV_stall_in_water"
	}
	"state"
	{
		"name"		"SS_IDLE"
		"sound"		"&PREFIX&_engine_idle"
	}
	"state"
	{
		"name"		"SS_REVERSE"
		"sound"		"&PREFIX&_reverse"
		"min_time"	"0.5"
	}
	"state"
	{
		"name"		"SS_GEAR_0"
		"sound"		"&PREFIX&_rev"
		"min_time"	"0.5"
	}
	"state"
	{
		"name"		"SS_GEAR_0_RESUME"
		"sound"		"&PREFIX&_engine_idle"
		"min_time"	"0.75"
	}
	"state"
	{
		"name"		"SS_GEAR_1"
		"sound"		"&PREFIX&_firstgear"
		"min_time"	"0.5"
	}
	"state"
	{
		"name"		"SS_GEAR_1_RESUME"
		"sound"		"&PREFIX&_firstgear_noshift"
		"min_time"	"0.5"
	}
	"state"
	{
		"name"		"SS_GEAR_2"
		"sound"		"&PREFIX&_secondgear"
		"min_time"	"0.5"
	}
	"state"
	{
		"name"		"SS_GEAR_2_RESUME"
		"sound"		"&PREFIX&_secondgear_noshift"
		"min_time"	"0.5"
	}
	"state"
	{
		"name"		"SS_GEAR_3"
		"sound"		"&PREFIX&_thirdgear"
		"min_time"	"0.5"
	}
	"state"
	{
		"name"		"SS_GEAR_3_RESUME"
		"sound"		"&PREFIX&_thirdgear_noshift"
		"min_time"	"0.5"
	}
	"state"
	{
		"name"		"SS_GEAR_4"
		"sound"		"&PREFIX&_fourthgear"
		"min_time"	"0.5"
	}
	"state"
	{
		"name"		"SS_GEAR_4_RESUME"
		"sound"		"&PREFIX&_fourthgear_noshift"
		"min_time"	"0.5"
	}
	"state"
	{
		"name"		"SS_SLOWDOWN_HIGHSPEED"
		"sound"		"&PREFIX&_throttleoff_fastspeed"
		"min_time"	"2.0"
	}
	"state"
	{
		"name"		"SS_SLOWDOWN"
		"sound"		"&PREFIX&_throttleoff_slowspeed"
		"min_time"	"2.0"
	}
	"state"
	{
		"name"		"SS_TURBO"
		"sound"		"&PREFIX&_turbo_on"
		"min_time"	"2.5"
	}
	"state"
	{
		"name"		"SS_SHUTDOWN"
		"sound"		"ATV_engine_stop"
	}
	"crashsound"
	{
		"min_speed"			"350"
		"min_speed_change"	"250"
		"sound"				"ATV_impact_medium"
		"gear_limit"		"1"
	}
	"crashsound"
	{
		"min_speed"			"450"
		"min_speed_change"	"350"
		"sound"				"ATV_impact_heavy"
	}

	
	"skid_lowfriction"		"&PREFIX&_skid_lowfriction"
	"skid_normalfriction"		"&PREFIX&_skid_normalfriction"
	"skid_highfriction"		"&PREFIX&_skid_highfriction"
}
]];
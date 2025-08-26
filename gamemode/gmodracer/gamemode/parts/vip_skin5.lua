Part.Name = "Superman ( VIP ONLY )";
Part.Class = "VIPSkin";
Part.ClassLevel = 5;
Part.Cost = 0;
Part.Icon = "vip";
Part.Description = "Not involved with Soldja Boy.";
Part.Sellable = true;
Part.RequiredModels = {}
Part.RequiresAccess = 4;

// Engine Details
Part.AddedWeight = 0; // Weight of the part.
Part.AddedHorsepower = 0; // Acceleration
Part.AddedForwardMaximumMPH = 0; // Maximum forward MPH
Part.AddedReverseMaximumMPH = 0; // Maximum reverse MPH
Part.AddedAutobrakeMaximumSpeed = 0; // Default is 1.1, the maximum speed the car can go in multiple of mph while rolling

// Nos Details
Part.AddedBoostForce = 0; // nos added force, in %.    .1 = 10%
Part.AddedBoostDuration = 0; // Increases nos duration
Part.AddedBoostDelay = 0; // Delay between each nos, should always use - unless it's something that'll slow the car down
Part.AddedBoostMaximumSpeed = 0; // Increases the maximum speed of the nos. In MPH. Default max speed is maxmph * 1.5

// Sterring Details
Part.AddedTurningDegrees_Slow = 0; // steering cone at zero to slow speed
Part.AddedTurningDegrees_Fast = 0; // steering cone at fast speed to max speed
Part.AddedTurningDegrees_Boost = 0; // steering cone at max boost speed (blend toward this after max speed)

// Braking Details
Part.AddedForwardAxilBreaking = 0; // Default is .4
Part.AddedRearAxilBreaking = 0; // Default is .7;

// DM Stuff
Part.AddedHealth = 0;
Part.AddedArmor = 0;


function Part.Place ( Jeep, Forward, Back, Right, Left, Up, Down )
	if Jeep:GetOwner() and Jeep:GetOwner():IsValid() and Jeep:GetOwner():Team() != 4 then return {}; end

	Jeep:SetMaterial("buggy_reskins/vip_superman");

	return {};
end

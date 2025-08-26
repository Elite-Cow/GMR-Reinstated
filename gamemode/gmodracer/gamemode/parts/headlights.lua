Part.Name = "Headlights";
Part.Class = "Headlights";
Part.ClassLevel = 1;
Part.Cost = 5000;
Part.Icon = "headlights";
Part.Description = "Allows you to see in the dark.";
Part.Sellable = true;
Part.RequiredModels = {"models/props_c17/light_cagelight02_on.mdl"}

// Engine Details
Part.AddedWeight = 25; // Weight of the part.
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
	local Entity;

	if SERVER then
		Entity = ents.Create("prop_headlight");
	
		if !Entity or !Entity:IsValid() then return false; end
		Entity:SetPos(Jeep:GetPos() + (Forward * 56) + Vector(0, 0, 39) + (Left * 11));
		Entity:SetAngles(Jeep:GetAngles() - Angle(0, 90, 0));
		Entity:SetParent(Jeep);
		Entity:SetModel("models/props_c17/light_cagelight02_on.mdl");
		Entity:SetColor(255, 255, 255, 1);
		Entity:Spawn();
		
		Entity2 = ents.Create("prop_headlight");
	
		if !Entity2 or !Entity:IsValid() then return false; end
		Entity2:SetPos(Jeep:GetPos() + (Forward * 56) + Vector(0, 0, 39) + (Right * 11));
		Entity2:SetAngles(Jeep:GetAngles() - Angle(0, 90, 0));
		Entity2:SetParent(Jeep);
		Entity2:SetModel("models/props_c17/light_cagelight02_on.mdl");
		Entity2:SetColor(255, 255, 255, 1);
		Entity2:Spawn();
		
		return {Entity, Entity2};
	else
		return {};
	end
end

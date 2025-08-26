Part.Name = "Dual Exhaust Tailpipes";
Part.Class = "Exhaust";
Part.ClassLevel = 2;
Part.Cost = 7500;
Part.Icon = "dual_tailpipe";
Part.Description = "Increases turbo duration by 2 seconds.";
Part.Sellable = true;
Part.RequiredModels = {"models/props_vehicles/carparts_muffler01a.mdl"}

// Engine Details
Part.AddedWeight = 140; // Weight of the part.
Part.AddedHorsepower = 0; // Acceleration
Part.AddedForwardMaximumMPH = 0; // Maximum forward MPH
Part.AddedReverseMaximumMPH = 0; // Maximum reverse MPH
Part.AddedAutobrakeMaximumSpeed = 0; // Default is 1.1, the maximum speed the car can go in multiple of mph while rolling

// Nos Details
Part.AddedBoostForce = 0; // nos added force, in %.    .1 = 10%
Part.AddedBoostDuration = 4; // Increases nos duration
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

	if CLIENT then
		Entity = ents.CreateClientProp("models/props_vehicles/carparts_muffler01a.mdl");
	else
		Entity = ents.Create("prop_muffler");
	end
	
	if !Entity or !Entity:IsValid() then return false; end
	Entity:SetPos(Jeep:GetPos() + (Back * 60) + (Right * 20) + Vector(0, 0, 15));
	Entity:SetAngles(Jeep:GetAngles() - Angle(0, 90, 0));
	Entity:SetModel("models/props_vehicles/carparts_muffler01a.mdl");
	Entity:SetParent(Jeep);
	Entity:Spawn();
	
	local Entity2;

	if CLIENT then
		Entity2 = ents.CreateClientProp("models/props_vehicles/carparts_muffler01a.mdl");
	else
		Entity2 = ents.Create("prop_muffler");
	end
	
	if !Entity2 or !Entity2:IsValid() then return false; end
	Entity2:SetPos(Jeep:GetPos() + (Back * 60) + (Left * 20) + Vector(0, 0, 15));
	Entity2:SetAngles(Jeep:GetAngles() - Angle(-5, 90, 180));
	Entity2:SetModel("models/props_vehicles/carparts_muffler01a.mdl");
	Entity2:SetParent(Jeep);
	Entity2:Spawn();
	
	return {Entity, Entity2};
end

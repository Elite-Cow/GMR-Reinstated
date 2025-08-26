Part.Name = "3 Forward Spikes";
Part.Class = "Forward Spikes";
Part.ClassLevel = 2;
Part.Cost = 15000;
Part.Icon = "spikes";
Part.Description = "Increases ramming damage.";
Part.Sellable = true;
Part.RequiredModels = {"models/props_c17/TrapPropeller_Lever.mdl"}

// Engine Details
Part.AddedWeight = 30; // Weight of the part.
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
	
	if CLIENT then
		Entity = ents.CreateClientProp("models/props_c17/TrapPropeller_Lever.mdl");
	else
		Entity = ents.Create("prop_dynamic_override");
	end
	
	if !Entity or !Entity:IsValid() then return false; end
	Entity:SetPos(Jeep:GetPos() + (Forward * 70) + (Right * 27) + Vector(0, 0, 12))
	Entity:SetAngles(Jeep:GetAngles() - Angle(0, 180, 0));
	Entity:SetModel("models/props_c17/TrapPropeller_Lever.mdl");
	Entity:SetParent(Jeep);
	Entity:Spawn();
	
	local Entity2;
	
	if CLIENT then
		Entity2 = ents.CreateClientProp("models/props_c17/TrapPropeller_Lever.mdl");
	else
		Entity2 = ents.Create("prop_dynamic_override");
	end
	
	if Entity2 and Entity2:IsValid() then
		Entity2:SetPos(Jeep:GetPos() + (Forward * 70) + (Left * 27) + Vector(0, 0, 12))
		Entity2:SetAngles(Jeep:GetAngles() - Angle(0, 180, 0));
		Entity2:SetModel("models/props_c17/TrapPropeller_Lever.mdl");
		Entity2:SetParent(Jeep);
		Entity2:Spawn();
	end
	
	local Entity3;
	
	if CLIENT then
		Entity3 = ents.CreateClientProp("models/props_c17/TrapPropeller_Lever.mdl");
	else
		Entity3 = ents.Create("prop_dynamic_override");
	end
	
	if Entity3 and Entity3:IsValid() then
		Entity3:SetPos(Jeep:GetPos() + (Forward * 70) + Vector(0, 0, 12))
		Entity3:SetAngles(Jeep:GetAngles() - Angle(0, 180, 0));
		Entity3:SetModel("models/props_c17/TrapPropeller_Lever.mdl");
		Entity3:SetParent(Jeep);
		Entity3:Spawn();
	end

	return {Entity, Entity2, Entity3};
end

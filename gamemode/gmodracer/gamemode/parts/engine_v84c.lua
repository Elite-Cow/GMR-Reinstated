Part.Name = "8 Cylinder 6 Stroke Engine";
Part.Class = "Engine";
Part.ClassLevel = 3;
Part.Cost = 25000;
Part.Icon = "8_cylinder";
Part.Description = "Increases maximum speed by 5 MPH.";
Part.Sellable = true;
Part.RequiredModels = {"models/Gibs/airboat_broken_engine.mdl"}

// Engine Details
Part.AddedWeight = 750; // Weight of the part.
Part.AddedHorsepower = 0; // Acceleration
Part.AddedForwardMaximumMPH = 25; // Maximum forward MPH
Part.AddedReverseMaximumMPH = 12.5; // Maximum reverse MPH
Part.AddedAutobrakeMaximumSpeed = 0; // Default is 1.1, the maximum speed the car can go in multiple of mph while rolling

// Nos Details
Part.AddedBoostForce = 0; // nos added force, in %.    .1 = 10%
Part.AddedBoostDuration = 0; // Increases nos duration
Part.AddedBoostDelay = 0; // Delay between each nos, should always use - unless it's something that'll slow the car down
Part.AddedBoostMaximumSpeed = 0; // Increases the maximum speed of the nos. In MPH. Default max speed is maxmph * 1.5

// Sterring Details
Part.AddedTurningDegrees_Slow = -25; // steering cone at zero to slow speed
Part.AddedTurningDegrees_Fast = -13; // steering cone at fast speed to max speed
Part.AddedTurningDegrees_Boost = -7; // steering cone at max boost speed (blend toward this after max speed)

// Braking Details
Part.AddedForwardAxilBreaking = 0; // Default is .4
Part.AddedRearAxilBreaking = 0; // Default is .7;

// DM Stuff
Part.AddedHealth = 0;
Part.AddedArmor = 0;


function Part.Place ( Jeep, Forward, Back, Right, Left, Up, Down )
	local Entity;
	if CLIENT then
		Entity = ents.CreateClientProp("models/Gibs/airboat_broken_engine.mdl");
	else
		Entity = ents.Create("prop_dynamic_override");
	end
	
	
	if !Entity or !Entity:IsValid() then return false; end
	Entity:SetPos(Jeep:GetPos() + (Forward * 30) + (Right * 3) + Vector(0, 0, 35))
	Entity:SetAngles(Jeep:GetAngles() - Angle(0, 90, 15));
	Entity:SetModel("models/Gibs/airboat_broken_engine.mdl");
	Entity:SetParent(Jeep);
	Entity:Spawn();
	
	local Entity2;
	if CLIENT then
		Entity2 = ents.CreateClientProp("models/Gibs/airboat_broken_engine.mdl");
	else
		Entity2 = ents.Create("prop_dynamic_override");
	end
	
	if !Entity2 or !Entity2:IsValid() then return false; end
	Entity2:SetPos(Jeep:GetPos() + (Forward * 30) + (Left * 3) + Vector(0, 0, 35))
	Entity2:SetAngles(Jeep:GetAngles() - Angle(0, 90, -15));
	Entity2:SetModel("models/Gibs/airboat_broken_engine.mdl");
	Entity2:SetParent(Jeep);
	Entity2:Spawn();
	
	return {Entity, Entity2};
end

Part.Name = "That Guy's Generic Stock Engine";
Part.Class = "Engine";
Part.ClassLevel = 0;
Part.Cost = 0;
Part.Icon = "4_cylinder";
Part.Description = "Stock engine.";
Part.Sellable = false;
Part.RequiredModels = {"models/Gibs/airboat_broken_engine.mdl", "models/props_vehicles/tire001c_car.mdl"}

// Engine Details
Part.AddedWeight = 200; // Weight of the part.
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
		Entity = ents.CreateClientProp("models/Gibs/airboat_broken_engine.mdl");
	else
		Entity = ents.Create("prop_dynamic_override");
	end
	
	if !Entity or !Entity:IsValid() then return false; end
	Entity:SetPos(Jeep:GetPos() + (Forward * 30) + (Left) + Vector(0, 0, 35))
	Entity:SetAngles(Jeep:GetAngles() - Angle(0, 90, 0));
	Entity:SetModel("models/Gibs/airboat_broken_engine.mdl");
	Entity:SetParent(Jeep);
	Entity:Spawn();
	
	return {Entity};
end

Part.Name = "Dual Mines";
Part.Class = "Landmines";
Part.ClassLevel = 2;
Part.Cost = 15000;
Part.Icon = "mine";
Part.Description = "Launch with TAB. Two per round.";
Part.Sellable = true;
Part.RequiredModels = {}

// Engine Details
Part.AddedWeight = 20; // Weight of the part.
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
		Entity = ents.CreateClientProp("models/Combine_Helicopter/helicopter_bomb01.mdl");
	else
		Entity = ents.Create("prop_dynamic_override");
	end
	
	if !Entity or !Entity:IsValid() then return false; end
	
	Jeep.MinesRemaining = 2;
	
	Entity:SetPos(Jeep:GetPos() + (Back * 120) + (Right * 25) + Vector(0, 0, 40))
	Entity:SetAngles(Jeep:GetAngles() + Angle(-90, 0, -90));
	Entity:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl");
	Entity:SetParent(Jeep);
	Entity:Spawn();
	Entity:SetColor(0, 255, 0, 255);
	
	local Entity2;
	
	if CLIENT then
		Entity2 = ents.CreateClientProp("models/Combine_Helicopter/helicopter_bomb01.mdl");
	else
		Entity2 = ents.Create("prop_dynamic_override");
	end
	
	if Entity2 and Entity2:IsValid() then	
		Entity2:SetPos(Jeep:GetPos() + (Back * 120) + (Left * 25) + Vector(0, 0, 40))
		Entity2:SetAngles(Jeep:GetAngles() + Angle(-90, 0, -90));
		Entity2:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl");
		Entity2:SetParent(Jeep);
		Entity2:Spawn();
		Entity2:SetColor(0, 255, 0, 255);
	end
	
	Jeep.Mines = {Entity, Entity2};
	
	return {Entity, Entity2};
end

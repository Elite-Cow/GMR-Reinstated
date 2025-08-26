Part.Name = "Radio";
Part.Class = "Radio";
Part.ClassLevel = 1;
Part.Cost = 500;
Part.Icon = "radio";
Part.Description = "Plays techno while racing.";
Part.Sellable = true;
Part.RequiredModels = {"models/props_lab/reciever01b.mdl"}

// Engine Details
Part.AddedWeight = 10; // Weight of the part.
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
	if SERVER and GAMEMODE.SpawningRace then
		umsg.Start('StartRadioMusic', Jeep:GetOwner()); umsg.End();
	end
	
	local Entity;
	
	if CLIENT then
		Entity = ents.CreateClientProp("models/props_lab/reciever01b.mdl");
	else
		Entity = ents.Create("prop_dynamic_override");
	end
	
	if !Entity or !Entity:IsValid() then return false; end
	Entity:SetPos(Jeep:GetPos() + (Forward * 3) + (Right * 10) + Vector(0, 0, 43))
	Entity:SetAngles(Jeep:GetAngles() - Angle(0, 90, 0));
	Entity:SetModel("models/props_lab/reciever01b.mdl");
	Entity:SetParent(Jeep);
	Entity:Spawn();

	return {Entity};
end

if CLIENT then

	function GM.StartRadioMusic ( UMsg )
		local Music = GAMEMODE.Music[math.random(table.Count(GAMEMODE.Music))];
		timer.Simple(Music.Time + 3, GAMEMODE.StartRadioMusic);
		RunConsoleCommand("stopsound");
		timer.Simple(3, function() GAMEMODE.PlayRadioMusic("gmracer/" .. Music.Name .. ".mp3") end );
	end
	
	usermessage.Hook('StartRadioMusic', GM.StartRadioMusic);
	
	function GM.PlayRadioMusic ( Music )
		if LocalPlayer():IsRacing() then
			surface.PlaySound(Music);
		end
	end

end

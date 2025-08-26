local PlayerMetaTable = FindMetaTable("Player");

function PlayerMetaTable:IsRacing ( )
	if self:GetNetworkedBool("IsDestroyed") then
		return false
	else
		if GetGlobalInt('GamemodeType') == 2 then
			return self:GetNetworkedBool("IsCurrentlyRacing");
		else
			return (self:GetNetworkedBool("IsCurrentlyRacing") and self:GetNetworkedInt("CurrentCheckpoint") != GetGlobalInt("TotalNumberCheckpoints"));
		end
	end
end

function PlayerMetaTable:GetUsedPart ( Location ) -- add read from file
	GAMEMODE.PlayerStats[self] = GAMEMODE.PlayerStats[self] or {};

	return tonumber(GAMEMODE.PlayerStats[self][Location]) or 0;
end

function PlayerMetaTable:SetUsedPart ( Location, ID ) -- add write to file
	GAMEMODE.PlayerStats[self] = GAMEMODE.PlayerStats[self] or {};
	
	GAMEMODE.PlayerStats[self][Location] = ID;

	if !SERVER then return false; end
	
	self:SetPData("GMRacer_PartUsing_" .. Location, ID);
		
	umsg.Start("GMRPlayerStat", self);
		umsg.String(Location);
		umsg.Short(ID);
	umsg.End();
end

function PlayerMetaTable:GetCash ( ForShow )
	if SERVER or !ForShow then
		return tonumber(self:GetNetworkedString("GMRacer_Money")) or 0;
	else
		return GAMEMODE.SmoothedCash;
	end
end

concommand.Add("gmr_addcash", function(ply, stringargs, args) player.GetHumans()[tonumber(args[1])]:AddCash(tonumber(args[2])) end, function() return "gmr_addcash" end, "player index, cash value", FCVAR_CHEAT )

function PlayerMetaTable:AddCash ( Value )
	if !SERVER then return false; end

	local NewCashValue;
	if self:Team() <= 4 then
		NewCashValue = math.Clamp(self:GetCash() + Value, -200000000, 400000);
	else
		NewCashValue = math.Clamp(self:GetCash() + Value, -200000000, 200000);
	end
	
	self:SetPData("Money", NewCashValue)
	self:SetNetworkedString("GMRacer_Money", NewCashValue);
end

function PlayerMetaTable:CompileJeepData ( )
	local ReturnTable = table.Copy(GAMEMODE.DefaultStats);
	
	if ReturnTable.BoostMaximumSpeed < ReturnTable.ForwardMaximumMPH then
		ReturnTable.BoostMaximumSpeed = ReturnTable.ForwardMaximumMPH;
	end
		
	for k, v in pairs(GAMEMODE.PartsTable) do
		if v[self:GetUsedPart(k)] then
			local Table = v[self:GetUsedPart(k)];
			
			ReturnTable.Weight = ReturnTable.Weight + Table.AddedWeight;
			ReturnTable.Horsepower = ReturnTable.Horsepower + Table.AddedHorsepower;
			ReturnTable.ForwardMaximumMPH = ReturnTable.ForwardMaximumMPH + Table.AddedForwardMaximumMPH;
			ReturnTable.ReverseMaximumMPH = ReturnTable.ReverseMaximumMPH + Table.AddedReverseMaximumMPH;
			ReturnTable.AutobrakeMaximumSpeed = ReturnTable.AutobrakeMaximumSpeed + Table.AddedAutobrakeMaximumSpeed;

			ReturnTable.BoostForce = ReturnTable.BoostForce + Table.AddedBoostForce;
			ReturnTable.BoostDuration = ReturnTable.BoostDuration + Table.AddedBoostDuration;
			ReturnTable.BoostDelay = ReturnTable.BoostDelay + Table.AddedBoostDelay;

			ReturnTable.TurningDegrees_Slow = ReturnTable.TurningDegrees_Slow + Table.AddedTurningDegrees_Slow;
			ReturnTable.TurningDegrees_Fast = ReturnTable.TurningDegrees_Fast + Table.AddedTurningDegrees_Fast;
			ReturnTable.TurningDegrees_Boost = ReturnTable.TurningDegrees_Boost + Table.AddedTurningDegrees_Boost;

			ReturnTable.ForwardAxilBreaking = ReturnTable.ForwardAxilBreaking + Table.AddedForwardAxilBreaking;
			ReturnTable.RearAxilBreaking = ReturnTable.RearAxilBreaking + Table.AddedRearAxilBreaking;
			
			ReturnTable.Health = ReturnTable.Health + Table.AddedHealth;
			ReturnTable.Armor = ReturnTable.Armor + Table.AddedArmor;
		end
	end
	
	ReturnTable.BoostMaximumSpeed = ReturnTable.ForwardMaximumMPH;
	
	for k, v in pairs(GAMEMODE.PartsTable) do
		if v[self:GetUsedPart(k)] then
			local Table = v[self:GetUsedPart(k)];
			ReturnTable.BoostMaximumSpeed = ReturnTable.BoostMaximumSpeed + Table.AddedBoostMaximumSpeed;
		end
	end
	
	local Div = ReturnTable.ForwardMaximumMPH / 7;
	ReturnTable.FastCarSpeed = Div * 4;
	ReturnTable.SlowCarSpeed = Div * 3;
		
	return ReturnTable;
end

function PlayerMetaTable:SpawnJeep ( Location, Angles )
	if !SERVER then return false; end
	if GAMEMODE.PlayerVehicles[self] and GAMEMODE.PlayerVehicles[self]:IsValid() then GAMEMODE.PlayerVehicles[self]:Remove(); end

	local JeepTable = self:CompileJeepData();
	
	if !file.IsDir("", "DATA/scripts/vehicles") then
		file.CreateDir("scripts\\vehicles");
	end
	
	local SaveFile = GAMEMODE.DefaultJeep;

	local SaveFile = string.gsub(SaveFile, "&VEHICLEWEIGHT&", JeepTable.Weight);
	local SaveFile = string.gsub(SaveFile, "&HORSEPOWER&", JeepTable.Horsepower);
	local SaveFile = string.gsub(SaveFile, "&MAXFORWARDSPEED&", JeepTable.ForwardMaximumMPH);
	local SaveFile = string.gsub(SaveFile, "&MAXREVERSESPEED&", JeepTable.ReverseMaximumMPH);
	local SaveFile = string.gsub(SaveFile, "&AUTOBRAKEMAXSPEED&", JeepTable.AutobrakeMaximumSpeed);
	local SaveFile = string.gsub(SaveFile, "&BOOSTFORCE&", JeepTable.BoostForce);
	local SaveFile = string.gsub(SaveFile, "&BOOSTDURATION&", JeepTable.BoostDuration);
	local SaveFile = string.gsub(SaveFile, "&BOOSTDELAY&", JeepTable.BoostDelay);
	local SaveFile = string.gsub(SaveFile, "&BOOSTMAXSPEED&", JeepTable.BoostMaximumSpeed);
	local SaveFile = string.gsub(SaveFile, "&SLOWTURNDEGREE&", JeepTable.TurningDegrees_Slow);
	local SaveFile = string.gsub(SaveFile, "&FASTTURNDEGREE&", JeepTable.TurningDegrees_Fast);
	local SaveFile = string.gsub(SaveFile, "&BOOSTTURNDEGREE&", JeepTable.TurningDegrees_Boost);
	local SaveFile = string.gsub(SaveFile, "&SLOWCARSPEED&", JeepTable.SlowCarSpeed);
	local SaveFile = string.gsub(SaveFile, "&FASTCARSPEED&", JeepTable.FastCarSpeed);
	local SaveFile = string.gsub(SaveFile, "&FORWARDAXILBRAKE&", JeepTable.ForwardAxilBreaking);
	local SaveFile = string.gsub(SaveFile, "&REARAXILBRAKE&", JeepTable.RearAxilBreaking);
	
	if self:GetUsedPart('Engine') == 4 then
		SaveFile = string.gsub(SaveFile, "&PREFIX&", 'JNK');
	else
		SaveFile = string.gsub(SaveFile, "&PREFIX&", 'ATV');
	end
	
	self:SetHealth(JeepTable.Health);
	
	
	file.Write("scripts\\vehicles\\gmracer_" .. GAMEMODE.NumJeepsPlaced .. ".txt", SaveFile);
	
	
	GAMEMODE.PlayerVehicles[self] = ents.Create("prop_vehicle_jeep_old");
	if !GAMEMODE.PlayerVehicles[self] or !GAMEMODE.PlayerVehicles[self]:IsValid() then
		self:Kill();
		self:PrintMessage(HUD_PRINTTALK, "Sorry, but an error occurred.");
		return false;
	end
	
	
	
	GAMEMODE.PlayerVehicles[self]:SetKeyValue("vehiclescript", "../../../../../data/scripts/vehicles/gmracer_" .. GAMEMODE.NumJeepsPlaced .. ".txt");
	GAMEMODE.PlayerVehicles[self]:SetModel("models/buggy.mdl");
	
	GAMEMODE.PlayerVehicles[self]:SetPos(Location);
	GAMEMODE.PlayerVehicles[self]:SetAngles(Angles);
	GAMEMODE.PlayerVehicles[self]:Spawn();
	--print(GAMEMODE.PlayerVehicles[self]:GetKeyValues());
	GAMEMODE.PlayerVehicles[self]:SetOwner(self);
	
	
	
	self:EnterVehicle(GAMEMODE.PlayerVehicles[self]);
	
	GAMEMODE.NumJeepsPlaced = GAMEMODE.NumJeepsPlaced + 1;
	GAMEMODE.PlayerVehicles[self].Children = {}
	
	if GAMEMODE.SpawnCarParts then
		local DoTime = 0;
		for k, v in pairs(GAMEMODE.PartsTable) do
			//timer.Simple(DoTime, 
			//	function ( )
					if self and GAMEMODE.PlayerVehicles[self] and GAMEMODE.PlayerVehicles[self]:IsValid() and v[self:GetUsedPart(k)] then
					
						local Forward = GAMEMODE.PlayerVehicles[self]:GetForward() // left
						local Back = Forward * -1;  // right
						local Right = GAMEMODE.PlayerVehicles[self]:GetRight(); // back
						local Left = Right * -1; // Forward
						local Up = GAMEMODE.PlayerVehicles[self]:GetUp(); // Up
						local Down = Up * -1; // Down
									
						local Ent = v[self:GetUsedPart(k)].Place(GAMEMODE.PlayerVehicles[self], Forward, Back, Right, Left, Up, Down);
						for k, p in pairs(Ent) do
							p:SetOwner(self);
							table.insert(GAMEMODE.PlayerVehicles[self].Children, p);
						end
					end
			//	end
			//);
			DoTime = DoTime + .1;
		end
	else
		self:PrintMessage(HUD_PRINTTALK, "The admin has chosen to not spawn models for your car parts. This may be temporary to help stabalize the server.");
	end
	GAMEMODE.PlayerTables[self].LastNOSTime = 0;
	
	--thats gay shit
	--[[
	if self:Team() == 0 then
		GAMEMODE.PlayerVehicles[self]:SetMaterial("buggy_reskins/admin_hunts");
	elseif self:Team() == 1 then
		GAMEMODE.PlayerVehicles[self]:SetMaterial("buggy_reskins/admin_black");
	elseif self:Team() == 2 then
		if self:SteamID() == 'STEAM_0:0:10659704' then
			GAMEMODE.PlayerVehicles[self]:SetMaterial("buggy_reskins/admin_pk");
		else
			GAMEMODE.PlayerVehicles[self]:SetMaterial("buggy_reskins/admin_generic");
		end
	end
	]]--
	
	self:GetTable().PlayerVehicleBak = GAMEMODE.PlayerVehicles[self];

	--file.Delete("scripts\\vehicles\\gmracer_" .. GAMEMODE.NumJeepsPlaced .. ".txt");
	file.Delete("scripts\\vehicles\\gmracer_" .. GAMEMODE.NumJeepsPlaced .. ".txt");
	
end

function PlayerMetaTable:GiveDamage ( Ammount, Damager )
	if Damager and Damager:IsPlayer() and Damager:IsValid() then
		GAMEMODE.PlayerDamageTables[self] = GAMEMODE.PlayerDamageTables[self] or {};
		GAMEMODE.PlayerDamageTables[self][Damager] = GAMEMODE.PlayerDamageTables[self][Damager] or 0;
		GAMEMODE.PlayerDamageTables[self][Damager] = GAMEMODE.PlayerDamageTables[self][Damager] + Ammount;
		
		// Msg(Damager:Nick() .. " damaged " .. self:Nick() .. " for " .. Ammount .. " damage!\n");

		if self:Health() - Ammount <= 0 then
			self:Kill();
		else
			self:SetHealth(self:Health() - Ammount);
		end
	else
		// Msg("ERROR: Damager not found...\n");
	end
end

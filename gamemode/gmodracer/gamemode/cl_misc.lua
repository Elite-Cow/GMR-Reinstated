gmod_vehicle_viewmode_hack = CreateClientConVar( "gmod_vehicle_viewmode_hack", "1", true, true )
RunConsoleCommand("gmod_vehicle_viewmode", "1");

function GM.HUDShouldDraw ( Name )
	if Name == "CHudHealth" or Name == "CHudBattery" or Name == "CHudAmmo" or Name == "CHudSecondaryAmmo" then
		return false;
	else
		return true;
	end
end 
hook.Add("HUDShouldDraw", "GMR_HUDShouldDraw", GM.HUDShouldDraw)  ;

function GM:PlayerBindPress ( Player, Bind, Pressed )
	if Bind == "+use" or Bind == "-use" or string.find(Bind, "slot") then
		return true;
	elseif Pressed and Bind == "+duck" and IsValid(Player:GetVehicle()) then
		local iVal = gmod_vehicle_viewmode_hack:GetInt()
		if iVal == 0 then iVal = 1 else iVal = 0 end
		RunConsoleCommand( "gmod_vehicle_viewmode_hack", iVal )
		return true
	elseif Bind == "+speed" then
		if LocalPlayer():GetUsedPart("Engine Supercharging") != 0 or LocalPlayer():GetUsedPart("Cooling System") != 0 or LocalPlayer():GetUsedPart("Nitrous System") != 0 or LocalPlayer():GetUsedPart("Exhaust") != 0 then
			local JeepData = Player:CompileJeepData()
			
			if Player:InVehicle() and self.LastNOSTime + JeepData.BoostDelay + JeepData.BoostDuration <= CurTime() then
				self.LastNOSTime = CurTime();
			end
		else
			return true;
		end
	elseif Bind == "+jump" and Player:GetUsedPart("Hand Brake") == 0 and IsValid(Player:GetVehicle()) then
		return true;
	elseif Bind == "impulse 100" then
		SetGlobalBool("LightsOn", GetGlobalBool("LightsOn"));
		RunConsoleCommand("GMRacer_ToggleLights", "");
	end
end

function GM:CalcView( ply, origin, angles, fov )
	
	local Vehicle = ply:GetVehicle()
	local wep = ply:GetActiveWeapon()

	
	if ( IsValid( Vehicle ) && 
		 gmod_vehicle_viewmode_hack:GetInt() == 1 
		 /*&& ( !IsValid(wep) || !wep:IsWeaponVisible() )*/
		) then
		--VehicleThirdPerson
		return GAMEMODE:CalcVehicleView( Vehicle, ply, {
		origin = origin*1-(angles:Forward()*150), 
		angles = angles*1, 
		fov = fov,
		drawviewer = true
		})
	end

	/*
	local ScriptedVehicle = ply:GetScriptedVehicle() --	local ScriptedVehicle = ply:GetVehicle():GetClass() Scripted Entitys dont exist anymore
	if ( IsValid( ScriptedVehicle ) ) then
	
		// This code fucking sucks.
		local view = ScriptedVehicle.CalcView( ScriptedVehicle:GetTable(), ply, origin, angles, fov )
		if ( view ) then return view end

	end
	*/
	
	local view = {}
	view.origin 	= origin
	view.angles		= angles
	view.fov 		= fov
	
	// Give the active weapon a go at changing the viewmodel position
	
	if ( IsValid( wep ) ) then
	
		local func = wep.GetViewModelPosition
		if ( func ) then
			view.vm_origin,  view.vm_angles = func( wep, origin*1, angles*1 ) // Note: *1 to copy the object so the child function can't edit it.
		end
		
		local func = wep.CalcView
		if ( func ) then
			view.origin, view.angles, view.fov = func( wep, ply, origin*1, angles*1, fov ) // Note: *1 to copy the object so the child function can't edit it.
		end
	
	end
	
	return view
	
end

function GM.NewRecord ( Name, Time, Place, Numeric )
	GAMEMODE.NewRecordNum = Numeric;
	
	GAMEMODE.NewRecord_Text = Name .. " beat the " .. Place .." place record with a time of " .. Time .. " seconds!";
	
	SetGlobalString("MapRecords_" .. Numeric .. "_Name", Name);
	SetGlobalInt("MapRecords_" .. Numeric .. "_Time", Time);
	
	timer.Simple(1, function ( ) GAMEMODE.IsNewRecord = true; end)
	timer.Simple(GAMEMODE.NewRecordTime + 1, GAMEMODE.StopNewRecord);
	RunConsoleCommand("stopsounds");
	timer.Simple(1, function() surface.PlaySound("gmracer/new_record.mp3") end );
end

function GM.StopNewRecord ( ) GAMEMODE.IsNewRecord = false; end
GM.GlobalEmitter = ParticleEmitter(Vector(0, 0, 0));
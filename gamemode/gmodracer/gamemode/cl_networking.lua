function GM.ReceivePartInformation ( UMsg )
	local Str = UMsg:ReadString();
	local Sho = UMsg:ReadShort();
	
	timer.Simple(1, 
		function ( )
			GAMEMODE.PlayerStats[LocalPlayer()] = GAMEMODE.PlayerStats[LocalPlayer()] or {};
			GAMEMODE.PlayerStats[LocalPlayer()][Str] = Sho;
		end
	);
end
usermessage.Hook("GMRPlayerStat", GM.ReceivePartInformation);

function GM.ShowTrackMenu ( )
	if GAMEMODE.IsInGarage then return false; end
	
	if GAMEMODE.IsInMenu then
		GAMEMODE.IsInMenu = false;
		GAMEMODE:WipeClickZones();
	else
		GAMEMODE.IsInMenu = true;
	end
	
	gui.EnableScreenClicker(GAMEMODE.IsInMenu);
end
usermessage.Hook("ShowTrackMenu", GM.ShowTrackMenu);

function GM.DeleteVehicleAddons ( )
	for k, v in pairs(GAMEMODE.VehicleAddons) do if v:IsValid() then v:SetNoDraw(true); v:Remove(); else v:SetPos(Vector(0,0,0)) end end 
	GAMEMODE.VehicleAddons = {};
end

function GM.DeleteGarageInfo ( )
	if GAMEMODE.GarageVehicle and GAMEMODE.GarageVehicle:IsValid() then GAMEMODE.GarageVehicle:SetNoDraw(true); GAMEMODE.GarageVehicle:Remove(); end
	GAMEMODE.VehicleAddons = GAMEMODE.VehicleAddons or {};
	GAMEMODE.DeleteVehicleAddons();
	GAMEMODE.ClickZonesSetup = false;
end

function GM.SetStartTime ( UMsg ) GAMEMODE.RaceStartTime = CurTime(); end
usermessage.Hook("SetStartTime", GM.SetStartTime);
function GM.SetShowSorryMessage ( UMsg ) GAMEMODE.ShowSorryMessage = true; end
usermessage.Hook("SorryMessage", GM.SetShowSorryMessage);
function GM.SetWrongWay ( UMsg )
	GAMEMODE.ShowWrongWay = true;
	GAMEMODE.WrongWayCheckpoint = LocalPlayer():GetNetworkedInt("CurrentCheckpoint");
end
usermessage.Hook("WrongWay", GM.SetWrongWay);

function GM.StartRaceCountdown ( UMsg )
	gui.EnableScreenClicker(false);
	SplashSlow("gmracer/3");
	surface.PlaySound(GAMEMODE.CountdownSound);
	timer.Simple(1, function() SplashSlow("gmracer/2") end ); -- some gay shit happening causing it to all fire at once
	timer.Simple(1, function() surface.PlaySound(GAMEMODE.CountdownSound) end );
	timer.Simple(2, function() SplashSlow("gmracer/1") end );
	timer.Simple(2, function() surface.PlaySound(GAMEMODE.CountdownSound) end );
	timer.Simple(3, function() SplashSlow("gmracer/go") end );
	timer.Simple(3, function() surface.PlaySound(GAMEMODE.GoSound) end );
	GAMEMODE.RaceStartTime = CurTime() + 5;
	GAMEMODE:WipeClickZones();
	LocalPlayer():SetNetworkedBool('IsCurrentlyRacing', true)
	RunConsoleCommand("r_cleardecals");
end
usermessage.Hook("StartCountdown", GM.StartRaceCountdown);

function GM.ShowGarageMenu ( UMsg )
	if GAMEMODE.IsInMenu then return false; end
	
	GAMEMODE.GarageViewLocation = UMsg:ReadVector();
	GAMEMODE.GarageVehicleLocation = UMsg:ReadVector();
	
	if GAMEMODE.IsInGarage then
		GAMEMODE.IsInGarage = false;
		
		GAMEMODE.DeleteGarageInfo();
		
		gui.EnableScreenClicker(false);
	else
		GAMEMODE.IsInGarage = true;
		
		GAMEMODE.DeleteGarageInfo();
		
		GAMEMODE.GarageVehicle = ents.CreateClientProp("models/buggy.mdl");
		--GAMEMODE.GarageVehicle = ents.Create("prop_physics");
		--GAMEMODE.GarageVehicle:SetModel("models/buggy.mdl");
		if !GAMEMODE.GarageVehicle or !GAMEMODE.GarageVehicle:IsValid() then return false; end
		GAMEMODE.GarageVehicle:SetPos(GAMEMODE.GarageVehicleLocation - Vector(0, 0, 30));
		GAMEMODE.GarageVehicle:SetAngles(Angle(0, (GAMEMODE.GarageViewLocation - GAMEMODE.GarageVehicleLocation):Angle().y - 50, 0));
		GAMEMODE.GarageVehicle:SetOwner(LocalPlayer());
		GAMEMODE.GarageVehicle:Spawn();
		
		GAMEMODE.GarageViewAngle = (GAMEMODE.GarageVehicleLocation - GAMEMODE.GarageViewLocation):Angle()
		
		gui.EnableScreenClicker(true);
	end
end
usermessage.Hook("ShowGarageMenu", GM.ShowGarageMenu);

function GM.BuyPart ( PartTable )
	if !GAMEMODE.IsInGarage then return false; end
	if LocalPlayer():GetCash() < PartTable.Cost then return false; end
	if LocalPlayer():GetUsedPart(PartTable.Class) != PartTable.ClassLevel - 1  then return false; end

	if LocalPlayer():Team() > PartTable.RequiresAccess then
		LocalPlayer():PrintMessage(HUD_PRINTTALK, "You must be a VIP member to access that part! Visit http://www.pulsareffect.com/ for more information.");
		return false;
	end
	
	if GAMEMODE.DrillSound then surface.PlaySound(GAMEMODE.DrillSound); end
	
	GAMEMODE.DeleteVehicleAddons()
	GAMEMODE.ClickZonesSetup = false;
	LocalPlayer():SetUsedPart(PartTable.Class, PartTable.ClassLevel);
	LocalPlayer():SetNetworkedInt("GMRacer_Money", LocalPlayer():GetCash() - PartTable.Cost);
	RunConsoleCommand("GMRacer_BuyPart",  PartTable.Class);
end

function GM.SellPart ( PartTable )
	if !GAMEMODE.IsInGarage then return false; end
	if LocalPlayer():GetUsedPart(PartTable.Class) != PartTable.ClassLevel then return false; end
	if !PartTable.Sellable then return false; end
	if !GAMEMODE.PartsTable[PartTable.Class][PartTable.ClassLevel - 1] and PartTable.ClassLevel != 1 then return false; end
	
	if GAMEMODE.RegisterSound then surface.PlaySound(GAMEMODE.RegisterSound); end
	
	LocalPlayer():SetNetworkedInt("GMRacer_Money", LocalPlayer():GetCash() + PartTable.Cost * 2);
	GAMEMODE.DeleteVehicleAddons()
	GAMEMODE.ClickZonesSetup = false;
	LocalPlayer():SetUsedPart(PartTable.Class, PartTable.ClassLevel - 1);
	RunConsoleCommand("GMRacer_SellPart",  PartTable.Class);
end

function GM.NewRecord2 ( UMsg )
	GAMEMODE.NewRecord(UMsg:ReadString(), UMsg:ReadShort(), UMsg:ReadString(), UMsg:ReadShort());
end
usermessage.Hook('NewRecord', GM.NewRecord2);
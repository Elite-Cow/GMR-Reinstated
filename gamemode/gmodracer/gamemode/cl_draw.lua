GM.FPS = 0;
GM.FramesThisSec = 0;
GM.CurSec = CurTime();

function GM:HUDPaintBackground ( )
	hook.Remove("RenderScreenspaceEffects", "NV_Render");
	
	if self.IsNewRecord then
		draw.SimpleText(self.NewRecord_Text, "DermaLarge", ScrW() * .5, ScrH() * .25, Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255), 1, 1);
	end

	if self.CurSec == math.ceil(CurTime()) then
		self.FramesThisSec = self.FramesThisSec + 1;
	else
		self.FPS = (self.FPS + self.FramesThisSec) / 2;
		self.CurSec = math.ceil(CurTime());
		self.FramesThisSec = 1;
	end
	
	local MouseX, MouseY = gui.MousePos();
	local MouseIsDown = input.IsMouseDown(MOUSE_LEFT);
	
	GAMEMODE.SmoothedCash = GAMEMODE.SmoothedCash or LocalPlayer():GetCash();
	if GAMEMODE.SmoothedCash < LocalPlayer():GetCash() then
		if GAMEMODE.SmoothedCash + 100 > LocalPlayer():GetCash() then
			GAMEMODE.SmoothedCash = LocalPlayer():GetCash();
		else
			GAMEMODE.SmoothedCash = GAMEMODE.SmoothedCash + 100;
		end
	elseif GAMEMODE.SmoothedCash > LocalPlayer():GetCash() then
		if GAMEMODE.SmoothedCash - 100 < LocalPlayer():GetCash() then
			GAMEMODE.SmoothedCash = LocalPlayer():GetCash();
		else
			GAMEMODE.SmoothedCash = GAMEMODE.SmoothedCash - 100;
		end
	end
	
	if MouseIsDown then
		for k, v in pairs(self.ClickZones) do
			if !v.WasJustDown and MouseX >= v.X and MouseX <= v.X + v.W and MouseY >= v.Y and MouseY <= v.Y + v.H then
				v.WasJustDown = true;
				v.Func(v.PassArg);
			end
		end
	else
		for k, v in pairs(self.ClickZones) do
			v.WasJustDown = false;
		end
	end
	
	BlackBorder = 1;
	DrawBorder = 4;
	GreyColor = Color(200, 200, 200, 255);
	RedColor = Color(255, 100, 100, 255);
	BrightRedColor = Color(255, 0, 0, 255);
	TextColor = Color(150, 150, 150, 255);
	surface.SetFont("DermaLarge");
	HeaderSize_X, HeaderHeight = surface.GetTextSize("PDFd|");
	surface.SetFont("DermaDefaultBold");
	SubtractHeader_X, SubtractHeader_B_Y = surface.GetTextSize("PDFd|");
	SubtractHeader_Y = SubtractHeader_B_Y + (DrawBorder * 2);
	surface.SetFont("DermaDefault");
	TextWidth, TextHeight = surface.GetTextSize("fgsfdgGFGf|");
	
	SpaceLeft = ScrW() - ((DrawBorder + BlackBorder) * 2);
	BarHeight = ScrH() / 20;
	StartX = DrawBorder + BlackBorder;
	StartY = ScrH() - DrawBorder - BarHeight - BlackBorder
	
	local PeopleAreRacing = false;
	for k, v in pairs(player.GetAll()) do		
		if v:IsRacing() then
			PeopleAreRacing = true;
		end
	
		if v != LocalPlayer() then
			local TraceDat = {};
			TraceDat.start = v:GetPos() + Vector(0, 0, 64);
			TraceDat.endpos = LocalPlayer():GetPos() + Vector(0, 0, 64);
			TraceDat.filter = {v, LocalPlayer()};
			
			if v:InVehicle() then table.insert(TraceDat.filter, v:GetVehicle()); end
			if LocalPlayer():InVehicle() then table.insert(TraceDat.filter, LocalPlayer():GetVehicle()); end
			
			local Trace = util.TraceLine(TraceDat);
			
			local pos = (v:GetPos() + Vector(0, 0, 90)):ToScreen()
			
			if !Trace.Hit then
				draw.SimpleText(v:GetName(), "DermaDefaultBold", pos.x, pos.y, team.GetColor(v:Team()), 1, 1);
			end
		end
	
		if v:InVehicle() then
			local Vehicle = v:GetVehicle();
			local FirePos = Vehicle:GetPos() + Vector(0, 0, 35)
				
			if v:Health() < 10 and GAMEMODE.EffectsOn:GetBool() then
				local effectdata = EffectData()
				effectdata:SetOrigin(FirePos)
				effectdata:SetStart(FirePos)
				effectdata:SetScale(1)
				util.Effect("smoke_and_fire", effectdata)
			elseif v:Health() < 50 and GAMEMODE.EffectsOn:GetBool() then
				local effectdata = EffectData()
				effectdata:SetOrigin(FirePos)
				effectdata:SetStart(FirePos)
				effectdata:SetScale(1)
				effectdata:SetRadius(v:Health());
				util.Effect("smoke", effectdata)
			end
		end
	end
	
	SetGlobalBool("CurrentlyRacing", PeopleAreRacing);
	
	if GetGlobalBool("VotingForMap") then
		self.WasJustRacing = false;
		self:DrawMapVoteMenu();
	elseif LocalPlayer():IsRacing() and LocalPlayer():InVehicle() then
		self.WasJustRacing = true;
		if GetGlobalInt('GamemodeType') == 2 then
			self:DrawDemo();
		else
			self:DrawRace();
		end
	elseif self.IsInGarage then
		self.WasJustRacing = false;
		self:DrawGarage();
	elseif self.IsInMenu then
		self.WasJustRacing = false;
		self:DrawHelpMenu();
	else
		local NextRaceTime = GetGlobalInt("NextRaceStart");
		local DisplayString;
		self.WasJustRacing = false;
		
		if GetGlobalBool("CurrentlyRacing") then
			DisplayString = "A race is currently going, so please wait for the next race.";
		else
			DisplayString = "Next race in: " .. NextRaceTime .. " seconds.";
		end
		
		if LocalPlayer():GetNetworkedBool("IsQueued") then
			draw.SimpleText("You are currently queued for the next race. " .. DisplayString, "DermaDefaultBold", DrawBorder, ScrH() - (SubtractHeader_Y / 2) + DrawBorder, GreyColor, 0, 1);
			if self.ShowSorryMessage then
				draw.SimpleText("Because we could not fit you into the last race, you have been placed at the front of the line for the next race.", "DermaDefaultBold", DrawBorder, ScrH() - (SubtractHeader_Y * 1.1) + DrawBorder, RedColor, 0, 1);
			elseif LocalPlayer():IsAdmin() == true then
				draw.SimpleText("As an Admin, you will be placed at the front of the line for all races.", "DermaDefaultBold", DrawBorder, ScrH() - (SubtractHeader_Y * 1.1) + DrawBorder, Color(50, 50, 255, 255), 0, 1);
			elseif LocalPlayer():Team() <= 4 then
				draw.SimpleText("As a VIP member, you will be placed at the front of the line for all races.", "DermaDefaultBold", DrawBorder, ScrH() - (SubtractHeader_Y * 1.1) + DrawBorder, Color(50, 50, 255, 255), 0, 1);
			end
		else
			self.ShowSorryMessage = false;
			draw.SimpleText("You are not currently queued for the next race. Press F3 to queue. " .. DisplayString, "DermaDefaultBold", DrawBorder, ScrH() - (SubtractHeader_Y / 2) + DrawBorder, GreyColor, 0, 1);
		end
	end
end

function SplashSlow ( name )

	local sprite = CreateSprite( Material(name) )
	
	local W1 = 10
	local H1 = 10
	
	sprite:SetTerm(1)
	sprite:SetPos(ScrW() * 0.5, ScrH() * 0.5)
	sprite:SetSize(W1, H1)
	sprite:SetColor(Color(0,0,0,255))
	
	local W2 = ScrW() * .25
	local H2 = ScrH() * .25
	
	sprite:SizeTo(W2, H2, 0.3, 0)
	sprite:MoveTo(ScrW() * 0.5, ScrH() * 0.5, 0.3, 0)
	sprite:ColorTo( Color(255, 255, 255, 255), 0.3, 0 )
	
	local W3 = ScrW() * .75
	local H3 = ScrH() * .75
	
	sprite:SizeTo(W3, H3, 0.5, 0.5 )
	sprite:MoveTo(ScrW() * 0.5, ScrH() * 0.5, 0.5, 0.5)
	sprite:ColorTo( Color(255, 255, 255, 0), 0.5, 0.5 )
end

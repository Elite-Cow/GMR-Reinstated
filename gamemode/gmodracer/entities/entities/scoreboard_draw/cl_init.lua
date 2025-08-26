include('shared.lua')

ENT.RenderGroup = RENDERGROUP_OPAQUE;

function ENT:DrawText ( text, font, x, y, color, xalign, yalign )
	surface.SetFont(font);
	local W, H = surface.GetTextSize(text);
	
	if yalign == 1 then
		y = y - (H * .5);
	elseif yalign == 2 then
		y = y - H;
	end
	
	if xalign == 1 then
		x = x - (W * .5);
	elseif xalign == 2 then
		x = x - W;
	end
	
	draw.DrawText(text, font, self.X + x, self.Y + y, color);
end

function ENT:DrawRect ( x, y, w, h, color )
	surface.SetDrawColor(color.r, color.g, color.b, color.a);
	surface.DrawRect(self.X + x, self.Y + y, w, h);
end

surface.CreateFont("3DDermaLarge", {
	font = "coolvetica",
	size = 70,
	weight = 500
});
surface.CreateFont("3DDermaDefault", {
	font = "coolvetica",
	size = 40,
	weight = 500
});
surface.CreateFont("3DDermaDefault_LCD", {
	font = "LCD",
	size = 40,
	weight = 700
});

function ENT:Draw()		
	if !self.Setup then
		local Angle = self:GetAngles();
		Angle:RotateAroundAxis(Angle:Right(), 90)
		Angle:RotateAroundAxis(Angle:Up(), -90)
		
		cam.Start3D2D(self:GetPos(), Angle, 1);
			draw.SimpleText("Loading Scoreboard...", "DermaLarge", 0, 0, GreyColor, 1, 1);
		cam.End3D2D();
		
		return false;
	end

	/*
	local Forward = (self:GetPos() - self:GetNetworkedVector("ScoreboardFace")):Normalize()
	local Angle = Forward:Angle();
	*/
	
	local Angle = self:GetAngles();
	Angle:RotateAroundAxis(Angle:Right(), 90)
	Angle:RotateAroundAxis(Angle:Up(), -90)
	
	local OBBMax = self:GetNetworkedVector("OBB_Max");
	local OBBMin = self:GetNetworkedVector("OBB_Min");
		
	local YDist = OBBMax:Distance(Vector(OBBMax.x, OBBMax.y, OBBMin.z));
	local XDist = OBBMax:Distance(Vector(OBBMin.x, OBBMin.y, OBBMax.z));
		
	local Scale = 3;
		
	self.X = XDist * -(Scale * .5);
	self.Y = YDist * -(Scale * .5);
	self.W = XDist * Scale;
	self.H = YDist * Scale;
	
	cam.Start3D2D(self:GetPos(), Angle, 1 / Scale);
		if GAMEMODE.IsNewRecord then
			self:DrawRect(0, 0, self.W, self.H, Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255));
		else
			self:DrawRect(0, 0, self.W, self.H, Color(255, 255, 255, 255));
		end

		local HeaderColor = Color(50, 50, 50, 255);
		
		if GetGlobalInt('GamemodeType') != 2 then
			self:DrawText("Last Race", "3DDermaLarge", self.W * .25, 35, HeaderColor, 1, 1); 
			self:DrawText("Map Records", "3DDermaLarge", self.W * .75, 35, HeaderColor, 1, 1); 
		else
			self:DrawText("Last Race", "3DDermaLarge", self.W * .50, 35, HeaderColor, 1, 1); 
		end
		
		surface.SetFont("3DDermaLarge");
		local SW, SH = surface.GetTextSize("ASDFD|");
		surface.SetFont("3DDermaDefault");
		local SW2, SH2 = surface.GetTextSize("ASDFD|");
		
		local MenuWidths = self.W * .4;
		local MenuStartY = 25 + SH;
		local MenuHeight = self.H - MenuStartY - 20;
		
		local NumDataShow = math.floor(MenuHeight / SH2);
		
		if GetGlobalInt('GamemodeType') != 2 then
			self:DrawText("( Top " .. NumDataShow .. " Shown )", "3DDermaDefault", self.W * .25, 35 + (SH * .5), HeaderColor, 1, 1); 
			self:DrawText("( Top " .. math.Clamp(10, 0, NumDataShow - 1) .. " Shown )", "3DDermaDefault", self.W * .75, 35 + (SH * .5), HeaderColor, 1, 1); 
		else
			self:DrawText("( Top " .. NumDataShow .. " Shown )", "3DDermaDefault", self.W * .5, 35 + (SH * .5), HeaderColor, 1, 1); 
		end
		
		if GetGlobalInt('GamemodeType') != 2 then
			self:DrawRect(self.W * .25 - MenuWidths * .5, MenuStartY, MenuWidths, MenuHeight, Color(0, 0, 0, 255));
			self:DrawRect(self.W * .25 - MenuWidths * .5 + 1, MenuStartY + 1, MenuWidths - 2, MenuHeight - 2, Color(255, 255, 255, 255));
			
			self:DrawRect(self.W * .75 - MenuWidths * .5, MenuStartY, MenuWidths, MenuHeight, Color(0, 0, 0, 255));
			self:DrawRect(self.W * .75 - MenuWidths * .5 + 1, MenuStartY + 1, MenuWidths - 2, MenuHeight - 2, Color(255, 255, 255, 255));
		else
			self:DrawRect(self.W * .25 - MenuWidths * .5, MenuStartY, self.W * .5 + MenuWidths, MenuHeight, Color(0, 0, 0, 255));
			self:DrawRect(self.W * .25 - MenuWidths * .5 + 1, MenuStartY + 1, self.W * .5 + MenuWidths - 2, MenuHeight - 2, Color(255, 255, 255, 255));
		end
		
		local XPos = MenuStartY + (SH2 * .5);
		
		if GetGlobalInt('GamemodeType') != 2 then
			self:DrawText("Your Record:", "3DDermaDefault", self.W * .75 - MenuWidths * .5, XPos, HeaderColor, 0, 1); 
		end
		
		local Time = LocalPlayer():GetNetworkedInt("MapRecord");
		
		if Time == 1337 then 
			Time = "Haven't Raced Yet";
		else
			Time = string.ToMinutesSecondsMilliseconds(Time);
		end
		
		if GetGlobalInt('GamemodeType') != 2 then
			if Time == "Haven't Raced Yet" then
				self:DrawText(Time, "3DDermaDefault", self.W * .75 + MenuWidths * .5, XPos, HeaderColor, 2, 1); 
			else
				self:DrawText(Time, "3DDermaDefault_LCD", self.W * .75 + MenuWidths * .5, XPos, HeaderColor, 2, 1); 
			end
		end
		
		XPos = XPos + SH2;
		
		if GetGlobalInt('GamemodeType') != 2 then
			for i = 1, math.Clamp(10, 0, NumDataShow - 1) do
				local Time = GetGlobalInt("MapRecords_" .. tostring(i) .. "_Time");
				
				if Time == 1337 then Time = 0; end
				
				Time = string.ToMinutesSecondsMilliseconds(Time);
			
				if GAMEMODE.IsNewRecord and GAMEMODE.NewRecordNum == i then
					self:DrawRect(self.W * .75 - MenuWidths * .5, XPos - SH2 * .5, MenuWidths, SH2, Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255));
				end
				
				self:DrawText("#" .. i .. ". " .. GetGlobalString("MapRecords_" .. tostring(i) .. "_Name", "No Record"), "3DDermaDefault", self.W * .75 - MenuWidths * .5, XPos, HeaderColor, 0, 1); 
				
				self:DrawText(Time, "3DDermaDefault_LCD", self.W * .75 + MenuWidths * .5, XPos, HeaderColor, 2, 1); 
							
				XPos = XPos + SH2;
			end
		end
		
		local XPos = MenuStartY + (SH2 * .5);
		local DrawPlayers = {};
		local NumRacers = math.Clamp(GetGlobalInt("NumberOfRacers"), 0, NumDataShow);
		
		if !NumRacers or NumRacers == 0 then cam.End3D2D(); return false; end
		
		for i = 1, NumRacers do
			local CurCheckpoint = -1;
			local CurTime = 1337;
			local Destroyed = true;
			local Finished = false;
			local Kills = -1;
			local CurHealth = 0;
			local CurPlayer;
			
			for k, Player in pairs(player.GetAll()) do
				local AlreadyPlaced = false;
				for k, v in pairs(DrawPlayers) do if v == Player then AlreadyPlaced = true; end end
				
				if !AlreadyPlaced then
					if Player:GetNetworkedBool("IsCurrentlyRacing") then
					
						local function Insert ( Player, Fine )
							Kills = Player:GetNetworkedInt("RoundKills");
							CurCheckpoint = Player:GetNetworkedInt("CurrentCheckpoint");
							Destroyed = Player:GetNetworkedBool("IsDestroyed");
							CurTime = Player:GetNetworkedInt("RaceTime");
							CurHealth = Player:Health()
							CurPlayer = Player;
							Finished = Fine;
						end
					

							local PlayerFinished = false;
							if Player:GetNetworkedInt("CurrentCheckpoint") == GetGlobalInt("TotalNumberCheckpoints") and !Player:GetNetworkedBool("IsDestroyed") then
								PlayerFinished = true;
							end
							
							if GetGlobalInt('GamemodeType') != 2 then
								if Player:GetNetworkedBool("IsDestroyed") and !Destroyed then
								
								elseif !PlayerFinished and Finished then
									
								elseif Destroyed and !Player:GetNetworkedBool("IsDestroyed") then
									Insert(Player, PlayerFinished);
								elseif PlayerFinished and !Finished then
									Insert(Player, PlayerFinished);
								elseif Player:GetNetworkedInt("CurrentCheckpoint") >= CurCheckpoint and Player:GetNetworkedInt("RaceTime") <= CurTime then
									Insert(Player, PlayerFinished);
								end
							else
								if Player:GetNetworkedBool("IsDestroyed") and !Destroyed then
								
								elseif Destroyed and !Player:GetNetworkedBool("IsDestroyed") then
									Insert(Player, PlayerFinished);
								else
									Insert(Player, PlayerFinished);
								end
							end
						
						
					end
				end
			end
			
			DrawPlayers[i] = CurPlayer;
		end
		
		for k, v in pairs(DrawPlayers) do
			local Time = CurTime() - GAMEMODE.RaceStartTime;
			if v:GetNetworkedInt("RaceTime") != 0 then
				Time = v:GetNetworkedInt("RaceTime");
			end
			
			local Time = string.ToMinutesSecondsMilliseconds(Time);
		
			self:DrawText("#" .. k .. ". " .. v:Nick(), "3DDermaDefault", self.W * .25 - MenuWidths * .5, XPos, HeaderColor, 0, 1); 
			

			if GetGlobalInt('GamemodeType') != 2 then
				if v:GetNetworkedBool("IsDestroyed") then
					self:DrawText("Destroyed", "3DDermaDefault", self.W * .25 + MenuWidths * .5, XPos, Color(255, 0, 0, 255), 2, 1); 
				else
					self:DrawText(Time, "3DDermaDefault_LCD", self.W * .25 + MenuWidths * .5, XPos, HeaderColor, 2, 1); 
				end
			else
				if v:GetNetworkedBool("IsDestroyed") then
					self:DrawText(string.ToMinutesSecondsMilliseconds(v:GetNetworkedBool("RaceTime")), "3DDermaDefault", self.W * .75 + MenuWidths * .5, XPos, Color(255, 0, 0, 255), 2, 1); 
				else
					self:DrawText(Time, "3DDermaDefault_LCD", self.W * .75 + MenuWidths * .5, XPos, HeaderColor, 2, 1); 
				end
			end
						
			XPos = XPos + SH2;
		end
	cam.End3D2D();
end

function ENT:Initialize ( )
	self.Setup = false;
end

function ENT:Think()
	if !self.Setup and self:GetNetworkedVector("OBB_Max") and self:GetNetworkedVector("OBB_Max") != Vector(0, 0, 0) then
		self.Setup = true;
		self:SetRenderBoundsWS(self:GetNetworkedVector("OBB_Min"), self:GetNetworkedVector("OBB_Max"));
	end
end

function ENT:DrawTranslucent() self:Draw(); end
function ENT:BuildBonePositions( NumBones, NumPhysBones ) end
function ENT:SetRagdollBones( bIn ) self.m_bRagdollSetup = bIn; end
function ENT:DoRagdollBone( PhysBoneNum, BoneNum ) end

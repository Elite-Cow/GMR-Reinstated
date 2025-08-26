function GM:DrawGarage ( )
	GAMEMODE.GarageVehicle:SetAngles(GAMEMODE.GarageVehicle:GetAngles() + Angle(0, 1, 0));

		local CamData = {}
		CamData.angles, CamData.origin = self.GarageViewAngle, self.GarageViewLocation - Vector(0, 0, 20);
		CamData.x, CamData.y, CamData.w, CamData.h = 0, 0, ScrW(), ScrH();
		render.RenderView(CamData);
		
		local LeftMenuW = ScrW() / 4;
		local LeftMenuH = (ScrH() / 15) * 14;
		local LeftMenuY = (ScrH() - LeftMenuH) / 2;
		local LeftMenuX = LeftMenuY;
		
		local RightMenuW = ScrW() / 4;
		local RightMenuH = (ScrH() / 15) * 14;
		local RightMenuY = (ScrH() - RightMenuH) / 2;
		local RightMenuX = ScrW() - RightMenuY - RightMenuW;
		
		local BottomMenuX = (LeftMenuX * 2) + LeftMenuW;
		local BottomMenuH = 8 * TextHeight + 5 + SubtractHeader_Y;
		local BottomMenuY = ScrH() - (ScrH() / 30) - BottomMenuH;
		local BottomMenuW = RightMenuX - LeftMenuX - BottomMenuX;
		
		local DirButtonHeight = TextHeight * 1.25;
		
		draw.RoundedBox(10, LeftMenuX, LeftMenuY, LeftMenuW, LeftMenuH, GreyColor);
		draw.RoundedBox(10, LeftMenuX + BlackBorder, LeftMenuY + BlackBorder, LeftMenuW - (BlackBorder * 2), LeftMenuH - (BlackBorder * 2), Color(255, 255, 255, 255));
		
		draw.RoundedBox(10, RightMenuX, RightMenuY, RightMenuW, RightMenuH, GreyColor);
		draw.RoundedBox(10, RightMenuX + BlackBorder, RightMenuY + BlackBorder, RightMenuW - (BlackBorder * 2), RightMenuH - (BlackBorder * 2), Color(255, 255, 255, 255));

				
		draw.RoundedBox(10, BottomMenuX, BottomMenuY, BottomMenuW, BottomMenuH, GreyColor);
		draw.RoundedBox(10, BottomMenuX + BlackBorder, BottomMenuY + BlackBorder, BottomMenuW - (BlackBorder * 2), BottomMenuH - (BlackBorder * 2), Color(255, 255, 255, 255));
		
		
		// Bottom screen
		local CompJeepData = LocalPlayer():CompileJeepData();
		local StartDrawY = BottomMenuY + BottomMenuH - 5 - (TextHeight / 2);
		
		draw.SimpleText("Car Stats", "DermaDefaultBold", BottomMenuX + BottomMenuW / 2, BottomMenuY + SubtractHeader_Y / 2, GreyColor, 1, 1);
		
		draw.SimpleText("Press F2 to exit the garage", "DermaDefaultBold", BottomMenuX + BottomMenuW / 2, BottomMenuY - SubtractHeader_Y / 2, GreyColor, 1, 1);
		
		draw.SimpleText("Car Health: " .. CompJeepData.Health .. "%", "DermaDefault", BottomMenuX + 5, StartDrawY, GreyColor, 0, 1);
		draw.SimpleText("Car Armor: " .. CompJeepData.Armor .. " Plates", "DermaDefault", BottomMenuX + BottomMenuW - 5, StartDrawY, GreyColor, 2, 1);
		StartDrawY = StartDrawY - TextHeight;
		
		draw.SimpleText("Rear Axil Braking: " .. (CompJeepData.RearAxilBreaking * 100) .. "%", "DermaDefault", BottomMenuX + 5, StartDrawY, GreyColor, 0, 1);
		draw.SimpleText("Slow Turning Cone: " .. CompJeepData.TurningDegrees_Slow .. " Degrees", "DermaDefault", BottomMenuX + BottomMenuW - 5, StartDrawY, GreyColor, 2, 1);
		StartDrawY = StartDrawY - TextHeight;
		
		draw.SimpleText("Forward Axil Braking: " .. (CompJeepData.ForwardAxilBreaking * 100) .. "%", "DermaDefault", BottomMenuX + 5, StartDrawY, GreyColor, 0, 1);
		draw.SimpleText("Fast Turning Cone: " .. CompJeepData.TurningDegrees_Fast .. " Degrees", "DermaDefault", BottomMenuX + BottomMenuW - 5, StartDrawY, GreyColor, 2, 1);
		StartDrawY = StartDrawY - TextHeight;
		
		draw.SimpleText("Turbo Cooldown: " .. CompJeepData.BoostDelay .. " Seconds", "DermaDefault", BottomMenuX + 5, StartDrawY, GreyColor, 0, 1);
		draw.SimpleText("Turbo Turning Cone: " .. CompJeepData.TurningDegrees_Boost .. " Degrees", "DermaDefault", BottomMenuX + BottomMenuW - 5, StartDrawY, GreyColor, 2, 1);
		StartDrawY = StartDrawY - TextHeight;
		
		draw.SimpleText("Turbo Duration: " .. CompJeepData.BoostDuration .. " Seconds", "DermaDefault", BottomMenuX + 5, StartDrawY, GreyColor, 0, 1);
		draw.SimpleText("Turbo Boost Force: " .. (CompJeepData.BoostForce * 100) .. "%", "DermaDefault", BottomMenuX + BottomMenuW - 5, StartDrawY, GreyColor, 2, 1);
		StartDrawY = StartDrawY - TextHeight;
		
		draw.SimpleText("Maximum Reverse Speed: " .. CompJeepData.ReverseMaximumMPH .. " MPH", "DermaDefault", BottomMenuX + 5, StartDrawY, GreyColor, 0, 1);
		draw.SimpleText("Maximum Turbo Speed: " .. CompJeepData.BoostMaximumSpeed .. " MPH", "DermaDefault", BottomMenuX + BottomMenuW - 5, StartDrawY, GreyColor, 2, 1);
		StartDrawY = StartDrawY - TextHeight;
		
		draw.SimpleText("Maximum Forward Speed: " .. CompJeepData.ForwardMaximumMPH .. " MPH", "DermaDefault", BottomMenuX + 5, StartDrawY, GreyColor, 0, 1);
		draw.SimpleText("Maximum Roll Speed: " .. (CompJeepData.AutobrakeMaximumSpeed * CompJeepData.ForwardMaximumMPH) .. " MPH", "DermaDefault", BottomMenuX + BottomMenuW - 5, StartDrawY, GreyColor, 2, 1);
		StartDrawY = StartDrawY - TextHeight;
		
		draw.SimpleText("Weight: " .. CompJeepData.Weight .. " KG", "DermaDefault", BottomMenuX + 5, StartDrawY, GreyColor, 0, 1);
		draw.SimpleText("Horse Power: " .. CompJeepData.Horsepower, "DermaDefault", BottomMenuX + BottomMenuW - 5, StartDrawY, GreyColor, 2, 1);
		StartDrawY = StartDrawY - TextHeight;
		
		local NeededPartPlaces = table.Count(self.PartsTable);
		
		PicHeight = (LeftMenuH - (DirButtonHeight * 2) - (DrawBorder * 4) - SubtractHeader_Y) / 9;
		LeftPerPlace = PicHeight;
		RightPerPlace = PicHeight;
				
		self.StartLeft = self.StartLeft or 1;
		self.StartRight = self.StartRight or 1;
		
		self.StopLeft = self.StartLeft + 8;
		self.StopRight = self.StartRight + 8;

		if !self.FontsAreSetup_GM then
			self.FontsAreSetup_GM = true;
			surface.CreateFont("DermaDefault_Left", {
				font = "Tahoma",
				size = LeftPerPlace / 6,
				weight = 1000
			})
			surface.CreateFont("DermaDefault_Right", {
				font = "Tahoma",
				size = RightPerPlace / 6,
				weight = 1000
			})
		end
		
		surface.SetFont("DermaDefault_Left");
		TextWidth_Left, TextHeight_Left = surface.GetTextSize("fgsfdgGFGf|");
		surface.SetFont("DermaDefault_Right");
		TextWidth_Right, TextHeight_Right = surface.GetTextSize("fgsfdgGFGf|");
		
		
		local CurLeftY = LeftMenuY + (DrawBorder * 2) + SubtractHeader_Y + DirButtonHeight;
		local CurRightY = RightMenuY + (DrawBorder * 2) + SubtractHeader_Y + DirButtonHeight;
		
		draw.SimpleText("Current Parts", "DermaDefaultBold", LeftMenuX + LeftMenuW / 2, LeftMenuY + SubtractHeader_Y / 2, GreyColor, 1, 1);
		draw.SimpleText("Available Parts", "DermaDefaultBold", RightMenuX + RightMenuW / 2, RightMenuY + SubtractHeader_Y / 2, GreyColor, 1, 1);
		draw.SimpleText("$" .. LocalPlayer():GetCash(true), "LCD_Large", ScrW() / 2, RightMenuY + SubtractHeader_Y / 2, GreyColor, 1, 1);
		
		if !self.ClickZonesSetup then GAMEMODE.ClickZones = {}; end
		
		local DirButtonWidth = LeftMenuW - (DrawBorder * 2)
		draw.RoundedBox(DirButtonHeight * .5, LeftMenuX + DrawBorder, LeftMenuY + DrawBorder + SubtractHeader_Y, DirButtonWidth, DirButtonHeight, GreyColor)
		draw.RoundedBox(DirButtonHeight * .5, LeftMenuX + DrawBorder + BlackBorder, LeftMenuY + DrawBorder + SubtractHeader_Y + BlackBorder, DirButtonWidth - (BlackBorder * 2), DirButtonHeight - (BlackBorder * 2), Color(255, 255, 255, 255))
		draw.RoundedBox(DirButtonHeight * .5, RightMenuX + DrawBorder, LeftMenuY + DrawBorder + SubtractHeader_Y, DirButtonWidth, DirButtonHeight, GreyColor)
		draw.RoundedBox(DirButtonHeight * .5, RightMenuX + DrawBorder + BlackBorder, LeftMenuY + DrawBorder + SubtractHeader_Y + BlackBorder, DirButtonWidth - (BlackBorder * 2), DirButtonHeight - (BlackBorder * 2), Color(255, 255, 255, 255))
		
		draw.RoundedBox(DirButtonHeight * .5, LeftMenuX + DrawBorder, LeftMenuY + LeftMenuH - DrawBorder - DirButtonHeight, DirButtonWidth, DirButtonHeight, GreyColor)
		draw.RoundedBox(DirButtonHeight * .5, LeftMenuX + DrawBorder + BlackBorder, LeftMenuY + LeftMenuH - DrawBorder - DirButtonHeight + BlackBorder, DirButtonWidth - (BlackBorder * 2), DirButtonHeight - (BlackBorder * 2), Color(255, 255, 255, 255))
		draw.RoundedBox(DirButtonHeight * .5, RightMenuX + DrawBorder, LeftMenuY + LeftMenuH - DrawBorder - DirButtonHeight, DirButtonWidth, DirButtonHeight, GreyColor)
		draw.RoundedBox(DirButtonHeight * .5, RightMenuX + DrawBorder + BlackBorder, LeftMenuY + LeftMenuH - DrawBorder - DirButtonHeight + BlackBorder, DirButtonWidth - (BlackBorder * 2), DirButtonHeight - (BlackBorder * 2), Color(255, 255, 255, 255))
		
		draw.SimpleText("Scroll Up", "DermaDefault", LeftMenuX + LeftMenuW * .5,  LeftMenuY + DrawBorder + SubtractHeader_Y + DirButtonHeight * .5, TextColor, 1, 1);
		draw.SimpleText("Scroll Up", "DermaDefault", RightMenuX + LeftMenuW * .5,  LeftMenuY + DrawBorder + SubtractHeader_Y + DirButtonHeight * .5, TextColor, 1, 1);
		
		draw.SimpleText("Scroll Down", "DermaDefault", LeftMenuX + LeftMenuW * .5, LeftMenuY + LeftMenuH - DrawBorder - DirButtonHeight + BlackBorder + DirButtonHeight * .5, TextColor, 1, 1);
		draw.SimpleText("Scroll Down", "DermaDefault", RightMenuX + LeftMenuW * .5, LeftMenuY + LeftMenuH - DrawBorder - DirButtonHeight + BlackBorder + DirButtonHeight * .5, TextColor, 1, 1);
		
		
		local NumProc_Right = 0;
		local NumProc_Left = 0;
		local MadeLast_Right = true;
		local MadeLast_Left = true;
		
		if !self.ClickZonesSetup then
			for k, v in pairs(GAMEMODE.VehicleAddons) do
				if v and v:IsValid() then
					v:SetNoDraw(true)
					v:Remove();
				end
			end
		end
		
		for k, v in pairs(self.PartsTable) do
			local DispID = tonumber(LocalPlayer():GetUsedPart(k)) + 1;
			
			if v[DispID] then				
				NumProc_Right = NumProc_Right + 1;
				
				if NumProc_Right >= self.StartRight and NumProc_Right <= self.StopRight then
					local DrawTable = v[DispID];

					self:DrawRightPartInformation(DrawTable, RightMenuX + DrawBorder, CurRightY, RightMenuW - (DrawBorder * 2), RightPerPlace);
					
					CurRightY = CurRightY + RightPerPlace;
					MadeLast_Right = true;
				else
					MadeLast_Right = false;
				end
			end
			
			local CurID = tonumber(LocalPlayer():GetUsedPart(k));

			if v[CurID] then
				NumProc_Left = NumProc_Left + 1;
				local DrawTable = v[CurID];
				
				if !self.ClickZonesSetup then
					local Forward = self.GarageVehicle:GetForward() // Down
					local Back = Forward * -1;  // Up!
					local Right = self.GarageVehicle:GetRight(); // Back
					local Left = Right * -1; // Forward
					local Up = self.GarageVehicle:GetUp(); // Up
					local Down = Up * -1; // Down
					
					local Ents = DrawTable.Place(self.GarageVehicle, Left, Right, Forward, Back, Up, Down);
						
					for k, e in pairs(Ents) do
						table.insert(GAMEMODE.VehicleAddons, e);
					end
				end
				
				if NumProc_Left >= self.StartLeft and NumProc_Left <= self.StopLeft then
					self:DrawLeftPartInformation(DrawTable, LeftMenuX + DrawBorder, CurLeftY, LeftMenuW - (DrawBorder * 2), LeftPerPlace);
					
					CurLeftY = CurLeftY + LeftPerPlace;
					MadeLast_Left = true;
				else
					MadeLast_Left = false;
				end
			end
			
		end
		
		if self.StartLeft == 1 then
			draw.RoundedBox(DirButtonHeight * .5, LeftMenuX + DrawBorder + BlackBorder, LeftMenuY + DrawBorder + SubtractHeader_Y + BlackBorder, DirButtonWidth - (BlackBorder * 2), DirButtonHeight - (BlackBorder * 2), Color(GreyColor.r, GreyColor.b, GreyColor.g, 100))
		elseif !self.ClickZonesSetup then
			self:RegisterClickZone(LeftMenuX + DrawBorder, LeftMenuY + DrawBorder + SubtractHeader_Y, DirButtonWidth, DirButtonHeight, function ( ) GAMEMODE.StartLeft = GAMEMODE.StartLeft - 1; GAMEMODE.ClickZonesSetup = false end);
		end
		
		if self.StartRight == 1 then
			draw.RoundedBox(DirButtonHeight * .5, RightMenuX + DrawBorder + BlackBorder, LeftMenuY + DrawBorder + SubtractHeader_Y + BlackBorder, DirButtonWidth - (BlackBorder * 2), DirButtonHeight - (BlackBorder * 2), Color(GreyColor.r, GreyColor.b, GreyColor.g, 100))
		elseif !self.ClickZonesSetup then
			self:RegisterClickZone(RightMenuX + DrawBorder, LeftMenuY + DrawBorder + SubtractHeader_Y, DirButtonWidth, DirButtonHeight, function ( ) GAMEMODE.StartRight = GAMEMODE.StartRight - 1; GAMEMODE.ClickZonesSetup = false end);
		end
		
		if MadeLast_Left then
			draw.RoundedBox(DirButtonHeight * .5, LeftMenuX + DrawBorder, LeftMenuY + LeftMenuH - DrawBorder - DirButtonHeight, DirButtonWidth, DirButtonHeight, Color(GreyColor.r, GreyColor.b, GreyColor.g, 100))
		elseif !self.ClickZonesSetup then
			self:RegisterClickZone(LeftMenuX + DrawBorder, LeftMenuY + LeftMenuH - DrawBorder - DirButtonHeight, DirButtonWidth, DirButtonHeight, function ( ) GAMEMODE.StartLeft = GAMEMODE.StartLeft + 1; GAMEMODE.ClickZonesSetup = false end);
		end
		
		if MadeLast_Right then
			draw.RoundedBox(DirButtonHeight * .5, RightMenuX + DrawBorder, LeftMenuY + LeftMenuH - DrawBorder - DirButtonHeight, DirButtonWidth, DirButtonHeight, Color(GreyColor.r, GreyColor.b, GreyColor.g, 100))
		elseif !self.ClickZonesSetup then
			self:RegisterClickZone(RightMenuX + DrawBorder, LeftMenuY + LeftMenuH - DrawBorder - DirButtonHeight, DirButtonWidth, DirButtonHeight, function ( ) GAMEMODE.StartRight = GAMEMODE.StartRight + 1; GAMEMODE.ClickZonesSetup = false end);
		end
	
		self.ClickZonesSetup = true
end

function GM:DrawRightPartInformation ( Table, X, Y, W, H, OnLeft )
	local DH = H;
	RightPerPlace = H;

	surface.SetDrawColor(255, 255, 255, 255);
	surface.SetTexture(Table.Material);
	surface.DrawTexturedRect(X + W - DH, Y, DH, DH);
	
	if !self.ClickZonesSetup then self:RegisterClickZone(X + W - DH, Y, DH, DH, self.BuyPart, Table); end
	
	surface.SetFont("DermaDefault");
	local TextWidth, TextHeight = surface.GetTextSize("fgsfdgGFGf|");
	surface.SetFont("DermaDefault_Right");
	local TextWidth2, TextHeight2 = surface.GetTextSize("fgsfdgGFGf|");
	
	local TextStartX, TextStartY = X + W - DH - 1, Y + (TextHeight * .5);
	
	draw.SimpleText(Table.Name, "DermaDefault", TextStartX, TextStartY, TextColor, 2, 1); 
	draw.SimpleText("Class: " .. Table.Class, "DermaDefault_Right", TextStartX, TextStartY + TextHeight, TextColor, 2, 1); 
	draw.SimpleText(Table.Description, "DermaDefault_Right", TextStartX, TextStartY + TextHeight2 + TextHeight, TextColor, 2, 1); 
	draw.SimpleText("Cost: " .. Table.Cost, "DermaDefault_Right", TextStartX, TextStartY + (TextHeight2 * 2) + TextHeight, TextColor, 2, 1); 
end

function GM:DrawLeftPartInformation ( Table, X, Y, W, H, OnLeft )
	local DH = H;
	LeftPerPlace = H;
	
	surface.SetDrawColor(255, 255, 255, 255);
	surface.SetTexture(Table.Material);
	surface.DrawTexturedRect(X, Y, DH, DH);
	
	if !self.ClickZonesSetup then self:RegisterClickZone(X, Y, DH, DH, self.SellPart, Table); end
	
	surface.SetFont("DermaDefault");
	local TextWidth, TextHeight = surface.GetTextSize("fgsfdgGFGf|");
	surface.SetFont("DermaDefault_Left");
	local TextWidth2, TextHeight2 = surface.GetTextSize("fgsfdgGFGf|");
	
	local TextStartX, TextStartY = X + DH + 1, Y + (TextHeight * .5);
	
	draw.SimpleText(Table.Name, "DermaDefault", TextStartX, TextStartY, TextColor, 0, 1); 
	draw.SimpleText("Class: " .. Table.Class, "DermaDefault_Left", TextStartX, TextStartY + TextHeight, TextColor, 0, 1); 
	draw.SimpleText(Table.Description, "DermaDefault_Left", TextStartX, TextStartY + TextHeight2 + TextHeight, TextColor, 0, 1); 
	if Table.Sellable then
		draw.SimpleText("Refund: " .. (Table.Cost / 2), "DermaDefault_Left", TextStartX, TextStartY + (TextHeight2 * 2) + TextHeight, TextColor, 0, 1); 
	else
		draw.SimpleText("Non-Refundable", "DermaDefault_Left", TextStartX, TextStartY + (TextHeight2 * 2) + TextHeight, TextColor, 0, 1); 
	end
end

function GM.GMRacerHUDShouldDraw ( Type )
	if Type == "CHudHealth" or Type == "CHudAmmo" or Type == "CHudSecondaryAmmo" or Type == "CHudCrosshair" then
		return false;
	end
end
hook.Add("HUDShouldDraw", "GM.GMRacerHUDShouldDraw", GM.GMRacerHUDShouldDraw);

GM.ClickZones = {};
function GM:RegisterClickZone ( X, Y, W, H, Function, PassArg )
	local NewTable = {}
	NewTable.X = X;
	NewTable.Y = Y;
	NewTable.W = W;
	NewTable.H = H;
	NewTable.Func = Function;
	NewTable.PassArg = PassArg;
	NewTable.WasJustDown = true;
	table.insert(self.ClickZones, NewTable);
end
function GM:WipeClickZones ( ) GAMEMODE.ClickZones = {}; end
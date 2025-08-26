function GM:DrawDemo ( )
	
		if !self.WasJustRacing then
			self.SmoothCheckpoint = 0;
		end
		self.WasJustRacing = true;
		self.ShowSorryMessage = false;
		
		local MeterWidths = ScrW() / 5;
		local TurboHeight = MeterWidths / 20;
		local TurboWidth = (ScrW() - StartX - 8 - MeterWidths) - (StartX + 8 + MeterWidths)
		
		surface.SetDrawColor(0, 0, 0, 100);
		surface.DrawRect(StartX + 8 + MeterWidths, StartY - TurboHeight, TurboWidth, TurboHeight);
		surface.SetDrawColor(255, 255, 255, 150);
		surface.DrawRect(StartX + 8 + MeterWidths + 1, StartY - TurboHeight + 1, TurboWidth - 2, TurboHeight - 2);
		
		local JeepData = LocalPlayer():CompileJeepData();
		local NumSecondsNeedDuration = TurboWidth / JeepData.BoostDuration;
		local NumSecondsNeedCooldown = TurboWidth / JeepData.BoostDelay;
		
		surface.SetDrawColor(0, 0, 255, 150);
		if GAMEMODE.LastNOSTime + JeepData.BoostDuration >= CurTime() then
			surface.DrawRect(StartX + 8 + MeterWidths + 1, StartY - TurboHeight + 1, (CurTime() - GAMEMODE.LastNOSTime) * NumSecondsNeedDuration, TurboHeight - 2);
		elseif GAMEMODE.LastNOSTime + JeepData.BoostDuration + JeepData.BoostDelay >= CurTime() then
			surface.DrawRect(StartX + 8 + MeterWidths + 1, StartY - TurboHeight + 1, TurboWidth - ((CurTime() - GAMEMODE.LastNOSTime - JeepData.BoostDuration) * NumSecondsNeedCooldown), TurboHeight - 2);
		end
		
		surface.SetTexture(self.SpeedometerMat);
		surface.SetDrawColor(255, 255, 255, 150);
		surface.DrawTexturedRect(StartX + 8, StartY - MeterWidths * .5, MeterWidths, MeterWidths * .5);
		
		local Speed = math.Round((LocalPlayer():GetVehicle():GetVelocity():Length() / 17.6) * 10) / 10
		
		local DegPerSpeed = 180 / 120
		
		surface.SetTexture(self.NeedleMat);
		surface.SetDrawColor(255, 0, 0, 200);
		surface.DrawTexturedRectRotated(StartX + MeterWidths * .5 + 8, StartY, MeterWidths, MeterWidths, 90 - (Speed * DegPerSpeed));
		
		
		surface.SetTexture(self.ThermometerMat);
		surface.SetDrawColor(255, 255, 255, 150);
		surface.DrawTexturedRect(ScrW() - StartX - 8 - MeterWidths, StartY - MeterWidths * .5, MeterWidths, MeterWidths * .5);
		
		local MaxHealth = GAMEMODE.DefaultStats.Health;
		
		for k, v in pairs(GAMEMODE.PartsTable) do
			if v[LocalPlayer():GetUsedPart(k)] then
				local Table = v[LocalPlayer():GetUsedPart(k)];
				MaxHealth = MaxHealth + Table.AddedHealth;
			end
		end
		
		local DegPerHealth = 180 / MaxHealth;
		
		surface.SetTexture(self.NeedleMat);
		surface.SetDrawColor(255, 0, 0, 200);
		surface.DrawTexturedRectRotated(ScrW() - StartX - MeterWidths * .5 - 8, StartY, MeterWidths, MeterWidths, -90 + (LocalPlayer():Health() * DegPerHealth));
		
		NumAlive = 0;
			
		for k, v in pairs(player.GetAll()) do
			if v:IsRacing() then
				NumAlive = NumAlive + 1;
			end
		end
			
		SpacePerCheckpoint = SpaceLeft / GetGlobalInt("NumberOfRacers");
		RealCheckpoints = SpacePerCheckpoint * NumAlive;

		local Add = (SpacePerCheckpoint / 25)
		if self.SmoothCheckpoint < RealCheckpoints then
			if self.SmoothCheckpoint + Add >  RealCheckpoints then
				self.SmoothCheckpoint = RealCheckpoints;
			else
				self.SmoothCheckpoint = self.SmoothCheckpoint + Add;
			end
		elseif self.SmoothCheckpoint > RealCheckpoints then
			if self.SmoothCheckpoint - Add <  RealCheckpoints then
				self.SmoothCheckpoint = RealCheckpoints;
			else
				self.SmoothCheckpoint = self.SmoothCheckpoint - Add;
			end
		end
		
		draw.RoundedBox(8, StartX - BlackBorder, StartY - BlackBorder, SpaceLeft + (BlackBorder * 2), BarHeight + (BlackBorder * 2), Color(0, 0, 0, 175));
		draw.RoundedBox(8, StartX, StartY, SpaceLeft, BarHeight, Color(255, 255, 255, 225));
		

		draw.RoundedBox(8, StartX, StartY, self.SmoothCheckpoint, BarHeight, Color(255, 100, 100, 150));
		draw.SimpleText(NumAlive .. " / " .. GetGlobalInt("NumberOfRacers") .. " Racers Left", "LCD_Large", StartX + (SpaceLeft * .5), StartY + (BarHeight * .5), BrightRedColor, 1, 1);
		
		local Time;
		Time = self.RaceTimeLimit;
		if CurTime() - self.RaceStartTime >= 0 then
			Time = self.RaceTimeLimit - (CurTime() - self.RaceStartTime);
		end
				
		draw.SimpleText(string.ToMinutesSecondsMilliseconds(Time), "LCD_ExtraLarge", DrawBorder, 0, BrightRedColor, 0, 0);
		
		draw.SimpleText("Kills: " .. LocalPlayer():GetNetworkedInt("RoundKills"), "LCD_ExtraLarge", ScrW() - DrawBorder, 0, BrightRedColor, 2, 0);

end

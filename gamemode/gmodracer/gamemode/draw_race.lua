function GM:DrawRace ( )
	
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
		
		
			SpacePerCheckpoint = SpaceLeft / (GetGlobalInt("TotalNumberCheckpoints") - 1);
			RealCheckpoints = SpacePerCheckpoint * LocalPlayer():GetNetworkedInt("CurrentCheckpoint");


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
		
			if self.SmoothCheckpoint > 0 then
				draw.RoundedBox(8, StartX, StartY, self.SmoothCheckpoint, BarHeight, Color(100, 100, 255, 150));
			end
			draw.SimpleText(LocalPlayer():GetNetworkedInt("CurrentCheckpoint") .. " / " .. GetGlobalInt("TotalNumberCheckpoints") .. " Checkpoints", "LCD_Large", StartX + (SpaceLeft * .5), StartY + (BarHeight * .5), BrightRedColor, 1, 1);
		
		local Time;
		Time = 0;
		if CurTime() - self.RaceStartTime >= 0 then
			Time = CurTime() - self.RaceStartTime;
		end

				
		draw.SimpleText(string.ToMinutesSecondsMilliseconds(Time), "LCD_ExtraLarge", DrawBorder, 0, BrightRedColor, 0, 0);
		
			local PlayersInFront = 1;
			for k, v in pairs(player.GetAll()) do
				if v:GetNetworkedBool("IsCurrentlyRacing") and !v:GetNetworkedBool("IsDestroyed") then
					if (v:GetNetworkedInt("CurrentCheckpoint") > LocalPlayer():GetNetworkedInt("CurrentCheckpoint")) or (v:GetNetworkedInt("CurrentCheckpoint") == LocalPlayer():GetNetworkedInt("CurrentCheckpoint") and v:GetNetworkedInt("CrossTime") < LocalPlayer():GetNetworkedInt("CrossTime")) then
						PlayersInFront = PlayersInFront + 1;
					end
				end
			end
			
			draw.SimpleText(PlayersInFront .. " / " .. GetGlobalInt("NumberOfRacers"), "LCD_ExtraLarge", ScrW() - DrawBorder, 0, BrightRedColor, 2, 0);

			if self.WrongWayCheckpoint != LocalPlayer():GetNetworkedInt("CurrentCheckpoint") then
				self.ShowWrongWay = false;
			else			
				local size = ScrW() / 4;
				local x = (ScrW() * .5) - (size * .5);
				local y = (ScrH() * .5) - (size * .5);
				local var = 20;
				
				surface.SetDrawColor(255, 255, 255, 255);
				surface.SetTexture(self.WrongWayText);
				surface.DrawTexturedRect(x + math.random(-var, var), y + math.random(-var, var), size, size);
			end
end

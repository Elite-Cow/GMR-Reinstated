function GM.StartRace ( )
	RunConsoleCommand("phys_timescale",1)
	for k, v in pairs(player.GetAll()) do
		umsg.Start("SetStartTime", v); umsg.End();
		if v:GetNetworkedBool("IsCurrentlyRacing") then
			if GAMEMODE.PlayerVehicles[v] and GAMEMODE.PlayerVehicles[v]:IsValid() then
				local phys = GAMEMODE.PlayerVehicles[v]:GetPhysicsObject()
				if phys and phys:IsValid() then
					-- Unfreeze the vehicle and enable motion
					GAMEMODE.PlayerVehicles[v]:Freeze(false)
					phys:EnableMotion(true)
					phys:Wake()
					--GAMEMODE.PlayerVehicles[v]:SetKeyValue("BaseVehicle", "TurnOn")
				end
			end
		end
	end
	GAMEMODE.RaceStartTime = CurTime();
end

function GM.LoadMapMenu ( )
	SetGlobalInt("MapsVotingOn_Num", math.Clamp(table.Count(GAMEMODE.Maps), 1, 4));
	
			for i = 1, math.Clamp(table.Count(GAMEMODE.Maps), 1, 4) do
				local Continue = true;
				
				while Continue do
					local RandNum = 1;
					if table.Count(GAMEMODE.Maps) > 1 then
						RandNum = math.random(1, table.Count(GAMEMODE.Maps));
					end
					local TestMap = GAMEMODE.Maps[RandNum];
					
					local AllUsed = true;
					for k, v in pairs(GAMEMODE.Maps) do
						if !v.Used then
							AllUsed = false;
						end
					end
					
					if AllUsed then
						Continue = false;
					else
						if TestMap and !TestMap.Used then
							if table.Count(GAMEMODE.Maps) < 5 or TestMap.MapPath != game.GetMap() then
								TestMap.Used = true;
								SetGlobalInt("MapsVotingOn_" .. i, RandNum);
								SetGlobalInt("MapsVotingOn_TimesPlayed_" .. i, TestMap.TimesPlayed);
								
								local Record_Name, Record_Time = GAMEMODE.RetrieveOffMapRecord(1, TestMap.MapPath);
								
								SetGlobalString("MapsVotingOn_Record_Name_" .. i, Record_Name);
								SetGlobalInt("MapsVotingOn_Record_Time_" .. i, Record_Time);
								
								Continue = false;
							end
						end
					end
				end
			end
end
timer.Simple(5, GM.LoadMapMenu);

function GM.FinishRace ( )

	if GAMEMODE.NumberPeopleFinished == GAMEMODE.NumRacers and !GAMEMODE.ChangingMaps then
		GAMEMODE.NumRacesRan = GAMEMODE.NumRacesRan + 1;
		
		if GAMEMODE.NumRacesRan >= GAMEMODE.MaxRaces and !GAMEMODE.ChangingMaps then
			GAMEMODE.EnableAutoKick = false;
			SetGlobalBool("VotingForMap", true);
			GAMEMODE.VotesReceived = 0
			GAMEMODE.ChangingMaps = true;
			
			local SendTime = 0;
			for k, v in pairs(player.GetAll()) do
			/*
				SendTime = SendTime + .1
				for i = 1, math.Clamp(table.Count(GAMEMODE.Maps), 1, 4) do
					local TestMap = GAMEMODE.Maps[GetGlobalInt("MapsVotingOn_" .. i)];
					
					timer.Simple(SendTime, function ( )
												umsg.Start("YourMapRecord", v);
													umsg.Short(i);
													umsg.Long(tonumber(v:GetPData("MapRecord_" .. TestMap.MapPath, "0")));
												umsg.End();
											end
					);
				end
			*/
			
				if GAMEMODE.PlayerTables[v].InMenu then
					GAMEMODE:ShowHelp(v)
				elseif GAMEMODE.PlayerTables[v].InGarage then
					GAMEMODE:ShowTeam(v)
				end
				
				v:Freeze(true);
				v:SendLua("surface.PlaySound(Sound('music/HL1_song25_REMIX3.mp3')); SetGlobalBool('VotingForMap', true)");
			end
			
			timer.Simple(30, GAMEMODE.PrepareChangeMap);
			return true;
		elseif !GAMEMODE.ChangingMaps then
			GAMEMODE.NextRace = CurTime() + GAMEMODE.DelayBetweenRaces;
			SetGlobalInt("NextRaceStart", GAMEMODE.DelayBetweenRaces);
			SetGlobalBool("CurrentlyRacing", false);
			return false;
		end
	else
		return false;
	end
end

function GM:Think ( )
	--for _,e in pairs(player.GetHumans()) do
		--self:ShowSpare1(e);
	--end

	if GetGlobalBool("CurrentlyRacing") then
		local AnyRacing = false;
		for k, v in pairs(player.GetAll()) do
			if v:IsRacing() then
				AnyRacing = true;
			end
		end	
		
		if !AnyRacing then
			self.NumberPeopleFinished = self.NumRacers;
			self.FinishRace();
		end
	end

		for k, v in pairs(player.GetAll()) do
		
			if v:IsRacing() and !v:InVehicle() then
				if GAMEMODE.PlayerVehicles[v] and GAMEMODE.PlayerVehicles[v]:IsValid() and GAMEMODE.PlayerVehicles[v]:IsVehicle() then
					v:EnterVehicle(GAMEMODE.PlayerVehicles[v]);
				end
				
				v:Kill();
			end
			
			if v and v:IsValid() and v:IsPlayer() and v:InVehicle() and v:GetVehicle() and v:GetVehicle():IsValid() and v:GetVehicle():IsVehicle() then
				self.PlayerTables[v].LastAngle = self.PlayerTables[v].LastAngle or v:GetAngles();
				self.PlayerTables[v].LastPos = self.PlayerTables[v].LastPos or v:GetPos();
				self.PlayerTables[v].Countdown = self.PlayerTables[v].Countdown or 0;
				
				if self.PlayerTables[v].LastPos == v:GetPos() and self.PlayerTables[v].LastAngle == v:GetAngles() then
					if self.PlayerTables[v].Countdown == 500 then
						v:Kill();
					else
						self.PlayerTables[v].Countdown = self.PlayerTables[v].Countdown + 1;
					end
				else
					self.PlayerTables[v].Countdown = 0;
				end
				
				self.PlayerTables[v].LastAngle = v:GetAngles();
				self.PlayerTables[v].LastPos = v:GetPos();
			
				if self.PlayerTables[v].GoingWrongWay then
					self.PlayerTables[v].LastWWDamage = self.PlayerTables[v].LastWWDamage or 0;
					
					if self.PlayerTables[v].LastWWDamage + 1 < CurTime() then
						self.PlayerTables[v].LastWWDamage = CurTime();
						v:GiveDamage(1, v);
					end
				end
			
				local Vehicle = v:GetVehicle();
				local Speed = math.Round((Vehicle:GetVelocity():Length() / 17.6) * 10) / 10
				local JeepData = v:CompileJeepData();
				
				if v:GetUsedPart("Spoiler") == 1 then
					local Trace = {};
					Trace.start = Vehicle:GetPos();
					Trace.endpos = Vehicle:GetPos() + (Vector(0, 0, -1) * 5000);
					Trace.filter = {v, Vehicle};
					local TraceEnd = util.TraceLine(Trace);
					
					if TraceEnd.HitPos:Distance(Vehicle:GetPos()) < 5 then
						Vehicle:GetPhysicsObject():ApplyForceCenter(Vector(0, 0, -200) * Speed);
					end
				end
				
				if self.PlayerTables[v].LastNOSTime + JeepData.BoostDuration > CurTime() then					
					local Trace = {};
					Trace.start = Vehicle:GetPos();
					Trace.endpos = Vehicle:GetPos() + (Vector(0, 0, -1) * 100000);
					Trace.filter = {v, Vehicle};
					
					if Vehicle.Children then
						for k, v in pairs(Vehicle.Children) do
							table.insert(Trace.filter, v);
						end
					end
					
					local TraceEnd = util.TraceLine(Trace);
					
					if TraceEnd.HitPos:Distance(Vehicle:GetPos()) < 5 then
						Vehicle:GetPhysicsObject():ApplyForceCenter(Vector(0, 0, -200) * Speed);
					end
				end
							
				local Trace = {};
				Trace.start = Vehicle:GetPos() + Vector(0, 0, 10);
				Trace.endpos = Trace.start + Vector(0, 0, 10) + (Vehicle:GetForward() * 5);
				Trace.filter = {v, Vehicle};
				
				for p, l in pairs(Vehicle.Children) do
					table.insert(Trace.filter, l);
				end
				
				local TraceRes = util.TraceEntity(Trace, Vehicle);
				
				OurMaxArmor = GAMEMODE.DefaultStats.Armor;
						
				for q, w in pairs(GAMEMODE.PartsTable) do
					if w[v:GetUsedPart(q)] then
						local Table = w[v:GetUsedPart(q)];
						OurMaxArmor = OurMaxArmor + Table.AddedArmor;
					end
				end
				
				if !Vehicle.LastSpeed then Vehicle.LastSpeed = 0; end
				if TraceRes.Hit then
					
					local JeepData = v:CompileJeepData();
					
					if Vehicle.LastSpeed > 30 and Vehicle.LastSpeed - (JeepData.ForwardMaximumMPH / 3) > Speed then
						local NumPlayers = 0;
						for k, pl in pairs(ents.FindInSphere(Trace.endpos, 200)) do
							if pl and pl:IsValid() and pl:IsPlayer() and pl != v then
								NumPlayers = NumPlayers + 1;
							end
						end
						
						if NumPlayers == 0 then
							local SpeedDif = Vehicle.LastSpeed - Speed;
			
							local DmgToTake = (Speed * 2) / (OurMaxArmor + 1);
							
							v:GiveDamage(DmgToTake, v);
						end
					end
				
					
					for k, pl in pairs(ents.FindInSphere(Trace.endpos, 200)) do
						if pl:IsPlayer() and pl != v and pl:InVehicle() then
							GAMEMODE.LastHits[pl:UniqueID() .. "-" .. v:UniqueID()] = GAMEMODE.LastHits[pl:UniqueID() .. "-" .. v:UniqueID()] or 0;
							if GAMEMODE.LastHits[pl:UniqueID() .. "-" .. v:UniqueID()] + 5 < CurTime() then
								local TheirSpeed = math.Round((pl:GetVehicle():GetVelocity():Length() / 17.6) * 10) / 10;
								local SpeedDifference = math.abs(TheirSpeed - Speed);
								
								if SpeedDifference > 30 then
									local MaxArmor = GAMEMODE.DefaultStats.Armor;
										
									for q, w in pairs(GAMEMODE.PartsTable) do
										if w[pl:GetUsedPart(q)] then
											local Table = w[pl:GetUsedPart(q)];
											MaxArmor = MaxArmor + Table.AddedArmor;
										end
									end
									
									GAMEMODE.LastHits[pl:UniqueID() .. "-" .. v:UniqueID()] = CurTime();
										
									local DmgToTake_Us = (SpeedDifference * .5) / (OurMaxArmor + 1);
									local DmgToTake_Them = (SpeedDifference * .75) / (MaxArmor + 1);
									
									if v:GetUsedPart("Forward Spikes") == 1 then
										DmgToTake_Them = DmgToTake_Them + (DmgToTake_Them * .15);
									elseif v:GetUsedPart("Forward Spikes") == 2 then
										DmgToTake_Them = DmgToTake_Them + (DmgToTake_Them * .25);
									end
									
									if pl:GetUsedPart("Rear Spikes") == 1 then
										DmgToTake_Us = DmgToTake_Us + (DmgToTake_Us * .25);
									elseif pl:GetUsedPart("Rear Spikes") == 2 then
										DmgToTake_Us = DmgToTake_Us + (DmgToTake_Us * .35);
									end
										
									pl:GiveDamage(DmgToTake_Them, v);
									v:GiveDamage(DmgToTake_Us, pl);
								end
								
							end
						end	
					end
				end
				
				if self.PlayerVehicles[v] then
					self.PlayerVehicles[v].LastSpeed = Speed;
				end
			end
		end
		

	if GetGlobalBool("CurrentlyRacing") and GAMEMODE.RaceStartTime + GAMEMODE.RaceTimeLimit <= CurTime() and !GAMEMODE.ChangingMaps then
		GAMEMODE.DontGiveCash = true;
		for k, v in pairs(player.GetAll()) do
			if v:IsRacing() then
				v:Kill();
				self.FinishRace();
			end
		end
		GAMEMODE.DontGiveCash = false;
	elseif GetGlobalInt("NextRaceStart") <= 0 and !GetGlobalBool("CurrentlyRacing") and !GAMEMODE.ChangingMaps then
		if table.Count(self.QueuedPlayers) != 0 then
			SetGlobalBool("CurrentlyRacing", true);

			local OldQueuedPlayers = self.QueuedPlayers;
			self.QueuedPlayers = {};
			self.NumRacers = 0;
			for k, v in pairs(player.GetAll()) do
				v:SetNetworkedBool("IsCurrentlyRacing", false);
			end
			
			local Angles2;
			if self.Checkpoints[2] then
				Angles2 = (self.Checkpoints[2]:OBBCenter() - self.Checkpoints[1]:OBBCenter()):Angle();
				Angles2:RotateAroundAxis(Angles2:Up(), -90)
			end
			
			self.SpawningRace = true;
			for k, v in pairs(OldQueuedPlayers) do
				if self.NumRacers >= self.MaxRacers or !v or !v:IsValid() or !v:Alive() then
					if v and v:IsValid() then
						umsg.Start("SorryMessage", v); umsg.End();
						table.insert(self.QueuedPlayers, v);
					end
				else
					if self.PlayerTables[v].InMenu then
						self:ShowHelp(v)
					elseif self.PlayerTables[v].InGarage then
						self:ShowTeam(v)
					end
					
					local DoAng;
					if !Angles2 then
						DoAng = Angle(0, math.random(360), 0);
					else
						DoAng = Angles2;
					end
					
					v:SetNetworkedInt("RaceTime", 0);
					self.NumRacers = self.NumRacers + 1;
					v:SetNetworkedBool("IsCurrentlyRacing", true);
					v:SetNetworkedInt("RoundKills", 0)
					v:SetNetworkedInt("CurrentCheckpoint", 0);
					
					self.PlayerDamageTables[v] = {};
					
					v:SetNetworkedBool("IsQueued", false);
					//umsg.Start("IsQueued", v); umsg.Bool(false); umsg.End();
					umsg.Start("StartCountdown", v); umsg.End();
					v:SetNetworkedBool("IsDestroyed", false);

					v:SpawnJeep(self.VehicleSpawnPoints[self.NumRacers]:GetPos(), DoAng);
					RunConsoleCommand("phys_timescale",0)
					--self.PlayerVehicles[v]:Freeze(false) -- MOVETYPE_VPHYSICS 
					--self.PlayerVehicles[v]:GetPhysicsObjectNum(0):EnableMotion(false);
					--self.PlayerVehicles[v]:SetKeyValue("BaseVehicle", "TurnOff")
				end
			end
			timer.Simple(5, function ( ) self.SpawningRace = false; end);
			
			self.RaceStartTime = CurTime() + 3;
			timer.Simple(3, self.StartRace);
			SetGlobalString("NumberOfRacers", self.NumRacers); 
			SetGlobalInt("TotalNumberCheckpoints", self.NumCheckPoints);
			self.NumberPeopleFinished = 0;
			self.NumberPeopleDestroyed = 0;
			
			for k, v in pairs(self.Debris) do
				if v and v:IsValid() then
					v:Remove()
				end
			end
			
			self.Debris = {};
		else
			self.NextRace = CurTime() + self.DelayBetweenRaces;
			SetGlobalInt("NextRaceStart", self.DelayBetweenRaces);
		end
	elseif GetGlobalInt("NextRaceStart") != 0 and !GAMEMODE.ChangingMaps then
		if GetGlobalInt("NextRaceStart") != math.Round(self.NextRace - CurTime()) then
			SetGlobalInt("NextRaceStart", math.Round(self.NextRace - CurTime()));
		end
	end
end

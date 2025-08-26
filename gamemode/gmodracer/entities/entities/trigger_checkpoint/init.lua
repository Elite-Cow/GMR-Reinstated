ENT.Base = "base_brush"
ENT.Type = "brush"

function ENT:Initialize()
	self.ID = self.ID or 1;
	GAMEMODE.Checkpoints[self.ID] = self;
end

function ENT:StartTouch( Ent )
	if !Ent:IsValid() or !Ent:IsPlayer() then return false; end
	if !Ent:GetNetworkedBool("IsCurrentlyRacing") or GetGlobalInt("TotalNumberCheckpoints") == Ent:GetNetworkedInt("CurrentCheckpoint") or !Ent:InVehicle() then return end
	if !Ent:IsRacing() then return false; end
	
	if self.ID == Ent:GetNetworkedInt("CurrentCheckpoint") + 1 then
		GAMEMODE.PlayerTables[Ent].GoingWrongWay = false;
		
		if self.ID == GetGlobalInt("TotalNumberCheckpoints") then
			if game.GetMap() == "gmr_black" then
				--PEAchievements.Update(Ent, "GMod Racer: Black Worshiper", 1);
			end
			
			Ent:SetNetworkedInt("RaceTime", CurTime() - GAMEMODE.RaceStartTime);
			
			GAMEMODE.NumberPeopleFinished = GAMEMODE.NumberPeopleFinished + 1;
			local NumFinish = GAMEMODE.NumberPeopleFinished - GAMEMODE.NumberPeopleDestroyed;
			
			if NumFinish == 1 then
				if Ent:GetPData("gmr_wins") then
					Ent:SetPData("gmr_wins", Ent:GetPData("gmr_wins")+1)
				else
					Ent:SetPData("gmr_wins", 1)
				end
			end
			
			local CashToGrant = (GAMEMODE.NumRacers - NumFinish) * GAMEMODE.PerCash;
			
			
			Ent:PrintMessage(HUD_PRINTTALK, "You earned $" .. tostring(CashToGrant) .. " for coming in " .. tostring(GAMEMODE.PlaceNames[NumFinish]) .. " place!");
			
			if Ent:Team() < 4 then
				local Extra = math.Round(CashToGrant / 4)
				CashToGrant = CashToGrant + Extra;
				Ent:PrintMessage(HUD_PRINTTALK, "You earned $" .. Extra .. " ( 25% ) bonus cash for being an Admin!");
			elseif Ent:Team() < 5 then
				local Extra = math.Round(CashToGrant / 4)
				CashToGrant = CashToGrant + Extra;
				Ent:PrintMessage(HUD_PRINTTALK, "You earned $" .. Extra .. " ( 25% ) bonus cash for being a VIP member!");
			end
			
			Ent:AddCash(CashToGrant);
			
			
			
			local function KillPart ( v )
				if v and v:IsValid() then
					v:Remove();
				end
			end
			
			local Time = 0;
			for k, v in pairs(GAMEMODE.PlayerVehicles[Ent].Children) do
				if v and v:IsValid() then
					timer.Simple(Time, function() KillPart(v) end );
					Time = Time + .5;
				end
			end
			timer.Simple(Time, function ( ) if GAMEMODE.PlayerVehicles[Ent] and GAMEMODE.PlayerVehicles[Ent]:IsValid() then GAMEMODE.PlayerVehicles[Ent]:Remove(); end end);
			Ent:KillSilent();
			
			if Ent:GetNetworkedInt("RaceTime") < Ent:GetNetworkedInt("MapRecord") then
				Ent:PrintMessage(HUD_PRINTTALK, "New Personal Record!");
				
				Ent:SetNetworkedInt("MapRecord", Ent:GetNetworkedInt("RaceTime"));
				
				sql.Query("UPDATE `gmr_records` SET `Time`='" .. Ent:GetNetworkedInt("RaceTime") .. "' WHERE `SteamID`='" .. Ent:SteamID() .. "' AND `Map`='" .. game.GetMap() .. "'");
				
				local Return, Success, Error = sql.Query("SELECT * FROM `gmr_records` WHERE `Map`='" .. game.GetMap() .. "' ORDER BY `Time` ASC LIMIT 10");
				
				local TempCompareTop10 = '';
				for k, v in pairs(Return) do
					TempCompareTop10 = TempCompareTop10 .. v['Time'];
				end
								
				if TempCompareTop10 != GAMEMODE.CompareTop10 then
					local OurPlace = 32;
					GAMEMODE.CompareTop10 = '';
					for i, v in pairs(Return) do
						GAMEMODE.CompareTop10 = GAMEMODE.CompareTop10 .. v['Time'];
						
						if v['SteamID'] == Ent:SteamID() then
							OurPlace = tonumber(i);
						end
						
						
						SetGlobalString("MapRecords_" .. i .. "_Name", v['Name']);
						SetGlobalInt("MapRecords_" .. i .. "_Time", v['Time']);
					end
										
					if OurPlace != 32 then
						PEA_GMR_RecordBreaker(Ent);
						
						umsg.Start('NewRecord');
							umsg.String(Ent:Name());
							umsg.Short(math.floor(Ent:GetNetworkedInt("RaceTime")));
							umsg.String(GAMEMODE.PlaceNames[OurPlace]);
							umsg.Short(OurPlace);
						umsg.End();
					
						GAMEMODE.IsNewRecord = true;
						timer.Simple(GAMEMODE.NewRecordTime + 1, function ( ) GAMEMODE.IsNewRecord = false; end);
					end
				end
				
			end

			local FinishedMap = GAMEMODE.FinishRace();
			
			if Ent:GetUsedPart("Radio") == 1 and !GAMEMODE.IsNewRecord then
				Ent:ConCommand("stopsounds");
			end
							
		end
		Ent:SetNetworkedInt("CrossTime", CurTime());
		Ent:SetNetworkedInt("CurrentCheckpoint", self.ID);
		GAMEMODE.PlayerTables[Ent].GoingWrongWay = false;
	elseif self.ID == Ent:GetNetworkedInt("CurrentCheckpoint") then
		umsg.Start("WrongWay", Ent); umsg.End();
		GAMEMODE.PlayerTables[Ent].GoingWrongWay = true;
	end
end

function ENT:KeyValue ( Key, Value )
	local LoweredKey = string.lower(Key);

	if LoweredKey == "number" then
		self.ID = tonumber(Value);

		GAMEMODE:UpdateNumCheckpoints(self.ID);
	end
end

function ENT:EndTouch( Ent ) end
function ENT:Touch( Ent ) end
function ENT:PassesTriggerFilters( Ent ) return Ent:IsPlayer() end
function ENT:Think() end
function ENT:OnRemove() end

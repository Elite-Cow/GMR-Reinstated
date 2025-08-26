function GM:UpdateNumCheckpoints ( NewNum )
	if NewNum <= self.NumCheckPoints then return false; end

	self.NumCheckPoints = NewNum;
end

function GM.RecieveBuyOrder ( Player, Command, Args )
	local Part = Args[1];
	local CurrentlyUsedPart = Player:GetUsedPart(Part);
	local WantedPart = CurrentlyUsedPart + 1;
	
	if !GAMEMODE.PartsTable[Part][WantedPart] then
		Player:SetUsedPart(Part, CurrentlyUsedPart);
		return false;
	end
	
	if GAMEMODE.PartsTable[Part][WantedPart].RequiresAccess < Player:Team() then
		Player:SetUsedPart(Part, CurrentlyUsedPart);
		return false;
	end
	
	if Player:GetCash() >= GAMEMODE.PartsTable[Part][WantedPart].Cost then
		Player:AddCash(GAMEMODE.PartsTable[Part][WantedPart].Cost * -1);
		Player:SetUsedPart(Part, WantedPart);
	else
		Player:SetUsedPart(Part, CurrentlyUsedPart);
	end
end
concommand.Add("GMRacer_BuyPart", GM.RecieveBuyOrder);

function GM.RecieveSellOrder ( Player, Command, Args )
	local Part = Args[1];
	local CurrentlyUsedPart = tonumber(Player:GetUsedPart(Part));
	local WantedPart = CurrentlyUsedPart - 1;
	
	if !GAMEMODE.PartsTable[Part][WantedPart] and WantedPart != 0 then return false; end
	Player:AddCash(GAMEMODE.PartsTable[Part][CurrentlyUsedPart].Cost * .5);
	Player:SetUsedPart(Part, WantedPart);
end
concommand.Add("GMRacer_SellPart", GM.RecieveSellOrder);

function GM.ReceiveToggleLights ( Player, Command, Args )
	Player:SetNetworkedBool("LightsOn", !Player:GetNetworkedBool("LightsOn"));
end
concommand.Add("GMRacer_ToggleLights", GM.ReceiveToggleLights);


function GM:AddMap ( MapName, MapAuthor, MapPath, MapDescription )
	local NewTable = {}
	NewTable.MapName = MapName;
	NewTable.MapAuthor = MapAuthor;
	NewTable.MapPath = MapPath;
	NewTable.MapDescription = MapDescription;
	
	if CLIENT then
		NewTable.Texture = surface.GetTextureID("maps/" .. MapPath);
	else
		NewTable.Used = false;
		NewTable.Votes = 0;
		
		if file.Exists(MapPath .. ".txt", "gmracer/times_played/") then
			NewTable.TimesPlayed = file.Read("gmracer/times_played/" .. MapPath .. ".txt");
		else
			NewTable.TimesPlayed = 0;
		end
	end
	
	table.insert(self.Maps, NewTable);
end

GM:AddMap("Desert Circuit", "Primus8", "gmr_desertcircuit_v2", "A quick race through the desert at night.");
GM:AddMap("Hunt's Circuit", "Primus8", "gmr_huntscircuit", "A hilly race around a sunken center.");
GM:AddMap("Triple-Decker", "GMod4Ever", "gmr_tripledecker_v2", "A triple-deck race track.");
GM:AddMap("Derby", "Scope", "gmr_derby_v2", "A nascar style race track.");
GM:AddMap("Panda Faggotry", "Primus8", "gmr_pandafaggot", "This map is cursed. 6.66 MB exactly.");
GM:AddMap("Circuit 69", "{RS} Malcom", "gmr_circuit69_v2", "A long track with many obstacles. Kinky? Defninately.");
GM:AddMap("Figure 8", "Xeno", "gmr_figure8_v3", "A track in the shape of an 8 with tunnels and hills.");
//GM:AddMap("Drag", "BaraSpitFire", "gmr_drag", "A long straightaway to test your car's brute force.");
GM:AddMap("Optio", "Mal", "gmr_optio_v1", "Twin parallel figure 8 tracks.");
GM:AddMap("Wario Stadium", "Testament-Doom", "gmr_wariostadium", "Known from Mario Cart.");
// GM:AddMap("Tunnel of Death", "Kreuzer", "gmr_tunnelofdeath", "A long straightaway through a tunnel.");
// GM:AddMap("Snowpack", "Deer Shark", "gmr_snowpack", "Based off of Triple-Decker.");
GM:AddMap("Black", "{RS} Malcom", "gmr_black", "I hope you have headlights.");
GM:AddMap("Flash", "StarChick971", "gmr_flash", "Caution: Slippery when wet.");
GM:AddMap("Spliter Crasher", "Neko_Baron", "gmr_spliter_crasher", "Choose your destiny.");
GM:AddMap("Ice Rink", "StarChick971", "gmr_icerink", "Choose your path, but make sure you grab the checkpoints!");
GM:AddMap("Bowser's Castle", "Testament-Doom", "gmr_bowserscastle_v2", "Watch out for the lava.");

if CLIENT then
	GM.ClickZonesSetup_Maps = false;
	GM.RespawnClickZones = false;
	GM.VotesReceived = 0;
	GM.MyMapRecords = {};
	
	function GM.ReceiveVotesReceived ( UMsg )
		GAMEMODE.VotesReceived = GAMEMODE.VotesReceived + 1;
	end
	usermessage.Hook("votes_received", GM.ReceiveVotesReceived);
	
	function GM.YourMapRecord ( UMsg )
		local MapNumber = UMsg:ReadShort(); local MapTime = UMsg:ReadLong();
		
		GAMEMODE.MyMapRecords[MapNumber] = MapTime;
	end
	usermessage.Hook("YourMapRecord", GM.YourMapRecord);
	
	function GM:DrawMapVoteMenu ( )
		surface.SetDrawColor(255, 255, 255, 255);
		surface.DrawRect(0, 0, ScrW(), ScrH());
		
		local DrawBorder = ScrH() / 30;
		
		local X = DrawBorder + BlackBorder
		local Y = X;
		local W = ScrW() - (DrawBorder * 2) - (BlackBorder * 2);
		local H = ScrH() - (DrawBorder * 3) - (BlackBorder * 4);
		
		local TopX = X;
		local TopY = Y;
		local TopW = W;
		local TopH = H * .7;
		
		local BottomY = TopH + TopY + DrawBorder + (BlackBorder * 2);
		local BottomX = X;
		local BottomH = H * .3;
		local BottomW = W;
		
		draw.RoundedBox(10, TopX - BlackBorder, TopY - BlackBorder, TopW + BlackBorder * 2, TopH + BlackBorder * 2, GreyColor);
		draw.RoundedBox(10, TopX, TopY, TopW, TopH, Color(255, 255, 255, 255));
		
		draw.RoundedBox(10, BottomX - BlackBorder, BottomY - BlackBorder, BottomW + BlackBorder * 2, BottomH + BlackBorder * 2, GreyColor);
		draw.RoundedBox(10, BottomX, BottomY, BottomW, BottomH, Color(255, 255, 255, 255));

		if GetGlobalInt("MapsVotingOn_Num") == 0 then
			draw.SimpleText("Loading...", "DermaDefaultBold", TopX + (TopW * .5), TopY + TopH * .5, GreyColor, 1, 1);
		else
			if !self.ClickZonesSetup_Maps then
				self.Voted = 0;
				self.ClickZones = {};
				self.SelectedOne = 0;
				gui.EnableScreenClicker(true);
				self.RespawnClickZones = true;
			end
			
			if GetGlobalInt("ChangingToIn") == 0 then
				draw.SimpleText("Vote for the Next Map - " .. GAMEMODE.VotesReceived .. " / " .. table.Count(player.GetAll()) .. " Votes Received", "DermaDefaultBold", TopX + (TopW * .5), TopY + SubtractHeader_Y / 2, GreyColor, 1, 1);
			else
				draw.SimpleText(GetGlobalString("ChangingTo") .. " Selected - Changing In " .. GetGlobalInt("ChangingToIn") .. " Seconds", "DermaDefaultBold", TopX + (TopW * .5), TopY + SubtractHeader_Y / 2, GreyColor, 1, 1);
			end
						
			local PictureHeights = BottomH - (BlackBorder * 4);
			local OccupiedSpace = GetGlobalInt("MapsVotingOn_Num") * PictureHeights;
			local PictureSpacing = (BottomW - OccupiedSpace) / (GetGlobalInt("MapsVotingOn_Num") + 1);
			
			if self.SelectedOne == 0 then
				draw.SimpleText("Select a Map to View More Information", "DermaLarge", TopX + (TopW * .5), TopY + TopH * .5, GreyColor, 1, 1);
			elseif self.Voted == 0 then
				draw.SimpleText("Click the highlighted box below again to vote for this map.", "DermaDefaultBold", TopX + (TopW * .5), TopY - SubtractHeader_Y / 2 + TopH, GreyColor, 1, 1);
			else
				local Number = GetGlobalInt("MapsVotingOn_" .. self.Voted);
				
				draw.SimpleText("You voted for " .. GAMEMODE.Maps[Number].MapName .. ".", "DermaDefaultBold", TopX + (TopW * .5), TopY - SubtractHeader_Y / 2 + TopH, GreyColor, 1, 1);
			end
			
			for i = 1, GetGlobalInt("MapsVotingOn_Num") do
				local Number = GetGlobalInt("MapsVotingOn_" .. i);
				
				local X, Y, W, H = BottomX + (PictureSpacing * i) + (PictureHeights * (i - 1)), BottomY + (BlackBorder * 2), PictureHeights, PictureHeights;
				
				draw.RoundedBox(6, X, Y, W, H, GreyColor);
				
				if self.Voted == i then
					self:RegisterClickZone(X + BlackBorder, Y + BlackBorder, W - BlackBorder * 2, H - BlackBorder * 2, GAMEMODE.SelectMapVote_Prelim, i)
					
					draw.RoundedBox(6, X + BlackBorder, Y + BlackBorder, W - BlackBorder * 2, H - BlackBorder * 2, Color(255, 100, 100, 100));
				elseif self.SelectedOne == i then
					if self.RespawnClickZones and self.Voted == 0 then
						self:RegisterClickZone(X + BlackBorder, Y + BlackBorder, W - BlackBorder * 2, H - BlackBorder * 2, GAMEMODE.SelectMapVote_Confirm, i)
					else
						self:RegisterClickZone(X + BlackBorder, Y + BlackBorder, W - BlackBorder * 2, H - BlackBorder * 2, GAMEMODE.SelectMapVote_Prelim, i)
					end
					
					draw.RoundedBox(6, X + BlackBorder, Y + BlackBorder, W - BlackBorder * 2, H - BlackBorder * 2, Color(100, 255, 100, 100));
				else
					if self.RespawnClickZones then
						self:RegisterClickZone(X + BlackBorder, Y + BlackBorder, W - BlackBorder * 2, H - BlackBorder * 2, GAMEMODE.SelectMapVote_Prelim, i)
					end
					
					draw.RoundedBox(6, X + BlackBorder, Y + BlackBorder, W - BlackBorder * 2, H - BlackBorder * 2, Color(255, 255, 255, 255));
				end
				
				if self.SelectedOne == i then
					draw.SimpleText(GAMEMODE.Maps[Number].MapName, "DermaLarge", TopX + (TopW * .5), TopY + SubtractHeader_Y + HeaderHeight * 3, GreyColor, 1, 1);
					
					local TextStart = TopY + SubtractHeader_Y + HeaderHeight * 3.5 + TextHeight * .5;
					draw.SimpleText("Created By " .. GAMEMODE.Maps[Number].MapAuthor, "DermaDefault", TopX + (TopW * .5), TextStart, TextColor, 1, 1);
					draw.SimpleText("\"" .. GAMEMODE.Maps[Number].MapDescription .. "\"", "DermaDefault", TopX + (TopW * .5), TextStart + TextHeight, TextColor, 1, 1);		

					if GetGlobalInt("MapsVotingOn_Record_Time_" .. i) == 0 then
						draw.SimpleText("Map Record: " .. GetGlobalString("MapsVotingOn_Record_Name_" .. i), "DermaDefault", TopX + (TopW * .5), TextStart + TextHeight * 2, TextColor, 1, 1);
					else
						local Time = GetGlobalInt("MapsVotingOn_Record_Time_" .. i);
						local Time = string.ToMinutesSecondsMilliseconds(Time);
					
						draw.SimpleText("Map Record: " .. Time .. " By " .. GetGlobalString("MapsVotingOn_Record_Name_" .. i), "DermaDefault", TopX + (TopW * .5), TextStart + TextHeight * 2, TextColor, 1, 1);
					end
					
					/*
					if GAMEMODE.MyMapRecords[i] == 0 then
						draw.SimpleText("Your Map Record: You Haven't Raced There Yet!", "DermaDefault", TopX + (TopW * .5), TextStart + TextHeight * 3, TextColor, 1, 1);
					else
						local Time = GAMEMODE.MyMapRecords[i];
						local Time = string.ToMinutesSecondsMilliseconds(Time);
					
						draw.SimpleText("Your Map Record: " .. Time, "DermaDefault", TopX + (TopW * .5), TextStart + TextHeight * 3, TextColor, 1, 1);
					end
					*/
					
					draw.SimpleText("Times Played: " .. GetGlobalString("MapsVotingOn_TimesPlayed_" .. i), "DermaDefault", TopX + (TopW * .5), TextStart + TextHeight * 3, TextColor, 1, 1);
				end

				local PictureHeight = (H - BlackBorder * 6) - TextHeight;
				
				if self.Maps[Number] and self.Maps[Number].Texture then
					surface.SetDrawColor(255, 255, 255, 255);
					surface.SetTexture(self.Maps[Number].Texture);
					surface.DrawTexturedRect(X + BlackBorder * 12, Y + BlackBorder * 6, PictureHeight, PictureHeight);
				end
				
				draw.SimpleText(self.Maps[Number].MapName, "DermaDefault", X + W * .5, Y + H - TextHeight * .5, TextColor, 1, 1);
			end
			
			if !self.ClickZonesSetup_Maps then self.ClickZonesSetup_Maps = true; end
		end
	end

	function GM.SelectMapVote_Prelim ( id ) 
		GAMEMODE.SelectedOne = id;
		GAMEMODE:WipeClickZones();
		GAMEMODE.RespawnClickZones = true;
	end

	function GM.SelectMapVote_Confirm ( id ) 
		if GAMEMODE.Voted != 0 then return false; end

		GAMEMODE.SelectedOne = id;
		GAMEMODE:WipeClickZones();
		GAMEMODE.RespawnClickZones = true;
		GAMEMODE.Voted = id;
		
		local Number = GetGlobalInt("MapsVotingOn_" .. id);
		RunConsoleCommand("gmr_vote", Number);
	end
else
	function GM.RecieveVotes ( Player, Command, Args )
		local MapID = math.Round(tonumber(Args[1]));
		
		GAMEMODE.Maps[MapID].Votes = GAMEMODE.Maps[MapID].Votes + 1;
		GAMEMODE.VotesReceived = GAMEMODE.VotesReceived + 1;
		
		umsg.Start("votes_received"); umsg.End();
		
		if GAMEMODE.VotesReceived == table.Count(player.GetAll()) then
			GAMEMODE.PrepareChangeMap();
		end
	end
	concommand.Add("gmr_vote", GM.RecieveVotes);
	
	function GM.PrepareChangeMap ( )
		if GetGlobalInt("ChangingToIn") != 0 then return false; end
	
		local HighestVotes = -1;
		local HighestMap;
		
		for k, v in pairs(GAMEMODE.Maps) do
			if v.Votes > HighestVotes then
				HighestVotes = v.Votes;
				HighestMap = v;
			end
		end
		
		SetGlobalString("ChangingTo", HighestMap.MapName);
		SetGlobalInt("ChangingToIn", 10);
		
		for i = 1, 9 do
			timer.Simple(i, function ( ) SetGlobalInt("ChangingToIn", GetGlobalInt("ChangingToIn") - 1) end);
		end
		timer.Simple(11, function() RunConsoleCommand("changelevel", HighestMap.MapPath) end );
	end
end

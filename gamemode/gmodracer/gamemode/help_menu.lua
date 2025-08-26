function GM:DrawHelpMenu ( )
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
	
	local BottomLeftY = TopH + TopY + DrawBorder + (BlackBorder * 2);
	local BottomLeftX = X;
	local BottomLeftH = H * .3;
	local BottomLeftW = (W - (BlackBorder * 2) - DrawBorder) * .5;
	
	local BottomRightY = TopH + TopY + DrawBorder + (BlackBorder * 2);
	local BottomRightX = BottomLeftX + BottomLeftW + (BlackBorder * 2) + DrawBorder;
	local BottomRightH = H * .3;
	local BottomRightW = (W - (BlackBorder * 2) - DrawBorder) * .5;
	
	draw.RoundedBox(10, TopX - BlackBorder, TopY - BlackBorder, TopW + BlackBorder * 2, TopH + BlackBorder * 2, GreyColor);
	draw.RoundedBox(10, TopX, TopY, TopW, TopH, Color(255, 255, 255, 255));
	
	draw.RoundedBox(10, BottomLeftX - BlackBorder, BottomLeftY - BlackBorder, BottomLeftW + BlackBorder * 2, BottomLeftH + BlackBorder * 2, GreyColor);
	draw.RoundedBox(10, BottomLeftX, BottomLeftY, BottomLeftW, BottomLeftH, Color(255, 255, 255, 255));
	
	draw.RoundedBox(10, BottomRightX - BlackBorder, BottomRightY - BlackBorder, BottomRightW + BlackBorder * 2, BottomRightH + BlackBorder * 2, GreyColor);
	draw.RoundedBox(10, BottomRightX, BottomRightY, BottomRightW, BottomRightH, Color(255, 255, 255, 255));
	
	draw.SimpleText("Miscellaneous Information", "DermaDefaultBold", TopX + (TopW * .5), TopY + SubtractHeader_Y / 2, GreyColor, 1, 1);
	
	draw.SimpleText("Gamemode Binds", "DermaDefaultBold", TopX + 5, TopY + SubtractHeader_Y * 1.5, GreyColor, 0, 1);
	draw.SimpleText("F1 - Opens this help menu.", "DermaDefault", TopX + 5, TopY + SubtractHeader_Y * 1.5 + TextHeight, GreyColor, 0, 1);
	draw.SimpleText("F2 - Opens the vehicle upgrade menu.", "DermaDefault", TopX + 5, TopY + SubtractHeader_Y * 1.5 + TextHeight * 2, GreyColor, 0, 1);
	draw.SimpleText("F3 - Queues you into the next race / spawns your vehicle for testing.", "DermaDefault", TopX + 5, TopY + SubtractHeader_Y * 1.5 + TextHeight * 3, GreyColor, 0, 1);
	draw.SimpleText("F4 - Opens the achievement menu.", "DermaDefault", TopX + 5, TopY + SubtractHeader_Y * 1.5 + TextHeight * 4, GreyColor, 0, 1);
	
	draw.SimpleText("Gamemode Information", "DermaDefaultBold", TopX + TopW - 5, TopY + SubtractHeader_Y * 1.5, GreyColor, 2, 1);
	draw.SimpleText("The goal is to win races by destroying your enemies or outrunning them.", "DermaDefault", TopX + TopW - 5, TopY + SubtractHeader_Y * 1.5 + TextHeight, GreyColor, 2, 1);
	draw.SimpleText("You earn money by racing, the higher you place, the more you earn.", "DermaDefault", TopX + TopW - 5, TopY + SubtractHeader_Y * 1.5 + TextHeight * 2, GreyColor, 2, 1);
	draw.SimpleText("The more racers there are, the more money is at stake.", "DermaDefault", TopX + TopW - 5, TopY + SubtractHeader_Y * 1.5 + TextHeight * 3, GreyColor, 2, 1);
	draw.SimpleText("After 10 races there will be a vote for the next map.", "DermaDefault", TopX + TopW - 5, TopY + SubtractHeader_Y * 1.5 + TextHeight * 4, GreyColor, 2, 1);
	
	draw.SimpleText("General F.A.Q.", "DermaDefaultBold", TopX + TopW / 2,TopY + SubtractHeader_Y * 4 + TextHeight * 3, GreyColor, 1, 1);
	draw.SimpleText("Q: Where can I see what place I got? A: There is a scoreboard available on every map near the spawn which shows the last race results and map records.", "DermaDefault", TopX + TopW * .5,TopY + SubtractHeader_Y * 4 + TextHeight * 4, GreyColor, 1, 1);
	draw.SimpleText("Q: Why did I not get in the last race? A: Every map has a limited number of racers allowed per round. You will be bumped to the front of the line for the next round.", "DermaDefault", TopX + TopW * .5,TopY + SubtractHeader_Y * 4 + TextHeight * 5, GreyColor, 1, 1);
	draw.SimpleText("Q: What parts are needed to use Turbo? A: The two most needed parts are a Supercharger and an Exhaust Tailpipe. Other parts add effectivity of the Turbo.", "DermaDefault", TopX + TopW * .5,TopY + SubtractHeader_Y * 4 + TextHeight * 6, GreyColor, 1, 1);
	draw.SimpleText("Q: Can I make a map for GMRacer? A: Sure! There is a wiki page on garrysmod.com about mapping for GMRacer. A sample map will soon be added to help.", "DermaDefault", TopX + TopW * .5,TopY + SubtractHeader_Y * 4 + TextHeight * 7, GreyColor, 1, 1);
	
	draw.SimpleText("Server News", "DermaDefaultBold", BottomLeftX + (BottomLeftW * .5), BottomLeftY + SubtractHeader_Y / 2, GreyColor, 1, 1);
	draw.SimpleText("Special Thanks To...", "DermaDefaultBold", BottomRightX + (BottomRightW * .5), BottomRightY + SubtractHeader_Y / 2, GreyColor, 1, 1);
	
	self:RotateTable(self.ServerNews, BottomLeftX, BottomLeftY, BottomLeftW, BottomLeftH);

	self:RotateTable(self.ThanksTo, BottomRightX, BottomRightY, BottomRightW, BottomRightH);
	
end


function GM:RotateTable ( Table, X, Y, W, H )
	local mouse_x, mouse_y = gui.MousePos();
	
	local Movement = .5;
	
	if mouse_x < X or mouse_x > X + W or mouse_y < Y or mouse_y > Y + H then
		for k, v in pairs(Table) do
			local PrePos = 50;
			if Table[k - 1] then PrePos = Table[k - 1].CurPos; end
			local LastPos = Table[table.Count(Table)].CurPos;
			local StopPos = H - SubtractHeader_Y - 8;
			
			if k == 1 then
				if LastPos >= TextHeight and v.CurPos >= StopPos then
					v.CurPos = 0;
				end
				
				if v.CurPos >= 0 and v.CurPos <= StopPos then
					v.CurPos = v.CurPos + Movement;
				end
			else
				if v.CurPos >= StopPos then
					v.CurPos = 0;
				end
				
				if (v.CurPos > 0 and v.CurPos < StopPos) or (v.CurPos == 0 and PrePos >= TextHeight and PrePos <= StopPos) then
					v.CurPos = v.CurPos + Movement;
				end
			end
		end
	end
	
	for k, v in pairs(Table) do
		local StopPos = H - SubtractHeader_Y - 8;
		if v.CurPos > 0 and v.CurPos < StopPos then
			draw.SimpleText(v.Name, "DermaDefault", X + (W * .5), Y + SubtractHeader_Y / 2 + v.CurPos + 2, TextColor, 1, 0);
		end
	end
		
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawRect(X, Y + SubtractHeader_Y * .7, W, TextHeight);
	surface.DrawRect(X, Y - SubtractHeader_Y * .7 + H, W, TextHeight);
end

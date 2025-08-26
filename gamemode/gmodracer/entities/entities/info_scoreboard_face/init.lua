ENT.Base = "base_point"
ENT.Type = "point"

function ENT:AcceptInput ( Name, Activator, Caller ) end

function ENT:Initialize ( )
	self.ID = self.ID or 1;
	
	GAMEMODE.ScoreboardFaces[self.ID] = self;
end

function ENT:KeyValue ( Key, Value )
	if Key == "scoreboard_id" then
		self.ID = tonumber(Value);
	end
end

function ENT:Think ( )
end

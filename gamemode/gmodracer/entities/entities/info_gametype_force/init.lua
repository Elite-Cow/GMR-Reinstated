ENT.Base = "base_point"
ENT.Type = "point"

function ENT:AcceptInput ( Name, Activator, Caller ) end

function ENT:Initialize ( )
	self.ID = self.ID or 1;
	GAMEMODE.GamemodeType = self.ID;
	SetGlobalInt("GamemodeType", self.ID);
end

function ENT:KeyValue ( Key, Value )
	if Key == "forcegame" then
		self.ID = tonumber(Value);
	end
end

function ENT:Think ( )
end

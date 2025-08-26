ENT.Base = "base_point"
ENT.Type = "point"

function ENT:AcceptInput ( Name, Activator, Caller ) end

function ENT:Initialize ( )
	GAMEMODE.MaxRacers = GAMEMODE.MaxRacers + 1;
	self.ID = self.ID or table.Count(GAMEMODE.VehicleSpawnPoints) + 1;
	
	if GAMEMODE.VehicleSpawnPoints[self.ID] then
		self.ID = table.Count(GAMEMODE.VehicleSpawnPoints) + 1;
	end
		
	GAMEMODE.VehicleSpawnPoints[self.ID] = self;
end

function ENT:KeyValue ( Key, Value )
	if Key == "number" then
		self.ID = tonumber(Value);
	end
end

function ENT:Think ( ) end

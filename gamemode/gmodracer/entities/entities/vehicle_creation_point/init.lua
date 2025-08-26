ENT.Base = "base_point"
ENT.Type = "point"

function ENT:AcceptInput ( Name, Activator, Caller ) end

function ENT:Initialize ( )
	GAMEMODE.GarageLocationEntity = self;
end

function ENT:KeyValue ( Key, Value ) end
function ENT:Think ( ) end

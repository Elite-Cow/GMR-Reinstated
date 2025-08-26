
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()   
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)

	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake();
	end

	self.TimeLeft = CurTime() + 30;
	table.insert(GAMEMODE.Debris, self.Entity);
end   
 
function ENT:Think()
		
	if CurTime() >= self.TimeLeft then
		self:Remove();
	end
	
	self:NextThink(CurTime() + 0.01);
	return true
end

function ENT:PhysicsCollide( data, physobj ) 
    
 end  
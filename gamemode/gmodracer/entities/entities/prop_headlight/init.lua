AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()   
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetSolid(SOLID_NONE)

	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake();
		phys:EnableGravity(false);
	end
end   
 
function ENT:Think()
	return true
end

function ENT:PhysicsCollide( data, physobj ) 
    
 end  
 
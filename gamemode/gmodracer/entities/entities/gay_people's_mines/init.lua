
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()   
	self.Entity:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl");
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)

	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake();
		phys:EnableGravity(true);
		phys:EnableCollisions(true);
		phys:EnableDrag(true);
	end
	
	self:SetColor(0, 255, 0, 255);

	self.ArmTime = CurTime() + 1;
	self.IsArmed = false;
	self.TimeLeft = CurTime() + 25;
	table.insert(GAMEMODE.Debris, self.Entity);
	
	util.PrecacheSound("ambient/explosions/explode_1.wav")
end   

function ENT:Explode ( )	
	local expl=ents.Create("env_explosion")
	expl:SetPos(self:GetPos())
	expl:SetParent(self)
	expl:SetOwner(self:GetOwner())
	expl:SetKeyValue("spawnflags", 128)
	expl:Spawn()
	expl:Activate()
	expl:Fire("explode", "", 0)
	expl:Fire("kill","",0)
	
	self.shakeeffect = ents.Create("env_shake")
	self.shakeeffect:SetKeyValue("amplitude", 16)
	self.shakeeffect:SetKeyValue("spawnflags", 4 + 8 + 16)
	self.shakeeffect:SetKeyValue("frequency", 200.0)
	self.shakeeffect:SetKeyValue("duration", 2)
	self.shakeeffect:SetKeyValue("radius", 200)
	self.shakeeffect:SetPos(self.Entity:GetPos())
	self.shakeeffect:Fire("StartShake","",0)
	self.shakeeffect:Fire("Kill","",4)
	
	self:EmitSound("ambient/explosions/explode_1.wav", 70, 90)
	
	for k, v in pairs(ents.FindInSphere(self:GetPos(), 300)) do
		if v:IsPlayer() then
			local Damage = math.Clamp(((300 - self:GetPos():Distance(v:GetPos())) * .25) / math.Clamp(v:GetUsedPart('Chasis') * .25, 1, 2), 0, 50);
			v:GiveDamage(Damage, v);
		end
	end
	
	self:Remove();
end

function ENT:SetLauncher ( Ent ) self.GetLauncher = Ent; end
 
function ENT:Think()

	if !self.IsArmed and CurTime() >= self.ArmTime then
		self.IsArmed = true;
		self:SetColor(255, 0, 0, 255);
	end
		
	if self.IsArmed and CurTime() >= self.TimeLeft then
		self:Explode();
		return true
	end
	
	if self.IsArmed then
		local NearEntities = ents.FindInSphere(self:GetPos(), 100);
				
		for k, v in pairs(NearEntities) do
			if v:GetModel() == 'models/buggy.mdl' then
				self:Explode();
				return true;
			end
		end
	end
	
	self:NextThink(CurTime() + 0.01);
	return true
end

function ENT:PhysicsCollide( data, physobj ) 
    
 end  
 include('shared.lua')     
 
 
function ENT:Initialize() end

function ENT:Draw()
	self:DrawModel();
end

function ENT:Think()
	if !self:GetOwner() or !self:GetOwner():IsValid() then
		self:Remove();
		return false;
	end
	
	if GAMEMODE.EffectsOn:GetBool() then
		local Forward = self:GetForward();
		local Right = self:GetRight();
		local Up = self:GetUp();
		
		local JeepData = self:GetOwner():CompileJeepData();
		if self:GetOwner():GetNetworkedBool("IsTurboing") then
			local effectdata = EffectData();
			effectdata:SetOrigin(self.Entity:GetPos() + (Forward * 25)+ (Right * 4))
			effectdata:SetStart(Forward * 2) 
			util.Effect("turbo_exhaust", effectdata);
		else
			local effectdata = EffectData();
			effectdata:SetOrigin(self.Entity:GetPos() + (Forward * 25)+ (Right * 4))
			effectdata:SetStart(Forward * 2) 
			util.Effect("smoke_exhaust", effectdata);
		end
	end

	if !GAMEMODE.StopEffects then self:NextThink(CurTime() + 0.1); else self:NextThink(CurTime() + 0.5); end
	return true
end

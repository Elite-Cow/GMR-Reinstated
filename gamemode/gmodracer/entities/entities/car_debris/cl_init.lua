 include('shared.lua')     
 
 
function ENT:Initialize() end

function ENT:Draw()
	self:DrawModel();
end

function ENT:Think()
	if GAMEMODE.EffectsOn:GetBool() then
		local effectdata = EffectData();
		effectdata:SetOrigin(self:GetPos());
		effectdata:SetStart(self:GetPos());
		effectdata:SetScale(20);
		util.Effect("fire", effectdata);
	end

	if !GAMEMODE.StopEffects then self:NextThink(CurTime() + 0.1); else self:NextThink(CurTime() + 0.5); end
	return true
end

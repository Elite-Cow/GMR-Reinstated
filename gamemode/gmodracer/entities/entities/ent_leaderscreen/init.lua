ENT.Base = "base_brush"
ENT.Type = "brush"

function ENT:Initialize()
	self.ID = self.ID or 1;
	self.Setup = 10;
end

function ENT:StartTouch( Ent ) end

function ENT:KeyValue ( Key, Value )
	local LoweredKey = string.lower(Key);

	if LoweredKey == "screen_id" then
		self.ID = tonumber(Value);
	end
end

function ENT:EndTouch( Ent ) end
function ENT:Touch( Ent ) end
function ENT:PassesTriggerFilters( Ent ) return Ent:IsPlayer() end
function ENT:Think()
	if self.Setup > 0 then
		self.Setup = self.Setup - 1;
	elseif self.Setup == 0 then		
		self.Setup = self.Setup - 1;
				
		local ScoreboardDraw = ents.Create("leaderscreen_draw");
		if !ScoreboardDraw or !ScoreboardDraw:IsValid() then return false; end
		ScoreboardDraw:SetPos(self:OBBCenter());
		--ScoreboardDraw:SetAngles((self:OBBCenter() - GAMEMODE.LeaderscreenFaces[self.ID]:GetPos()):Angle());
		ScoreboardDraw:Spawn();
		ScoreboardDraw:SetNetworkedVector("OBB_Max", self:OBBMaxs());
		ScoreboardDraw:SetNetworkedVector("OBB_Min", self:OBBMins());
		ScoreboardDraw:SetNetworkedVector("ScoreboardFace", GAMEMODE.LeaderscreenFaces[self.ID]:GetPos());
	end
end
function ENT:OnRemove() end

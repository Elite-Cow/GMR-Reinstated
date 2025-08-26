function EFFECT:Init( data )

	self.EffectTimer = CurTime() + 0.001;
	
	local Offset = data:GetOrigin();
	local Size = data:GetScale();
 
 /*
 	local emitter = self:ParticleEmitter( Offset );
	if !emitter then
		GAMEMODE.StopEffects = true;
		timer.Simple(5, function ( ) GAMEMODE.StopEffects = false; end);
		return false;
	end
	*/
	
 	for i= 0, 1 do 
 		 			
		local particle1 = GAMEMODE.GlobalEmitter:Add( "particles/smokey", Offset );
		
		local Velocity = math.random(0,700);
		local Death = math.random(1,5);
		local Roll = math.random(0, 360);
		local RollDelta = math.random(-0.5, 0.5);
		local SetColor = math.random(0,50);
		local StartAlpha = math.random(200,255);
		local Gravity = Vector(math.Rand(-100, 10), math.Rand(-100, 10), math.Rand(2, 400));
		local FlameColor = math.random(200,250);
		
 		if particle1 then 
					
	 		particle1:SetVelocity(VectorRand() * Velocity);
	 				 
	 		particle1:SetLifeTime( 0 );
	 		particle1:SetDieTime(Death);
	 				 
	 		particle1:SetStartAlpha(StartAlpha);
	 		particle1:SetEndAlpha(0);
	 				 
	 		particle1:SetStartSize(Size / 1.5);
	 		particle1:SetEndSize(Size);
						 				
	 		particle1:SetRoll(Roll);
	 		particle1:SetRollDelta(RollDelta);
	 				 
	 		particle1:SetAirResistance(400);
	 				 
	 		particle1:SetGravity(Vector(0, 0, 400));
				
			particle1:SetColor(SetColor, SetColor, SetColor);
		end
		
		local particle2 = GAMEMODE.GlobalEmitter:Add("particles/flamelet" .. math.random(1,5), Offset);
		
		if particle2 then
			particle2:SetVelocity(VectorRand() * Velocity);
 			
			particle2:SetLifeTime(0);
 			particle2:SetDieTime(0.3);
 				 
 			particle2:SetStartAlpha(100);
 			particle2:SetEndAlpha(0);
 				 
 			particle2:SetStartSize(math.Clamp(Size, 10, 300));
 			particle2:SetEndSize(math.Clamp(Size, 20, 600) * 2);
 				 
 			particle2:SetRoll(Roll);
 			particle2:SetRollDelta(RollDelta);
 				 
 			particle2:SetAirResistance(400);
 				 
 			particle2:SetGravity(Gravity);
 			    
			particle2:SetColor(200, FlameColor, FlameColor);
		 			 
 		end 
 		 
 	//emitter:Finish();
	
	end
	
end

function EFFECT:ParticleEmitter( OffSet )
	if !self.Emitter then self.Emitter = ParticleEmitter(OffSet); end
	return self.Emitter
end

function EFFECT:Think( ) return false; end
function EFFECT:Render() end

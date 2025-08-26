
function EFFECT:Init ( data )

	local Offset = data:GetOrigin();
	local Size = data:GetScale();

 	local NumParticles = 30;
	
	/*
 	local Emitter = ParticleEmitter(Offset);
	if !emitter then
		GAMEMODE.StopEffects = true;
		timer.Simple(5, function ( ) GAMEMODE.StopEffects = false; end);
		return false;
	end
 	*/
	
 	for i=0, NumParticles do 
 		 			
		local particle1 = GAMEMODE.GlobalEmitter:Add("particles/smokey", Offset);
		
		local Death = math.random(3,5);
		local Roll = math.random(0, 360);
		local RollDelta = math.random(-0.5, 0.5);
		local SetColor = math.random(0,50);
		local StartAlpha = math.random(50,100);
		local Gravity = Vector(math.Rand(-100, 100), math.Rand(-100, 100), math.Rand(0, 10));
		local VelocityVector = Vector(Size * math.Rand(-10, 10), Size * math.Rand(-10, 10), Size * math.Rand(-10, 10));
 			
		if particle1 then 
 				 
			particle1:SetVelocity(VelocityVector);
				
 			particle1:SetLifeTime(0);
 			particle1:SetDieTime(Death); 
 				 
 			particle1:SetStartAlpha(StartAlpha); 
 			particle1:SetEndAlpha(0); 
 				 
 			particle1:SetStartSize(Size * 1); 
 			particle1:SetEndSize(Size * 2); 
				
			particle1:SetGravity(Gravity);
 				 
 			particle1:SetRoll(Roll); 
 			particle1:SetRollDelta(RollDelta); 
 				 
 			particle1:SetAirResistance(100); 
				
			particle1:SetColor(SetColor, SetColor, SetColor);		
		end

		local particle2 = GAMEMODE.GlobalEmitter:Add("particles/flamelet" .. math.random(1, 3), Offset); 

		if particle2 then
		
			particle2:SetVelocity(VelocityVector); 
				
 			particle2:SetLifeTime(0); 
 			particle2:SetDieTime(0.1); 
 				 
 			particle2:SetStartAlpha(StartAlpha); 
 			particle2:SetEndAlpha(0); 
 				 
 			particle2:SetStartSize(Size / 2); 
 			particle2:SetEndSize(Size * 2); 
				
			particle2:SetGravity(Gravity);
 				 
 			particle2:SetRoll(Roll); 
 			particle2:SetRollDelta(RollDelta); 
 				 
 			particle2:SetAirResistance(100); 
				
			particle2:SetColor(255, 255, 255);	
		end

		local particle3 = GAMEMODE.GlobalEmitter:Add("particles/flamelet" .. math.random(1, 5), Offset); 

		if particle3 then
		
			particle3:SetVelocity(VelocityVector); 
				
 			particle3:SetLifeTime(10); 
 			particle3:SetDieTime(10); 
 				 
 			particle3:SetStartAlpha(255); 
 			particle3:SetEndAlpha(0); 
 				 
			particle3:SetStartLength(100);
			particle3:SetEndLength(0);
						
				 
 			particle3:SetStartSize(Size / 2); 
 			particle3:SetEndSize(Size * 2); 
				
			particle3:SetGravity(Gravity);
 				 
 			particle3:SetRoll(Roll); 
 			particle3:SetRollDelta(RollDelta); 
 				 
 			particle3:SetAirResistance(100); 
				
			particle3:SetColor(255, 255, 255);	

 		end 
 			 
 	end 
 		 
 	//Emitter:Finish(); 
	
end

function EFFECT:Think() return false; end
function EFFECT:Render() end

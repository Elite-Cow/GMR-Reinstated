

--Initializes the effect. The data is a table of data 
--which was passed from the server.
function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
	
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 6

	local emitter = ParticleEmitter( Pos )
	
	local Size = 125;
	
	local Point75 = Size * .75;
	local NegPoint75 = Point75 * -1
	local NegSize = Size * -1;
	local LSize = Size * 1.25;
	local Point25 = Size * .25;
	local NegPoint25 = Point25 - 1;
	
	
	--firecloud
		for i=1, 100 do
		
			local particle = emitter:Add( "particles/flamelet"..math.random( 1, 5 ), Pos + Vector(math.random(NegSize, Size),math.random(NegSize, Size),math.random(0, LSize)))

				particle:SetVelocity(Vector(math.random(-30,30),math.random(-30,30), math.random(0, 100)))
				particle:SetDieTime(math.Rand( 2.5, 4 ))
				particle:SetStartAlpha(math.Rand(200, 240))
				particle:SetStartSize( math.random(Point75, Size) )
				particle:SetEndSize( math.random(Size, LSize) )
				particle:SetRoll( math.Rand( 360, 480 ) )
				particle:SetRollDelta( math.Rand( -1, 1 ) )
				particle:SetColor( math.random(0, 25), 255, math.random(0, 25) )
				particle:VelocityDecay( false )
			end
			

		for i=1, 75 do
		
			local particle = emitter:Add( "particles/flamelet"..math.random( 1, 5 ), Pos + Vector(math.random(NegPoint75, Point75),math.random(NegPoint75, Point75),math.random(Point75, LSize)))

				particle:SetVelocity( Vector(math.random(-15, 15), math.random(-15, 15), math.random(0, 100)))
				particle:SetDieTime( math.Rand( 2.7, 4.5 ) )
				particle:SetStartAlpha( math.Rand( 200, 240 ) )
				particle:SetStartSize( math.random(Point75, Size) )
				particle:SetEndSize( math.random(Size, LSize) )
				particle:SetRoll( math.Rand( 360, 480 ) )
				particle:SetRollDelta( math.Rand( -1, 1 ) )
				particle:SetColor( math.random(0, 55), 255, math.random(0, 55) )
				particle:VelocityDecay( false )
			end


		for i=1, 50 do
		
			local particle = emitter:Add( "particles/flamelet"..math.random( 1, 5 ), Pos + Vector(math.random(NegPoint25, Point25),math.random(NegPoint25, Point25),math.random(0, Point25)))

				particle:SetVelocity(Vector(math.random(-50,50),math.random(-50,50), math.random(0, 100)))
				particle:SetDieTime(math.Rand( 2.5, 4 ))
				particle:SetStartAlpha(math.Rand(200, 240))
				particle:SetStartSize( math.random(Point75, Size) )
				particle:SetEndSize( math.random(Size, LSize) )
				particle:SetRoll( math.Rand( 360, 480 ) )
				particle:SetRollDelta( math.Rand( -1, 1 ) )
				particle:SetColor( math.random(0, 55), 255, math.random(0, 55) )
				particle:VelocityDecay( false )
			end
end


function EFFECT:Think( )
	return true	
end

-- Draw the effect
function EFFECT:Render()
	-- Do nothing - this effect is only used to spawn the particles in Init	
end




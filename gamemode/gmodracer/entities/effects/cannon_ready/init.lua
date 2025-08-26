

--Initializes the effect. The data is a table of data 
--which was passed from the server.
function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
	
	local Pos = self.Position
	local Norm = Vector(0,0,1)
	
	Pos = Pos + Norm * 6
	
	local Size = 10;

	local particle = GAMEMODE.GlobalEmitter:Add("particles/flamelet" .. math.random( 1, 5 ), Pos)
		particle:SetVelocity(data:GetEntity():GetVelocity())
		particle:SetDieTime(1)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(Size)
		particle:SetEndSize(Size)
		particle:SetRoll( math.Rand( 1360, 1480 ) )
		particle:SetRollDelta( math.Rand( -1, 1 ) )
		particle:SetColor( math.random(0, 25), 255, math.random(0, 25) )
		particle:VelocityDecay( false )

end


function EFFECT:Think( )
	return true	
end

-- Draw the effect
function EFFECT:Render()
	-- Do nothing - this effect is only used to spawn the particles in Init	
end




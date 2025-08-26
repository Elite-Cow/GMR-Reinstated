local matLight 		= Material( "sprites/light_ignorez" )
local matBeam		= Material( "effects/lamp_beam" )

ENT.RenderGroup 	= RENDERGROUP_TRANSLUCENT

include('shared.lua')

function ENT:Initialize()

	self.PixVis = util.GetPixelVisibleHandle()
	
end

/*---------------------------------------------------------
   Name: Draw
---------------------------------------------------------*/
function ENT:Draw()

	if !GAMEMODE.LightsOn:GetBool() then return end

	self.BaseClass.Draw( self, true )
	
end

/*---------------------------------------------------------
   Name: Think
---------------------------------------------------------*/
function ENT:Think()
	
	if !GAMEMODE.LightsOn:GetBool() then return end
	if !self:GetOwner():GetNetworkedBool("LightsOn") then return end

	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		local r, g, b, a = self:GetColor()
		dlight.Pos = self:GetPos()
		dlight.r = r
		dlight.g = g
		dlight.b = b
		dlight.Brightness = 2
		dlight.Decay = 256 * 5
		dlight.Size = 256
		dlight.DieTime = CurTime() + 1
	end
	
	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		local r, g, b, a = self:GetColor()
		dlight.Pos = self:GetPos() + (self:GetForward() * -50)
		dlight.r = r
		dlight.g = g
		dlight.b = b
		dlight.Brightness = 2
		dlight.Decay = 256 * 5
		dlight.Size = 256
		dlight.DieTime = CurTime() + 1
	end
	
	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		local r, g, b, a = self:GetColor()
		dlight.Pos = self:GetPos() + (self:GetForward() * -100)
		dlight.r = r
		dlight.g = g
		dlight.b = b
		dlight.Brightness = 2
		dlight.Decay = 256 * 5
		dlight.Size = 256
		dlight.DieTime = CurTime() + 1
	end
	
	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		local r, g, b, a = self:GetColor()
		dlight.Pos = self:GetPos() + (self:GetForward() * -150)
		dlight.r = r
		dlight.g = g
		dlight.b = b
		dlight.Brightness = 2
		dlight.Decay = 256 * 5
		dlight.Size = 256
		dlight.DieTime = CurTime() + 1
	end
	
	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		local r, g, b, a = self:GetColor()
		dlight.Pos = self:GetPos() + (self:GetForward() * -200)
		dlight.r = r
		dlight.g = g
		dlight.b = b
		dlight.Brightness = 2
		dlight.Decay = 256 * 5
		dlight.Size = 256
		dlight.DieTime = CurTime() + 1
	end
	
end

/*---------------------------------------------------------
   Name: DrawTranslucent
   Desc: Draw translucent
---------------------------------------------------------*/
function ENT:DrawTranslucent()
	
	if !GAMEMODE.LightsOn:GetBool() then return end
	
	self.BaseClass.DrawTranslucent( self, true )
	
	local LightPos = self:GetPos()
	render.SetMaterial( matLight )
	
	local ViewNormal = self:GetPos() - EyePos()
	local Distance = ViewNormal:Length()
	ViewNormal:Normalize()

	local r, g, b, a = self:GetColor()
		
	local Visibile	= util.PixelVisible( LightPos, 4, self.PixVis )	
	
	if (!Visibile) then return end
	
	if ( !self:GetOwner():GetNetworkedBool("LightsOn") ) then 
	
		render.DrawSprite( LightPos, 16, 16, Color(40, 40, 40, 255 * Visibile) )
	
	return end
	
	local Alpha = 255
	
	render.DrawSprite( LightPos, 8, 8, Color(255, 255, 255, Alpha), Visibile )
	render.DrawSprite( LightPos, 8, 8, Color(255, 255, 255, Alpha), Visibile )
	render.DrawSprite( LightPos, 8, 8, Color(255, 255, 255, Alpha), Visibile )
	render.DrawSprite( LightPos, 32, 32, Color( r, g, b, 64 ), Visibile )

	
end

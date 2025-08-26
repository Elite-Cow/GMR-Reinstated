include('shared.lua')

ENT.RenderGroup = RENDERGROUP_OPAQUE;

function ENT:DrawText ( text, font, x, y, color, xalign, yalign )
	surface.SetFont(font);
	local W, H = surface.GetTextSize(text);
	
	if yalign == 1 then
		y = y - (H * .5);
	elseif yalign == 2 then
		y = y - H;
	end
	
	if xalign == 1 then
		x = x - (W * .5);
	elseif xalign == 2 then
		x = x - W;
	end
	
	draw.DrawText(text, font, self.X + x, self.Y + y, color);
end

function ENT:DrawRect ( x, y, w, h, color )
	surface.SetDrawColor(color.r, color.g, color.b, color.a);
	surface.DrawRect(self.X + x, self.Y + y, w, h);
end

surface.CreateFont("3DDermaLarge", {
	font = "coolvetica",
	size = 70,
	weight = 500
});
surface.CreateFont("3DDermaDefault", {
	font = "coolvetica",
	size = 40,
	weight = 500
});
surface.CreateFont("3DDermaDefault_LCD", {
	font = "LCD",
	size = 40,
	weight = 700
});

function ENT:Draw()			
	local Trace = {}
	Trace.start = self:GetPos();
	Trace.endpos = LocalPlayer():GetPos() + Vector(0, 0, 64);
	Trace.filter = {self, LocalPlayer()};
	
	if LocalPlayer():InVehicle() then
		table.insert(Trace.filter, LocalPlayer():GetVehicle());
	end
	
	local TraceRes = util.TraceLine(Trace);

	if !self.Setup or Trace.Hit then
		local Angle = self:GetAngles();
		Angle:RotateAroundAxis(Angle:Right(), 90)
		Angle:RotateAroundAxis(Angle:Up(), -90)
		
		cam.Start3D2D(self:GetPos(), Angle, .5);
			draw.SimpleText("Loading Screen...", "DermaLarge", 0, 0, GreyColor, 1, 1);
		cam.End3D2D();
		
		return false;
	end

	/*
	local Forward = (self:GetPos() - self:GetNetworkedVector("ScoreboardFace")):Normalize()
	local Angle = Forward:Angle();
	*/
	
	local Old_Angle = Angle;
	local Angle = self:GetAngles();
	Angle:RotateAroundAxis(Angle:Right(), 90)
	Angle:RotateAroundAxis(Angle:Up(), -90)
	
	local OBBMax = self:GetNetworkedVector("OBB_Max");
	local OBBMin = self:GetNetworkedVector("OBB_Min");
		
	local YDist = OBBMax:Distance(Vector(OBBMax.x, OBBMax.y, OBBMin.z));
	local XDist = OBBMax:Distance(Vector(OBBMin.x, OBBMin.y, OBBMax.z));
		
	local Scale = 3;
		
	self.X = XDist * -(Scale * .5);
	self.Y = YDist * -(Scale * .5);
	self.W = XDist * Scale;
	self.H = YDist * Scale;
	
	local ClosestCamera = nil;

					
	cam.Start3D2D(self:GetPos(), Angle, 1 / Scale);

		if GetGlobalInt('GamemodeType') == 2 or !GetGlobalBool("CurrentlyRacing") or !Leader then			
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawRect(self.X, self.Y, self.W, self.H);
			
			surface.SetFont("3DDermaLarge");
			local w, h = surface.GetTextSize("s");
			
			
			draw.SimpleText("< PulsarEffect.Com >", "3DDermaLarge", self.X + self.W * .5, self.Y + self.H * .5, GreyColor, 1, 1);
		else
			surface.SetDrawColor(255, 255, 255, 255);
			surface.SetMaterial(ScreenMat);
			surface.DrawTexturedRect(self.X, self.Y, self.W, self.H);
		end
	
	cam.End3D2D();
end

function ENT:Initialize ( )
	self.Setup = false;
end

function ENT:Think()
	if !self.Setup and self:GetNetworkedVector("OBB_Max") and self:GetNetworkedVector("OBB_Max") != Vector(0, 0, 0) and self:GetNetworkedVector("OBB_Min") and self:GetNetworkedVector("OBB_Min") != Vector(0, 0, 0) then
		self.Setup = true;
		self:SetRenderBoundsWS(self:GetNetworkedVector("OBB_Min"), self:GetNetworkedVector("OBB_Max"));
	end
end

function ENT:DrawTranslucent() self:Draw(); end
function ENT:BuildBonePositions( NumBones, NumPhysBones ) end
function ENT:SetRagdollBones( bIn ) self.m_bRagdollSetup = bIn; end
function ENT:DoRagdollBone( PhysBoneNum, BoneNum ) end

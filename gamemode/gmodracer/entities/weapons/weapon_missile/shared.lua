

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "pistol"
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "UH OH"			
	SWEP.Author				= "Mr. Awesome"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "."
	SWEP.ViewModelFlip		= false
	
	killicon.AddFont( "weapon_awesome", "HL2MPTypeDeath", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end


SWEP.Base				= "weapon_cs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_rpg.mdl"
SWEP.WorldModel			= "models/weapons/w_rocket_launcher.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_357.Single" )
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Damage			= 3000
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0001
SWEP.Primary.ClipSize		= 6
SWEP.Primary.Delay			= 5
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "357"

SWEP.Primary.Sound			= Sound( "Weapon_357.Single" )
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Damage			= 3000
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0001
SWEP.Primary.ClipSize		= 6
SWEP.Primary.Delay			= 5
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "357"

SWEP.IronSightsPos = Vector (-5.6636, -11.5496, 2.6359)
SWEP.IronSightsAng = Vector (0.2196, -0.1405, 0.123)

function SWEP:PrimaryAttack()
	if CLIENT then return false; end
	self.NextPrimaryAttack = self.NextPrimaryAttack or 0;
	if ( self.NextPrimaryAttack > CurTime() ) then return end
	self.NextPrimaryAttack = CurTime() + 5;
	
	self:Throw();
end

function SWEP:Throw ()
	
	
	local SpawnPos = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 20);
	
	local bl = ents.Create('vip_missile');
	bl:SetPos(SpawnPos);
	bl:SetAngles(self.Owner:GetAimVector():Angle() + Angle(90, 0, 0));
	bl:Spawn();
end

function SWEP:SecondaryAttack()
	if CLIENT then return false; end
	self:Throw();
	
	
end

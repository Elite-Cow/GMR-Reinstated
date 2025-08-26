surface.CreateFont("LCD_Large", {
	font = "LCD",
	size = 50,
	weight = 400
});
surface.CreateFont("LCD_ExtraLarge", {
	font = "LCD",
	size = 125,
	weight = 400
});
GM.EffectsOn = CreateClientConVar( "gmr_effects", "1", true, false )
GM.LightsOn = CreateClientConVar( "gmr_lights", "1", true, false )

include("cl_setup.lua");
include("shared.lua")
include("cl_networking.lua");
include("cl_draw.lua");
include("garage.lua");
include("help_menu.lua");
include("cl_misc.lua");
include("cl_draw_scoreboard.lua");
include("cl_leaderscreen.lua");
include("draw_race.lua");
include("draw_demo.lua");

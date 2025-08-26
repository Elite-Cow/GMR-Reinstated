GM.IsInGarage = false;
GM.IsShowingRaceMenu = false;
GM.ShowSorryMessage = false;
GM.RaceStartTime = 0;
GM.CameraLocations = {};
GM.SmoothCheckpoint = 0

GM.WrongWayText = surface.GetTextureID("gmracer/wrongway");
GM.SpeedometerMat = surface.GetTextureID("gmracer/speedometer");
GM.ThermometerMat = surface.GetTextureID("gmracer/thermometer");
GM.NeedleMat = surface.GetTextureID("gmracer/needle");

GM.DrillSound = Sound("gmracer/drill.mp3");
GM.RegisterSound = Sound("gmracer/register.mp3");
GM.CountdownSound = Sound("hl1/fvox/bell.wav");
GM.GoSound = Sound("plats/elevbell1.wav");

GM.LastNOSTime = 0;

GM.Music = {};
GM.ServerNews = {};
GM.ThanksTo = {};

local function AddDisplay ( Table, Name )
	local NewTable = {};
	NewTable.Name = Name;
	NewTable.CurPos = 0;
	
	table.insert(Table, NewTable);
end

local function AddMusic ( Name, Time )
	local NewTable = {};
	NewTable.Name = Name;
	NewTable.Time = Time;
	
	table.insert(GM.Music, NewTable);
end

AddMusic("music1", 81);
AddMusic("music2", 53);
AddMusic("music3", 162);

AddDisplay(GM.ServerNews, "http://www.pulsareffect.com/");

AddDisplay(GM.ThanksTo, "Primus8 - Mapping");
AddDisplay(GM.ThanksTo, "SharpShark - Mapping");
AddDisplay(GM.ThanksTo, "Sad Panda - Uber Sound Editor");
AddDisplay(GM.ThanksTo, "Daxter Fellowes - Server Host");
AddDisplay(GM.ThanksTo, "GMod4Ever - Entertainment");
AddDisplay(GM.ThanksTo, "TheJ89 - Vector Help");
AddDisplay(GM.ThanksTo, "Night-Eagle - Partial Scoreboard Script");
AddDisplay(GM.ThanksTo, "Sakarias88 - Partial Upgrades Icons");
AddDisplay(GM.ThanksTo, "LuaBanana - Entertainment and Inspiration");
AddDisplay(GM.ThanksTo, "Train - Showing Me How NOT To Make This Gamemode");
AddDisplay(GM.ThanksTo, "Garry - For Not Fixing the SNPCs");
AddDisplay(GM.ThanksTo, "Marco[MW] - Buggy Skin");
AddDisplay(GM.ThanksTo, "£cho - Buggy Skin");
AddDisplay(GM.ThanksTo, "East Clubbers - Race Music");
AddDisplay(GM.ThanksTo, "DJS1207 - Race Music");
AddDisplay(GM.ThanksTo, "Benefactr - Spoiler Model");
AddDisplay(GM.ThanksTo, "Fxuem - Record Music");
AddDisplay(GM.ThanksTo, "Scope - Mapping and Models");
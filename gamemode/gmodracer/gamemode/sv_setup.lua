GM.TrackInformation = {};
GM.PlayerTables = {};
GM.NumCheckPoints = 0;
GM.QueuedPlayers = {};
GM.DelayBetweenRaces = 30;
GM.MaxRacers = 0;
GM.NumJeepsPlaced = 0;
SetGlobalBool("CurrentlyRacing", false);
SetGlobalInt("NextRaceStart", GM.DelayBetweenRaces);
SetGlobalString("NumberOfRacers", 0);
GM.NextRace = CurTime() + GM.DelayBetweenRaces;
GM.GamemodeType = 1;
GM.VehicleSpawnPoints = {};
GM.PlayerVehicles = {};
GM.Checkpoints = {};
GM.ScoreboardFaces = {};
GM.Debris = {};
GM.NumRacesRan = 0;
GM.SpawningRace = false;
GM.MaxRaces = 10;

if !string.find(game.GetMap(), "drag") then--game.GetMap() != "gmr_drag" then
	GM.PerCash = 500; -- /10 for base value
else
	GM.PerCash = 350; -- /10 for base value
end


GM.CameraLocations = {};
GM.LeaderscreenFaces = {};
GM.PlayerDamageTables = {};
GM.LastHits = {};

GM.PlaceNames = {};
GM.PlaceNames[1] = "first";
GM.PlaceNames[2] = "second";
GM.PlaceNames[3] = "third";
GM.PlaceNames[4] = "fourth";
GM.PlaceNames[5] = "fifth";
GM.PlaceNames[6] = "sixth";
GM.PlaceNames[7] = "seventh";
GM.PlaceNames[8] = "eighth";
GM.PlaceNames[9] = "ninth";
GM.PlaceNames[10] = "tenth";
GM.PlaceNames[11] = "eleventh";
GM.PlaceNames[12] = "twelveth";
GM.PlaceNames[13] = "thirteenth";
GM.PlaceNames[14] = "fourteenth";
GM.PlaceNames[15] = "fifteenth";
GM.PlaceNames[16] = "sixteenth";
GM.PlaceNames[17] = "seventeenth";
GM.PlaceNames[18] = "eighteenth";
GM.PlaceNames[19] = "nineteenth";
GM.PlaceNames[20] = "twentieth";
GM.PlaceNames[21] = "twenty-first";
GM.PlaceNames[22] = "twenty-second";
GM.PlaceNames[23] = "twenty-third";
GM.PlaceNames[24] = "twenty-fourth";
GM.PlaceNames[25] = "twenty-fifth";
GM.PlaceNames[26] = "twenty-sxith";
GM.PlaceNames[27] = "twenty-seventh";
GM.PlaceNames[28] = "twenty-eighth";
GM.PlaceNames[29] = "twenty-ninth";
GM.PlaceNames[30] = "thirtieth";
GM.PlaceNames[31] = "thirty-first";
GM.PlaceNames[32] = "thirty-second";
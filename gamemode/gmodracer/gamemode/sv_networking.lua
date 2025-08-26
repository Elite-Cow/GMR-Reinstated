if !file.IsDir("", "gmracer") then file.CreateDir("gmracer"); end
if !file.IsDir("", "gmracer/map_records") then file.CreateDir("gmracer/map_records"); end

if !file.IsDir("","gmracer/map_records/" .. game.GetMap()) then
	file.CreateDir("gmracer/map_records/" .. game.GetMap());
end

if !file.IsDir("", "gmracer/times_played") then
	file.CreateDir("gmracer/times_played");
end

if !file.Exists(game.GetMap() .. ".txt", "gmracer/times_played/") then
	file.Write("gmracer/times_played/" .. game.GetMap() .. ".txt", "1");
else
	file.Write("gmracer/times_played/" .. game.GetMap() .. ".txt", tonumber(file.Read("gmracer/times_played/" .. game.GetMap() .. ".txt", "DATA")) + 1);
end


function GM.SetMapRecord ( Place, Name, Time )	
	SetGlobalString("MapRecords_" .. Place .. "_Name", Name);
	SetGlobalInt("MapRecords_" .. Place .. "_Time", Time);
end

function GM.LoadMapRecord ( Place )

end

function GM.RetrieveOffMapRecord ( Place, Map )
	Return = nil
	if Return then
		--return Return[1]['Name'], tonumber(Return[1]['Time']);
	else
		return "UNKNOWN", 0;
	end
end

local Success = sql.Query("SELECT * FROM `gmr_records` WHERE `Map`='" .. game.GetMap() .. "' ORDER BY `Time` ASC LIMIT 10");
GM.CompareTop10 = '';
Return = Success
if Success then
	for k, v in pairs(Return) do
		GM.CompareTop10 = GM.CompareTop10 .. v['Time'];
		SetGlobalString("MapRecords_" .. k .. "_Name", v['Name']);
		SetGlobalInt("MapRecords_" .. k .. "_Time", v['Time']);
	end
end
--[[
	for i = 0, 4 do
		timer.Simple(i, function ( )
			for k, v in pairs(player.GetAll()) do
				v:PrintMessage(HUD_PRINTTALK, "MYSQL ERROR: RESTARTING MAP IN " .. (5 - i) .. " SECONDS.");
			end
		end
		);
	end
	timer.Simple(5, function ( )
		for k, v in pairs(player.GetAll()) do
			v:PrintMessage(HUD_PRINTTALK, "lol nah");
		end
	end
	);
end
]]--
function GM.RecieveCameraLocations ( UMsg )
	local NumIncoming = UMsg:ReadFloat();

	for i = 1, NumIncoming do
		table.insert(GAMEMODE.CameraLocations, UMsg:ReadVector());
	end
end
usermessage.Hook("cameralocs", GM.RecieveCameraLocations);
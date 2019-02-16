
--@Class CDOTAPlayer

--[[
Return player steamID64

@return string
]]
function CDOTAPlayer:GetSteamID()
	return tostring(PlayerResource:GetSteamID(self:GetPlayerID()))
end

--@Class CDOTA_BaseNPC_Hero

--[[
Return hero's player steamID64

@return string
]]
function CDOTA_BaseNPC_Hero:GetSteamID()
	return tostring(PlayerResource:GetSteamID(self:GetPlayerID()))
end

function CDOTA_BaseNPC_Hero:HasVIP()
	return ShuShanPlayersHasVIP[self:GetSteamID()] == true
end
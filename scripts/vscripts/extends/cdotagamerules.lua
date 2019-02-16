
--@Class CDOTAGamerules

local __custom_game_rate_level = Avalon:Forever('__custom_game_rate_level',1)
function CDOTAGamerules:SetCustomGameRate(lv)
	__custom_game_rate_level = lv
end

function CDOTAGamerules:GetCustomGameRate()
	return __custom_game_rate_level
end

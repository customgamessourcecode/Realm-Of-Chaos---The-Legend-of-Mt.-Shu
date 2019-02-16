
function OnStartTouch(keys)
	local activator = keys.activator

	activator:ShowCustomMessage({
		type="message-box",
		role="PS", 
		list={
			{
				text="avalon_msg_enter_dizifang",
			}
		},
		duration=10,
	})

	activator:SetContextThink("__ShuShan_liandanfang_gain__", function ()
		if GameRules:IsGamePaused() then
			return 0.1
		end

		activator:AddExperience(activator:GetLevel()*10, DOTA_ModifyXP_Unspecified, false, false)

		if activator:GetHealthPercent() < 100 then
			activator:SetHealth(activator:GetHealth() + activator:GetMaxHealth() * 0.2)
		end

		return 1
	end, 1)
end

function OnEndTouch(keys)
	local activator = keys.activator

	activator:SetContextThink("__ShuShan_liandanfang_gain__", function () return nil end, 0)
end
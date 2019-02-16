
function OnStartTouch(keys)
	local activator = keys.activator
	local trigger = keys.caller

	if activator:GetBag():FindItemByName("item_0103") ~= nil then
		return 1
	end
	if GameRules:IsDaytime() then
		if not activator.__jifengya_is_touching then
			activator.__jifengya_is_touching = true
			
			if activator:GetHealth() <= 10000 then
				activator:ForceKill(true)
			else
				ApplyDamage({
					attacker = activator,
					victim = activator,
					damage = 10000,
					damage_type = DAMAGE_TYPE_PURE,
				})
			end
		end
	end
end

function OnEndTouch(keys)
	local activator = keys.activator
	local trigger = keys.caller

	Wait("jifengya"..tostring(activator:GetEntityIndex()), trigger, 0.2, function ()
		if not trigger:IsTouching(activator) then
			activator.__jifengya_is_touching = false
		end
	end)
end


function OnStartTouch(keys)
	local activator = keys.activator
	local trigger = keys.caller

	local children = trigger:GetChildren()
	local child = nil
	if #children >= 1 then
		child = children[RandomInt(1,#children)]

		local delay = trigger:Attribute_GetFloatValue("delay",0)
		if delay < 0 then delay = 0 end
		if delay > 5 then delay = 5 end

		if delay <= 0.2 then
			FindClearSpaceForUnit(activator, child:GetOrigin(), true)
			activator:CameraLock(0.1)
		else
			activator:AddNewModifier(activator, nil, "modifier_rooted", {duration=5})
			activator:CameraLock(delay+0.1)
			CustomGameEventManager:Send_ServerToPlayer(activator:GetPlayerOwner(), "start_teleport_screen", {delay=delay})
			Wait(delay,function ()
				activator:Stop()
				FindClearSpaceForUnit(activator, child:GetOrigin(), true)
				activator:RemoveModifierByName("modifier_rooted")
			end)
		end
	end
end
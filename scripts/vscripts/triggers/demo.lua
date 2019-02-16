
function OnStartTouch(keys)
	local activator = keys.activator
	local trigger = keys.caller

	local children = trigger:GetChildren()
	local child = nil
	if #children >= 1 then
		child = children[RandomInt(1,#children)]
	end
end

function OnTrigger(keys)
	local activator = keys.activator
	local trigger = keys.caller

	local children = trigger:GetChildren()
	local child = nil
	if #children >= 1 then
		child = children[RandomInt(1,#children)]
	end
end

function OnEndTouch(keys)
	local activator = keys.activator
	local trigger = keys.caller

	local children = trigger:GetChildren()
	local child = nil
	if #children >= 1 then
		child = children[RandomInt(1,#children)]
	end
end
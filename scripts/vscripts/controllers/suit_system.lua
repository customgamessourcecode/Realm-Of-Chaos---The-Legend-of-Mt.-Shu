
if SuitSystem == nil then
	SuitSystem = RegisterController('suit_system')
	setmetatable(SuitSystem,SuitSystem)
end

local public = SuitSystem

function public:__call(hero)
	local attributes = {}

	Timer(DoUniqueString("suit_system"), hero, 1, function ()
		self:Do(hero, attributes)
		return 1
	end)
end

function public:Do(hero, attributes)
	if not hero:IsAlive() then return end

	for k in pairs(attributes) do
		attributes[k] = 0
	end

	for suitName,t in pairs(item_suit_table) do
		local requestItem = t["requestItems"]
		local conform = 0

		for i,itemname in ipairs(requestItem) do
			if type(itemname) == "table" then
				for i=0,5 do
					local item = hero:GetItemInSlot(i)

					if item then
						for i,v in ipairs(itemname) do
							if item:GetAbilityName() == v then
								conform = conform + 1
								break
							end
						end
					end
				end
			else
				for i=0,5 do
					local item = hero:GetItemInSlot(i)

					if item and item:GetAbilityName() == itemname then
						conform = conform + 1
						break
					end
				end
			end
		end

		if conform == #requestItem then
			-- 满足套装需求
			local suitAttributes = t['attributes']
			for k,v in pairs(suitAttributes) do
				attributes[k] = (attributes[k] or 0) + v
			end

			-- 检测并附加BUFF
			local modifiers = t["modifiers"]
			if modifiers and #modifiers > 0 then
				for i,modifier_name in ipairs(modifiers) do
					if not hero:HasModifier(modifier_name) then
						hero:AddNewModifier(hero, nil, modifier_name, nil)
					end
				end
			end
		else
			-- 不满足套装需求的情况下，删除套装BUFF
			local modifiers = t["modifiers"]
			if modifiers and #modifiers > 0 then
				for i,modifier_name in ipairs(modifiers) do
					hero:RemoveModifierByName(modifier_name)
				end
			end
		end

	end

	for k,v in pairs(attributes) do
		hero:SetCustomAttribute(k,'suit_system',v)
	end
end

function public:GetAttribute(hero, name)
	return hero:GetCustomAttributeChild(name, "suit_system", 0)
end
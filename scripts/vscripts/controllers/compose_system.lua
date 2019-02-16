
if ComposeSystem == nil then
	ComposeSystem = RegisterController('compose_system')
	setmetatable(ComposeSystem,ComposeSystem)
end

local public = ComposeSystem

function public:Compose(hero, index)
	local data = item_compose_table[index]
	if not data then return false end

	local bag = hero:GetBag()
	if not bag then return false end

	local composeItemName = data["composeItem"]
	local requestItem = data["requestItem"]
	local conform = {}
	local composeItem = {}

	for i,t in pairs(requestItem) do
		local items = {}
		bag:Look(function(bagSlot,itemIndex,item)
			if item:GetAbilityName() == t.itemname then

				if item:IsStackable() then
					local list = items['list']
					if list == nil then
						list = {}
						items['list'] = list
						items['count'] = 0
					end

					if conform[t.itemname] == nil then
						conform[t.itemname] = bag:GetNumItemInBag(t.itemname)
					end

					local num = conform[t.itemname]
					if num <= 0 then return true end

					local charges = item:GetCurrentCharges()
					local remaining_require = t.count - items.count

					if charges >= remaining_require then
						items.count = items.count + remaining_require
						conform[t.itemname] = num - remaining_require
					else
						items.count = items.count + charges
						conform[t.itemname] = num - charges
					end
					table.insert(list,bagSlot)

					if items.count >= t.count then
						return true
					end

				elseif conform[bagSlot] == nil then
					conform[bagSlot] = true
					items['IsStackable'] = false

					local list = items['list']
					if list == nil then
						list = {}
						items['list'] = list
						items['count'] = 0
					end

					table.insert(list,bagSlot)
					items.count = items.count + 1

					if items.count >= t.count then
						return true
					end
				end
			end
		end)
		composeItem[i] = items
	end

	for i,t in pairs(requestItem) do
		local items = composeItem[i]
		if (items.count or 0) < t.count then
			return Avalon:Throw(hero,"avalon_msg_materials_not_enough",false)
		end
	end

	for k,items in pairs(composeItem) do
		if items.IsStackable == false then
			for _,bagSlot in pairs(items.list) do
				bag:RemoveItemInSlot(bagSlot)
			end
			
		else
			for _,bagSlot in pairs(items.list) do
				bag:CostItemInSlot(bagSlot,items.count)
			end
		end
	end
	
	bag:CreateItem(composeItemName)
	GameStats:Increment("ItemsSpawnCount", composeItemName)

	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "shushan_new_item_tips", {itemname=composeItemName})
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "shushan_compose_item_finished", {ID=index})
end

function public:ComposeForUI(hero, index, itemname)
	local t = item_compose_table[index]
	if not t then return end
	if t["composeItem"] ~= itemname then return end
	self:Compose(hero, index)
end
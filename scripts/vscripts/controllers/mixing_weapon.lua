
if MixingWeapon == nil then
	MixingWeapon = RegisterController('mixing_weapon')
	setmetatable(MixingWeapon,MixingWeapon)
end

local public = MixingWeapon

function public:Compose(hero, data)
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
	
	self:FateEffect(hero, bag:CreateItem(composeItemName))
	GameStats:Increment("ItemsSpawnCount", composeItemName)

	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "shushan_new_item_tips", {itemname=composeItemName})
end

function public:ComposeForUI(hero, recipe, stage, index)
	local t = mixing_weapon_config[hero:GetUnitName()]
	if not t then return end
	t = t[recipe]
	if not t then return end
	t = t[stage]
	if not t then return end
	t = t[index]
	if not t then return end

	self:Compose(hero, t)
end

local m_FateAttributeBounsList = {
	["str"]="bonus_strength",
	["agi"]="bonus_agility",
	["int"]="bonus_intellect",
	["sword_coefficient"]="weapon_mult_sword",
	["knife_coefficient"]="weapon_mult_knife",
	["blade_coefficient"]="weapon_mult_blade",
	["caster_coefficient"]="weapon_mult_caster",
	["lancer_coefficient"]="weapon_mult_lancer",
}
function public:FateEffect(hero, weapon)
	if not weapon then return end
	if not hero:IsFate("lianqitianshi") then return end

	for name,specialName in pairs(m_FateAttributeBounsList) do
		local value = weapon:GetSpecialValueFor(specialName) or 0
		if value > 0 then
			weapon:SetCustomAttribute(name,value*RandomFloat(0.2, 0.4))
		end
	end
	
end

if CustomItemSpellSystem == nil then
	CustomItemSpellSystem = RegisterController('custom_item_spell_system')
	CustomItemSpellSystem.__heroes = {}
	CustomItemSpellSystem.__dummy_list = {}
	setmetatable(CustomItemSpellSystem,CustomItemSpellSystem)
end

local public = CustomItemSpellSystem

Custom_Item_Spell_System_Slot_1 = 6
Custom_Item_Spell_System_Slot_2 = 7
Custom_Item_Spell_System_Slot_3 = 8
Custom_Item_Spell_System_Slot_4 = 9
Custom_Item_Spell_System_Slot_5 = 10
Custom_Item_Spell_System_Slot_6 = 11
Custom_Item_Spell_System_Slot_Min = 6
Custom_Item_Spell_System_Slot_Max = 11

function public:init()
	_G['AbilitiesKV'] = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
	Avalon:Listen("bag_changed", Dynamic_Wrap(self,"OnBagChanged"), self)
end

function public:SetSlot(hero, slot, item)
	if slot < Custom_Item_Spell_System_Slot_Min then return end

	local hasItemInInventory = hero:HasItem(item)

	local bag = hero:GetBag()
	if not bag or not bag:HasItem(item) then 
		if not hasItemInInventory then
			return
		end
	end

	if not hasItemInInventory then
		if ItemKindGroup[ItemConfig[item:GetAbilityName()].kind] ~= ITEM_KIND_GROUP_MATERIAL then
			return
		end
	end

	local itemname = item:GetAbilityName()
	local abilityName = 'custom_'..itemname
	if not AbilitiesKV[abilityName] then return end

	local oldAbility = hero:GetAbilityByIndex(slot)
	if not oldAbility or oldAbility:GetAbilityName() == abilityName then return end

	local hasSwap = false
	for i=Custom_Item_Spell_System_Slot_Min,Custom_Item_Spell_System_Slot_Max do
		local ability = hero:GetAbilityByIndex(i)
		if ability and ability:GetAbilityName() == abilityName and i ~= slot then
			self:SwapAbilities(hero,i,slot)
			hasSwap = true
			break
		end
	end

	if not hasSwap then
		hero:RemoveAbility(oldAbility:GetAbilityName())
		local ability = hero:AddAbility(abilityName)
		ability:SetLevel(1)
		self:SetSlotItemIndex(hero, slot, item:GetEntityIndex())
	end
end

-- 获取槽位上绑定的物品index
function public:GetItemIndex(hero, slot)
	if slot < Custom_Item_Spell_System_Slot_Min then return -1 end

	local heroItemAbilities = self.__heroes[hero:GetEntityIndex()]
	if heroItemAbilities == nil then
		heroItemAbilities = {}
		self.__heroes[hero:GetEntityIndex()] = heroItemAbilities
	end

	return heroItemAbilities[slot] or -1
end

-- 绑定物品index
function public:SetSlotItemIndex(hero, slot, itemIndex)
	if slot < Custom_Item_Spell_System_Slot_Min then return end

	local heroItemAbilities = self.__heroes[hero:GetEntityIndex()]
	if heroItemAbilities == nil then
		heroItemAbilities = {}
		self.__heroes[hero:GetEntityIndex()] = heroItemAbilities
	end

	heroItemAbilities[slot] = itemIndex;

	CustomNetTables:SetTableValue("Common", "custom_item_spell_system_"..hero:GetEntityIndex(), heroItemAbilities)
end

-- 替换位置
function public:SwapAbilities(hero, slot1,slot2)
	if slot1 == slot2 then return end
	if slot1 < Custom_Item_Spell_System_Slot_Min then return end
	if slot2 < Custom_Item_Spell_System_Slot_Min then return end

	local ability1 = hero:GetAbilityByIndex(slot1)
	local ability2 = hero:GetAbilityByIndex(slot2)
	if not ability1 or not ability2 then return end

	hero:SwapAbilities(ability1:GetAbilityName(), ability2:GetAbilityName(), true, true)

	local temp = self:GetItemIndex(hero, slot1)
	self:SetSlotItemIndex(hero, slot1, self:GetItemIndex(hero, slot2))
	self:SetSlotItemIndex(hero, slot2, temp)
end

function public:QuickCastAbility(hero, item)
	if item:GetBehavior() ~= DOTA_ABILITY_BEHAVIOR_NO_TARGET then
		return
	end
	
	local itemname = item:GetAbilityName()
	local abilityName = 'custom_'..itemname
	if not AbilitiesKV[abilityName] then return end

	if hero:HasAbility(abilityName) then
		local ability = hero:FindAbilityByName(abilityName)
		ability:CastAbility()
	else
		local ability = hero:AddAbility(abilityName)
		ability:SetLevel(1)
		ability.__is_free = true

		local slot = ability:GetAbilityIndex()
		self:SetSlotItemIndex(hero, slot, item:GetEntityIndex())
		ability:CastAbility()
		hero:RemoveAbility(abilityName)
		self:SetSlotItemIndex(hero, slot, -1)
	end
end

function public:Release(hero, slot)
	if slot < Custom_Item_Spell_System_Slot_Min then return end

	local ability = hero:GetAbilityByIndex(slot)
	if ability then hero:RemoveAbility(ability:GetAbilityName()) end

	for i=1,6 do
		if not hero:HasAbility("custom_item_spell_system_"..i) then
			local ability = hero:AddAbility("custom_item_spell_system_"..i)
			if ability then ability:SetLevel(1) break end
		end
	end

	self:SetSlotItemIndex(hero, slot, -1)
end

-- 背包发生改变
function public:OnBagChanged(hero)
	for i=Custom_Item_Spell_System_Slot_Min,Custom_Item_Spell_System_Slot_Max do
		local ability = hero:GetAbilityByIndex(i)
		if ability and string.find(ability:GetAbilityName(),'custom_item_spell_system_') == nil and ability.GetBindItem then
			local item = ability:GetBindItem()
			local bag = hero:GetBag()
			local hasItemInInventory = hero:HasItem(item)

			if not item or item:IsNull() or not bag:HasItem(item) then
				if not hasItemInInventory then
					self:Release(hero,i)
				end
			end
			if item and not item:IsNull() and not hasItemInInventory and ItemKindGroup[ItemConfig[item:GetAbilityName()].kind] ~= ITEM_KIND_GROUP_MATERIAL then
				self:Release(hero,i)
			end
		end
	end
end

-- 只能使用一次的物品
local __use_once_items = {
	["item_0077"] = true,
	["item_0148"] = true,
	["item_0392"] = true,
	["item_0393"] = true,
	["item_0394"] = true,
	["item_0395"] = true,
	["item_0396"] = true,
	["item_0423"] = true,
}
local __use_once_log = {}
function public:UseOnce(hero, itemname)
	if not __use_once_items[itemname] then return false end

	local log = __use_once_log[itemname]
	if log == nil then
		log = {}
		__use_once_log[itemname] = log
	end

	if log[hero:GetEntityIndex()] == nil then
		log[hero:GetEntityIndex()] = true
		return false
	else
		return true
	end
end

function CustomItemSpellSystem__OnSpellStart(self)
	local caster = self:GetCaster()

	local item = self:GetBindItem()
	if not item or item:IsNull() then return end

	if CustomItemSpellSystem:UseOnce(caster,item:GetAbilityName()) == true then
		caster:Stop()
		return
	end

	if item:GetBehavior() == DOTA_ABILITY_BEHAVIOR_CHANNELLED then
		self:OnCustomSpellStart(item)
		return
	end

	if item:IsStackable() and item:GetCurrentCharges() > 0 then
		self:OnCustomSpellStart(item)
		CustomItemSpellSystem:StartItemCooldown(caster,item,self)

		local bag = caster:GetBag()
		item:SetCurrentCharges(item:GetCurrentCharges() - 1)

		if item:GetCurrentCharges() <= 0 and not item:IsPermanent() then
			if not self.__is_free then
				CustomItemSpellSystem:Release(caster, self:GetAbilityIndex())
			end
			bag:RemoveItem(item)
		end

		bag:Update()
	elseif not item:IsStackable() then
		self:OnCustomSpellStart(item)
		CustomItemSpellSystem:StartItemCooldown(caster,item,self)

		if not item:IsPermanent() then
			local bag = caster:GetBag()
			if not self.__is_free then
				CustomItemSpellSystem:Release(caster, self:GetAbilityIndex())
			end
			bag:RemoveItem(item)
		end
	end
end

function CustomItemSpellSystem__OnChannelFinish(self, bInterrupted)
	local caster = self:GetCaster()

	local item = self:GetBindItem()
	if not item or item:IsNull() then return end

	if not bInterrupted then
		if item:IsStackable() and item:GetCurrentCharges() > 0 then
			self:OnCustomChannelFinish(item, bInterrupted)
			CustomItemSpellSystem:StartItemCooldown(caster,item,self)

			local bag = caster:GetBag()
			item:SetCurrentCharges(item:GetCurrentCharges() - 1)

			if item:GetCurrentCharges() <= 0 and not item:IsPermanent() then
				if not self.__is_free then
					CustomItemSpellSystem:Release(caster, self:GetAbilityIndex())
				end
				bag:RemoveItem(item)
			end

			bag:Update()
		elseif not item:IsStackable() then
			self:OnCustomChannelFinish(item, bInterrupted)
			CustomItemSpellSystem:StartItemCooldown(caster,item,self)
		end
	else
		self:OnCustomChannelFinish(item, bInterrupted)
		CustomItemSpellSystem:StartItemCooldown(caster,item,self)
	end
		
end

function CustomItemSpellSystem__GetBindItem(self)
	return EntIndexToHScript(CustomItemSpellSystem:GetItemIndex(self:GetCaster(), self:GetAbilityIndex()))
end

function public:StartItemCooldown(hero,item,ability)
	if item:IsNull() or ability:IsNull() then return end

	local dummy_list = self.__dummy_list
	if dummy_list == nil then
		dummy_list = {}
		self.__dummy_list = dummy_list
	end

	local itemname = item:GetAbilityName()
	hero:GetBag():Look(function(bagSlot,itemIndex,bagItem)
		if bagItem:GetAbilityName() == itemname then
			local hasStartCooldown = false
			for i,dummy in ipairs(dummy_list) do
				repeat
					if dummy:IsNull() then return end

					if dummy:HasItemInInventory(itemname) then
						for i=0,5 do
							local slot_item = dummy:GetItemInSlot(i)
							if slot_item and not slot_item:IsNull() and slot_item:GetEntityIndex() == itemIndex then
								slot_item:StartCooldown(ability:GetCooldownTimeRemaining())
								hasStartCooldown = true
							end
						end
						break
					end

					local num = 0
					for i=0,5 do
						local slot_item = dummy:GetItemInSlot(i)
						if slot_item and not slot_item:IsNull() then
							num = num + 1
						end
					end

					if hasStartCooldown then break end

					if num < 6 then
						dummy:AddItem(bagItem)
						bagItem:StartCooldown(ability:GetCooldownTimeRemaining())
						hasStartCooldown = true
						break
					end
				until true
				if hasStartCooldown then return end
			end

			if not hasStartCooldown then
				local dummy = CreateUnitByName("avalon_dummy", Vector(0,0,0), true, nil, nil, hero:GetTeam())
				dummy:SetOwner(hero)
				dummy:AddNoDraw()
				dummy:AddNewModifier(hero, nil, "modifier_invulnerable", nil)
				dummy:AddNewModifier(hero, nil, "modifier_phased", nil)

				dummy:AddItem(bagItem)
				bagItem:StartCooldown(ability:GetCooldownTimeRemaining())

				table.insert(dummy_list,dummy)
			end
		end
	end)
end

function public:GetBaseClass()
	return class({
		OnSpellStart=CustomItemSpellSystem__OnSpellStart,
		GetBindItem=CustomItemSpellSystem__GetBindItem,
		OnChannelFinish=CustomItemSpellSystem__OnChannelFinish,
	})
end
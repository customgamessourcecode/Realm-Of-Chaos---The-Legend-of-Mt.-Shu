
if DropItemsCtrl == nil then
	DropItemsCtrl = RegisterController('dropped')
	setmetatable(DropItemsCtrl,DropItemsCtrl)
end

local public = DropItemsCtrl

function public:__call(attacker, victim)
	if victim:GetTeam() == DOTA_TEAM_GOODGUYS then
		return
	end
	
	local unitName = victim:GetUnitName()
	local hero = nil

	if attacker:IsRealHero() then
		hero = attacker
	else
		local owner = attacker:GetOwner()
		if owner and owner.IsRealHero and owner:IsRealHero() then
			hero = owner
		else
			return
		end
	end

	local data = Dropped_Item_Table[unitName]
	if not data then return end

	local dropCount = data.DropCount
	local ItemList = data.ItemList
	local ItemListFixed = data.ItemListFixed

	if hero:IsFate("xingyuner") and RandomFloat(0, 100) <= 35 then
		dropCount = dropCount + 1
	end

	if ItemList then
		local dropItemCount = #ItemList
		if data.DropAll == true then
			for k,v in pairs(ItemList) do
				local itemName = v[1]
				local newItem = CreateItem(itemName, nil, nil )
			    local item_container = CreateItemOnPositionSync( victim:GetOrigin() + RandomVector(150), newItem )
			    self:RemoveItemThink(item_container)
			    GameStats:Increment("ItemsSpawnCount", itemName)
			end
		else
			for i=1,dropCount do
				local i = RandomInt( 1, dropItemCount)
				local itemdata = ItemList[i]
				local itemName = itemdata[1]
				local dropChance = itemdata[2]

				if RandomFloat(0.0, 1.0) <= dropChance then
					local newItem = CreateItem(itemName, nil, nil )
				    local item_container = CreateItemOnPositionSync( victim:GetOrigin() + RandomVector(150), newItem )
				    self:RemoveItemThink(item_container)
				    GameStats:Increment("ItemsSpawnCount", itemName)
				end
			end
		end
	end

	if ItemListFixed then
		for i,v in ipairs(ItemListFixed) do
			for i=1,v[2] do
				local itemName = v[1]
				local newItem = CreateItem(itemName, nil, nil )
			    local item_container = CreateItemOnPositionSync( victim:GetOrigin() + RandomVector(150), newItem )
			    self:RemoveItemThink(item_container)
			    GameStats:Increment("ItemsSpawnCount", itemName)
			end
		end
	end

end

function public:ReleaseItem(item)
	local quality = item:GetQuality()
	local gold = 0
	if quality ~= -1 then
		if quality >= 0 and quality <= 3 then
			gold = 100
		elseif quality > 3 and quality <= 4 then
			gold = 300
		elseif quality > 4 then
			gold = 900
		end
		gold = math.floor(gold / PlayerResource:GetPlayerCount())
		for i=0,PlayerResource:GetPlayerCount() do
			local player = PlayerResource:GetPlayer(i)
			if player then
				local hero = player:GetAssignedHero()
				if hero then
					hero:GiveGold(gold)
				end
			end
		end
	end
	item:RemoveSelf()
end

function public:RemoveItemThink(item_container)
	local delete = false
	Timer(DoUniqueString("DropItemsCtrl"), item_container, function()

		if GameRules:IsGamePaused() then
			return 1
		end
		
		if delete == false then
			delete = true
		else
			self:ReleaseItem(item_container:GetContainedItem())
		    item_container:RemoveSelf()
		    return nil
		end

		return 60
	end)
end
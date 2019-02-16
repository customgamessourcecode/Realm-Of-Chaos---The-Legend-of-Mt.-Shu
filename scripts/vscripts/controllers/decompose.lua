
if DecomposeSystem == nil then
	DecomposeSystem = RegisterController('decompose_system')
	DecomposeSystem.players_decompose_item = {}
	setmetatable(DecomposeSystem,DecomposeSystem)
end

local public = DecomposeSystem

local decompose_config = {
	[ITEM_QUALITY_C] = {
		min = 1,
		max = 3,
		itemname = "item_0388",
	},
	[ITEM_QUALITY_B] = {
		min = 3,
		max = 6,
		itemname = "item_0388",
	},
	[ITEM_QUALITY_A] = {
		min = 6,
		max = 15,
		itemname = "item_0388",
	},
	[ITEM_QUALITY_S] = {
		min = 15,
		max = 30,
		itemname = "item_0388",
	},
	[ITEM_QUALITY_Z] = {
		min = 30,
		max = 60,
		itemname = "item_0388",
	},
	[ITEM_QUALITY_EX] = {
		min = 30,
		max = 60,
		itemname = "item_0388",
	},
}

function public:CanDecompose(hero, item)
	local config = ItemConfig[item:GetAbilityName()]
	local player_data = self.players_decompose_item[hero:GetEntityIndex()]

	if player_data == nil then
		player_data = {}
		self.players_decompose_item[hero:GetEntityIndex()] = player_data
	end

	if item.__get_source == "shop" then
		player_data.item = -1
		player_data.config = nil
		CustomNetTables:SetTableValue("Common", "PlayersDecomposeItem", self.players_decompose_item )
		return Avalon:Throw(hero,"shushan_decompose_error_msg_shop", false)
	end

	if config.quality < ITEM_QUALITY_C then
		player_data.item = -1
		player_data.config = nil
		CustomNetTables:SetTableValue("Common", "PlayersDecomposeItem", self.players_decompose_item )
		return Avalon:Throw(hero,"shushan_decompose_error_msg_quality", false)
	end

	local group = ItemKindGroup[config.kind]

	if group == ITEM_KIND_GROUP_WEAPON or group == ITEM_KIND_GROUP_SHOES or group == ITEM_KIND_GROUP_CLOTHES
		or group == ITEM_KIND_GROUP_HAT or group == ITEM_KIND_GROUP_TRINKET then
		return true
	end

	
	return Avalon:Throw(hero,"shushan_decompose_error_msg_kind",false)
end

function public:Bind(hero, item)
	local config = ItemConfig[item:GetAbilityName()]
	local player_data = self.players_decompose_item[hero:GetEntityIndex()]
	if player_data == nil then
		player_data = {}
		self.players_decompose_item[hero:GetEntityIndex()] = player_data
	end

	if not self:CanDecompose(hero, item) then
		player_data.item = -1
		player_data.config = nil
		CustomNetTables:SetTableValue("Common", "PlayersDecomposeItem", self.players_decompose_item )
		return
	end

	player_data.item = item:GetEntityIndex()
	player_data.config = decompose_config[config.quality]
	CustomNetTables:SetTableValue("Common", "PlayersDecomposeItem", self.players_decompose_item )
end

function public:Clear(hero)
	local player_data = self.players_decompose_item[hero:GetEntityIndex()]
	if player_data == nil or player_data.item == -1 then return end

	player_data.item = -1
	player_data.config = nil
	CustomNetTables:SetTableValue("Common", "PlayersDecomposeItem", self.players_decompose_item )
end

function public:Decompose(hero, item)
	local player_data = self.players_decompose_item[hero:GetEntityIndex()]
	if player_data == nil then
		player_data = {}
		self.players_decompose_item[hero:GetEntityIndex()] = player_data
	end

	local bag = hero:GetBag()

	if item == nil then
		item = EntIndexToHScript(player_data.item)
	else
		player_data.item = item:GetEntityIndex()
		player_data.config = decompose_config[ItemConfig[item:GetAbilityName()].quality]
	end

	if item == nil or not bag:HasItem(item) then return end

	if not self:CanDecompose(hero, item) then
		return
	end
	
	bag:RemoveItem(item)
	local config = player_data.config
	player_data.item = -1
	player_data.config = nil
	CustomNetTables:SetTableValue("Common", "PlayersDecomposeItem", self.players_decompose_item )

	EmitSoundOnClient("CustomGameUI.Decompose", hero:GetPlayerOwner())

	local count = RandomInt(config.min, config.max)
	if not bag:CreateItem(config.itemname, count) then
		local item = CreateItem(config.itemname, nil, nil)
		item:SetCurrentCharges(count)
		CreateItemOnPositionSync(RandomVector(150), item)
	end
end

if PlayerSetting == nil then
	PlayerSetting = RegisterController('player_settings')
	PlayerSetting.__settings = {}
	setmetatable(PlayerSetting,PlayerSetting)
end

local public = PlayerSetting

local m_SettingModel = {
	
	-- 默认接受任务类型
	['accept_quest_type'] = {
		default = 'good',
		option = {'bad','none','good','free'},
	}
}

function CDOTA_BaseNPC_Hero:setting(key)
	return public:get(self:GetSteamID(),key)
end

function public:__call(hero)
	self:GetPlayerSetting(hero:GetSteamID())
end

function public:GetPlayerSetting(steamid)
	local t = self.__settings[steamid]
	if t == nil then
		t = {}
		for k,v in pairs(m_SettingModel) do
			t[k] = v.default
		end
		self.__settings[steamid] = t
		CustomNetTables:SetTableValue("Common", "setting_"..steamid, t )
	end
	return t
end

function public:IsValid(key, value)
	local t = m_SettingModel[key]
	if not t then return false end

	for i,v in ipairs(t.option) do
		if v == value then
			return true
		end
	end

	return false
end

function public:set(steamid, key, value)
	if not self:IsValid(key, value) then return end

	local setting = self:GetPlayerSetting(steamid)
	setting[key] = value

	CustomNetTables:SetTableValue("Common", "setting_"..steamid, setting )
	CustomGameEventManager:Send_ServerToAllClients("avalon_update_player_settings", AvalonEmptyTable)
end

function public:get(steamid, key)
	local setting = self:GetPlayerSetting(steamid)
	return setting[key]
end

function public:all(steamid)
	return self:GetPlayerSetting(steamid)
end

if CustomVoteSystem == nil then
	CustomVoteSystem = RegisterController('custom_vote_system')
	CustomVoteSystem.__players_vote = {}
end

local public = CustomVoteSystem

function public:init()
	local t = {}
	for name, v in pairs(AvalonVoteConfig) do
		if v["type"] == AVALON_VOTE_RADIO then
			t[name] = v.default
			v["options"][v.default] = PlayerResource:GetPlayerCount()
			EachPlayerID(function ( id )
				if self.__players_vote[id] == nil then
					self.__players_vote[id] = {}
				end
				self.__players_vote[id][name] = v.default
			end)

		elseif v["type"] == AVALON_VOTE_COUNT then
			t[name] = false
			v.count = 0
		end
	end
	CustomNetTables:SetTableValue("Common", "VoteSystem_VoteConfig", AvalonVoteConfig )
	CustomNetTables:SetTableValue("Common", "VoteSystem_Result", t )

	CustomGameEventManager:RegisterListener("avalon_vote_system_select", Dynamic_Wrap( self, "OnUI_Select" ))
end

function public:OnUI_Select(data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player == nil then return end

	public:Select(data.PlayerID, data.name or "", data.key or 1)
end

function public:Select(playerID, name, key)
	local conf = AvalonVoteConfig[name]
	if not conf then return end

	local data = self.__players_vote[playerID]
	if data == nil then
		data = {}
		self.__players_vote[playerID] = data
	end

	if conf["type"] == AVALON_VOTE_RADIO then
		local options = conf["options"]
		if options[key] == nil then error("[CustomVoteSystem] Select(): can not find key") end

		local oldKey = data[name]
		if oldKey == key then return end

		if oldKey ~= nil then
			options[oldKey] = options[oldKey] - 1
		end
		
		options[key] = options[key] + 1

		data[name] = key

	elseif conf["type"] == AVALON_VOTE_COUNT then
		data[name] = not data[name]

		if data[name] == true then
			conf.count = (conf.count or 0) + 1
		else
			conf.count = conf.count - 1
		end

	end

	self:Update()
end

function public:Update()
	local t = {}
	for name in pairs(AvalonVoteConfig) do
		t[name] = self:Result(name)
	end

	CustomNetTables:SetTableValue("Common", "VoteSystem_VoteConfig", AvalonVoteConfig )
	CustomNetTables:SetTableValue("Common", "VoteSystem_Result", t )
end

function public:Result(name)
	local conf = AvalonVoteConfig[name]
	if not conf then return end

	if conf["type"] == AVALON_VOTE_RADIO then
		local options = conf["options"]
		local key
		local max = 0

		for k,v in pairs(options) do
			if key == nil or v > max then
				key = k
				max = v
			end
		end
		return key

	elseif conf["type"] == AVALON_VOTE_COUNT then
		local count = 0
		EachPlayer(function ( player )
			count = count + 1
		end)
		local c = math.floor(count*conf.percent)
		return conf.count > c
	end
end

function public:GetVoteCount(name)
	local conf = AvalonVoteConfig[name]
	if not conf then return 0 end

	if conf["type"] == AVALON_VOTE_COUNT then
		return conf.count
	end

	return 0
end
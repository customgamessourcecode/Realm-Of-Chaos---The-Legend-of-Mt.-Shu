
--[[
Message Node:
]]

if CustomMessage == nil then
	CustomMessage = RegisterController('message')
	setmetatable(CustomMessage,CustomMessage)
end

local public = CustomMessage

CUSTOM_MESSAGE_TARGET_PLAYER = 1
CUSTOM_MESSAGE_TARGET_TEAM = 2
CUSTOM_MESSAGE_TARGET_ALL = 3

-- 发送消息给玩家
function public:player( playerEntity, msgData )
	self(CUSTOM_MESSAGE_TARGET_PLAYER, msgData, playerEntity)
end

-- 发送消息给玩家
function public:single( playerID, msgData )
	local player = PlayerResource:GetPlayer(playerID)
	if player then
		self:player(player, msgData)
	end
end

-- 发送消息给队伍
function public:team( teamID, msgData )
	self(CUSTOM_MESSAGE_TARGET_TEAM, msgData, teamID)
end

-- 发送消息给所有玩家
function public:all( msgData )
	self(CUSTOM_MESSAGE_TARGET_ALL, msgData)
end

function CDOTA_BaseNPC_Hero:ShowCustomMessage(msgData)
	public:single( self:GetPlayerID(), msgData )
end

--[[
|=========================================================================
| 
|=========================================================================
]]
function public:__call( target, msgData, arg1 )
	if target == CUSTOM_MESSAGE_TARGET_ALL then
		CustomGameEventManager:Send_ServerToAllClients("avalon_custom_message",msgData)
	elseif target == CUSTOM_MESSAGE_TARGET_PLAYER then
		CustomGameEventManager:Send_ServerToPlayer(arg1,"avalon_custom_message",msgData)
	elseif target == CUSTOM_MESSAGE_TARGET_TEAM then
		CustomGameEventManager:Send_ServerToTeam(arg1,"avalon_custom_message",msgData)
	end
end
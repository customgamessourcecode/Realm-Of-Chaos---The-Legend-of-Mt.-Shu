modifier_npc_task_tiandaomenyunyoudizi_hero_touching = class({})

local public = modifier_npc_task_tiandaomenyunyoudizi_hero_touching

--------------------------------------------------------------------------------

function public:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function public:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function public:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function public:OnCreated(keys)
	if IsServer() then
		local npc = self:GetCaster()
		local hero = self:GetParent()
		QuestsCtrl:OnTouching(npc,hero)
		
		self:StartIntervalThink(1)
		CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "avalon_touch_npc", {unit=npc:GetEntityIndex()})
	end
end

function public:OnDestroy(keys)
	if IsServer() then
		local npc = self:GetCaster()
		local hero = self:GetParent()
		
		CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "avalon_touch_npc_close", {unit=npc:GetEntityIndex()})
	end
end

function public:OnIntervalThink()
	if IsServer() then
		local npc = self:GetCaster()
		local hero = self:GetParent()

		QuestsCtrl:OnTouching(npc,hero)
	end
end
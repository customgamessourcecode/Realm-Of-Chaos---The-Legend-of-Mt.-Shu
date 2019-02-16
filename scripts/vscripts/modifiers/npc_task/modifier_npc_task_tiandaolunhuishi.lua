modifier_npc_task_tiandaolunhuishi = class({})

local public = modifier_npc_task_tiandaolunhuishi

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

function public:IsAura()
	return true
end

--------------------------------------------------------------------------------

function public:GetModifierAura()
	return "modifier_npc_task_tiandaolunhuishi_hero_touching"
end

--------------------------------------------------------------------------------

function public:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function public:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------

function public:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function public:GetAuraRadius()
	return 250
end

--------------------------------------------------------------------------------

function public:GetAuraEntityReject( hEntity )
	if IsServer() then
		if not hEntity:IsHero() then return true end

		if self:GetParent() == hEntity then
			return true
		end
	end

	return false
end

--------------------------------------------------------------------------------

function public:CheckState()
	return ShuShan_NPCTask_Modifier_States
end

--------------------------------------------------------------------------------
modifier_shushan_boss_casting = class({})

local public = modifier_shushan_boss_casting

local m_modifier_states = {
	[MODIFIER_STATE_INVULNERABLE] = true,
}

--------------------------------------------------------------------------------

function public:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function public:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function public:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function public:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local origin = caster:GetOrigin()
		local t = {
			should_stun = 0.3,
			knockback_duration = 0.5,
			duration = 0.5,
			knockback_distance = 150,
			knockback_height = 200,
			center_x = origin.x,
			center_y = origin.y,
			center_z = origin.z
		}

		local iTeamFilter = DOTA_UNIT_TARGET_TEAM_ENEMY
		local iTypeFilter = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
		local iFlagFilter = DOTA_UNIT_TARGET_FLAG_NONE
		local iOrder = FIND_UNITS_EVERYWHERE
		local entities = FindUnitsInRadius(caster:GetTeam(), origin, nil, 200, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, false)
		for i,v in ipairs(entities) do
			v:AddNewModifier(caster, nil, "modifier_knockback", t)
		end
	end
end

--------------------------------------------------------------------------------

function public:OnRefresh()
	if IsServer() then
		self:OnCreated()
	end
end

--------------------------------------------------------------------------------

function public:CheckState()
	return m_modifier_states
end

--------------------------------------------------------------------------------
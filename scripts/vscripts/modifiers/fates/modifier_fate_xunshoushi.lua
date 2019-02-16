modifier_fate_xunshoushi = class({})

local public = modifier_fate_xunshoushi

local m_modifier_funcs = {
	MODIFIER_EVENT_ON_ATTACK_START,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
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

function public:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function public:GetTexture()
	return 'lycan_summon_wolves_invisibility'
end

--------------------------------------------------------------------------------

function public:OnCreated(kv)
	if IsServer() then
		local caster = self:GetCaster()
		unit = CreateUnitByName("npc_ling_lang", caster:GetOrigin(), true, nil, nil, caster:GetTeam())
		unit:SetOwner(caster)
		unit:SetControllableByPlayer(caster:GetPlayerID(), true)
		unit:AddNewModifier(caster, nil, "modifier_fate_xunshoushi_ling_lang", nil)
		unit:SetRenderColor(0,255,255)
		self.__state = 0
		self.__ling_lang = unit
		self.__ling_lang_move_time = 0
		self.__ling_lang_damage_table = {attacker=caster}

		self:StartIntervalThink(0.5)
	end
end

--------------------------------------------------------------------------------

function public:OnDestroy(kv)
	if IsServer() then
		self.__ling_lang:ForceKill(true)
	end
end

--------------------------------------------------------------------------------

function public:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		local unit = self.__ling_lang
		local damage = DamageSystem:GetDamage(self.__ling_lang_damage_table) * 0.2

		unit:SetBaseDamageMin(damage)
		unit:SetBaseDamageMax(damage)
		unit:SetBaseMoveSpeed(caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed()) + 100)

		if caster:GetCustomAttribute("state",0) > self.__state then
			self.__state = caster:GetCustomAttribute("state",0)
			unit:SetModelScale(0.6+0.1*self.__state)
		end

		if not unit:IsAttacking() then
			if caster:IsIdle() then
				if GameRules:GetGameTime() >= self.__ling_lang_move_time then
					self.__ling_lang_move_time = GameRules:GetGameTime() + RandomFloat(1, 5)
					unit:MoveToPositionAggressive(caster:GetOrigin() + RandomVector(RandomFloat(100, 300)))
				end
			else
				unit:MoveToPositionAggressive(caster:GetOrigin() - caster:GetRightVector()*150)
			end
			
		end

		if not GridNav:CanFindPath(unit:GetOrigin(),caster:GetOrigin()) then
			FindClearSpaceForUnit(unit, caster:GetOrigin(), true)

		elseif (unit:GetOrigin() - caster:GetOrigin()):Length2D() >= 1200 then
			FindClearSpaceForUnit(unit, caster:GetOrigin() + RandomVector(150), true)
			unit:Stop()
		end
	end
end

--------------------------------------------------------------------------------

function public:AttackToCasterTarget(target)
	local oldTarget = self.__attack_target
	if (oldTarget == nil) or (oldTarget and (oldTarget:IsNull() and not oldTarget:IsAlive())) then
		oldTarget = target
	end
	self.__ling_lang:MoveToTargetToAttack(oldTarget)
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	return m_modifier_funcs
end

--------------------------------------------------------------------------------

function public:OnAttackStart(kv)
	if IsServer() then
		if kv.attacker == self:GetCaster() then
			self:AttackToCasterTarget(kv.target)
		end
	end
end

--------------------------------------------------------------------------------

function public:OnTakeDamage(kv)
	if IsServer() then
		if kv.attacker == self:GetCaster() and kv.target ~= self:GetCaster() then
			self:AttackToCasterTarget(kv.target)
		end
	end
end

--------------------------------------------------------------------------------

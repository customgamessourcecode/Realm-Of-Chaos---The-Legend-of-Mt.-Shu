modifier_item_suit_niepan = class({})

local public = modifier_item_suit_niepan

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

function public:GetTexture()
	return 'item_0501'
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACKED,
	}
	return funcs
end

--------------------------------------------------------------------------------

function public:OnAttacked(keys)
	if IsServer() then
		local attacker = keys.attacker
		if attacker == self:GetCaster() and keys.target ~= self:GetCaster() and RandomFloat(0, 100) <= 20 then
			local info = 
		    {
		        Ability = attacker:FindAbilityByName("ability_shushan_jump"),
		        EffectName = "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf",
		        vSpawnOrigin = attacker:GetOrigin(),
		        fDistance = 800,
		        fStartRadius = 256,
		        fEndRadius = 256,
		        Source = attacker,
		        bHasFrontalCone = false,
		        bReplaceExisting = false,
		        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		        fExpireTime = GameRules:GetGameTime() + 10.0,
		        bDeleteOnHit = false,
		        vVelocity = attacker:GetForwardVector() * 1600,
		        bProvidesVision = true,
		        iVisionRadius = 300,
		        iVisionTeamNumber = attacker:GetTeamNumber(),
		        ExtraData = {modifier="modifier_item_suit_niepan"}
		    }
		    ProjectileManager:CreateLinearProjectile(info)
		end
	end
end

--------------------------------------------------------------------------------

function public:OnProjectileHit(hTarget)
	if IsServer() then
		UnitDamageTarget({
			victim = hTarget,
			attacker = self:GetCaster(),
			damage_percent = 4
		})
	end
end

--------------------------------------------------------------------------------
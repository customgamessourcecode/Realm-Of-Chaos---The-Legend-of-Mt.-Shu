fb_20_boss_fushuizhifeng_ability03 = class({})
LinkLuaModifier("modifier_fb_20_boss_fushuizhifeng_fire_debuff","modifiers/abilities/modifier_fb_20_boss_fushuizhifeng_fire_debuff",LUA_MODIFIER_MOTION_NONE)

_G["FB20fushuizhifengCheckHeight"] = function (caster)
	if caster:GetOrigin().z >= 456 then
		FindClearSpaceForUnit(caster, caster:GetOrigin() + RandomVector(150), true)
		FB20fushuizhifengCheckHeight(caster)
	end
end

local public = fb_20_boss_fushuizhifeng_ability03

function public:OnSpellStart()
	local caster = self:GetCaster()
	local origin = caster:GetOrigin()
	local endPoint = self:GetCursorPosition()
	local face = (endPoint - origin):Normalized()
	face.z = 0

	-- 残影特效
	local p = ParticleManager:CreateParticle("particles/avalon/abilities/fb_boss_fushuizhifeng/fb_20_boss_fushuizhifeng_ability03.vpcf", 
											PATTACH_CUSTOMORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(p, 0, caster:GetOrigin())
	self.__particle = p

	-- 眩晕
	caster:AddNewModifier(caster, nil, "modifier_custom_stun", {duration=5})
	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_3)

	local info = 
    {
        Ability = self,
        EffectName = "",
        vSpawnOrigin = origin,
        fDistance = 2000,
        fStartRadius = 360,
        fEndRadius = 360,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10.0,
        bDeleteOnHit = false,
        vVelocity = face * 2500,
        bProvidesVision = true,
        iVisionRadius = 300,
        iVisionTeamNumber = caster:GetTeamNumber()
    }
    self.__projectile = ProjectileManager:CreateLinearProjectile(info)
end

function public:OnProjectileHit(hTarget, vLocation)
	if hTarget then
		hTarget:AddNewModifier(self:GetCaster(), nil, "modifier_fb_20_boss_fushuizhifeng_fire_debuff", nil)
		local damage_table = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetAbilityDamage(),
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
		ApplyDamage(damage_table)
	else
		self:GetCaster():RemoveModifierByName("modifier_custom_stun")
		FindClearSpaceForUnit(self:GetCaster(), vLocation, true)
		FB20fushuizhifengCheckHeight(caster)
		self:GetCaster():RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_3)
		ParticleManager:DestroyParticle(self.__particle, false)
	end
end

function public:OnProjectileThink(vLocation)
	local caster = self:GetCaster()
	if GridNav:IsBlocked(vLocation) or not GridNav:IsTraversable(vLocation) then
		self:GetCaster():RemoveModifierByName("modifier_custom_stun")
		ProjectileManager:DestroyLinearProjectile(self.__projectile)
		FindClearSpaceForUnit(self:GetCaster(), vLocation, true)
		FB20fushuizhifengCheckHeight(caster)
		self:GetCaster():RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_3)
		ParticleManager:DestroyParticle(self.__particle, false)
		return
	end
	caster:SetOrigin(GetGroundPosition(vLocation, caster))
end

function public:GetCastRange()
	return 2000
end


--[[
此处实现凤凰变蛋重生，从Damage Filter中进入
]]
function public:OnDamageFilter(attacker, damage)
	local caster = self:GetCaster()
	if damage - caster:GetHealth() >= 0 and self.__in_respawn_egg ~= true then
		self.__in_respawn_egg = true
		caster:AddNoDraw()
		caster:AddNewModifier(caster, nil, "modifier_invulnerable", {duration=15})
		caster:AddNewModifier(caster, nil, "modifier_custom_stun", {duration=15})

		local unit = CreateUnitByName("shushan_fushuizhifeng_egg", caster:GetOrigin(), false, nil, nil, caster:GetTeam())
		unit:SetBaseMaxHealth(caster:GetMaxHealth()*0.25)
		unit:SetMaxHealth(caster:GetMaxHealth()*0.25)
		unit:SetHealth(unit:GetMaxHealth())
		unit:SetPhysicalArmorBaseValue(caster:GetPhysicalArmorValue())
		unit:SetOrigin(unit:GetOrigin() + Vector(0,0,256))
		unit:SetModelScale(1.6)

		local endTime = GameRules:GetGameTime() + 10
		Timer("fb_20_boss_fushuizhifeng_ability03_OnDamageFilter", caster, 1, function ()

			if GameRules:GetGameTime() >= endTime then
				if not unit:IsNull() and unit:IsAlive() then
					caster:RemoveNoDraw()
					caster:RemoveModifierByName("modifier_invulnerable")
					caster:RemoveModifierByName("modifier_custom_stun")
					caster:SetHealth(caster:GetMaxHealth())
					unit:AddNoDraw()
					unit:ForceKill(true)
					self.__in_respawn_egg = false

					local p = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", 
															PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(p,0,caster:GetOrigin())
					ParticleManager:SetParticleControl(p,1,Vector(1000,1000,1000))
					ParticleManager:SetParticleControl(p,2,caster:GetOrigin())
					ParticleManager:DestroyParticleSystem(p)

					local enemies = FindUnitsInRadiusForAbility(self, caster:GetOrigin(), 1000)
					local t = {
						attacker = caster,
						damage = 300000,
						damage_type = DAMAGE_TYPE_MAGICAL,
					}
					for i,v in ipairs(enemies) do
						t.victim = v
						v:AddNewModifier(caster, nil, "modifier_stunned", {duration=5})
						ApplyDamage(t)
					end

					return nil
				else
					caster:RemoveNoDraw()
					caster:Kill(nil, attacker)
					return nil
				end
			end

			if unit:IsNull() or not unit:IsAlive() then
				caster:RemoveNoDraw()
				caster:ForceKill(true)
				return nil
			end
				
			return 0.1
		end)
		return true
	end

	if self.__in_respawn_egg == true then
		return true
	end

	return false
end
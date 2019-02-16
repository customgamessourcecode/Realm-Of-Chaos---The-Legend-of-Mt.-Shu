
function ShuShanFBUnitCommon( keys )
	if GameRules:GetCustomGameDifficulty() >= 3 then
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_shushan_fb_unit_common_move_speed", nil)
	end
end

function fb_03_boss_jiulongzhaizhaizhu_ability01(keys)
	local caster = keys.caster
	local ability = keys.ability
	ability:StartCooldown(ability:GetCooldown(1))
	caster:RemoveModifierByName("modifier_fb_03_boss_jiulongzhaizhaizhu_ability01")
	
	Timer("fb_03_boss_jiulongzhaizhaizhu_ability01", caster, function ()
		if ability:IsCooldownReady() then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_fb_03_boss_jiulongzhaizhaizhu_ability01", nil)
			return nil
		end
		return 1
	end)
end

function fb_07_boss_hunmobingyanzhenjun_ability01_precast( keys )
	local caster = keys.caster

	if RollPercentage(50) then
		keys.ability.__is_fire = true
	else
		keys.ability.__is_fire = false
	end

	local p = ParticleManager:CreateParticle("particles/avalon/boss_ready_cast_ability.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
	ParticleManager:SetParticleControl(p,0,caster:GetOrigin())
	ParticleManager:SetParticleControl(p,1,caster:GetOrigin())
	ParticleManager:SetParticleControl(p,2,Vector(1000,0,0))
	ParticleManager:DestroyParticleSystem(p)
end

function fb_07_boss_hunmobingyanzhenjun_ability01_particle( keys )
	local caster = keys.caster
	
	if keys.ability.__is_fire then
		local path = "particles/avalon/abilities/fb_07_boss_hunmobingyanzhenjun_ability01/fb_07_boss_hunmobingyanzhenjun_ability01_for_fire.vpcf"
		local p = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(p, 0, caster:GetOrigin())
		ParticleManager:DestroyParticleSystem(p)
	else
		local path = "particles/avalon/abilities/fb_07_boss_hunmobingyanzhenjun_ability01/fb_07_boss_hunmobingyanzhenjun_ability01.vpcf"
		local p = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(p, 0, caster:GetOrigin())
		ParticleManager:DestroyParticleSystem(p)
	end
end

function fb_07_boss_hunmobingyanzhenjun_ability01(keys)
	local caster = keys.caster

	caster:RemoveModifierByName("modifier_fb_07_boss_hunmobingyanzhenjun_ability01_ice")
	caster:RemoveModifierByName("modifier_fb_07_boss_hunmobingyanzhenjun_ability01_fire")

	if keys.ability.__is_fire then
		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_fb_07_boss_hunmobingyanzhenjun_ability01_fire", nil)
	else
		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_fb_07_boss_hunmobingyanzhenjun_ability01_ice", nil)
	end
end

function fb_07_boss_hunmobingyanzhenjun_ability01_attack_for_ice( keys )
	local caster = keys.caster
	local target = keys.target
	target:RemoveModifierByName("modifier_fb_07_boss_hunmobingyanzhenjun_ability01_fire_debuff")
	if target:HasModifier("modifier_fb_07_boss_hunmobingyanzhenjun_ability01_ice_debuff") then
		target:RemoveModifierByName("modifier_fb_07_boss_hunmobingyanzhenjun_ability01_ice_debuff")
		keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_fb_07_boss_hunmobingyanzhenjun_ability01_ice_effect", nil)
	end
end

function fb_07_boss_hunmobingyanzhenjun_ability01_attack_for_fire( keys )
	local caster = keys.caster
	local target = keys.target
	target:RemoveModifierByName("modifier_fb_07_boss_hunmobingyanzhenjun_ability01_ice_debuff")
	target:RemoveModifierByName("modifier_fb_07_boss_hunmobingyanzhenjun_ability01_ice_effect")
	if target:HasModifier("modifier_fb_07_boss_hunmobingyanzhenjun_ability01_fire_debuff") then
		target:RemoveModifierByName("modifier_fb_07_boss_hunmobingyanzhenjun_ability01_fire_debuff")
		ApplyDamage({
			attacker = caster,
			victim = target,
			damage = keys.Damage or 13000,
			damage_type = DAMAGE_TYPE_MAGICAL,
		})
	end
end

function fb_06_boss_tulingjvshou_ability01( keys )
	local caster = keys.caster
	local ability = keys.ability

	if ability:IsCooldownReady() then
		ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_fb_06_boss_tulingjvshou_ability01_effect", nil)

		local p = ParticleManager:CreateParticle("particles/avalon/boss_ready_cast_ability.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
		ParticleManager:SetParticleControl(p,0,caster:GetOrigin())
		ParticleManager:SetParticleControl(p,1,caster:GetOrigin())
		ParticleManager:SetParticleControl(p,2,Vector(ability:GetSpecialValueFor("radius"),0,0))
		ParticleManager:DestroyParticleSystem(p)
	end
end


------------------------------------------------------------------

function FB19BOSS_DiHen_Ability01( keys )
	local caster = keys.caster
	local origin = GetGroundPosition(caster:GetOrigin(), caster)
	local face = caster:GetForwardVector()
	local angle = 15
	local ability = keys.ability
	local index = 1
	local point = origin + face*keys.Radius
	local isReverse = RollPercentage(50)

	if isReverse then index = -1 end

	Timer("FB19BOSS_DiHen_Ability01", caster, function ()
		if isReverse then
			if angle*index <= -360 then
				return nil
			end
		else
			if angle*index >= 360 then
				return nil
			end
		end

		local pos = RotatePosition(origin, QAngle(0,angle*index,0), point)

		ability:ApplyDataDrivenThinker(caster, pos, "modifier_fb_19_boss_dihen_ability01_damage", {duration=1.5})

		if isReverse then
			index = index - 1
		else
			index = index + 1
		end
		return 0.05
	end)
end

function FB19BOSS_DiHen_Ability02_Random( keys )
	local caster = keys.caster
	local entities = keys.target_entities
	local origin = GetGroundPosition(caster:GetOrigin(), caster)

	local pos = nil

	if entities and #entities > 0 then
		local unit = entities[RandomInt(1, #entities)]
		pos = unit:GetOrigin() + RandomVector(RandomFloat(0, 100))
	end

	if pos == nil then
		pos = origin + RandomVector(RandomFloat(100, 1000))
	end

	keys.ability:ApplyDataDrivenThinker(caster, pos, "modifier_fb_19_boss_dihen_ability02_damage", {duration=2.0})

	local radius = 150
	local p = ParticleManager:CreateParticle("particles/avalon/boss_ready_cast_ability_a.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
	ParticleManager:SetParticleControl(p,0,caster:GetOrigin())
	ParticleManager:SetParticleControl(p,1,pos)
	ParticleManager:SetParticleControl(p,2,Vector(radius,radius,radius))
	ParticleManager:DestroyParticleSystem(p)
	
end

function FB19BOSS_DiHen_Ability02(keys)
	local caster = keys.caster
	local target = keys.target
	local origin = GetGroundPosition(target:GetOrigin(), caster)
	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(p, 0, origin + Vector(0,0,900))
	ParticleManager:SetParticleControl(p, 1, origin)
	ParticleManager:SetParticleControl(p, 2, Vector(1000,0,0))
	ParticleManager:SetParticleControl(p, 3, origin)
	ParticleManager:DestroyParticleSystem(p)
end

function FB19BOSS_DiHen_Ability04( keys )
	local caster = keys.caster
end


function FB13BOSS_Dizangwang_Ability01( keys )
	local caster = keys.caster
	local ability = keys.ability

	local oldUnit = ability.__unit

	if oldUnit == nil or oldUnit:IsNull() or not oldUnit:IsAlive() then
		local unit = CreateUnitByName("fb_13_boss_dizangwang_diting", caster:GetOrigin(), true, nil, nil, caster:GetTeam())
		unit:SetBaseDamageMax(caster:GetBaseDamageMax()*0.25)
		unit:SetBaseDamageMin(caster:GetBaseDamageMin()*0.25)
		unit:SetBaseMaxHealth(caster:GetMaxHealth()*0.5)
		unit:SetMaxHealth(caster:GetMaxHealth()*0.5)
		unit:SetPhysicalArmorBaseValue(caster:GetPhysicalArmorValue())
		unit:SetHealth(unit:GetMaxHealth())
		ability.__unit = oldUnit

		local endTime = GameRules:GetGameTime() + 10
		unit:SetContextThink("FB13BOSS_Dizangwang_Ability01_Think", function ()
			if unit:IsNull() or not unit:IsAlive() then
				return nil
			end

			if GameRules:GetGameTime() >= endTime then
				unit:RemoveSelf()
			end

			return 1
		end, 0)
	end
		
end
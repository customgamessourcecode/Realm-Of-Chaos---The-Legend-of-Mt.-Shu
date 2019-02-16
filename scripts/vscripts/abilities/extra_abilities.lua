
-- 恢复生命值
function abilityShushanCommonHeal( keys )
	if keys.Level ~= nil and keys.ability:GetLevel() < keys.Level then
		return
	end

	local caster = keys.caster
	caster:Heal(caster:GetMaxHealth()*(keys.HealthPercent/100), keys.ability)
end

-- 昆仑剑法
function abilityShushanKunlunjianfa(keys)
	local caster = keys.caster

	local damage_table = {
		victim = keys.target,
		attacker = caster,
		ability = keys.ability,
		damage_percent = 1 + keys.AddDamage/100,
	}
	UnitDamageTarget(damage_table)
end

-- 蜀山心法
function abilityShushanXinFa(keys)
	local caster = keys.caster

	for i=0,5 do
		local ability = caster:GetAbilityByIndex(i)
		if ability and ability:GetLevel() > 0 and ability ~= keys.ability then
			ability:EndCooldown()
		end
	end

	if keys.ability:GetLevel() >= 3 then
		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_ability_shushan_shushanxinfa_heal", {duration=keys.LV3Duration or 1})
	end
end

-- 蜀山心法 - 三重
function abilityShushanXinFa_UseAnyAbility( keys )
	local caster = keys.caster
	if keys.ability:GetLevel() < 4 then
		return
	end

	local damage_table = {
		attacker = caster,
		radius = keys.Radius,
		pos = caster:GetOrigin(),
	}
	DamageSystem:TakeInRadius(damage_table)
end

-- 日轮魔枪计数
function abilityShushanRilunmoqiangCount(keys)
	local caster = keys.caster
	local ability = keys.ability

	if ability.__attack_count == nil then
		ability.__attack_count = 0
	end

	ability.__attack_count = ability.__attack_count + 1

	if ability.__attack_count >= keys.Count then
		ability.__attack_count = 0
		ability.__attack_lock = true
		abilityShushanRilunmoqiangEffect(keys)
	end
end

-- 日轮魔枪
function abilityShushanRilunmoqiang(keys)
	local caster = keys.caster
	local ability = keys.ability

	if ability.__attack_lock == true then
		ability.__attack_lock = false
		local damage_table = {
			victim = keys.target,
			attacker = caster,
			ability = ability,
			damage_percent = 1 + keys.DamagePercent/100,
		}
		UnitDamageTarget(damage_table)
		abilityShushanRilunmoqiangEffect2(keys)
	end
end

-- 贯穿天地
function abilityShushanGuanchuantiandi( keys )
	local caster = keys.caster
	local target = keys.target

	if caster.__Guanchuantiandi_lock == true then return end
	caster.__Guanchuantiandi_lock = true

	local iTeamFilter = DOTA_UNIT_TARGET_TEAM_ENEMY
	local iTypeFilter = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
	local iFlagFilter = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	local iOrder = FIND_CLOSEST
	local units = FindUnitsInRadius(caster:GetTeam(), caster:GetOrigin(), nil, caster:GetAttackRange(), iTeamFilter, iTypeFilter, iFlagFilter, iOrder, false)
	
	local effectIndex1 = ParticleManager:CreateParticle("particles/heroes/gongfa/guanchuantiandi/ability_gongfa_guanchuantiandi.vpcf", PATTACH_CUSTOMORIGIN, caster)
	local face1 = (target:GetOrigin() - caster:GetOrigin()):Normalized()
	ParticleManager:SetParticleControl(effectIndex1 , 0, target:GetOrigin()+face1*200)
	face1 = (caster:GetOrigin() - target:GetOrigin()):Normalized()
	ParticleManager:SetParticleControlForward(effectIndex1, 0, face1)
	ParticleManager:DestroyParticleSystem(effectIndex1)

	local count = 0
	for i=1,#units do
		local unit = units[i]

		if unit ~= target and not unit:IsNull() and unit:IsAlive() then

			caster:PerformAttack(unit,false,true,true,false,false,false,false)

			local face = (unit:GetOrigin() - caster:GetOrigin()):Normalized()

			local effectIndex = ParticleManager:CreateParticle("particles/heroes/gongfa/guanchuantiandi/ability_gongfa_guanchuantiandi.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(effectIndex , 0, unit:GetOrigin()+face*200)
			face = (caster:GetOrigin() - unit:GetOrigin()):Normalized()
			ParticleManager:SetParticleControlForward(effectIndex, 0, face)
			ParticleManager:DestroyParticleSystem(effectIndex)
			count = count + 1
			
		end

		if count >= keys.ExtraTargetCount then
			break
		end
	end

	caster.__Guanchuantiandi_lock = false
end

-- 殊途同归
function abilityShushanShututonggui( keys )
	local caster = keys.caster
	caster:ModifyHealth(caster:GetHealth()*(keys.HealthPercent/100),keys.ability,true,0)
end

-- 玄冰宫心法 一重
function abilityShushanXuanbinggongxinfa( keys )
	if keys.ability:GetLevel() < 2 then
		return
	end

	local damage_table = {
		victim = keys.target,
		attacker = keys.caster,
	}
	UnitDamageTarget(damage_table)
end

-- 玄冰宫心法 三重
function abilityShushanXuanbinggongxinfaForOnAttacked( keys )
	if keys.ability:GetLevel() < 4 then
		return
	end

	local duration = keys.Duration or 1
	if GameRules:GetCustomGameDifficulty() >= 4 then
		duration = duration/2
	end

	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.attacker, "modifier_ability_shushan_xuanbinggongxinfa_frozen", {duration=duration})

	local damage_table = {
		victim = keys.attacker,
		attacker = keys.caster,
	}
	UnitDamageTarget(damage_table)
end

-- 昆仑心法
function abilityShushanKunlunxinfaDamage( keys )
	local caster = keys.caster

	local damage_percent = 1
	local damage_increase = 1

	-- 一重
	if keys.ability:GetLevel() < 2 then
		damage_percent = keys.DamagePercent/100
	end

	-- 三重
	if keys.ability:GetLevel() < 5 then
		damage_increase = keys.DamageIncrease or 1.0
	end

	local damage_table = {
		victim = keys.target,
		attacker = caster,
		damage_percent = damage_percent,
		damage_increase = damage_increase,
	}
	UnitDamageTarget(damage_table)
end

-- 妖神心法
function abilityShushanYaoshenxinfaDamage( keys )
	if keys.ability:GetLevel() < 4 then
		return
	end

	local damage_table = {
		victim = keys.target,
		attacker = keys.caster,
	}
	UnitDamageTarget(damage_table)
end

-- 佛门心法
function abilityShushanFomenxinfa( keys )
	if not keys.ability:IsCooldownReady() then
		return
	end
	local caster = keys.caster

	HeroRespawnManager(caster, "Fomenxinfa", keys.ability)
end

-- 佛门心法
function abilityShushanFomenxinfaDamage( keys )
	if keys.ability:GetLevel() < 3 then
		return
	end

	local damage_table = {
		victim = keys.target,
		attacker = keys.caster,
		damage_increase = 0.5,
	}
	UnitDamageTarget(damage_table)
end

-- 巫族心法 - 二重
function abilityShushanWuzuxinfaDamage( keys )
	if keys.ability:GetLevel() < 2 then
		return
	end
	local caster = keys.caster

	local damage_table = {
		attacker = caster,
		radius = keys.Radius,
		pos = caster:GetOrigin(),
	}
	DamageSystem:TakeInRadius(damage_table)
end

function abilityShushanSanqingxinfa_GetMasterModifier( caster )
	-- if caster:GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH then
	-- 	return "modifier_ability_shushan_sanqingxinfa_strength"
	-- elseif caster:GetPrimaryAttribute() == DOTA_ATTRIBUTE_AGILITY then
	-- 	return "modifier_ability_shushan_sanqingxinfa_agility"
	-- elseif caster:GetPrimaryAttribute() == DOTA_ATTRIBUTE_INTELLECT then
	-- 	return "modifier_ability_shushan_sanqingxinfa_intellect"
	-- end
	return "modifier_ability_shushan_sanqingxinfa_effect"
end

-- 三清心法
function abilityShushanSanqingxinfa( keys )
	local caster = keys.caster

	local master_modifier = abilityShushanSanqingxinfa_GetMasterModifier(caster)

	if not caster:HasModifier(master_modifier) then
		keys.ability:ApplyDataDrivenModifier(caster, caster, master_modifier, nil)
	end

	local stackCount = caster:GetModifierStackCount(master_modifier, caster)
	if stackCount >= keys.MaxStackCount then
		return
	end

	caster:SetModifierStackCount(master_modifier, caster, stackCount + 1)
	caster:SetModifierStackCount("modifier_ability_shushan_sanqingxinfa_attack", caster, stackCount + 1)
	caster:SetCustomAttribute(shushan_GetWeaponType(caster).."_coefficient",'abilityShushanSanqingxinfa', stackCount + 1)
end

-- 三清心法 死亡
function abilityShushanSanqingxinfaOnDeath( keys )
	local caster = keys.caster
	local master_modifier = abilityShushanSanqingxinfa_GetMasterModifier(caster)
	local stackCount = caster:GetModifierStackCount(master_modifier, caster)

	local count = math.floor(stackCount/2)
	caster:SetModifierStackCount(master_modifier, caster, count)
	caster:SetModifierStackCount("modifier_ability_shushan_sanqingxinfa_attack", caster, count)
	caster:SetCustomAttribute(shushan_GetWeaponType(caster).."_coefficient",'abilityShushanSanqingxinfa',count)
end

-- 三清心法 二重
function abilityShushanSanqingxinfaDamage( keys )
	if keys.ability:GetLevel() < 2 then
		return
	end
	local caster = keys.caster
	local damage_percent = 1
	local master_modifier = abilityShushanSanqingxinfa_GetMasterModifier(caster)

	if caster:HasModifier(master_modifier) then
		damage_percent = damage_percent + caster:GetModifierStackCount(master_modifier, caster)*0.01
	end

	local damage_table = {
		attacker = caster,
		radius = keys.Radius,
		pos = caster:GetOrigin(),
		damage_percent = damage_percent,
	}
	DamageSystem:TakeInRadius(damage_table)
end

-- 天道门心法
function abilityShushanTiandaomenxinfaDamage( keys )
	local caster = keys.caster

	local damage_table = {
		attacker = caster,
		radius = keys.Radius,
		pos = caster:GetOrigin(),
	}
	DamageSystem:TakeInRadius(damage_table)
end

-- 昆仑剑法特效
function abilityShushanKunlunjianfaEffect(keys)
	local caster = keys.caster

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/gongfa/kunlunjianfa/ability_gongfa_kunlunjianfa.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, keys.target:GetOrigin())
	ParticleManager:DestroyParticleSystem(effectIndex)
end

-- 断水毒功特效
function abilityShushanDuanshuidugongEffect(keys)
	local caster = keys.caster
	local target = keys.target

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/gongfa/duanshuidugong/ability_gongfa_duanshuidugong.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, target, 5, "absorigin", Vector(0,0,0), true)
	ParticleManager:DestroyParticleSystem(effectIndex)
end



 -- 暗行刃法特效
function abilityShushanAnxingrenfaEffect(keys)
	local caster = keys.caster
	local target = keys.target

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/gongfa/anxingrenfa/ability_gongfa_anxingrenfa.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, target, 5, "absorigin", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 9, target, 5, "absorigin", Vector(0,0,0), true)
	ParticleManager:DestroyParticleSystem(effectIndex)
end                   

-- 日轮魔枪特效
function abilityShushanRilunmoqiangEffect(keys)
	local caster = keys.caster
	local target = keys.target

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/gongfa/rilunmoqiang/ability_gongfa_rilunmoqiang.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex , 0, caster:GetOrigin())
	ParticleManager:SetParticleControlForward(effectIndex, 0, caster:GetForwardVector())
	ParticleManager:DestroyParticleSystem(effectIndex)
	caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2_END,(1/caster:GetBaseAttackTime())*100/caster:GetAttackSpeed())
end

-- 日轮魔枪特效2
function abilityShushanRilunmoqiangEffect2(keys)
	local caster = keys.caster
	local target = keys.target

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/gongfa/rilunmoqiang/ability_gongfa_rilunmoqiang_boom.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, target, 5, "absorigin", Vector(0,0,0), true)
	ParticleManager:DestroyParticleSystem(effectIndex)
end

-- 殊途同归特效
function abilityShushanShututongguiEffect(keys)
	local caster = keys.caster
	local target = keys.target

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/gongfa/shututonggui/ability_gongfa_shututonggui.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, target, 5, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 1, caster, 5, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControl(effectIndex, 15, Vector(200,255,255))
	ParticleManager:DestroyParticleSystem(effectIndex)

	local effectIndex = ParticleManager:CreateParticle("particles/heroes/gongfa/shututonggui/ability_gongfa_shututonggui_body.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(effectIndex , 0, target, 5, "absorigin", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effectIndex , 1, caster, 5, "absorigin", Vector(0,0,0), true)
	local face = (caster:GetOrigin() - target:GetOrigin()):Normalized()
	ParticleManager:SetParticleControlForward(effectIndex, 0, face)
	ParticleManager:DestroyParticleSystem(effectIndex)
end

-- 殊途同归特效
function abilityShushanLiemendaojueEffect(keys)
	local caster = keys.caster
	local target = keys.target

	local rad = GetRadBetweenTwoVec2D(caster:GetOrigin(),target:GetOrigin())
	
	local effectIndex1 = ParticleManager:CreateParticle("particles/heroes/gongfa/liemendaojue/ability_gongfa_liemendaojue.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex1 , 0, caster:GetOrigin()+Vector(math.cos(rad-math.pi/2),math.sin(rad-math.pi/2),0)*50)
	ParticleManager:SetParticleControlForward(effectIndex1, 0, VectorRollByZ(caster:GetForwardVector(),-math.pi/4))
	ParticleManager:DestroyParticleSystem(effectIndex1)

	local effectIndex2 = ParticleManager:CreateParticle("particles/heroes/gongfa/liemendaojue/ability_gongfa_liemendaojue.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex2 , 0, caster:GetOrigin()+Vector(math.cos(rad+math.pi/2),math.sin(rad+math.pi/2),0)*50)
	ParticleManager:SetParticleControlForward(effectIndex2, 0, VectorRollByZ(caster:GetForwardVector(),math.pi/4))
	ParticleManager:DestroyParticleSystem(effectIndex2)
end
function OnLuodu01DealDamage(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targets = keys.target_entities
	for _,v in pairs(targets) do
		local damage_table = {
				victim = v,
				attacker = caster,
				ability = keys.ability,
				damage_type = keys.ability:GetAbilityDamageType(), 
			    damage_flags = keys.ability:GetAbilityTargetFlags()
			}
		UnitDamageTarget(damage_table) 
	end
end

function OnLuodu02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
	local effectIndex
	local plyID =  caster:GetPlayerOwnerID()
	if HasPass(plyID) then
		effectIndex = ParticleManager:CreateParticle("particles/heroes/luodu/ability_luodu_01_vip.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,target)
		ParticleManager:SetParticleControl(effectIndex,0,target:GetOrigin())
	else
		effectIndex = ParticleManager:CreateParticle("particles/heroes/luodu/ability_luodu_01.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,target)
		ParticleManager:SetParticleControl(effectIndex,0,target:GetOrigin())
	end

	ParticleManager:DestroyParticleSystemTime(effectIndex,3.0)
end

function OnLuodu02DealDamage(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
    local damage_table = {
				victim = target,
				attacker = caster,
				ability = keys.ability,
				damage_type = keys.ability:GetAbilityDamageType(), 
			    damage_flags = keys.ability:GetAbilityTargetFlags()
	}
	UnitDamageTarget(damage_table)
end

function OnLuodu03AttackLanded(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target
    local damage_table = {
				victim = target,
				attacker = caster,
				ability = keys.ability,
				damage_type = keys.ability:GetAbilityDamageType(), 
			    damage_flags = keys.ability:GetAbilityTargetFlags()
	}
	UnitDamageTarget(damage_table)

	local plyID =  caster:GetPlayerOwnerID()
	if HasPass(plyID) then
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/byakuren/ability_byakuren_02_vip.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,target)
		ParticleManager:SetParticleControl(effectIndex,0,target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex,1,target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex,2,target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex,3,target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex,6,target:GetOrigin())
	else
		local effectIndex = ParticleManager:CreateParticle("particles/heroes/byakuren/ability_byakuren_02.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,target)
		ParticleManager:SetParticleControl(effectIndex,0,target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex,1,target:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex,2,target:GetOrigin())
	end
end

function OnLuodu04SpellStart(keys)
	local caster = keys.caster
	local plyID =  caster:GetPlayerOwnerID()
	local effectIndex
	if HasPass(plyID) then
		effectIndex = ParticleManager:CreateParticle("particles/heroes/luodu/ability_luodu_04_vip.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,caster)
		ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "follow_origin", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(effectIndex , 1, caster, 5, "follow_origin", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(effectIndex , 3, caster, 5, "follow_origin", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(effectIndex , 6, caster, 5, "follow_origin", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(effectIndex , 7, caster, 5, "follow_origin", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(effectIndex , 8, caster, 5, "follow_origin", Vector(0,0,0), true)
		ParticleManager:SetParticleControlEnt(effectIndex , 9, caster, 5, "follow_origin", Vector(0,0,0), true)
	else
		effectIndex = ParticleManager:CreateParticle("particles/heroes/luodu/ability_luodu_04.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,caster)
		ParticleManager:SetParticleControlEnt(effectIndex , 0, caster, 5, "follow_origin", Vector(0,0,0), true)
	end
	ParticleManager:DestroyParticleSystemTime(effectIndex,10.0)
end

function OnLuodu04Think(keys)
	local caster = keys.caster
	local targets = keys.target_entities
	for _,v in pairs(targets) do
		local damage_table = {
				victim = v,
				attacker = caster,
				ability = keys.ability,
				damage_type = keys.ability:GetAbilityDamageType(), 
			    damage_flags = keys.ability:GetAbilityTargetFlags()
			}
		UnitDamageTarget(damage_table) 
		local effectIndex
		local plyID =  caster:GetPlayerOwnerID()
		if HasPass(plyID) then
			effectIndex = ParticleManager:CreateParticle("particles/heroes/luodu/ability_luodu_04_thunder_b4.vpcf",PATTACH_CUSTOMORIGIN,v)
			ParticleManager:SetParticleControl(effectIndex,0,v:GetOrigin())
			ParticleManager:SetParticleControl(effectIndex, 1, v:GetOrigin())
			ParticleManager:SetParticleControl(effectIndex, 2, v:GetOrigin())
			ParticleManager:SetParticleControl(effectIndex, 3, v:GetOrigin())
			ParticleManager:SetParticleControl(effectIndex, 5, v:GetOrigin())
			ParticleManager:SetParticleControl(effectIndex, 6, v:GetOrigin())
		end
		effectIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification_b.vpcf",PATTACH_CUSTOMORIGIN,v)
		ParticleManager:SetParticleControl(effectIndex,0,v:GetOrigin())
		ParticleManager:SetParticleControl(effectIndex,1,v:GetOrigin())
	end
end

function HuanKong012_Effect( keys )
	local caster = keys.caster
	local target = keys.target
	local path = shushan_GetEffectName(caster,"ability_shushan_huankong012")
	local p = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(p, 0, target:GetOrigin()+Vector(0,0,128))
	ParticleManager:DestroyParticleSystem(p)
end

function HuanKong013( keys )
	local caster = keys.caster
	local point = keys.target_points[1]

	local path = shushan_GetEffectName(caster,"ability_shushan_huankong013")
	local p = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(p, 0, point)
	ParticleManager:SetParticleControl(p, 1, point)
	ParticleManager:SetParticleControl(p, 3, point)
	ParticleManager:DestroyParticleSystem(p)
end

function HuanKong013_Effect( keys )
	local caster = keys.caster
	local target = keys.target
	local path = shushan_GetEffectName(caster,"ability_shushan_huankong013_end")
	local p = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(p, 0, target:GetOrigin())
	ParticleManager:DestroyParticleSystem(p)
end

function HuanKong014( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local targetPoint = target:GetOrigin()
	local endTime = GameRules:GetGameTime() + keys.Duration - 0.8
	local masterFace = (targetPoint - caster:GetOrigin()):Normalized()
	local nextPoint =  targetPoint
	masterFace.z = 0

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_ability_shushan_huankong014_master", {duration=keys.Duration})
	local thinker = ability:ApplyDataDrivenThinker(caster, targetPoint, "modifier_ability_shushan_huankong014", {duration=keys.Duration-0.8})

	local path = shushan_GetEffectName(caster,"ability_shushan_huankong014")
	local p = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(p, 0, caster:GetOrigin())
	ParticleManager:SetParticleControl(p, 1, caster:GetOrigin())
	ParticleManager:SetParticleControlEnt(p, 3, caster, 5, "follow_origin", caster:GetOrigin(), true)
	ParticleManager:SetParticleControl(p, 4, Vector(0.9,0,0))

	if ability.__motion == nil then
		ability.__motion = caster:CreateMotion()
	end

	local motion = ability.__motion
	local dddd = 1

	local iTeamFilter = DOTA_UNIT_TARGET_TEAM_ENEMY
	local iTypeFilter = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
	local iFlagFilter = DOTA_UNIT_TARGET_FLAG_NONE
	iOrder = FIND_UNITS_EVERYWHERE
	local units = FindUnitsInRadius(caster:GetTeam(), targetPoint, nil, keys.Radius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, false)
	table.filter(units, function ( a )
		return a == target
	end)

	local count = #units

	motion:OnStart(function ()
		local path = shushan_GetEffectName(caster,"ability_shushan_huankong014_end")
		local p3 = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(p3, 0, caster:GetOrigin())
		ParticleManager:SetParticleControl(p3, 1, nextPoint)
		ParticleManager:DestroyParticleSystem(p3)
	end)

	motion:OnEnd(function ()
		if GameRules:GetGameTime() >= endTime then
			ParticleManager:DestroyParticle(p, false)
			
			if not target:IsNull() and target:IsAlive() then
				FindClearSpaceForUnit(caster, target:GetOrigin()+target:GetForwardVector()*150, true)
				caster:SetForwardVector(-target:GetForwardVector())

				caster:ForcePlayActivityOnce(ACT_DOTA_CAST_ABILITY_4_END)

				caster:SetContextThink("ability_HuanKong014_end_think", function ()
					local damage_table = {
						victim = target,
						attacker = caster,
						ability = ability,
					}
					UnitDamageTarget(damage_table)
				
					local path = "particles/avalon/abilities/ability_shushan_huankong014/ability_shushan_huankong014_boom.vpcf"
					local p3 = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(p3, 0, targetPoint)
					ParticleManager:SetParticleControl(p3, 3, targetPoint)
					ParticleManager:DestroyParticleSystem(p3)
				end, 0.5)
			else
				FindClearSpaceForUnit(caster, targetPoint, true)
			end
			return
		end

		local path = shushan_GetEffectName(caster,"ability_shushan_huankong014_attack")
		local p2 = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(p2, 0, caster:GetOrigin())
		ParticleManager:SetParticleControlForward(p2,0,masterFace)
		ParticleManager:DestroyParticleSystem(p2)

		Wait(DoUniqueString("HuanKong014"), caster, RandomFloat(0.1, 0.2), function ()
			dddd = dddd * -1

			if not target:IsNull() and target:IsAlive() then
				targetPoint = target:GetOrigin()
			end

			if dddd == -1 then
				if count > 0 and RollPercentage(70) then
					local unit = units[RandomInt(1, count)]
					if unit ~= target and not unit:IsNull() and unit:IsAlive() then
						nextPoint = unit:GetOrigin()
					else
						nextPoint = targetPoint + RandomVector((keys.Radius/2))
					end
				else
					nextPoint = targetPoint + RandomVector((keys.Radius/2))
				end
			else
				nextPoint = targetPoint - masterFace*RandomFloat(128, 256)
			end
			masterFace = (nextPoint-caster:GetOrigin()):Normalized()
			masterFace.z = 0
			nextPoint = nextPoint + masterFace*RandomFloat(128, 256)
			caster:SetForwardVector(masterFace)
			motion:Linear(caster:GetOrigin(), nextPoint, 0, 0.06, "modifier_custom_stun2")
		end)
	end)

	motion:Linear(caster:GetOrigin(), targetPoint+masterFace*RandomFloat(128, 256), 0, 0.06, "modifier_custom_stun2")
end

function HuanKong014_Attack( keys )
	keys.caster:PerformAttack(keys.target,false,true,true,false,false,false,true)
end

function HuanKong014_ForJueXing( keys )
	local caster = keys.caster

	if caster.__juexing_la and not caster:HasModifier("modifier_ability_shushan_huankong014_master") then
		HuanKong014(keys)
	end
end
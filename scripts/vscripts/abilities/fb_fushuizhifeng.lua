
function FB20fushuizhifengAbility01( keys )
	local caster = keys.caster
	local point = keys.target_points[1]

	local height = 500
	local h = 0
	local speed = 500*FrameTime()
	local origin = caster:GetOrigin()
	caster:StartGestureWithPlaybackRate(ACT_DOTA_OVERRIDE_ABILITY_2,0.5)
	caster:AddNewModifier(caster, nil, "modifier_custom_stun", {duration=5})

	caster:SetContextThink("FB20fushuizhifengAbility01Think", function ()

		if GameRules:IsGamePaused() then
			return 0.1
		end
		
		h = h + speed
		caster:SetOrigin(origin + Vector(0,0,h))

		if h >= height then
			FB20fushuizhifengAbility01_MoveToPoint(caster, point, keys.ability, keys.Radius)
			return nil
		end

		return FrameTime()
	end, 0)
end

function FB20fushuizhifengAbility01_MoveToPoint(caster, point, ability, radius)
	local origin = caster:GetOrigin()
	local forward = caster:GetForwardVector()
	local face = (point - origin):Normalized()
	local speed = face*1500*FrameTime()
	caster:SetForwardVector(face)
	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_3)

	local endTime = GameRules:GetGameTime() + ((origin - point):Length2D() / 1500)

	caster:SetContextThink("FB20fushuizhifengAbility01_MoveToPointThink", function ()

		if GameRules:IsGamePaused() then
			return 0.1
		end

		caster:SetOrigin(caster:GetOrigin() + speed)

		if (caster:GetOrigin() - point):Length() <= 50 or GameRules:GetGameTime() >= endTime then
			caster:SetForwardVector(forward)
			caster:RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_3)
			caster:RemoveModifierByName("modifier_custom_stun")

			local p = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(p,0,caster:GetOrigin())
			ParticleManager:SetParticleControl(p,1,Vector(radius,radius,radius))
			ParticleManager:SetParticleControl(p,2,caster:GetOrigin())
			ParticleManager:DestroyParticleSystem(p)

			local enemies = FindUnitsInRadiusForAbility(ability, caster:GetOrigin(), radius)
			local t = {
				attacker = caster,
				damage = ability:GetAbilityDamage(),
				damage_type = DAMAGE_TYPE_MAGICAL,
			}
			for i,v in ipairs(enemies) do
				t.victim = v
				v:AddNewModifier(caster, nil, "modifier_stunned", {duration=ability:GetSpecialValueFor("duration")})
				ApplyDamage(t)
			end

			FindClearSpaceForUnit(caster, caster:GetOrigin(), true)
			FB20fushuizhifengCheckHeight(caster)
			return nil
		end

		return FrameTime()
	end, 0)
end


function FB20fushuizhifengAbility05( keys )
	local caster = keys.caster
	local origin = caster:GetOrigin()
	local forward = caster:GetForwardVector()

	local height = 500
	local h = 0
	local speed = 250*FrameTime()
	local origin = caster:GetOrigin()
	caster:AddNewModifier(caster, nil, "modifier_custom_stun", {duration=keys.Duration*2})

	caster:SetContextThink("FB20fushuizhifengAbility05Think", function ()

		if GameRules:IsGamePaused() then
			return 0.1
		end
		
		h = h + speed
		caster:SetOrigin(origin + Vector(0,0,h))

		if h >= height then
			local p = ParticleManager:CreateParticle("particles/avalon/abilities/fb_boss_fushuizhifeng/fb_20_boss_fushuizhifeng_ability05.vpcf", 
													PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(p,0,GetGroundPosition(caster:GetOrigin(), caster))
			keys.ability.__particle = p

			keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_fb_20_boss_fushuizhifeng_ability05", {duration=keys.Duration})

			caster:AddNewModifier(caster, nil, "modifier_invulnerable_fake", {duration=60})
			return nil
		end

		return FrameTime()
	end, 0)
end

function FB20fushuizhifengAbility05_Destroy( keys )
	local caster = keys.caster
	local origin = caster:GetOrigin()
	local speed = Vector(0,0,-500*FrameTime())
	local minZ = GetGroundPosition(origin, caster).z

	caster:SetContextThink("FB20fushuizhifengAbility05Think", function ()

		if GameRules:IsGamePaused() then
			return 0.1
		end
		
		caster:SetOrigin(caster:GetOrigin() + speed)

		if caster:GetOrigin().z <= minZ then
			caster:RemoveModifierByName("modifier_custom_stun")
			caster:RemoveModifierByName("modifier_invulnerable_fake")
			FindClearSpaceForUnit(caster, caster:GetOrigin(), true)
			ParticleManager:DestroyParticle(keys.ability.__particle, false)

			return nil
		end

		return FrameTime()
	end, 0)
end

function FB20fushuizhifengAbility05Damage( keys )
	local caster = keys.caster
	local target = keys.target

	if target and not target:IsNull() and target:GetOrigin().z <= 456 then
		local t = {
			attacker = caster,
			victim = target,
			damage = keys.ability:GetAbilityDamage(),
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
		ApplyDamage(t)
	end
	
end

function FB20fushuizhifengAbility06( keys )
	local caster = keys.caster
	local origin = caster:GetOrigin()
	local count = keys.Count
	local face = caster:GetForwardVector()
	local angle = 360/count
	local radius = keys.Radius
	local point = origin + face*radius

	for i=1,count do
		local p = RotatePosition(origin, QAngle(0,i*angle,0), point)

		local unit = CreateUnitByName("shushan_fushuizhifeng_egg", p, false, nil, nil, caster:GetTeam())
		unit:SetBaseMaxHealth(caster:GetMaxHealth()*0.1)
		unit:SetHealth(unit:GetMaxHealth())
		unit:SetPhysicalArmorBaseValue(caster:GetPhysicalArmorValue())
		unit:SetOrigin(unit:GetOrigin() + Vector(0,0,256))

		Wait("FB20fushuizhifengAbility06_Think", unit, keys.Duration, function ()
			if not unit:IsNull() and unit:IsAlive() then
				unit:AddNoDraw()
				unit:ForceKill(true)

				if caster:IsNull() or not caster:IsAlive() then
					return nil
				end

				local u = CreateUnitByName("shushan_fushuizhifeng_little", unit:GetOrigin(), true, nil, nil, caster:GetTeam())
				u:SetBaseDamageMax(caster:GetBaseDamageMax()*0.2)
				u:SetBaseDamageMin(caster:GetBaseDamageMin()*0.2)
				u:SetBaseMaxHealth(caster:GetMaxHealth()*0.2)
				u:SetPhysicalArmorBaseValue(caster:GetPhysicalArmorValue())
				u:SetHealth(u:GetMaxHealth())

				local dieTime = GameRules:GetGameTime() + 60
				Timer("FB20fushuizhifengAbility06_Think", u, function ()
					if GameRules:GetGameTime() >= dieTime then
						if not u:IsNull() and u:IsAlive() then
							u:ForceKill(true)
						end
						return nil
					end

					if not caster:IsNull() and caster:IsAlive() then
						u:MoveToPositionAggressive(caster:GetOrigin()+RandomVector(150))
					else
						u:ForceKill(true)
					end
					return 3
				end)

				local path = "particles/avalon/abilities/creature_24_boss/ability02/creature_24_boss_ability02_immortal1.vpcf"
				local p = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN, u)
				ParticleManager:SetParticleControl(p, 0, u:GetOrigin())
				ParticleManager:SetParticleControl(p, 1, Vector(50,50,50))
				ParticleManager:SetParticleControl(p, 2, u:GetOrigin())
				ParticleManager:SetParticleControl(p, 3, u:GetOrigin())
				ParticleManager:DestroyParticleSystem(p)
			end
		end)
	end
end

-- 
local ShuShanFushuizhifengChao = nil
local ShuShanFushuizhifengSpawnEnt = nil
function FB20fushuizhifengAbility07( keys )
	local caster = keys.caster
	local ability = keys.ability
	
	if ShuShanFushuizhifengChao == nil then
		ShuShanFushuizhifengChao = Entities:FindByName(nil, "shushan_fushuizhifeng_chao")
		ShuShanFushuizhifengSpawnEnt = Entities:FindByName(nil, "shushan_fushuizhifeng")
	end

	local point = ShuShanFushuizhifengChao:GetOrigin()
	local origin = caster:GetOrigin()
	local face = (point - origin):Normalized()
	local forward = caster:GetForwardVector()

	local heroList = {}
	EachHero(function ( hero )
		table.insert(heroList,hero)
	end)

	ability.__hero_list_max_count = #heroList
	ability.__hero_list_count = 0
	ability.__hit_count = 0
	ability.__enter_chao = false

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_fb_20_boss_fushuizhifeng_ability07", {duration=60})
	caster:SetForwardVector(face)

	local speed = face*30
	local healCount = 0
	local healMaxCount = 10
	local effectPoint = ShuShanFushuizhifengSpawnEnt:GetOrigin()

	caster:SetContextThink("FB20fushuizhifengAbility07Think", function ()

		if GameRules:IsGamePaused() then
			return 0.1
		end
		
		if ability.__enter_chao then
			healCount = healCount + 1
			caster:Heal(caster:GetMaxHealth() * 0.05, ability)

			if healCount >= healMaxCount then
				for i=0,5 do
					local b = caster:GetAbilityByIndex(i)
					if b ~= nil then b:StartCooldown(3) end
				end

				local a = caster:FindAbilityByName("fb_20_boss_fushuizhifeng_ability01")
				a:EndCooldown()

				caster:RemoveModifierByName("modifier_fb_20_boss_fushuizhifeng_ability07")
				caster:CastAbilityOnPosition(effectPoint, a, -1)
				return nil
			end

			return 1
		else
			caster:SetOrigin(caster:GetOrigin() + speed)

			if (caster:GetOrigin() - point):Length2D() <= 50 then
				ability.__enter_chao = true
				caster:SetForwardVector(forward)
				FindClearSpaceForUnit(caster, caster:GetOrigin(), true)

				for i=1,ability.__hero_list_max_count do
					CreateFB20fushuizhifengAbility07_Ball(caster, ability, effectPoint, heroList)
				end
			end
		end
			

		return FrameTime()
	end, 0)
end

function CreateFB20fushuizhifengAbility07_Ball(caster, ability, effectPoint, heroList)
	if ability.__hero_list_count >= ability.__hero_list_max_count*3 then
		return
	end

	ability.__hero_list_count = ability.__hero_list_count + 1
	local index = RandomInt(0, 6)
	local point = effectPoint - Vector(1,-1,0)*index*200
	local range = 400
	if index == 0 then range = 200 end

	FB20fushuizhifengAbility07_Ball(caster, ability, effectPoint, heroList, point+RandomVector(400))
end

function FB20fushuizhifengAbility07_Ball(caster, ability, effectPoint, heroList, point)
	local effectPath = "particles/avalon/abilities/fb_boss_fushuizhifeng/fb_20_boss_fushuizhifeng_ability07_point.vpcf"
	local p = ParticleManager:CreateParticle(effectPath, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(p, 0, point)
	ParticleManager:DestroyParticleSystemTime(p,20)

	local endTime = GameRules:GetGameTime() + 20

	caster:SetContextThink(DoUniqueString("FB20fushuizhifengAbility07_Ball"), function ()

		if GameRules:GetGameTime() >= endTime then return nil end
		
		for i,unit in ipairs(heroList) do

			if unit:IsAlive() and (unit:GetOrigin() - point):Length2D() <= 180 then
				local info =
			    {
			        Target = caster,
			        Source = unit,
			        Ability = ability,  
			        EffectName = "particles/avalon/abilities/fb_boss_fushuizhifeng/fb_20_boss_fushuizhifeng_ability07_target.vpcf",
			        bDodgeable = false,
			        iMoveSpeed = 3000,
			        bProvidesVision = true,
			        iVisionRadius = 300,
			        iVisionTeamNumber = caster:GetTeamNumber(),
			        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
			    }
			    ProjectileManager:CreateTrackingProjectile(info)
			    ParticleManager:DestroyParticle(p, true)
			    CreateFB20fushuizhifengAbility07_Ball(caster, ability, effectPoint, heroList)
			    return nil
			end
		end

		return 0.1
	end, 0)
end

function FB20fushuizhifengAbility07_Hit( keys )
	local caster = keys.caster
	local ability = keys.ability
	ability.__hit_count = ability.__hit_count + 1

	if ability.__hit_count >= ability.__hero_list_max_count*3 then
		if not caster:HasModifier("modifier_fb_20_boss_fushuizhifeng_ability07") then return end
		if ability.__enter_chao ~= true then return end

		caster:SetContextThink("FB20fushuizhifengAbility07Think", function ()
			return nil
		end,0)

		caster:RemoveModifierByName("modifier_fb_20_boss_fushuizhifeng_ability07")

		local forward = caster:GetForwardVector()
		forward.z = 0
		caster:SetForwardVector(forward)
		caster:SetOrigin(GetGroundPosition(caster:GetOrigin(), caster))
		FindClearSpaceForUnit(caster, caster:GetOrigin(), true)

		local health = caster:GetHealth() - caster:GetMaxHealth()*0.2
		if health <= 0 then
			caster:SetHealth(1)
		else
			caster:SetHealth(health)
		end

		for i=0,5 do
			local b = caster:GetAbilityByIndex(i)
			if b ~= nil then b:StartCooldown(3) end
		end

		local a = caster:FindAbilityByName("fb_20_boss_fushuizhifeng_ability01")
		a:EndCooldown()
		local effectPoint = ShuShanFushuizhifengSpawnEnt:GetOrigin()
		caster:CastAbilityOnPosition(effectPoint, a, -1)
		
		return
	end
end
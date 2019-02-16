
--[[
闪烁
]]
function blink(keys)
	FindClearSpaceForUnit(keys.caster, keys.ability:GetCursorPosition(), true)
	keys.caster:EmitSound("ShuShanAbilities.blink")
	keys.caster:Stop()
end

--[[
传送
]]
local teleport_points = nil
function Teleport(keys)
	local point = keys.target_points[1]

	if teleport_points == nil then
		teleport_points = {}
		for k in pairs(ItemsKV) do
			if string.find(k,"item_teleport_") == 1 then
				local entity = Entities:FindByName(nil, k)
				if entity then
					table.insert(teleport_points,entity:GetOrigin())
				end
			end
		end
		if ShushanFort then
			table.insert(teleport_points,ShushanFort:GetOrigin() - Vector(220,220,0))
		end
	end

	local len = -1
	local end_point = nil
	for i,v in ipairs(teleport_points) do
		if (v-point):Length2D() <= len or len == -1 then
			len = (v-point):Length2D()
			end_point = v
		end
	end

	if end_point then
		FindClearSpaceForUnit(keys.caster, end_point, true)
		keys.caster:CameraLock(0.1)
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "ability_shushan_teleport", {duration=0.1})
	end
end

--[[
升级物品
]]
function LevelUpItem( keys )
	if keys.unit:IsAlive() then
		return
	end
	local unitname = keys.unit:GetUnitName()
	if string.find(unitname,"_boss_") == nil then
		return
	end
	local str = string.match(unitname,"LV(%d+)_")
	local level = tonumber(str)
	if level == nil then return end

	if level >= keys.RequireLevel then
		keys.caster:RemoveItem(keys.ability)
		keys.caster:AddItemByName(keys.Item)
	end
end

--[[
买活
]]
function ShuShanBuyback( keys )
	local caster = keys.caster
	local hero = caster:GetOwner()
	local ability = keys.ability
	if hero:IsAlive() then
		if ability:GetCooldownTimeRemaining() >= ability:GetCooldown(1)-1 then
			ability:EndCooldown()
		end
		return
	end

	local minute = GameRules:GetGameTime()/60
	local gold = math.floor(minute*1000)
	if hero:SpendGold(gold) then
		hero:RespawnHero( false, false )
	else
		ability:EndCooldown()
	end
end

--[[
自动拾取物品
]]
function AutoPickUp( keys )
	local caster = keys.caster
	
	caster:SetContextThink("CourireAutoPickUpThink", function ()
		if GameRules:IsGamePaused() then
			return 0.1
		end

		local containerList = Entities:FindAllByClassnameWithin("dota_item_drop", caster:GetOrigin(), 1000)

		table.filter(containerList, function ( container )
			return not BagCtrl:CourierCanPickup(caster, container:GetContainedItem(), true)
		end)

		if #containerList == 0 then return nil end

		local container = containerList[1]
		local len = (caster:GetOrigin() - container:GetOrigin()):Length2D()

		for i,v in ipairs(containerList) do
			if (caster:GetOrigin() - v:GetOrigin()):Length2D() < len then
				len = (caster:GetOrigin() - container:GetOrigin()):Length2D()
				container = v
			end
		end
		
		caster:PickupDroppedItem(container)
		return 0.5
	end, 0)
end

--[[
跳跃
]]
-- local JumpMotions = {}
function ShushanJump(keys)
	-- local caster = keys.caster
	-- local motion = JumpMotions[caster:GetEntityIndex()]

	-- -- 注册移动器
	-- if motion == nil then
	-- 	local firstAnimation = false
	-- 	local secondAnimation = false
	-- 	motion = caster:CreateMotion()
	-- 	motion:SetDelayToDeleteStun(0.9)

	-- 	motion:OnStart(function ()
	-- 		firstAnimation = true
	-- 		secondAnimation = true
	-- 		caster:ForcePlayActivityOnce(ACT_JUMP_AUTOGUN)
	-- 	end)

	-- 	motion:OnUpdate(function(time)
	-- 		if time >= 0.1 and firstAnimation then
	-- 			firstAnimation = false
	-- 			caster:ForcePlayActivityOnce(ACT_JUMP)
	-- 		elseif time >= 0.4 and secondAnimation then
	-- 			secondAnimation = false
	-- 			caster:ForcePlayActivityOnce(ACT_JUMP_DUAL)
	-- 		end
	-- 	end)

	-- 	JumpMotions[caster:GetEntityIndex()] = motion
	-- end

	-- if motion:IsRunning() then
	-- 	return
	-- end

	-- -- 启动移动器
	-- local origin = caster:GetOrigin()
	-- local end_pos = keys.target_points[1]
	-- local face = (end_pos - origin):Normalized()
	-- local len = (origin - end_pos):Length2D()
	-- face.z = 0

	-- if GridNav:IsBlocked(end_pos) then
	-- 	return Avalon:Throw(caster,"avalon_can_not_jump_to_here")
	-- end

	-- if len < 200 then
	-- 	len = 200
	-- 	end_pos = origin + face*len
	-- elseif len > 500 then
	-- 	len = 500
	-- 	end_pos = origin + face*len
	-- end

	-- motion:OnEnd(function()
	-- 	local h = origin.z - GetGroundPosition(end_pos, caster).z - 750
	-- 	if h > 0 then
	-- 		local p = h / 100
	-- 		if p >= 1 then
	-- 			caster:ForceKill(true)
	-- 			return
	-- 		else
	-- 			local health = caster:GetMaxHealth()*p
	-- 			if caster:GetHealth() <= health then
	-- 				caster:ForceKill(true)
	-- 				return
	-- 			else
	-- 				caster:SetHealth(caster:GetHealth() - health)
	-- 				if caster:GetHealth() <= 0 then
	-- 					caster:ForceKill(true)
	-- 				end
	-- 				return
	-- 			end
	-- 		end
	-- 	end

	-- 	local newOrigin = caster:GetOrigin()
	-- 	if (motion:GetEndPosition() - newOrigin):Length2D() >= 100 then
	-- 		caster:SetOrigin(origin)
	-- 	end
	-- end)

	-- local height_speed = 2000 * len/500
	
	-- caster:SetForwardVector(face)
	-- motion:Jump(origin, end_pos, height_speed, 0.6, "modifier_custom_stun")
end

function OnEndMotion(caster, ability, motion)
	if not caster:IsFate("canjiren") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_ability_shushan_evade", {})
	end
	if caster:HasModifier("modifier_shushan_mengyan011_action") then
		caster:RemoveModifierByName("modifier_shushan_mengyan011_action")
	end
	local humei013Ability = caster:FindAbilityByName("ability_hsj_humei013")
	if humei013Ability~=nil and humei013Ability:GetLevel()>0 and caster:HasModifier("modifier_ability_humei_013")==false then
		for i=1,4 do
			local targets = FindUnitsInRadius(
					caster:GetTeam(),		--caster team
					caster:GetOrigin(),		--find position
					nil,					--find entity
					800,					--find radius
				    DOTA_UNIT_TARGET_TEAM_ENEMY,
					humei013Ability:GetAbilityTargetType(),
					0, 
					FIND_ANY_ORDER,
					false
			)
			if targets[1]~=nil then
				caster:EmitSound("shushan_humei.abilityhumei013")
				local plyID =  caster:GetPlayerOwnerID()
				local effectName = "particles/heroes/humei/ability_humei_03_attack.vpcf"

				local swordTable = {
					Target = targets[1],
					Source = caster,
					Ability = humei013Ability,	
					EffectName = effectName,
					iMoveSpeed = 1500,
					vSourceLoc= caster:GetAbsOrigin(),
					bDrawsOnMinimap = false, 
			        bDodgeable = true,
			        bIsAttack = false, 
			        bVisibleToEnemies = true,
			        bReplaceExisting = false,
			        flExpireTime = GameRules:GetGameTime() + 10,
					bProvidesVision = true,
					iVisionRadius = 100,
					iVisionTeamNumber = caster:GetTeamNumber(),
					iSourceAttachment = i
				} 
				ProjectileManager:CreateTrackingProjectile(swordTable)
			end
		end
		ability:EndCooldown()
	end
end

--[[
闪避
]]
local EvadeMotions = {}
function ShushanEvade(keys)
	local caster = keys.caster
	local ability = keys.ability
	local motion = EvadeMotions[caster:GetEntityIndex()]

	-- 注册移动器
	if motion == nil then
		motion = caster:CreateMotion()
		motion:SetStopIfBlocked(true)

		motion:OnEnd(function()
			if GameRules:GetGameTime() < motion.__shushan_evade_end_time then
				caster:SetContextThink("ShushanEvadeWaitThink", function ()
					OnEndMotion(caster, ability, motion)
					return nil
				end, motion.__shushan_evade_end_time-GameRules:GetGameTime())
			else
				OnEndMotion(caster, ability, motion)
			end
			
		end)

		-- motion:OnUpdate(function(time)
		-- 	-- caster:StartGesture(ACT_GLIDE)
		-- end)

		EvadeMotions[caster:GetEntityIndex()] = motion
	end

	if motion:IsRunning() then
		return
	end

	-- 启动移动器
	local origin = caster:GetOrigin()
	local face = caster:GetForwardVector()
	face.z = 0
	-- caster:Stop()
	caster:StartGesture(ACT_GLIDE)

	motion.__shushan_evade_end_time = GameRules:GetGameTime() + 0.4

	-- 残影特效
	local p = ParticleManager:CreateParticle("particles/avalon/evade_effect.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(p, 0, caster, 5, "follow_origin", caster:GetOrigin(), true)
	ParticleManager:SetParticleControlForward(p, 0, face)
	ParticleManager:DestroyParticleSystem(p)

	motion:Linear(origin, origin+face*350, 0, 0.4, "modifier_shushan_evade")
end

--[[
造成单体伤害
]]
function DealDamage(keys)
	local caster = keys.caster

	local stackCount = 1

	if keys.LinkModifier then
		stackCount = keys.target:GetModifierStackCount(keys.LinkModifier,caster)
		if stackCount < 1 then stackCount = 1 end
	end

	local damage_table = {
		victim = keys.target,
		attacker = caster,
		ability = keys.ability,
		damage_percent = (keys.DamagePercent or 0)/100 + stackCount,
		damage_increase = keys.DamageIncrease,
	}
	UnitDamageTarget(damage_table)
end

--[[
叠加BUFF
]]
function StackBuff(keys)
	local caster = keys.caster

	if keys.Target == "CASTER" then
		local stackCount = caster:GetModifierStackCount(keys.ModifierName, caster)
		if stackCount >= keys.MaxStackCount then
			return
		end

		if not caster:HasModifier(keys.ModifierName) then
			keys.ability:ApplyDataDrivenModifier(caster, caster, keys.ModifierName, {duration=keys.Duration or 1})
		end

		caster:SetModifierStackCount(keys.ModifierName, caster, stackCount + 1)
		
	else
		local target = keys.target or keys.unit

		if target == nil then return end

		local stackCount = target:GetModifierStackCount(keys.ModifierName, caster)
		if stackCount >= keys.MaxStackCount then
			return
		end

		if not target:HasModifier(keys.ModifierName) then
			keys.ability:ApplyDataDrivenModifier(caster, target, keys.ModifierName, {duration=keys.Duration or 1})
		end

		target:SetModifierStackCount(keys.ModifierName, caster, stackCount + 1)
	end
end

--[[
矿精-闪烁
]]
function BlinkToOre( keys )
	-- local caster = keys.caster
	-- local ability = caster:GetAbilityByIndex(1)
	-- if ability == nil then return end

	-- local str = string.match(ability:GetAbilityName(),".*_lv(%d+)") or "1"
	-- local level = tonumber(str)
	-- if level == nil then return end

	-- for i,v in ipairs(CollectOreSystem.__all_ores) do
	-- 	if not v.__has_spirit_collecting and v.__collect_ore_system_points > 0 then
	-- 		if level >= CollectOreFakeUnitConfig[v:GetUnitName()].Level then
	-- 			FindClearSpaceForUnit(caster, v:GetOrigin()+RandomVector(50), true)
	-- 			caster:CastAbilityOnTarget(v, ability, caster:GetPlayerOwnerID())
	-- 			break
	-- 		end
	-- 	end
	-- end
end

function BlinkToOreThink( keys )
	local caster = keys.caster
	if caster:IsIdle() then
		BlinkToOre( keys )
	end
end


function Stun( keys )
	local target = keys.target or keys.unit
	if target then
		UnitStunTarget( keys.caster, target, keys.Duration )
	end
end

function TotalDamageOutgoingPercentage(keys)
	keys.caster:SetCustomAttribute("damage_outgoing", keys.Name, keys.Percent)
end

function HealHP( keys )
	local caster = keys.caster
	caster:Heal(caster:GetMaxHealth() * (keys.HealPercent/100), keys.ability)
end
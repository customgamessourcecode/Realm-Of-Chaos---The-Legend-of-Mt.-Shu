
function OnUpgrade(keys)
	local caster = keys.caster
	local health_bonus = keys.health_bonus
	local health_percent = caster:GetHealthPercent()

	local stackCount = caster:GetModifierStackCount("modifier_avalon_fort_upgrade",caster)
	if stackCount >= 20 then
		return Avalon:ThrowAll("error_msg_can_not_upgrade_fort_because_maxlevel")
	end
	if stackCount == 0 then
		stackCount = 1
		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_avalon_fort_upgrade", nil)
	end
	local hp = caster:GetMaxHealth() + health_bonus
	caster:SetBaseMaxHealth(hp)
	caster:SetMaxHealth(hp)
	caster:SetHealth(caster:GetMaxHealth() * (health_percent/100))

	caster:SetModifierStackCount("modifier_avalon_fort_upgrade",caster,stackCount+1)

	caster:RemoveModifierByName( "modifier_fixed_armor" )
	Wait(0.5, function ()
		caster:AddNewModifier( caster, nil, "modifier_fixed_armor", nil )
	end)
end

local shushan_stop_times = 0
function OnStop(keys)
	local caster = keys.caster
	local attacking = SpawnSystemCtrl:GetAttackingSpawner()
	local hero = keys.ability.__last_click_hero

	Timer(DoUniqueString("avalon_fort_stop_attacking"),  caster, function ()
		if attacking:IsFinished() or attacking:GetNextWaveRemainingTime() > 0 then
			if GameRules:GetCustomGameDifficulty() > 3 then
				local stopTime = 320 - 80*shushan_stop_times

				if hero and hero:IsFate("tuoyanzhenghuanzhe") then
					stopTime = stopTime + 120
				end

				if stopTime <= 0 then return end
				
				SpawnSystemCtrl:GetAttackingSpawner():Stop(stopTime)
				keys.ability:StartCooldown(420 + 60*shushan_stop_times)

				shushan_stop_times = shushan_stop_times + 1
			else
				local stopTime = 320

				if hero and hero:IsFate("tuoyanzhenghuanzhe") then
					stopTime = stopTime + 120
				end

				SpawnSystemCtrl:GetAttackingSpawner():Stop(stopTime)
				keys.ability:StartCooldown(720)
			end

			return nil
		end
		return 0.2
	end)
	
end

function TeleportToFort(keys)
	local caster = keys.caster

	FindClearSpaceForUnit(caster, ShushanFort:GetOrigin() - Vector(220,220,0), true)
	PlayerResource:SetCameraTarget(caster:GetPlayerID(),caster)

	caster:SetContextThink("TeleportToFort", function()
		PlayerResource:SetCameraTarget(caster:GetPlayerID(),nil)
	end, 0.1)
end
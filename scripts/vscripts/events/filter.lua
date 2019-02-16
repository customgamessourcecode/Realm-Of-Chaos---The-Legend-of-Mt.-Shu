------------------------------------------------------------------------------------------------------------
-- 伤害过滤器
------------------------------------------------------------------------------------------------------------

function Filter:DamageFilter( keys )
	local damage = keys.damage
	local damageType = keys.damagetype_const
	local attacker = EntIndexToHScript(keys.entindex_attacker_const or -1)
	local victim = EntIndexToHScript(keys.entindex_victim_const or -1)
	local victim_unitname = victim:GetUnitName()

	-- 基地检测
	if victim == ShushanFort and victim:HasModifier("modifier_yunlian_defense") then
		local modifier = victim:FindModifierByName("modifier_yunlian_defense")
		return modifier:OnDamageFilter(keys)
	end

	if GameRules:GetCustomGameDifficulty() >= 5 and GameRules:GetCustomGameDifficulty() <= 6
		and attacker and damageType == DAMAGE_TYPE_MAGICAL and attacker:GetTeam() == DOTA_TEAM_BADGUYS then
		keys.damage = keys.damage * 1.5

	elseif GameRules:GetCustomGameDifficulty() >= 7 and attacker and damageType == DAMAGE_TYPE_MAGICAL and attacker:GetTeam() == DOTA_TEAM_BADGUYS then
		keys.damage = keys.damage * 2

	end

	if victim:IsHero() then
		-- 闪避
		if damageType == DAMAGE_TYPE_MAGICAL and (victim:HasModifier("modifier_shushan_evade") or victim:HasModifier("modifier_ability_shushan_luxiao012")) then
			keys.damage = 0
			FateSystem:OnEvadeSuccess(victim,attacker)
			return false
		end

		-- 天罡战翼免疫伤害
		for i=1,5 do
			local modifier = victim:FindModifierByName("tian_gang_zhan_yi_lv0"..i)
			if modifier then
				if modifier:CheckChance() then
					keys.damage = 0
					return false
				end
				break
			end
		end
		----

		-- 寒雪套装免疫伤害
		local modifier = victim:FindModifierByName("modifier_item_suit_hanxue")
		if modifier then
			if modifier:CheckChance() then
				keys.damage = 0
				return false
			end
		end
		----

		-- 娲皇圣造免疫伤害
		if victim:HasItemInInventory("item_0590") then
			if RandomFloat(0, 100) <= 15 then
				keys.damage = 0
				return false
			end
		end
		----
		

		-- 抵消伤害
		if victim:IsFate("qigongdashi") then
			local mana = victim:GetMana()
			if mana >= keys.damage then
				victim:ReduceMana(keys.damage)
				return false
			else
				keys.damage = keys.damage - mana
				victim:ReduceMana(mana)
			end
		end

		if attacker and attacker:GetUnitName() == "LV12_fb_19_boss_dihen" and GetDistanceBetweenTwoVec2D(attacker:GetOrigin(),victim:GetOrigin()) >= 600  then
			return false

		elseif attacker and attacker:GetUnitName() == "LV13_fb_20_boss_fushuizhifeng" then
			if (damageType == DAMAGE_TYPE_PHYSICAL) and
				(
					attacker:HasModifier("modifier_fb_20_boss_fushuizhifeng_ability07") or
					attacker:HasModifier("modifier_invulnerable_fake") or
					attacker:HasModifier("modifier_custom_stun") or
					attacker:IsInvulnerable()
				)
				then
				return false
			end
		end
	end

	-- 
	if attacker:IsHero() then
		if victim_unitname == "LV12_fb_19_boss_dihen" and GetDistanceBetweenTwoVec2D(attacker:GetOrigin(),victim:GetOrigin()) >= 600 then
			return false
		end
		if not GridNav:CanFindPath(attacker:GetOrigin(), victim:GetOrigin()) and victim_unitname ~= "LV12_fb_19_boss_dihen" then
			if not attacker:HasModifier("modifier_ability_shushan_huankong014_master") then
				return false
			end
		end
	end

	-- DPS统计
	-- ShuShanAttackingBossDPS(victim_unitname, attacker, keys.damage)

	-- 稻草人
	if victim_unitname == "npc_dao_cao_ren" then
		-- DaoCaoRenOnDamage(attacker, victim, keys.damage)
		return false

	elseif victim_unitname == "LV13_fb_20_boss_fushuizhifeng" then
		local ability = victim:FindAbilityByName("fb_20_boss_fushuizhifeng_ability03")
		if ability:OnDamageFilter(attacker, keys.damage) then
			return false
		end

	end

	return true
end

------------------------------------------------------------------------------------------------------------
-- 命令过滤器
------------------------------------------------------------------------------------------------------------

function Filter:ExecuteOrderFilter( keys )
	if keys.units["0"] ~= nil then
	    local orderUnit = EntIndexToHScript(keys.units["0"])
	    if orderUnit ~= nil and orderUnit:GetUnitName() == "unit_ore_spirit" then
	    	if keys.order_type ~= DOTA_UNIT_ORDER_CAST_TARGET then
	    		return false
	    	end
	    end
	    if orderUnit ~= nil and orderUnit:HasModifier("modifier_shushan_muyue011_wall") and orderUnit:HasModifier("modifier_shushan_muyue011_pause") == false then
	    	if keys.order_type == 5 then
	    		local ability = EntIndexToHScript(keys.entindex_ability)
	    		local targetPoint = Vector(keys.position_x,keys.position_y,keys.position_z)
	    		if orderUnit:FindAbilityByName("ability_shushan_muyue011") == ability and GetDistanceBetweenTwoVec2D(orderUnit:GetOrigin(),targetPoint)<1000 then
	    			local info = {}
	    			info.caster_entindex = orderUnit:GetEntityIndex()
	    			info.target_points = {}
	    			info.target_points[1] = Vector(keys.position_x,keys.position_y,keys.position_z)
	    			info.ability = ability
	    			OnMuyue011SpellStart(info)
	    			return false
	    		end
	    	end
		end
	end
	return true
end

------------------------------------------------------------------------------------------------------------
-- Modifier过滤器
------------------------------------------------------------------------------------------------------------

function Filter:ModifierGainedFilter( keys )
	-- keys.entindex_parent_const
	-- keys.name_const
	-- keys.duration
	-- keys.entindex_caster_const
	local caster = EntIndexToHScript(keys.entindex_caster_const)
	local parent = EntIndexToHScript(keys.entindex_parent_const)

	if parent:IsHero() 
		and keys.name_const ~= "modifier_shushan_evade" 
		and keys.name_const ~= "modifier_ability_shushan_luxiao012"
		and keys.name_const ~= "modifier_shushan_fb_unit_common_to_enemy" 
		and (parent:HasModifier("modifier_shushan_evade") or parent:HasModifier("modifier_ability_shushan_luxiao012"))
	then
		local caster = EntIndexToHScript(keys.entindex_caster_const)
		if parent:IsOpposingTeam(caster:GetTeam()) then
			FateSystem:OnEvadeSuccess(parent,caster)
			return false
		end
	else
		if GameRules:GetCustomGameDifficulty() >= 5 and parent:HasModifier("modifier_shushan_fb_unit_common_move_speed") then
			parent:Purge(false,true,false,true,false)
		end
		
		if string.find(keys.name_const,"slowdown_debuff") ~= nil then
			for i=1,parent:GetModifierCount() do
				local slowModifierName = parent:GetModifierNameByIndex(i)
				if string.find(slowModifierName,"slowdown_debuff")~=nil and keys.name_const ~= slowModifierName then
					return false
				end
			end
			if caster:GetBaseAttackRange()>200 and (keys.name_const == "modifier_item_0533_slowdown_debuff" or keys.name_const == "modifier_item_0537_slowdown_debuff") then
				return false
			end
		end
	end

	if GameRules:GetCustomGameDifficulty() >= 7 and keys.name_const == "modifier_item_0453_effect" then
		return false
	end
	
	return true
end

------------------------------------------------------------------------------------------------------------
-- 物品添加到物品栏过滤器
------------------------------------------------------------------------------------------------------------

function Filter:ItemAddedToInventory( keys )
	-- local iInventoryParentIndex = keys.inventory_parent_entindex_const
	-- local hInventoryParent = EntIndexToHScript(keys.inventory_parent_entindex_const)

	-- local iItemParentIndex = keys.item_parent_entindex_const
	-- local hItemParent = EntIndexToHScript(keys.item_parent_entindex_const)

	-- local iItemIndex = keys.item_entindex_const
	-- local hItem = EntIndexToHScript(iItemIndex)
	-- suggested_slot

	return BagCtrl:InventoryFilter(keys)
end

------------------------------------------------------------------------------------------------------------
-- 投射物过滤器
------------------------------------------------------------------------------------------------------------

function Filter:TrackingProjectileFilter( keys )
	return true
end

------------------------------------------------------------------------------------------------------------
-- 经验过滤器
------------------------------------------------------------------------------------------------------------

function Filter:ModifyExperienceFilter( keys )
	local player = PlayerResource:GetPlayer(keys.player_id_const)
	if player == nil then return false end

	local hero = player:GetAssignedHero()
	if hero == nil then return false end
	
	if hero:HasVIP() then
		keys.experience = keys.experience * 1.5
	end

	return true
end

------------------------------------------------------------------------------------------------------------
-- 技能值过滤器
------------------------------------------------------------------------------------------------------------

function Filter:AbilityTuningValueFilter( keys )
	return true
end

------------------------------------------------------------------------------------------------------------
-- 神符捡起过滤器
------------------------------------------------------------------------------------------------------------

function Filter:BountyRunePickupFilter( keys )
	return true
end

------------------------------------------------------------------------------------------------------------
-- 神符过滤器
------------------------------------------------------------------------------------------------------------

function Filter:RuneSpawnFilter( keys )
	return true
end

------------------------------------------------------------------------------------------------------------
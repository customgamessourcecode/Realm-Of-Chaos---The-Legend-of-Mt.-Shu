
function RemoveItem(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster

	if (ItemAbility:IsItem()) then
		Caster:RemoveItem(ItemAbility)
	end
end

function RegenHPMP(keys)
	local Target=keys.caster
	local Caster=keys.caster
	if keys.regen_health then
		if Target ~= nil and (Target:IsNull() == false) then
			Target:Heal(keys.regen_health,Target)
		end
	end
	if keys.regen_mana then
		Caster:GiveMana(keys.regen_mana)
	end
end

function IncreaseStats(keys)
	local Caster = keys.caster
	--print("IncreaseStats STR:"..tostring(keys.IncreaseSTR)..",AGI:"..tostring(keys.IncreaseAGI)..",INT:"..tostring(keys.IncreaseINT))
	if keys.IncreaseSTR then
		Caster:SetBaseStrength(Caster:GetBaseStrength() + keys.IncreaseSTR)
	end
	if keys.IncreaseINT then
		Caster:SetBaseIntellect(Caster:GetBaseIntellect() + keys.IncreaseINT)
	end
	if keys.IncreaseAGI then
		Caster:SetBaseAgility(Caster:GetBaseAgility() + keys.IncreaseAGI)
	end
end

function IncreaseRandomAllStats(keys)
	local Caster = keys.caster
	local increase_all_stats=RandomInt(keys.Min,keys.Max)
	Caster:SetBaseStrength(Caster:GetBaseStrength() + increase_all_stats)
	Caster:SetBaseIntellect(Caster:GetBaseIntellect() + increase_all_stats)
	Caster:SetBaseAgility(Caster:GetBaseAgility() + increase_all_stats)
end

function IncreaseRandomHPMAX(keys)
	local Caster = keys.caster
	local increase_maxhp=RandomInt(keys.Min,keys.Max)
	Caster:SetMaxHealth(Caster:GetMaxHealth()+increase_maxhp)
end

function ReturnDamage(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local Attacker = keys.attacker
	local DamageTaken = keys.DamageTaken

	if (Attacker:GetTeam()~=Caster:GetTeam()) then
		local damage_to_deal = DamageTaken*keys.returning_damage_pct/100
		if (damage_to_deal>0) then
			local damage_table = {
				ability = ItemAbility,
				victim = Attacker,
				attacker = Caster,
				damage = damage_to_deal,
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage_flags = 1
			}
			ApplyDamage(damage_table)
		end
	end
end

function DamageTarget(keys)
	local ItemAbility = keys.ability
	local Caster=keys.caster
	local Target=keys.target
	local damage=keys.Damage or 0
	local damage_type=DAMAGE_TYPE_MAGICAL
	if keys.Type=="DAMAGE_TYPE_PURE" then damage_type=DAMAGE_TYPE_PURE 
	elseif keys.Type=="DAMAGE_TYPE_MAGICAL" then damage_type=DAMAGE_TYPE_MAGICAL
	elseif keys.Type=="DAMAGE_TYPE_PHYSICAL" then damage_type=DAMAGE_TYPE_PHYSICAL end

	if keys.CurrentHealthPercentBasedDamage then
		damage=damage+Target:GetHealth()*keys.CurrentHealthPercentBasedDamage*0.01
	end
	if keys.MaxHealthPercentBasedDamage then
		damage=damage+Target:GetMaxHealth()*keys.MaxHealthPercentBasedDamage*0.01
	end
	--print("damage:"..tostring(damage))
	ApplyDamage{
			victim=Target, 
			attacker=Caster, 
			ability=ItemAbility,
			damage=damage,
			damage_type=damage_type,
		}
end

function DecayHealthRegen(keys)
	local Target=keys.unit
	local now_hp=Target:GetHealth()
	local last_hp=Target.decay_health_regen_last_hp or now_hp
	if now_hp>last_hp then
		local new_hp=last_hp+(now_hp-last_hp)*keys.DecayRegenPct*0.01
		--print("last_hp="..tostring(last_hp).." now_hp="..tostring(now_hp).." new_hp="..tostring(new_hp))
		Target:SetHealth(last_hp+(now_hp-last_hp)*keys.DecayRegenPct*0.01)
	end
	Target.decay_health_regen_last_hp=now_hp
end
function DecayHealthRegen_Clear(keys)
	local Target=keys.target
	Target.decay_health_regen_last_hp=nil
end

function Reincarnation_bak(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local CasterHP=Caster:GetHealth()
	-- Change it to your game needs
	local respawnTimeFormula = Caster:GetLevel() * 4

	if CasterHP==0 and ItemAbility:IsCooldownReady() then
		local CasterGold = Caster:GetGold()
		local RespawnPosition = Caster:GetAbsOrigin()

		ItemAbility:StartCooldown(ItemAbility:GetCooldown(ItemAbility:GetLevel()))

		-- Kill, counts as death for the player but doesn't count the kill for the killer unit
		Caster:SetHealth(1)
		Caster:ForceKill(false)
		--Caster:Kill(ItemAbility, Caster)

		-- Set the gold back
		Caster:SetGold(CasterGold, false)

		-- Set the short respawn time and respawn position
		Caster:SetTimeUntilRespawn(5) 
		Caster:SetRespawnPosition(RespawnPosition) 
	--elseif CasterHP==0 then
		-- On Death without reincarnation, set the respawn time to the respawn time formula
		--Caster:SetTimeUntilRespawn(respawnTimeFormula)
	end
end

function Reincarnation_bak2(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local CasterHP=Caster:GetHealth()

	if CasterHP==0 and ItemAbility:IsCooldownReady() and keys.caster~=keys.attacker then
		local CasterGold = Caster:GetGold()
		local RespawnPosition = Caster:GetAbsOrigin()
		local RespawnTime = keys.ReincarnateTime or 5

		Caster:SetHealth(1)

		Caster:SetContextThink(
			"Reincarnation",
			function ()
				Caster:SetTimeUntilRespawn(RespawnTime) 
				Caster:Kill(ItemAbility, Caster)

				Caster:SetGold(CasterGold, false)

				Caster:SetRespawnPosition(Caster:GetAbsOrigin()) 
			end,0)

		if ItemAbility:IsItem() and keys.RemoveItem==1 then
			Caster:RemoveItem(ItemAbility)
		else
			ItemAbility:StartCooldown(ItemAbility:GetCooldown(ItemAbility:GetLevel()))
		end
	end
end

function AddNoDrawForCaster(keys)
	keys.caster:AddNoDraw()
end
function RemoveNoDrawForCaster(keys)
	keys.caster:RemoveNoDraw()
end

function Reincarnation(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local CasterHP=Caster:GetHealth()

	if CasterHP==0 and ItemAbility:IsCooldownReady() then
		local RespawnTime = keys.ReincarnateTime or 5
		Caster:SetHealth(Caster:GetMaxHealth())
		Caster:SetMana(Caster:GetMaxMana())
		ItemAbility:ApplyDataDrivenModifier(Caster,Caster,"modifier_wait_for_reincarnation",{duration=RespawnTime})
		--Caster:AddNewModifier(Caster,ItemAbility,"modifier_item_0152_wait_for_reincarnation",{duration=RespawnTime})

		if ItemAbility:IsItem() and keys.RemoveItem==1 then
			Caster:RemoveItem(ItemAbility)
		else
			ItemAbility:StartCooldown(ItemAbility:GetCooldown(ItemAbility:GetLevel()))
		end
	end
end
function SummonUnit(keys)
	local ItemAbility = keys.ability
	local Caster = keys.caster
	local SummonUnitName=keys.UnitName
	local SummonNum=keys.SummonNum
	local SummonDuration=keys.SummonDuration
	local SummonPos=keys.target_points[1]

	for i=1,SummonNum do
		local unit=CreateUnitByName(SummonUnitName,SummonPos,true,Caster,Caster,Caster:GetTeamNumber())
		unit:AddNewModifier(Caster, ItemAbility, "modifier_kill", {Duration = SummonDuration})
	end
end

function CreateIllusion(keys)
	local ItemAbility = keys.ability
	local Target = keys.caster

	for i=1,keys.illusion_num do
		--create_illusion(keys, illusion_origin, illusion_incoming_damage, illusion_outgoing_damage, illusion_duration)	
		illusion=create_illusion(keys,Target:GetAbsOrigin(),keys.illusion_damage_percent_incoming,keys.illusion_damage_percent_outgoing,keys.illusion_duration)
		if (illusion ~= nil) then
			local CasterAngles = Target:GetAnglesAsVector()
			illusion:SetAngles(CasterAngles.x,CasterAngles.y,CasterAngles.z)
			
			illusion:SetHealth(illusion:GetMaxHealth()*Target:GetHealthPercent()*0.01)
			illusion:SetMana(illusion:GetMaxMana()*Target:GetManaPercent()*0.01)
		end
	end
end

function create_illusion(keys, illusion_origin, illusion_incoming_damage, illusion_outgoing_damage, illusion_duration)	
	local player_id = keys.caster:GetPlayerID()
	local caster_team = keys.caster:GetTeam()
	
	local illusion = CreateUnitByName(keys.caster:GetUnitName(), illusion_origin, true, keys.caster, nil, caster_team)  --handle_UnitOwner needs to be nil, or else it will crash the game.
	illusion:SetPlayerID(player_id)
	illusion:SetControllableByPlayer(player_id, true)

	--Level up the illusion to the caster's level.
	local caster_level = keys.caster:GetLevel()
	for i = 1, caster_level - 1 do
		illusion:HeroLevelUp(false)
	end

	--Set the illusion's available skill points to 0 and teach it the abilities the caster has.
	illusion:SetAbilityPoints(0)
	for ability_slot = 0, 15 do
		local individual_ability = keys.caster:GetAbilityByIndex(ability_slot)
		if individual_ability ~= nil then 
			local illusion_ability = illusion:FindAbilityByName(individual_ability:GetAbilityName())
			if illusion_ability ~= nil then
				illusion_ability:SetLevel(individual_ability:GetLevel())
			end
		end
	end

	--Recreate the caster's items for the illusion.
	--[[for item_slot = 0, 5 do
		local individual_item = keys.caster:GetItemInSlot(item_slot)
		if individual_item ~= nil then
			local illusion_duplicate_item = CreateItem(individual_item:GetName(), illusion, illusion)
			illusion:AddItem(illusion_duplicate_item)
		end
	end]]--
	
	-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle 
	illusion:AddNewModifier(keys.caster, keys.ability, "modifier_illusion", {duration = illusion_duration, outgoing_damage = illusion_outgoing_damage, incoming_damage = illusion_incoming_damage})
	
	illusion:MakeIllusion()  --Without MakeIllusion(), the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.  Without it, IsIllusion() returns false and IsRealHero() returns true.

	return illusion
end
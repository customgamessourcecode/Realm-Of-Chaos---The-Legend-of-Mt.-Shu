
--[[
霜冻新星
]]
function ShuangDongXinXing(keys)
	local path = 'particles/avalon/items/shuangdongxinxing/shuangdongxinxing_cowlofice.vpcf'
	local p = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN, keys.target)
	ParticleManager:SetParticleControl(p, 0, keys.target:GetOrigin())
	ParticleManager:SetParticleControl(p, 1, Vector(180,180,180))
	ParticleManager:SetParticleControl(p, 0, keys.target:GetOrigin())
	ParticleManager:SetParticleControl(p, 3, Vector(180,180,180))
	ParticleManager:DestroyParticleSystem(p)
	keys.target:EmitSound("ShuangDongXinXing.touch")

	DamageSystem:TakeInRadius({
		attacker = keys.caster or keys.attacker,
		pos = keys.target:GetOrigin(),
		radius = 180,
		damage_percent = keys.DamagePercent or 1
	})
end

--[[
造成单体伤害
]]
function ItemDealDamage(keys)
	local caster = keys.caster
	local item = keys.ability

	-- CD限制
	if item:GetCooldown(1) > 0 then
		if not item:IsCooldownReady() then return end
		item:StartCooldown(item:GetCooldown(1))
	end

	-- 攻击次数限制
	if keys.AttackTimes then
		item.__attack_times = (item.__attack_times or 0) + 1

		if item.__attack_times < keys.AttackTimes then
			return
		end

		item.__attack_times = 0
	end
	
	local damage_table = {
		victim = keys.target,
		attacker = caster,
		damage_increase = keys.DamageIncrease,
	}
	UnitDamageTarget(damage_table)
end

--[[
本命法器
]]
function BenMingFaQi(keys)
	local caster = keys.caster
	local item = keys.ability

	if caster.__has_eat_benmingfaqi == true then return end

	ModalDialog(caster, {
		type = "CommonForLua",
		title = "dialog_title_warning",
		text = "shushan_do_you_want_eat_item_0380",
		style = "warning",
		options = {
			{
				key = "YES",
				func = function ()
					caster:ModifyCustomAttribute('str','item_benmingfaqi',item:GetSpecialValueFor("bonus_strength"));
					caster:ModifyCustomAttribute('agi','item_benmingfaqi',item:GetSpecialValueFor("bonus_agility"));
					caster:ModifyCustomAttribute('int','item_benmingfaqi',item:GetSpecialValueFor("bonus_intellect"));
					caster:ModifyCustomAttribute('armor','item_benmingfaqi',item:GetSpecialValueFor("bonus_armor")/2);
					caster:ModifyCustomAttribute('hp','item_benmingfaqi',item:GetSpecialValueFor("bonus_health")/2);
					caster:ModifyCustomAttribute('sword_coefficient','item_benmingfaqi',item:GetSpecialValueFor("weapon_mult_sword")*2);
					caster:ModifyCustomAttribute('knife_coefficient','item_benmingfaqi',item:GetSpecialValueFor("weapon_mult_knife")*2);
					caster:ModifyCustomAttribute('blade_coefficient','item_benmingfaqi',item:GetSpecialValueFor("weapon_mult_blade")*2);
					caster:ModifyCustomAttribute('caster_coefficient','item_benmingfaqi',item:GetSpecialValueFor("weapon_mult_caster")*2);
					caster:ModifyCustomAttribute('lancer_coefficient','item_benmingfaqi',item:GetSpecialValueFor("weapon_mult_lancer")*2);
					caster:RemoveItem(item)
					CustomItemSpellSystem:OnBagChanged(caster)
					caster.__has_eat_benmingfaqi = true
				end,
			},
			{
				key = "NO",
			},
		},
	})
end


function AddModifier(keys)
	local caster = keys.caster

	if keys.Target == "CASTER" then
		caster:AddNewModifier(caster, nil, keys.ModifierName, {duration=keys.Duration or -1})
	else
		local target = keys.target or keys.unit
		target:AddNewModifier(caster, nil, keys.ModifierName, {duration=keys.Duration or -1})
	end
end


function Item0121Effect( keys )
	local caster = keys.caster
	local target = keys.target or keys.unit
	local item = keys.ability

	if target then
		local isBoss = string.find(target:GetUnitName(),"boss") ~= nil
		if isBoss then
			item.__item_0121_kill_boss_count = (item.__item_0121_kill_boss_count or 0) + 1
			if item.__item_0121_kill_boss_count >= 5 then
				caster:RemoveItem(item)
				caster:AddItemByName("item_0531")
			end
		end
	end
end

function Item0119Effect( keys )
	local caster = keys.caster
	local target = keys.target or keys.unit
	local item = keys.ability

	if target then
		item.__item_0119_kill_boss_count = (item.__item_0119_kill_boss_count or 0) + 1
		if item.__item_0119_kill_boss_count >= 100 then
			caster:RemoveItem(item)
			caster:AddItemByName("item_0532")
		end
	end
end
modifier_item_suit_zhanyun = class({})

local public = modifier_item_suit_zhanyun

--------------------------------------------------------------------------------

function public:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function public:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function public:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function public:GetTexture()
	return 'item_0507'
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACKED,
	}
	return funcs
end

--------------------------------------------------------------------------------

function public:OnAttacked(keys)
	if IsServer() then
		local attacker = keys.attacker
		if attacker == self:GetCaster() and keys.target ~= self:GetCaster() and RandomFloat(0, 100) <= 20 then
			local effectIndex = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_leap_impact.vpcf",PATTACH_CUSTOMORIGIN,keys.target)
			ParticleManager:SetParticleControl(effectIndex,0,keys.target:GetOrigin())
			ParticleManager:DestroyParticleSystem(effectIndex)

			local damage_table = {
				attacker = attacker,
				radius = 400,
				pos = keys.target:GetOrigin(),
				damage_increase = 3.0,
			}
			DamageSystem:TakeInRadius(damage_table)
		end
	end
end

--------------------------------------------------------------------------------
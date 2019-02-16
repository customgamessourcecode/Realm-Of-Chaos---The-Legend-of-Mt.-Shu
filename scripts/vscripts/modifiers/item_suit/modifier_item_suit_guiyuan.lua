modifier_item_suit_guiyuan = class({})

local public = modifier_item_suit_guiyuan

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
	return 'item_0504'
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
			local effectIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_transform.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,keys.target)
			ParticleManager:SetParticleControl(effectIndex,0,keys.target:GetOrigin())
			ParticleManager:DestroyParticleSystem(effectIndex)

			UnitDamageTarget({
				victim = keys.target,
				attacker = self:GetCaster(),
				damage_percent = 4
			})
		end
	end
end

--------------------------------------------------------------------------------
modifier_item_suit_binglie = class({})

local public = modifier_item_suit_binglie

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
	return 'item_0535'
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
		local target = keys.target
		local attacker = keys.attacker

		-- 攻击敌人
		if target ~= self:GetCaster() and attacker == self:GetCaster() and RandomFloat(0, 100) <= 40 then
			local path = 'particles/avalon/items/shuangdongxinxing/shuangdongxinxing_cowlofice.vpcf'
			local p = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN, target)
			ParticleManager:SetParticleControl(p, 0, target:GetOrigin())
			ParticleManager:SetParticleControl(p, 1, Vector(180,180,180))
			ParticleManager:SetParticleControl(p, 0, target:GetOrigin())
			ParticleManager:SetParticleControl(p, 3, Vector(180,180,180))
			ParticleManager:DestroyParticleSystem(p)
			keys.target:EmitSound("ShuangDongXinXing.touch")

			DamageSystem:TakeInRadius({
				attacker = attacker,
				pos = target:GetOrigin(),
				radius = 180,
			})
		end
	end
end

--------------------------------------------------------------------------------
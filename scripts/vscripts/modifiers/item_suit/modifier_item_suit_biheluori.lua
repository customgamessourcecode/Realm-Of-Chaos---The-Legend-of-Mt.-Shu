modifier_item_suit_biheluori = class({})

local public = modifier_item_suit_biheluori

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
	return 'item_0021'
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
		if target == self:GetCaster() and keys.attacker ~= self:GetCaster() then
			ApplyDamage({
				attacker = target,
				victim = keys.attacker,
				damage = keys.damage*0.35,
				damage_type = DAMAGE_TYPE_PURE,
			})
		end
	end
end

--------------------------------------------------------------------------------
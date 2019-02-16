modifier_item_suit_bingyan = class({})

local public = modifier_item_suit_bingyan

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
	return 'item_0204'
end

--------------------------------------------------------------------------------

function public:IsAura()
	return true
end

--------------------------------------------------------------------------------

function public:GetModifierAura()
	return "modifier_item_suit_lieyan_damage"
end

--------------------------------------------------------------------------------

function public:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function public:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------

function public:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

--------------------------------------------------------------------------------

function public:GetAuraRadius()
	return 250
end

--------------------------------------------------------------------------------

function public:GetAuraEntityReject( hEntity )
	if IsServer() then
		if self:GetParent() == hEntity then
			return true
		end
	end

	return false
end

--------------------------------------------------------------------------------

function public:OnCreated()
	if IsServer() then
		local path = "particles/avalon/items/item_suit_lieyan/item_suit_lieyan.vpcf"
		local caster = self:GetCaster()
		local p = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(p, 0, caster:GetOrigin())
		ParticleManager:SetParticleControlEnt(p, 1, caster, 5, "attach_hitloc", caster:GetOrigin(), false)
		ParticleManager:SetParticleControl(p, 2, Vector(250,250,250))
		ParticleManager:SetParticleControl(p, 3, Vector(250,0,0))
		ParticleManager:SetParticleControl(p, 4, caster:GetOrigin())
		self.__particle = p
	end
end

--------------------------------------------------------------------------------

function public:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.__particle, false)
	end
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
		if keys.target == self:GetCaster() and keys.attacker ~= self:GetCaster() and RandomFloat(0, 100) <= 5 then
			local duration = 0.5
			if GameRules:GetCustomGameDifficulty() >= 4 then
				duration = duration/2
			end
			keys.attacker:AddNewModifier(keys.target, nil, "modifier_item_suit_bingfeng_effect", {duration=duration})
		end
	end
end

--------------------------------------------------------------------------------
modifier_fb_20_boss_fushuizhifeng_fire_debuff = class({})

local public = modifier_fb_20_boss_fushuizhifeng_fire_debuff

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
	return 'doom_bringer_scorched_earth'
end

--------------------------------------------------------------------------------

function public:GetEffectName()
	return "particles/avalon/abilities/fb_boss_fushuizhifeng/fb_20_boss_fushuizhifeng_ability02.vpcf"
end

--------------------------------------------------------------------------------

function public:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

--------------------------------------------------------------------------------

function public:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

--------------------------------------------------------------------------------

function public:OnIntervalThink()
	if IsServer() then
		local damage_table = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = 50000,
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
		ApplyDamage(damage_table)
	end
end

--------------------------------------------------------------------------------
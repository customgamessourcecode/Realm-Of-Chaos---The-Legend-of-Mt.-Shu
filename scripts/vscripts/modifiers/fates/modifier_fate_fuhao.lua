
modifier_fate_fuhao = class({})

local public = modifier_fate_fuhao

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

function public:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function public:GetTexture()
	return 'alchemist_goblins_greed'
end

--------------------------------------------------------------------------------

function public:OnCreated(keys)
	self:StartIntervalThink(60)
end

--------------------------------------------------------------------------------

function public:OnIntervalThink()
	if IsServer() then
		self:GetCaster():GiveGold(self:OnTooltip())
	end
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	return ShuShan_Modifier_Funcs_Tooltip
end

--------------------------------------------------------------------------------

function public:OnTooltip()
	return 500
end

--------------------------------------------------------------------------------
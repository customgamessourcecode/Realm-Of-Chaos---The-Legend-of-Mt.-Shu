modifier_fate_tonglingshi = class({})

local public = modifier_fate_tonglingshi

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
	return 'abyssal_underlord_cancel_dark_rift'
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end

--------------------------------------------------------------------------------

function public:OnTooltip()
	return 5
end

--------------------------------------------------------------------------------
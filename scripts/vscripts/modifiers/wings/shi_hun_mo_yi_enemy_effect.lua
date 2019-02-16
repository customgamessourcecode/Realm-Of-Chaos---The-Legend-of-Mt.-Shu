
shi_hun_mo_yi_enemy_effect = class({})

local public = shi_hun_mo_yi_enemy_effect

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
	return 'omniknight_guardian_angel'
end

--------------------------------------------------------------------------------

function public:OnCreated(kv)
	if IsServer() then
		self:SetStackCount(1)
	end
end

--------------------------------------------------------------------------------

function public:OnRefresh(kv)
	if IsServer() then
		if self:GetStackCount() >= kv.max_count then
			return
		end

		self:SetStackCount(self:GetStackCount()+1)
	end
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	return ShuShan_Modifier_Funcs_TotalDamageOutgoing
end

--------------------------------------------------------------------------------

function public:GetModifierTotalDamageOutgoing_Percentage()
	return 5*self:GetStackCount()
end

--------------------------------------------------------------------------------
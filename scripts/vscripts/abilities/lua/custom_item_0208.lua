custom_item_0208 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0208

function public:OnCustomSpellStart(item)
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	target.__left_key_ok = true
	CustomNetTables:SetTableValue("Abilities", "custom_item_0208",  {can_not_cast=1})
	OpenXuanBingBaoZang( target )
end

function public:CastFilterResultTarget( hTarget )
	if hTarget:GetUnitName() == "shushan_xuanbingbaozang" then
		local t = CustomNetTables:GetTableValue("Abilities", "custom_item_0208")
		if t and t["can_not_cast"] == 1 then
			return UF_FAIL_OTHER
		end
		return UF_SUCCESS
	end
	return UF_FAIL_OTHER
end
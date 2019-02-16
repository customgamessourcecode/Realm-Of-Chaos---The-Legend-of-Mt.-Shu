custom_item_0495 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0495

function public:OnCustomSpellStart(item)
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local itemname = ""

	if caster:GetUnitLabel() == "shushan_sword" then
		itemname = "item_0469"
	elseif caster:GetUnitLabel() == "shushan_knife" then
		itemname = "item_0470"
	elseif caster:GetUnitLabel() == "shushan_blade" then
		itemname = "item_0471"
	elseif caster:GetUnitLabel() == "shushan_caster" then
		itemname = "item_0472"
	elseif caster:GetUnitLabel() == "shushan_lancer" then
		itemname = "item_0473"
	end

	if itemname == "" then return end

	local item = CreateItem(itemname, nil, nil)
	local container = CreateItemOnPositionSync(target:GetOrigin(), item)
	item:LaunchLoot(false, 256, 1, target:GetOrigin()-target:GetRightVector()*150)
end

function public:CastFilterResultTarget( hTarget )
	if hTarget:GetUnitName() == "shushan_difubaoxiang" then
		return UF_SUCCESS
	end
	return UF_FAIL_OTHER
end
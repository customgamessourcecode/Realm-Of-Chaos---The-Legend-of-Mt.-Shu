custom_item_0104 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0104

function public:OnCustomSpellStart(item)
	local unitname = self:GetCursorTarget():GetUnitName()
	if unitname == 'npc_task_shenmizhita' then
		QuestsCtrl:TouchCustomType(self:GetCaster(), 'custom_item_0104', function (subquest, data)
			if data["Target"] ~= unitname then return false end

			data["Count"] = data["Count"] + 1
			if data["Count"] >= data["MaxCount"] then
				return true
			end
		end)
	end
end
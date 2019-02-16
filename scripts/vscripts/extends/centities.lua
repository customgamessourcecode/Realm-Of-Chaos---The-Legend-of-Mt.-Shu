
--@Class CEntities

function CEntities:FindAllByUnitName(unitName)
	local entity = self:First()
	local list = {}
	while entity do

		if entity:IsBaseNPC() and entity:IsAlive() and entity:GetUnitName() == unitName then
			table.insert(list,entity)
		end

		entity = self:Next(entity)
	end
	return list
end

function CEntities:FindAllByUnitNameList(unitNameList)
	local entity = self:First()
	local list = {}
	while entity do

		if entity:IsBaseNPC() then
			for i,v in ipairs(unitNameList) do
				if entity:GetUnitName() == v then
					table.insert(list,entity)
					break
				end
			end
		end

		entity = self:Next(entity)
	end
	return list
end
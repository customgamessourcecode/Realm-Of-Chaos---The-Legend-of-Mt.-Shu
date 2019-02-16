
--@Class CDOTA_BaseNPC

local ____CDOTA_BaseNPC_SpawnOrigin = Avalon:Forever('____CDOTA_BaseNPC_SpawnOrigin',{})
function CDOTA_BaseNPC:SetSpawnOrigin(vec)
	____CDOTA_BaseNPC_SpawnOrigin[self:GetEntityIndex()] = vec
end

function CDOTA_BaseNPC:GetSpawnOrigin()
	return ____CDOTA_BaseNPC_SpawnOrigin[self:GetEntityIndex()] or self:GetOrigin()
end

function CDOTA_BaseNPC:CameraLock(duration)
	PlayerResource:SetCameraTarget(self:GetPlayerOwnerID(), self)
	self:SetContextThink("__CDOTA_BaseNPC_CameraLock__", function ()
		if GameRules:IsGamePaused() then return 0.1 end
		PlayerResource:SetCameraTarget(self:GetPlayerOwnerID(), nil)
		return nil
	end, duration or 0.1)
end

-- 
function CDOTA_BaseNPC:HasItem( item )
	if not item or item:IsNull() then return false end
	if not self:HasInventory() then return false end

	for i=0,5 do
		local t = self:GetItemInSlot(i)
		if t and not t:IsNull() and t == item then
			return true
		end
	end

	return false
end

function CDOTA_BaseNPC:GetHealthPercent()
	return self:GetHealth() / self:GetMaxHealth() * 100
end



local UnitAI = nil

function Spawn()
	thisEntity.SpawnEnt = SpawnEntity
	thisEntity.IsAIstart = true
	UnitAI=PylAI:Init(thisEntity)

	local children = SpawnEntity:GetChildren()
	if #children > 0 then
		local child = children[#children]
		if child.Disable then
			child:Disable()
		end
	end

	if SpawnEntity.__trigger_effect then
		ParticleManager:DestroyParticle(SpawnEntity.__trigger_effect, true)
	end
end

function Think()
	UnitAI:CreateBaseAI(1500,800)
end


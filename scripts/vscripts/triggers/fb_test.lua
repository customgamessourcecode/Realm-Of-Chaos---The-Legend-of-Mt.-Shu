
function Spawn()
	thisEntity:SetContextThink(DoUniqueString("Trigger"), function ()
		if GameRules:IsGamePaused() then
			return 0.1
		end

		EachHero(function (hero)
			if thisEntity:IsTouching(hero) then
				local spawner = SpawnSystemCtrl:GetDungeonSpawner(thisEntity:GetName())
				if spawner then
					spawner:RefreshDungeon()
				end
				return true
			end
		end)

		return 3
	end, 3)
end

function OnTrigger(keys)
	local activator = keys.activator
	local trigger = keys.caller

	-- local children = trigger:GetChildren()
	-- local child = nil
	-- if #children >= 1 then
	-- 	child = children[RandomInt(1,#children)]
	-- end

	local spawner = SpawnSystemCtrl:GetDungeonSpawner(trigger:GetName())
	if spawner then
		spawner:RefreshDungeon()
	end
end
modifier_yunlian_defense = class({})

local public = modifier_yunlian_defense

--------------------------------------------------------------------------------

function public:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function public:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function public:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	local funcs = {
		-- MODIFIER_EVENT_ON_ATTACKED,
		MODIFIER_PROPERTY_MIN_HEALTH,
	}
	return funcs
end

--------------------------------------------------------------------------------

-- function public:OnAttacked(keys)
-- 	if IsServer() then
-- 		local target = keys.target
-- 		if target == self:GetCaster() then
-- 			if target:GetHealth() <= 50 and self.__yunlian == nil then
-- 				self.__yunlian = CreateUnitByName("npc_yunlian", target:GetOrigin() - Vector(220,220,0), true, nil, nil, DOTA_TEAM_GOODGUYS)
-- 				CustomGameEventManager:Send_ServerToAllClients( "avalon_display_bubble",
-- 					{text="yunlian_defense_spawn_say",unit=self.__yunlian:GetEntityIndex()})

-- 				EachHero(function ( hero )
-- 					hero:ShowCustomMessage({type="left",msg="#avalon_msg_yunlian_defense", duration=10, log=true})
-- 				end)

-- 				Wait("modifier_yunlian_defense", target, 120, function ()
-- 					self.__yunlian:RemoveSelf()
-- 					self:Destroy()

-- 					EachHero(function ( hero )
-- 						hero:ShowCustomMessage({type="left",msg="#avalon_msg_yunlian_defense_leave", duration=10, log=true})
-- 					end)
-- 				end)
-- 			end
-- 		end
-- 	end
-- end

function public:OnDamageFilter(keys)
	if keys.damage - self:GetCaster():GetHealth() >= 0 then
		if self.__yunlian == nil then

			if SpawnSystemCtrl:GetAttackingSpawner():GetWave() >= 12 or GameRules:GetCustomGameDifficulty() >= 4 then
				self.__yunlian = {}

				EachHero(function ( hero )
					hero:ShowCustomMessage({type="left",msg="#avalon_msg_yunlian_not_defense", duration=10, log=true})
				end)

				Wait("modifier_yunlian_defense", self:GetCaster(), 30, function ()
					self:Destroy()
				end)

			else
				self.__yunlian = CreateUnitByName("npc_yunlian", self:GetCaster():GetOrigin() - Vector(220,220,0), true, nil, nil, DOTA_TEAM_GOODGUYS)
				CustomGameEventManager:Send_ServerToAllClients( "avalon_display_bubble",
					{text="yunlian_defense_spawn_say",unit=self.__yunlian:GetEntityIndex()})

				EachHero(function ( hero )
					hero:ShowCustomMessage({type="left",msg="#avalon_msg_yunlian_defense", duration=10, log=true})
				end)

				Wait("modifier_yunlian_defense", self:GetCaster(), 120, function ()
					self.__yunlian:RemoveSelf()
					self:Destroy()

					EachHero(function ( hero )
						hero:ShowCustomMessage({type="left",msg="#avalon_msg_yunlian_defense_leave", duration=10, log=true})
					end)
				end)
			end
				
		end
		return false
	end
	return true
end

--------------------------------------------------------------------------------

function public:GetMinHealth()
	return 1
end

--------------------------------------------------------------------------------
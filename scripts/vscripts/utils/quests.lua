

-- function QuestExampleAcceptFail(keys)
-- 	local quest = keys.quest
-- 	local hero = quest:GetHero()
-- 	print(quest:GetName().." fail")
-- 	for k,v in pairs(keys) do
-- 		print(k,v)
-- 	end
-- end

function ShuShanQuest_Guide_GoToTarget( keys )
	if GameRules:GetCustomGameDifficulty() > 1 then return end

	local quest = keys.quest
	local hero = quest:GetHero()

	local allNPC = QuestsCtrl:GetAllNPC()

	local thisNPC = allNPC[keys.NPC]

	local p = ParticleManager:CreateParticle("particles/avalon/quests/guide_arrow.vpcf", PATTACH_CUSTOMORIGIN, hero)
	local questManager = QuestsCtrl(hero)
	local isTooFar = false
	local isRemove = false

	Timer(DoUniqueString("NoviceGuide"), function ()

		if keys.PreQuests then
			local can = true
			for k,v in pairs(keys.PreQuests) do
				local q = questManager:GetQuest(k)
				if not q or q:GetSubmitCount() < v then
					if not isRemove then
						isRemove = true
						ParticleManager:DestroyParticle(p, true)
					end
					return FrameTime()
				end
			end
		end

		if isRemove then
			isRemove = false
			p = ParticleManager:CreateParticle("particles/avalon/quests/guide_arrow.vpcf", PATTACH_CUSTOMORIGIN, hero)
		end

		local vec1 = thisNPC:GetOrigin()
		local vec2 = hero:GetOrigin()

		local quest = questManager:GetQuest(keys.Quest)

		if quest == nil and keys.Suffixes ~= nil then
			for k,v in pairs(keys.Suffixes) do
				quest = questManager:GetQuest(keys.Quest..v)
				if quest ~= nil then break end
			end
		end

		if quest then
			if keys.IsSumited == 1 then
				if quest:IsSubmited() then
					ParticleManager:DestroyParticle(p, true)
					return nil
				end

			elseif quest:IsAccepted() or quest:GetSubmitCount() > 0 then
				ParticleManager:DestroyParticle(p, true)
				return nil
			end
		end

		if isTooFar == false and (vec1-vec2):Length2D() >= 1000 then
			isTooFar = true
			ParticleManager:DestroyParticle(p, true)
			p = ParticleManager:CreateParticle("particles/avalon/quests/guide_arrow_too_far.vpcf", PATTACH_CUSTOMORIGIN, hero)

		elseif isTooFar and (vec1-vec2):Length2D() < 1000 then
			isTooFar = false
			ParticleManager:DestroyParticle(p, true)
			p = ParticleManager:CreateParticle("particles/avalon/quests/guide_arrow.vpcf", PATTACH_CUSTOMORIGIN, hero)

		end

		ParticleManager:SetParticleControl(p, 0, vec1)
		ParticleManager:SetParticleControl(p, 1, vec2)

		return FrameTime()
	end)
end

function ShuShanQuest_Guide_GoToTarget2( keys )
	if GameRules:GetCustomGameDifficulty() > 1 then return end

	local quest = keys.quest
	local hero = quest:GetHero()

	local allNPC = QuestsCtrl:GetAllNPC()

	local thisNPC = allNPC[keys.NPC]

	local p = ParticleManager:CreateParticle("particles/avalon/quests/guide_arrow_this.vpcf", PATTACH_CUSTOMORIGIN, hero)
	local questManager = QuestsCtrl(hero)

	Timer(DoUniqueString("NoviceGuide"), function ()
		local vec1 = thisNPC:GetOrigin()
		local vec2 = hero:GetOrigin()

		local quest = questManager:GetQuest(keys.Quest)

		if quest == nil and keys.Suffixes ~= nil then
			for k,v in pairs(keys.Suffixes) do
				quest = questManager:GetQuest(keys.Quest..v)
				if quest ~= nil then break end
			end
		end

		if quest then
			if quest:IsAccepted() or quest:GetSubmitCount() > 0 then
				ParticleManager:DestroyParticle(p, true)
				return nil
			end
		end

		ParticleManager:SetParticleControl(p, 0, vec1)
		ParticleManager:SetParticleControl(p, 1, vec2)

		return FrameTime()
	end)
end

function ShuShanQuest_Guide_AddComposeItem( keys )
	if GameRules:GetCustomGameDifficulty() > 1 then return end
	
	local quest = keys.quest
	local hero = quest:GetHero()
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "shushan_item_to_be_collect_add_compose_item", {itemname=keys.ItemName})
end
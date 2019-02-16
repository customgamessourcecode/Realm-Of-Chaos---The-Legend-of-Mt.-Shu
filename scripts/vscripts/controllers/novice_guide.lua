
if NoviceGuide == nil then
	NoviceGuide = RegisterController('novice_guide')
end

local public = NoviceGuide

local arrow_particle = "particles/avalon/quests/guide_arrow.vpcf"

function NoviceGuide:start(hero)
	if GameRules:GetCustomGameDifficulty() > 1 then return end

	local allNPC = QuestsCtrl:GetAllNPC()

	local thisNPC = allNPC["npc_task_fortune_teller"]

	local p = ParticleManager:CreateParticle(arrow_particle, PATTACH_CUSTOMORIGIN, hero)
	local questManager = QuestsCtrl(hero)

	Timer(DoUniqueString("NoviceGuide"), function ()

		local vec1 = thisNPC:GetOrigin()
		local vec2 = hero:GetOrigin()

		local quest = questManager:GetQuest("quest_guide_0001")
		if quest and (quest:IsAccepted() or quest:GetSubmitCount() > 0) then
			ParticleManager:DestroyParticle(p, true)
			return nil
		end

		ParticleManager:SetParticleControl(p, 0, vec1)
		ParticleManager:SetParticleControl(p, 1, vec2)

		return 0.05
	end)
end
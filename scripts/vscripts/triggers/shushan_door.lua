
function OnStartTouch(keys)
	local activator = keys.activator
	local trigger = keys.caller

	local quest = activator:GetQuestsMnanager():GetQuest("quest_tianjianzhixing_02")
	if quest and quest:GetSubmitCount() > 0 then
		return
	end

	local child = trigger:GetChildren()[1]
	if child then
		FindClearSpaceForUnit(activator, child:GetOrigin(), true)
		activator:CameraLock(0.1)
	end
	local NPC = QuestsCtrl:GetAllNPC()["npc_task_shushankanmendizi"]
	CustomGameEventManager:Send_ServerToPlayer(activator:GetPlayerOwner(), "avalon_display_bubble",
		{text="shushan_door_can_not_enter",args={ItemName="item_0059"},unit=NPC:GetEntityIndex()})
	activator:Stop()
end
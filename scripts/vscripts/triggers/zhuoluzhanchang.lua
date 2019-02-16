
local FB10BOSS = {
	"LV9_fb_10_boss_dijianghuanying", --帝江幻影
	"LV9_fb_10_boss_goumanghuanying", --句芒幻影
	"LV9_fb_10_boss_lushouhuanying", --蓐收幻影
	"LV9_fb_10_boss_gonggonghuanying", --共工幻影
	"LV9_fb_10_boss_zhuronghuanying", --祝融幻影
	"LV9_fb_10_boss_zhujiuyinhuanying", --烛九阴幻影
	"LV9_fb_10_boss_qianglianghuanying", --强良幻影
	"LV9_fb_10_boss_shebishihuanying", --奢比尸幻影
	"LV9_fb_10_boss_tianwuhuanying", --天吴幻影
	"LV9_fb_10_boss_yuezihuanying", --龠兹幻影
	"LV9_fb_10_boss_xuanminghuanying", --玄冥幻影
	"LV9_fb_10_boss_houtuhuanying", --后土幻影
	"LV11_fb_10_boss_panguhuanying", --盘古幻影
}
local isStart = false
local stage = 1
local bossList = {}
local thisHero = nil
local spawnEnts = nil

function OnStartTouch(keys)
	local activator = keys.activator
	if thisHero ~= nil then
		if thisHero ~= activator then
			local ent = Entities:FindByName(nil, "zhuoluzhanchang_jump_01")
			activator:SetOrigin(ent:GetOrigin()-Vector(256,0,0))
			return Avalon:Throw(activator,"msg_only_one_player_is_allowed_to_enter")
		end
	end

	thisHero = activator

	if isStart == false then
		isStart = true

		thisEntity:SetContextThink("fb_10_boss_spawner", function ()
			if thisHero ~= nil then
				if #bossList == 0 then
					if spawnEnts == nil then
						spawnEnts = Entities:FindAllByName("FB10BOSS")
					end

					if stage == 1 then
						for i,ent in ipairs(spawnEnts) do
							local boss = CreateUnitByName(FB10BOSS[i], ent:GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
							boss.SpawnEnt = ent
							table.insert(bossList, boss)
							SpawnSystemCtrl:ChangeUnitData(boss)
							boss:AddAbility("shushan_fb_boss_common"):SetLevel(1)
							boss:AddNewModifier(boss, nil, "modifier_shushan_boss", nil)
						end
					elseif stage == 2 then
						for i,ent in ipairs(spawnEnts) do
							local boss = CreateUnitByName(FB10BOSS[i+4], ent:GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
							boss.SpawnEnt = ent
							table.insert(bossList, boss)
							SpawnSystemCtrl:ChangeUnitData(boss)
							boss:AddAbility("shushan_fb_boss_common"):SetLevel(1)
							boss:AddNewModifier(boss, nil, "modifier_shushan_boss", nil)
						end
					elseif stage == 3 then
						for i,ent in ipairs(spawnEnts) do
							local boss = CreateUnitByName(FB10BOSS[i+8], ent:GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
							boss.SpawnEnt = ent
							table.insert(bossList, boss)
							SpawnSystemCtrl:ChangeUnitData(boss)
							boss:AddAbility("shushan_fb_boss_common"):SetLevel(1)
							boss:AddNewModifier(boss, nil, "modifier_shushan_boss", nil)
						end
						local ent = spawnEnts[RandomInt(1, #spawnEnts)]
						panGuBoss = CreateUnitByName(FB10BOSS[13], ent:GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
						panGuBoss.SpawnEnt = ent
						table.insert(bossList, panGuBoss)
						SpawnSystemCtrl:ChangeUnitData(panGuBoss)
						panGuBoss:AddAbility("shushan_fb_boss_common"):SetLevel(1)
						panGuBoss:AddNewModifier(panGuBoss, nil, "modifier_shushan_boss", nil)
					end
					if stage >= 3 then
						stage = 1
					else
						stage = stage + 1
					end
				else
					for i,boss in ipairs(bossList) do
						if not boss:IsNull() and boss:IsAlive() then
							boss:MoveToPositionAggressive(thisHero:GetOrigin())
						end
					end
				end
			else
				for i,boss in ipairs(bossList) do
					if not boss:IsNull() and boss:IsAlive() then
						boss:RemoveSelf()
					end
				end
				stage = 1
				bossList = {}
				isStart = false
				return nil
			end

			table.filter(bossList, function (boss)
				return boss:IsNull() or not boss:IsAlive()
			end)
			return 1
		end, 0)
	end
end

function OnEndTouch(keys)
	local activator = keys.activator
	if activator == thisHero then
		thisHero = nil
	end
end
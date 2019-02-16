
--[[

具有跳跃功能的trigger

trigger接受以下参数
 - jump_type          int    跳跃类型，1为普通跳跃，2为御剑飞行，其他则是直接闪烁过去
 - jump_duration      float  跳跃时间，默认为0.5秒
 - jump_speed  int    跳跃速度，速度越高，高度也就越高，一般根据情况取1000到3000之间即可，默认2000速度

]]

local Motions = {}

function Spawn()
	-- thisEntity:SetContextThink(DoUniqueString("trigger"), function ()
	-- 	local p = ParticleManager:CreateParticle("particles/avalon/teleport_point.vpcf", PATTACH_CUSTOMORIGIN, thisEntity)
	-- 	ParticleManager:SetParticleControl(p, 0, thisEntity:GetOrigin())

		-- local child = thisEntity:GetChildren()[1]
		-- if child then
		-- 	ParticleManager:SetParticleControl(p, 1, child:GetOrigin())
		-- end
	-- end, 10)
	local name = "info_particle_target" .. tostring(thisEntity:GetEntityIndex())

	thisEntity:SetContextThink(DoUniqueString("trigger"), function ()
		local child = thisEntity:GetChildren()[1]
		if child then
			SpawnEntityFromTableSynchronous("info_particle_target", {
				origin = child:GetOrigin(),
				targetname = name,
			})
		end
	end, 1)
		
	thisEntity:SetContextThink(DoUniqueString("trigger"), function ()
		SpawnEntityFromTableSynchronous("info_particle_system",{
			origin = thisEntity:GetOrigin(),
			effect_name = "particles/avalon/teleport_point.vpcf",
			start_active = "1",
			cpoint1 = name,
		})
	end, 3)

			
end

function OnStartTouchResponse(keys)
	local activator = keys.activator
	local trigger = keys.caller
	activator:Stop()

	if activator:HasModifier("modifier_ability_shushan_moluo011_master") or activator:HasModifier("modifier_shushan_luxiao011_pause") then
		return
	end

	local _t = trigger:Attribute_GetIntValue('jump_type',-1)

	local child = trigger:GetChildren()[1]
	if child then

		if _t == 1 then
			local motion = Motions[activator:GetEntityIndex()]

			if motion == nil then
				motion = activator:CreateMotion()
				Motions[activator:GetEntityIndex()] = motion
			end

			if motion:IsRunning() then
				return
			end

			local duration = trigger:Attribute_GetFloatValue('jump_duration',0.5)
			local height_speed = trigger:Attribute_GetIntValue('jump_speed',2000)
			local origin = activator:GetOrigin()
			local len = (origin-child:GetOrigin()):Length2D()
			local end_pos = origin + (child:GetOrigin()-origin):Normalized()*len
			local forward = (end_pos - origin):Normalized()
			forward.z = 0
			activator:SetAngles(0, VectorToAngles(forward).y, 0)
			motion:Jump(origin, end_pos, height_speed, duration, "modifier_custom_stun")

		elseif _t == 2 then
			local motion = Motions[activator:GetEntityIndex()]

			if motion == nil then
				motion = activator:CreateMotion()
				Motions[activator:GetEntityIndex()] = motion
			end

			if motion:IsRunning() then
				return
			end

			local duration = trigger:Attribute_GetFloatValue('jump_duration',0.5)
			local height_speed = trigger:Attribute_GetIntValue('jump_speed',2000)
			local p = ParticleManager:CreateParticle("particles/avalon/yujianfeixing.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, activator)
			ParticleManager:SetParticleControlEnt(p, 0, activator, 5, "follow_origin", activator:GetOrigin(), true)
			ParticleManager:SetParticleControlEnt(p, 3, activator, 5, "follow_origin", activator:GetOrigin(), true)
			ParticleManager:SetParticleControl(p, 1, child:GetOrigin())

			PlayerResource:SetCameraTarget(activator:GetPlayerID(), activator)

			motion:OnEnd(function ()
				PlayerResource:SetCameraTarget(activator:GetPlayerID(), nil)
				ParticleManager:DestroyParticle(p, false)
			end)

			local origin = activator:GetOrigin()
			local len = (origin-child:GetOrigin()):Length2D()
			local end_pos = origin + (child:GetOrigin()-origin):Normalized()*len
			local forward = (end_pos - origin):Normalized()
			forward.z = 0
			activator:SetAngles(0, VectorToAngles(forward).y, 0)
			motion:Jump(origin, end_pos, height_speed, duration, "modifier_custom_stun")
		else
			FindClearSpaceForUnit(activator, child:GetOrigin(), true)
			activator:CameraLock(0.1)
		end
			
	end
end

function OnStartTouch(keys)
	if keys.caller:GetName() == "jifengya_jump_01" then
		ModalDialog(keys.activator, {
			type = "CommonForLua",
			title = "dialog_title_warning",
			text = "shushan_do_you_want_to_go_to_jifengya",
			style = "warning",
			options = {
				{
					key = "YES",
					func = function ()
						if keys.caller:IsTouching(keys.activator) then
							OnStartTouchResponse(keys)
						end
					end,
				},
				{
					key = "NO",
				},
			},
		})
	else
		OnStartTouchResponse(keys)
	end
end
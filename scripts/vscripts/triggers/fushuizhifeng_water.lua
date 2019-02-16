
function OnStartTouch(keys)
	local activator = keys.activator
	local trigger = keys.caller

	activator:SetContextThink("fushuizhifeng_fire_debuff_OnStartTouch", function ()
		if GameRules:IsGamePaused() then
			return 0.1
		end

		if not trigger:IsTouching(activator) then
			return
		end

		if activator:HasModifier("modifier_fb_20_boss_fushuizhifeng_fire_debuff") then
			local path = "particles/avalon/abilities/fb_boss_fushuizhifeng/fb_20_boss_fushuizhifeng_ability02_extinguished.vpcf"
			local p = ParticleManager:CreateParticle(path, PATTACH_CUSTOMORIGIN_FOLLOW, activator)
			ParticleManager:SetParticleControl(p, 0, activator:GetOrigin())
			ParticleManager:DestroyParticleSystem(p)
			activator:RemoveModifierByName("modifier_fb_20_boss_fushuizhifeng_fire_debuff")
		end

		return 0.5
	end, 0)
		
end
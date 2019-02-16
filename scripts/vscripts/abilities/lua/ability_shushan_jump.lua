ability_shushan_jump = class({})

local public = ability_shushan_jump
local JumpMotions = {}

function public:OnSpellStart()
	local caster = self:GetCaster()
	local motion = JumpMotions[caster:GetEntityIndex()]

	-- 注册移动器
	if motion == nil then
		local firstAnimation = false
		local secondAnimation = false
		motion = caster:CreateMotion()
		motion:SetDelayToDeleteStun(0.9)

		motion:OnStart(function ()
			firstAnimation = true
			secondAnimation = true
			caster:ForcePlayActivityOnce(ACT_JUMP_AUTOGUN)
		end)

		motion:OnUpdate(function(time)
			if time >= 0.1 and firstAnimation then
				firstAnimation = false
				caster:ForcePlayActivityOnce(ACT_JUMP)
			elseif time >= 0.4 and secondAnimation then
				secondAnimation = false
				caster:ForcePlayActivityOnce(ACT_JUMP_DUAL)
			end
		end)

		JumpMotions[caster:GetEntityIndex()] = motion
	end

	if motion:IsRunning() then
		return
	end

	-- 启动移动器
	local origin = caster:GetOrigin()
	local end_pos = self:GetCursorPosition()
	if end_pos.z - origin.z >= 500 then return end

	local face = (end_pos - origin):Normalized()
	local len = (origin - end_pos):Length2D()
	face.z = 0

	if GridNav:IsBlocked(end_pos) then
		return Avalon:Throw(caster,"avalon_can_not_jump_to_here")
	end

	if len < 200 then
		len = 200
		end_pos = origin + face*len
	elseif len > 500 then
		len = 500
		end_pos = origin + face*len
	end

	motion:OnEnd(function()
		local h = origin.z - GetGroundPosition(end_pos, caster).z - 750
		if h > 0 then
			local p = h / 100
			if p >= 1 then
				caster:ForceKill(true)
				return
			else
				local health = caster:GetMaxHealth()*p
				if caster:GetHealth() <= health then
					caster:ForceKill(true)
					return
				else
					caster:SetHealth(caster:GetHealth() - health)
					if caster:GetHealth() <= 0 then
						caster:ForceKill(true)
					end
					return
				end
			end
		end

		local newOrigin = caster:GetOrigin()
		if (motion:GetEndPosition() - newOrigin):Length2D() >= 100 then
			caster:SetOrigin(origin)
		end

		if caster:IsFate("julingshenzu") then
			if self.__fate_julingshenzu_endtime == nil or GameRules:GetGameTime() >= self.__fate_julingshenzu_endtime then
				self.__fate_julingshenzu_endtime = GameRules:GetGameTime() + 5

				local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(effect, 0, caster:GetOrigin())
				ParticleManager:SetParticleControl(effect, 1, Vector(256,0,0))
				ParticleManager:DestroyParticleSystem(effect)
				caster:EmitSound("Hero_Centaur.HoofStomp")

				local iTeamFilter = DOTA_UNIT_TARGET_TEAM_ENEMY
				local iTypeFilter = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
				local iFlagFilter = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
				local iOrder = FIND_CLOSEST
				local units = FindUnitsInRadius(caster:GetTeam(), caster:GetOrigin(), nil, 256, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, false)

				for i,v in ipairs(units) do
					UnitStunTarget(caster,v,3)
					UnitDamageTargetSimple(caster,v,nil,10)
				end
			end
		else
			caster:EmitSound("ShuShanAbility.JumpEnd")
		end
	end)

	local height_speed = 2000 * len/500
	
	caster:SetAngles(0, VectorToAngles(face).y, 0)
	caster:EmitSound("ShuShanAbility.JumpStart")
	motion:Jump(origin, end_pos, height_speed, 0.6, "modifier_custom_stun")
end

function public:OnInventoryContentsChanged()
	DelayDispatch(0.15, self:GetEntityIndex(), self.__OnInventoryContentsChanged, self)
end

function public:__OnInventoryContentsChanged()
	CustomItemSpellSystem:OnBagChanged(self:GetCaster())
	ShuShanCanUpgradeStateNotify(self:GetCaster())
end

function public:OnItemEquipped(item)
	if item:GetBehavior() ~= DOTA_ABILITY_BEHAVIOR_PASSIVE then
		DelayDispatch(0.15, self:GetEntityIndex(), self.CustomUpdate, self, item)
	end
end

function public:CustomUpdate(item)
	local hero = self:GetCaster()
	for i=Custom_Item_Spell_System_Slot_Min,Custom_Item_Spell_System_Slot_Max do
		local ability = hero:GetAbilityByIndex(i)
		if ability == nil or string.find(ability:GetAbilityName(),"custom_item_spell_system") == 1 then
			CustomItemSpellSystem:SetSlot(hero, i, item)
			break
		end
	end
end

function public:OnProjectileHit_ExtraData( hTarget, vLocation, data )
	if data["modifier"] ~= nil then
		local modifier = self:GetCaster():FindModifierByName(data["modifier"])
		if modifier then
			modifier:OnProjectileHit(hTarget)
		end
	end
end
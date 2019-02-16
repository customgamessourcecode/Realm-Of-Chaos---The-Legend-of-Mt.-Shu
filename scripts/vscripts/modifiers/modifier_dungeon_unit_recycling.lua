
modifier_dungeon_unit_recycling = class({})

local public = modifier_dungeon_unit_recycling

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

function public:OnCreated()
	if IsServer() then
		self.__dungeon_unit_remove_time = GameRules:GetGameTime() + 30
		self:StartIntervalThink(1)
	end
end

--------------------------------------------------------------------------------

function public:OnIntervalThink()
	if IsServer() then
		if GameRules:GetGameTime() >= self.__dungeon_unit_remove_time then
			self:GetCaster():RemoveSelf()
		end
	end
end

--------------------------------------------------------------------------------

function public:DeclareFunctions()
	return ShuShan_Modifier_Funcs_OnTakeDamage
end

--------------------------------------------------------------------------------

function public:OnTakeDamage(keys)
	if IsServer() then
		if keys.attacker == self:GetCaster() or keys.unit == self:GetCaster() then
			self.__dungeon_unit_remove_time = GameRules:GetGameTime() + 30
		end
	end
end
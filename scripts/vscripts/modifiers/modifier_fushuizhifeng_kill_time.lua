
modifier_fushuizhifeng_kill_time = class({})

local public = modifier_fushuizhifeng_kill_time

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
		self:StartIntervalThink(1)
	end
end

--------------------------------------------------------------------------------

function public:OnIntervalThink()
	if IsServer() then
		if self.__start_time ~= nil then
			
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
			if self.__start_time == nil then
				self.__start_time == GameRules:GetGameTime() + 300
				hero:ShowCustomMessage({
					type="message-box",
					role="???", 
					list={
						{
							text="shushan_kill_fushuizhifeng_start_say",
							args={}
						}
					},
					duration=10,
				})
			end
		end
	end
end

--------------------------------------------------------------------------------
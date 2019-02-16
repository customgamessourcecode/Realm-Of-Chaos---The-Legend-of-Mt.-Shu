modifier_shushan_fort = class({})

local public = modifier_shushan_fort

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
		MODIFIER_EVENT_ON_ATTACKED,
	}
	return funcs
end

--------------------------------------------------------------------------------

function public:OnCreated( kv )
	if IsServer() then
		self.__time = 0
	end
end

function public:OnAttacked(keys)
	if IsServer() then
		local target = keys.target
		if target == self:GetCaster() then
			if GameRules:GetGameTime() >= self.__time then
				self.__time = GameRules:GetGameTime() + 0.5
				EachHero(function ( hero )
					hero:ShowCustomMessage({
						type="message-box",
						role="npc_dota_goodguys_fort", 
						list={
							{
								text="shushan_fort_attacked",
								args={percent = ShushanFort:GetHealthPercent()}
							}
						},
						duration=3,
					})
				end)
			end
		end
	end
end

--------------------------------------------------------------------------------
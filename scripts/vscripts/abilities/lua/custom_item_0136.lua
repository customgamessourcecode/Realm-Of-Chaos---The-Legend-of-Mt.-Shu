custom_item_0136 = CustomItemSpellSystem:GetBaseClass()

local public = custom_item_0136

function public:OnCustomSpellStart(item)
	local caster = self:GetCaster()
	local p = ParticleManager:CreateParticle("particles/avalon/quests/xunbao_digging.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(p, 0, caster:GetOrigin())
	self.__particle_id = p
end

function public:OnCustomChannelFinish(item, bInterrupted)
	if not bInterrupted then
		DigTreasure:FindHit(self:GetCaster())
		DigTreasureItem0591:FindHit(self:GetCaster())
		DigTreasureItem0592:FindHit(self:GetCaster())
	end
	ParticleManager:DestroyParticle(self.__particle_id,false)
end
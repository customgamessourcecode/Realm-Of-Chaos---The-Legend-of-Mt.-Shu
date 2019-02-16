
AvalonParticlesQueueEndTime = Avalon:Forever('AvalonParticlesQueueEndTime',{})

function StartDestroyParticlesQueue()
	Timer(function ()

		local now = GameRules:GetGameTime()
		for index,endTime in pairs(AvalonParticlesQueueEndTime) do
			if now >= endTime then
				ParticleManager:DestroyParticle(index,true)
            	ParticleManager:ReleaseParticleIndex(index)
            	AvalonParticlesQueueEndTime[index] = nil
			end
		end

		return 1
	end)
end
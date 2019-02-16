
function CScriptParticleManager:DestroyParticleSystem(effectIndex,bool)
    if(bool)then
        self:DestroyParticle(effectIndex,true)
        self:ReleaseParticleIndex(effectIndex) 
    else
        AvalonParticlesQueueEndTime[effectIndex] = GameRules:GetGameTime() + 4
    end
end

function CScriptParticleManager:DestroyParticleSystemTime(effectIndex,time)
    AvalonParticlesQueueEndTime[effectIndex] = GameRules:GetGameTime() + time
end
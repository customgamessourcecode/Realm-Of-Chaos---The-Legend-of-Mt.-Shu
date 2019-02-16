
--@Class CDOTABaseAbility

local AbilityBehavior = {             
    DOTA_ABILITY_BEHAVIOR_ATTACK,            
    DOTA_ABILITY_BEHAVIOR_AURA,     
    DOTA_ABILITY_BEHAVIOR_AUTOCAST,    
    DOTA_ABILITY_BEHAVIOR_CHANNELLED,   
    DOTA_ABILITY_BEHAVIOR_DIRECTIONAL,    
    DOTA_ABILITY_BEHAVIOR_DONT_ALERT_TARGET,    
    DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT, 
    DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK,   
    DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT,             
    DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING,    
    DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL,      
    DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE,   
    DOTA_ABILITY_BEHAVIOR_IGNORE_TURN ,        
    DOTA_ABILITY_BEHAVIOR_IMMEDIATE,         
    DOTA_ABILITY_BEHAVIOR_ITEM,              
    DOTA_ABILITY_BEHAVIOR_NOASSIST,            
    DOTA_ABILITY_BEHAVIOR_NONE,             
    DOTA_ABILITY_BEHAVIOR_NORMAL_WHEN_STOLEN, 
    DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE,       
    DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES,      
    DOTA_ABILITY_BEHAVIOR_RUNE_TARGET,         
    DOTA_ABILITY_BEHAVIOR_UNRESTRICTED ,  
}

--判断单体技能
function CDOTABaseAbility:IsUnitTarget()
    local b = tonumber(tostring(self:GetBehavior()))

    if self:IsHidden() then b = b - 1 end
    for k,v in pairs(AbilityBehavior) do
        repeat
            if v == 0 then break end
            b = b % v
        until true
    end

    if (b - DOTA_ABILITY_BEHAVIOR_AOE) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
        b = b - DOTA_ABILITY_BEHAVIOR_AOE
    end

    if b == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
        return true
    end
    return false
end

--判断点目标技能
function CDOTABaseAbility:IsPoint()
    local b = tonumber(tostring(self:GetBehavior()))

     return bit.band(b,DOTA_ABILITY_BEHAVIOR_POINT) == DOTA_ABILITY_BEHAVIOR_POINT
end

--判断无目标技能
function CDOTABaseAbility:IsNoTarget()
    local b = tonumber(tostring(self:GetBehavior()))

    return bit.band(b,DOTA_ABILITY_BEHAVIOR_NO_TARGET) == DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
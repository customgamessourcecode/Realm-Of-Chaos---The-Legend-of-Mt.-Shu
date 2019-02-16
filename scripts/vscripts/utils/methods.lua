
FALSE = 0
TRUE = 1

Shushan_Custom_Hit_Block = {}

function GetDistanceBetweenTwoVec2D(a, b)
    local xx = (a.x-b.x)
    local yy = (a.y-b.y)
    return math.sqrt(xx*xx + yy*yy)
end

function GetRadBetweenTwoVec2D(a,b)
	local y = b.y - a.y
	local x = b.x - a.x
	return math.atan2(y,x)
end

function VectorRollByZ(vec,rad)
    return Vector(vec.x*math.cos(rad)+vec.y*math.sin(rad),-vec.x*math.sin(rad)+vec.y*math.cos(rad),vec.z)
end
function VectorRollByX(vec,rad)
    return Vector(vec.x,vec.y*math.cos(rad)+vec.z*math.sin(rad),-vec.y*math.sin(rad)+vec.z*math.cos(rad))
end
function VectorRollByY(vec,rad)
    return Vector(vec.x*math.cos(rad)-vec.z*math.sin(rad),vec.y,vec.x*math.sin(rad)+vec.z*math.cos(rad))
end

function VectorRoll(vec,forward,right,up)
    return Vector(vec.x*forward.x+vec.y*forward.y+vec.z*forward.z,
                  vec.x*right.x+vec.y*right.y+vec.z*right.z,
                  vec.x*up.x+vec.y*up.y+vec.z*up.z)
end

function HasPass( playerID )
    if IsInToolsMode() then
        return false
    end
    return PlayerResource:HasCustomGameTicketForPlayerID( playerID )
end

function UnitStunTarget( caster,target,stuntime)
    if GameRules:GetCustomGameDifficulty() >= 4 then
        stuntime = stuntime/2
    end
    target:AddNewModifier(caster, nil, "modifier_stunned", {duration=stuntime})
end
--aVec:原点向量
--rectOrigin：单位原点向量
--rectWidth：矩形宽度
--rectLenth：矩形长度
--rectRad：矩形相对Y轴旋转角度
function IsRadInRect(aVec,rectOrigin,rectWidth,rectLenth,rectRad)
    local aRad = GetRadBetweenTwoVec2D(rectOrigin,aVec)
    local turnRad = aRad + (math.pi/2 - rectRad)
    local aRadius = GetDistanceBetweenTwoVec2D(rectOrigin,aVec)
    local turnX = aRadius*math.cos(turnRad)
    local turnY = aRadius*math.sin(turnRad)
    local maxX = rectWidth/2
    local minX = -rectWidth/2
    local maxY = rectLenth
    local minY = 0
    if(turnX<maxX and turnX>minX and turnY>minY and turnY<maxY)then
        return true
    else
        return false
    end
    return false
end

function IsRadBetweenTwoRad2D(a,rada,radb)
    local math2pi = math.pi * 2
    rada = rada + math2pi
    radb = radb + math2pi
    a = a + math2pi
    local maxrad = math.max(rada,radb)
    local minrad = math.min(rada,radb)
    if(a<maxrad and a>minrad)then
        return true
    end
    return false
end

function GetAttributeByAttributeType(caster,AttributeType)
    if AttributeType == 0 then
        return caster:GetStrength()
    elseif AttributeType == 1 then
        return caster:GetAgility()
    elseif AttributeType == 2 then
        return caster:GetIntellect()
    end
end

-- cx = 目标的x
-- cy = 目标的y
-- ux = math.cos(theta)   (rad是caster和target的夹角的弧度制表示)
-- uy = math.sin(theta)
-- r = 目标和原点之间的距离
-- theta = 夹角的弧度制
-- px = 原点的x
-- py = 原点的y
-- 返回 true or false(目标是否在扇形内，在的话=true，不在=false)

function IsPointInCircularSector(cx,cy,ux,uy,r,theta,px,py)
    local dx = px - cx
    local dy = py - cy

    local length = math.sqrt(dx * dx + dy * dy)

    if (length > r) then
        return false
    end

    local vec = Vector(dx,dy,0):Normalized()
    return math.acos(vec.x * ux + vec.y * uy) < theta
 end 

 function IsFaceBack(caster,target,angle)
    local vecTarget = target:GetOrigin()
    local vecCaster = caster:GetOrigin()
    local face = target:GetForwardVector()
    local faceTo = (vecCaster - vecTarget):Normalized()

    local inAngle = math.acos(face.x*faceTo.x+face.y*faceTo.y)

    if inAngle > angle then
        return false
    else
        return true
    end
 end

 function create_illusion(keys, illusion_origin, illusion_incoming_damage, illusion_outgoing_damage, illusion_duration) 
    local player_id = keys.caster:GetPlayerID()
    local caster_team = keys.caster:GetTeam()
    
    local illusion = CreateUnitByName(keys.caster:GetUnitName(), illusion_origin, true, keys.caster, nil, caster_team)  --handle_UnitOwner needs to be nil, or else it will crash the game.
    illusion:SetOwner(keys.caster)
    illusion:SetPlayerID(player_id)
    illusion:SetControllableByPlayer(player_id, true)

    --Level up the illusion to the caster's level.
    local caster_level = keys.caster:GetLevel()
    for i = 1, caster_level - 1 do
        illusion:HeroLevelUp(false)
    end

    --Set the illusion's available skill points to 0 and teach it the abilities the caster has.
    illusion:SetAbilityPoints(0)
    for ability_slot = 0, 15 do
        local individual_ability = keys.caster:GetAbilityByIndex(ability_slot)
        if individual_ability ~= nil then 
            local illusion_ability = illusion:FindAbilityByName(individual_ability:GetAbilityName())
            if illusion_ability ~= nil then
                illusion_ability:SetLevel(individual_ability:GetLevel())
            end
        end
    end

    --Recreate the caster's items for the illusion.
    for item_slot = 0, 5 do
        local individual_item = keys.caster:GetItemInSlot(item_slot)
        if individual_item ~= nil then
            local illusion_duplicate_item = CreateItem(individual_item:GetName(), illusion, illusion)
            illusion:AddItem(illusion_duplicate_item)
            illusion_duplicate_item.__CustomAttributes = individual_item.__CustomAttributes
        end
    end

    SuitSystem:Do(illusion, {})

    illusion:AddNewModifier(keys.caster, keys.ability, "modifier_illusion", {duration = illusion_duration, outgoing_damage = illusion_outgoing_damage, incoming_damage = illusion_incoming_damage})
    illusion:MakeIllusion()
    illusion.shushan_illusion_ownner = keys.caster
    illusion:RemoveNoDraw()
    illusion:RemoveModifierByName("modifier_invulnerable")
    illusion:RemoveModifierByName("modifier_custom_stun2")

    return illusion
end

function MoveUnitToTarget(unit,target,speed,func)
    local endTime = GameRules:GetGameTime() + 5
    unit:SetContextThink(DoUniqueString("MoveUnitToTarget"), 
        function()
            if GameRules:IsGamePaused() then return 0.03 end
            if unit==nil or target==nil or unit:IsNull() or target:IsNull() or GameRules:GetGameTime() >= endTime  then
                if func then func() end
                return nil
            end
            local vecCaster = unit:GetOrigin()
            local vecTarget = target:GetOrigin()
            if GetDistanceBetweenTwoVec2D(vecCaster,vecTarget) > 100 or GameRules:GetGameTime() >= endTime then
                local forward = (vecTarget - vecCaster):Normalized()
                unit:SetOrigin(vecCaster+forward*speed*0.03)
                return 0.03
            else
                FindClearSpaceForUnit(unit,unit:GetOrigin(),false)
                if func then func() end
                return nil
            end
        end, 
    0.03)
end

function MoveUnitToTargetJump(unit,target,speed,vUp,func)
    local endTime = GameRules:GetGameTime() + 5
    local distance = GetDistanceBetweenTwoVec2D(unit:GetOrigin(),target:GetOrigin())
    local t = distance/speed
    local upSpeed = vUp
    unit:SetContextThink(DoUniqueString("MoveUnitToTarget"), 
        function()
            if GameRules:IsGamePaused() then return 0.03 end
            if unit==nil or target==nil or unit:IsNull() or target:IsNull() or GameRules:GetGameTime() >= endTime  then
                if func then func() end
                return nil
            end
            upSpeed = upSpeed - 0.03 * (2*upSpeed/t)
            local vecCaster = unit:GetOrigin()
            local vecTarget = target:GetOrigin()
            if GetDistanceBetweenTwoVec2D(vecCaster,vecTarget) > 100 or GameRules:GetGameTime() >= endTime then
                local forward = (vecTarget - vecCaster):Normalized()
                unit:SetOrigin(vecCaster+forward*speed*0.03+Vector(0,0,upSpeed))
                return 0.03
            else
                FindClearSpaceForUnit(unit,unit:GetOrigin(),false)
                if func then func() end
                return nil
            end
        end, 
    0.03)
end

function MoveUnitToTargetPointJump(unit,targetPoint,speed,vUp,func)
    local endTime = GameRules:GetGameTime() + 5
    local distance = GetDistanceBetweenTwoVec2D(unit:GetOrigin(),targetPoint)
    local t = distance/speed
    local upSpeed = vUp
    unit:SetContextThink(DoUniqueString("MoveUnitToTarget"), 
        function()
            if GameRules:IsGamePaused() then return 0.03 end
            if unit==nil or unit:IsNull() or GameRules:GetGameTime() >= endTime then
                if func then func() end
                return nil
            end
            upSpeed = upSpeed - 0.03 * (2*upSpeed/t)
            local vecCaster = unit:GetOrigin()

            if GetDistanceBetweenTwoVec2D(vecCaster,targetPoint) > 100 or GameRules:GetGameTime() >= endTime then
                local forward = (targetPoint - vecCaster):Normalized()
                unit:SetOrigin(vecCaster+forward*speed*0.03+Vector(0,0,upSpeed))
                return 0.03
            else
                FindClearSpaceForUnit(unit,unit:GetOrigin(),false)
                if func then func() end
                return nil
            end
        end, 
    0.03)
end

function MoveUnitToTargetPoint(unit,targetpoint,speed,func)
    local endTime = GameRules:GetGameTime() + 5
    unit:SetContextThink(DoUniqueString("MoveUnitToTarget"), 
        function()
            if GameRules:IsGamePaused() then return 0.03 end
            if unit==nil or unit:IsNull() or GameRules:GetGameTime() >= endTime  then
                if func then func() end
                return nil
            end
            local vecCaster = unit:GetOrigin()
            local vecTarget = targetpoint
            if GetDistanceBetweenTwoVec2D(vecCaster,vecTarget) > 100 or GameRules:GetGameTime() >= endTime then
                local forward = (vecTarget - vecCaster):Normalized()
                unit:SetOrigin(vecCaster+forward*speed*0.03)
                return 0.03
            else
                FindClearSpaceForUnit(unit,unit:GetOrigin(),false)
                if func then func() end
                return nil
            end
        end, 
    0.03)
end

function MoveUnitToFaceFixedTime(unit,speed,time,func)
    local endTime = time
    unit:SetContextThink(DoUniqueString("MoveUnitToTarget"), 
        function()
            if GameRules:IsGamePaused() then return 0.03 end
            if unit==nil or unit:IsNull() then
                if func then func() end
                return nil
            end
            if endTime > 0 then
                unit:SetOrigin(unit:GetOrigin()+unit:GetForwardVector()*speed*0.03)
                endTime = endTime - 0.03
                return 0.03
            else
                FindClearSpaceForUnit(unit,unit:GetOrigin(),false)
                if func then func() end
                return nil
            end
        end, 
    0.03)
end

function ShushanCreateProjectileMoveToTargetPoint(projectileTable,caster,speed,acceleration1,acceleration2,func)
    local effectIndex = ParticleManager:CreateParticle(projectileTable.EffectName, PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControlForward(effectIndex,3,projectileTable.vVelocity:Normalized())

    local acceleration = acceleration1
    local ability = projectileTable.Ability
    local targets = {}
    local targets_remove = {}
    local dis = 0
    local reflexCount = 0
    local pString = DoUniqueString("projectile_string")
    local high = projectileTable.vSpawnOriginNew.z - GetGroundHeight(projectileTable.vSpawnOriginNew, nil)
    local fixedTime = 10.0

    caster:SetContextThink(DoUniqueString("ability_caster_projectile"), 
        function()
            if GameRules:IsGamePaused() then return 0.03 end

            local vec = projectileTable.vSpawnOriginNew + projectileTable.vVelocity*speed/50
            dis = dis + speed/50

            -- 是否反射
            if projectileTable.bReflexByBlock~=nil and projectileTable.bReflexByBlock==true then
                if GridNav:CanFindPath(projectileTable.vSpawnOriginNew,projectileTable.vSpawnOriginNew + projectileTable.vVelocity*speed/50)==false or GetHitCustomBlock(projectileTable.vSpawnOriginNew,projectileTable.vSpawnOriginNew + projectileTable.vVelocity*speed/50)~=nil then
                    local inRad = GetRadBetweenTwoVec2D(vec,projectileTable.vSpawnOriginNew)
                    local blockRad = GetBlockTurning(inRad,projectileTable.vSpawnOriginNew)
                    projectileTable.vVelocity = Vector(math.cos(inRad-blockRad+math.pi),math.sin(inRad-blockRad+math.pi),0)
                    vec = projectileTable.vSpawnOriginNew + projectileTable.vVelocity*speed/50 
                    ParticleManager:SetParticleControlForward(effectIndex,3,projectileTable.vVelocity:Normalized())
                    reflexCount = reflexCount + 1
                    for k,v in pairs(targets_remove) do
                        if v:GetContext(pString)~=0 then
                            v:SetContextNum(pString,0,0)
                            table.remove(targets_remove,k)
                        end
                    end
                end
            end

            -- 是否判断击中墙壁
            if projectileTable.bStopByBlock~=nil and projectileTable.bStopByBlock==true then
                if GridNav:CanFindPath(projectileTable.vSpawnOriginNew,projectileTable.vSpawnOriginNew + projectileTable.vVelocity*speed/50)==false then
                    if(projectileTable.bDeleteOnHit)then
                        if func then func(nil,vec) end
                        ParticleManager:DestroyParticleSystem(effectIndex,true)
                        return nil
                    else
                        if func then func(nil,vec) end
                    end
                end
            end
            
            targets = FindUnitsInRadius(
                caster:GetTeam(),       --caster team
                vec,                    --find position
                nil,                    --find entity
                projectileTable.fStartRadius,       --find radius
                projectileTable.Ability:GetAbilityTargetTeam(),
                projectileTable.Ability:GetAbilityTargetType(),
                projectileTable.Ability:GetAbilityTargetFlags(), 
                FIND_CLOSEST,
                false
            )
            if(targets[1]~=nil)then
                if(projectileTable.bDeleteOnHit)then
                    if func then func(targets[1],vec,reflexCount) end
                    ParticleManager:DestroyParticleSystem(effectIndex,true)
                    return nil
                elseif(projectileTable.bDeleteOnHit==false)then
                    for k,v in pairs(targets) do
                        if v:GetContext(pString)~=1 then
                            v:SetContextNum(pString,1,0)
                            table.insert(targets_remove,v)
                            if func then func(v,vec,reflexCount) end
                        end
                    end
                end
            end

            if(speed <= 0 and acceleration2 ~= 0)then
                acceleration = acceleration2
                speed = 0
                acceleration2 = 0
            end

            fixedTime = fixedTime - 0.02
            if(dis<projectileTable.fDistance and fixedTime > 0)then
                    ParticleManager:SetParticleControl(effectIndex,3,Vector(vec.x,vec.y,GetGroundHeight(vec, nil)+high))
                    projectileTable.vSpawnOriginNew = vec
                    speed = speed + acceleration
                    return 0.02
            else
                ParticleManager:DestroyParticleSystem(effectIndex,true)
                return nil
            end
        end, 
    0.02)
end

function ShushanCreateProjectileMoveToTarget(projectileTable,caster,target,speed,iVelocity,acceleration,func)
    local effectIndex = ParticleManager:CreateParticle(projectileTable.EffectName, PATTACH_CUSTOMORIGIN, nil) 
    ParticleManager:SetParticleControlForward(effectIndex,3,(projectileTable.vVelocity*iVelocity/50 + speed/50 * (target:GetOrigin() - caster:GetOrigin()):Normalized()):Normalized())

    local ability = projectileTable.Ability
    local targets = {}
    local targets_remove = {}
    local totalDistance = 0

    caster:SetContextThink(DoUniqueString("ability_caster_projectile"), 
        function()
            if GameRules:IsGamePaused() then return 0.03 end
            if target:IsNull() or target==nil then
                ParticleManager:DestroyParticleSystem(effectIndex,true)
                return nil
            end

            -- 向心力单位向量
            local vecCentripetal = (projectileTable.vSpawnOriginNew - target:GetOrigin()):Normalized()

            -- 向心力
            local forceCentripetal = speed/50

            -- 初速度单位向量
            local vecInVelocity = projectileTable.vVelocity

            -- 初始力
            local forceIn = iVelocity/50

            -- 投射物矢量
            local vecProjectile = vecInVelocity * forceIn + forceCentripetal * vecCentripetal

            local vec = projectileTable.vSpawnOriginNew + vecProjectile

            -- 投射物单位向量
            local particleForward = vecProjectile:Normalized()

            -- 目标和投射物距离
            local dis = GetDistanceBetweenTwoVec2D(target:GetOrigin(),vec)

            ParticleManager:SetParticleControlForward(effectIndex,3,particleForward)

            totalDistance = totalDistance + math.sqrt(forceIn*forceIn + forceCentripetal*forceCentripetal)

            targets = FindUnitsInRadius(
                caster:GetTeam(),       --caster team
                vec,                    --find position
                nil,                    --find entity
                projectileTable.fStartRadius,       --find radius
                projectileTable.Ability:GetAbilityTargetTeam(),
                projectileTable.Ability:GetAbilityTargetType(),
                projectileTable.Ability:GetAbilityTargetFlags(), 
                FIND_CLOSEST,
                false
            )
            if(targets[1]~=nil)then
                if(projectileTable.bDeleteOnHit)then
                    if func then func(targets[1]) end
                    ParticleManager:DestroyParticleSystem(effectIndex,true)
                    return nil
                else
                    if #targets_remove==0 then
                        table.insert(targets_remove,targets[1])
                        if func then func(targets[1]) end
                    else
                        for k,v in pairs(targets) do
                            for k1,v1 in pairs(targets_remove) do
                                if v~=v1 then
                                    table.insert(targets_remove,v)
                                    if func then func(v) end
                                end
                            end
                        end
                    end
                end
            end

            if(totalDistance<projectileTable.fDistance and dis>=projectileTable.fEndRadius)then
                ParticleManager:SetParticleControl(effectIndex,3,vec)
                projectileTable.vSpawnOriginNew = vec
                speed = speed + acceleration
                return 0.02
            else
                ParticleManager:DestroyParticleSystem(effectIndex,true)
                return nil
            end
        end, 
    0.02)
end

function ShushanCreateProjectileThrowToTargetPoint(projectileTable,caster,targetPoint,speed,upSpeed,func)
    local ability = projectileTable.Ability
    local targets = {}
    local targets_remove = {}
    local totalDistance = 0

    -- 过程时间
    local distance = GetDistanceBetweenTwoVec2D(caster:GetOrigin(),targetPoint)
    local t = distance/speed

    -- 重力方向
    local vecGravity = Vector(0,0,-1)

    local PV = targetPoint.z - 128 - caster:GetOrigin().z

    -- 重力大小
    local gravity = 0.02 * ((2*upSpeed+PV/16)/t)

    -- 初速度单位向量
    local vecInVelocity = projectileTable.vVelocity

    -- 初始水平方向力
    local forceIn = 0.02 * speed

    -- 投射物矢量
    local vecProjectile = vecInVelocity * forceIn + gravity * vecGravity

    -- 投射物单位向量
    local particleForward = vecProjectile:Normalized()

    local effectIndex = ParticleManager:CreateParticle(projectileTable.EffectName, PATTACH_CUSTOMORIGIN, nil) 
    ParticleManager:SetParticleControlForward(effectIndex,3,caster:GetForwardVector())

    caster:SetContextThink(DoUniqueString("ability_caster_projectile"), 
        function()
            if GameRules:IsGamePaused() then return 0.03 end

            distance = distance - forceIn
            if distance<0 then
                forceIn = 0
            end

            -- 投射物矢量
            vecProjectile = vecInVelocity * forceIn + upSpeed * vecGravity

            local vec = projectileTable.vSpawnOriginNew + vecProjectile

            totalDistance = totalDistance + math.sqrt(forceIn*forceIn + gravity*gravity)

            if(projectileTable.vSpawnOriginNew.z+128>targetPoint.z or t > t/2)then
                ParticleManager:SetParticleControl(effectIndex,3,vec)
                projectileTable.vSpawnOriginNew = vec
                upSpeed = upSpeed - gravity
                t = t - 0.02
                return 0.02
            else
                targets = FindUnitsInRadius(
                    caster:GetTeam(),       --caster team
                    vec,                    --find position
                    nil,                    --find entity
                    projectileTable.fStartRadius,       --find radius
                    projectileTable.Ability:GetAbilityTargetTeam(),
                    projectileTable.Ability:GetAbilityTargetType(),
                    projectileTable.Ability:GetAbilityTargetFlags(), 
                    FIND_CLOSEST,
                    false
                )
                if func then func(targets) end
                ParticleManager:DestroyParticleSystem(effectIndex,true)
                return nil
            end
        end, 
    0.02)
end

function GetBlockTurning(face,pos)
    local vface = face

    local hitblock = GetHitCustomBlock(pos,pos + Vector(math.cos(vface/180*math.pi),math.sin(vface/180*math.pi),0)*50)

    if hitblock~=nil then
        return 90
    end

    for i=0,360 do
        vface = vface + i
        local rad = vface/180*math.pi
        if GridNav:CanFindPath(pos,pos + Vector(math.cos(rad),math.sin(rad),0)*50) then
            return GetRadBetweenTwoVec2D(pos,pos + Vector(math.cos(rad),math.sin(rad),0)*50)
        end
    end
    return 90
end

function GetBlockHeight(rad,pos)
    for i=0,200 do
        local gridPos = pos + Vector(math.cos(rad),math.sin(rad),0)*i
        local height = GetGroundHeight(gridPos,nil)
        if height > pos.z + 128 then
            return height
        end
    end
    return 0
end

function GetHitCustomBlock(vec,pos)
    for k,v in pairs(Shushan_Custom_Hit_Block) do
        local circlePoint = v.circlePoint
        local dis1 = GetDistanceBetweenTwoVec2D(vec,circlePoint)
        local dis2 = GetDistanceBetweenTwoVec2D(pos,circlePoint)

        if dis1-50 < v.radius and dis2+50 >= v.radius then
            return v
        end
    end
    return nil
end

function IsAroundBlock(pos)
    for k,v in pairs(Shushan_Custom_Hit_Block) do
        local circlePoint = v.circlePoint
        local dis = GetDistanceBetweenTwoVec2D(pos,circlePoint)

        if dis < v.radius then
            return true
        end
    end

    if GridNav:IsBlocked(pos) or GridNav:IsTraversable(pos) == false then
        return false
    end

    for i=0,360 do
        local rad = i/180*math.pi
        if GridNav:CanFindPath(pos,pos + Vector(math.cos(rad),math.sin(rad),0)*1000) then
            return false
        end
    end
    return true
end

function GetUnitNameStringLevel(unitName)
    local level = string.match(unitName,"LV(%d+)_")
    return level
end

shushan_caster_purchase_List = {
    ["76561198110203975"] = {
        ["ability_shushan_luxiao011"] = 2,
        ["ability_shushan_luxiao011_end"] = 2,
        ["ability_shushan_luxiao012"] = 2,
        ["ability_shushan_luxiao014"] = 2,
    },
}

shushan_EffectName_List = {
    ["ability_shushan_tianchen011"] = {
        [1] = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
        [2] = "particles/heroes/tianchen/ability_tianchen_011_shockwave.vpcf",
    },
    ["ability_shushan_tianchen012"] = {
        [1] = "particles/heroes/tianchen/ability_tianchen_011.vpcf",
        [2] = "particles/heroes/tianchen/ability_tianchen_011_vip.vpcf",
    },
    ["ability_shushan_tianchen013"] = {
        [1] = "particles/heroes/tianchen/ability_tianchen_013_attack.vpcf",
        [2] = "particles/heroes/tianchen/ability_tianchen_013_attack_vip.vpcf",
    },
    ["ability_shushan_tianchen015"] = {
        [1] = "particles/heroes/tianchen/ability_tianchen_015.vpcf",
        [2] = "particles/heroes/tianchen/ability_tianchen_015_vip.vpcf",
    },
    ["ability_shushan_lingcai021"] = {
        [1] = "particles/heroes/lingcai/ability_lingcai_011.vpcf",
        [2] = "particles/heroes/lingcai/ability_lingcai_011_vip.vpcf",
    },
    ["ability_shushan_lingcai022"] = {
        [1] = "particles/heroes/lingcai/ability_lingcai_021_fire.vpcf",
        [2] = "particles/heroes/lingcai/ability_lingcai_021_fire_vip.vpcf",
    },
    ["ability_shushan_lingcai023"] = {
        [1] = "",
        [2] = "particles/heroes/lingcai/ability_lingcai_023.vpcf",
    },
    ["ability_shushan_lingcai024"] = {
        [1] = "",
        [2] = "particles/heroes/lingcai/ability_lingcai_024_vip.vpcf",
    },
     ["ability_shushan_huankong012"] = {
        [1] = "particles/avalon/abilities/ability_shushan_huankong012/ability_shushan_huankong012.vpcf",
        [2] = "particles/avalon/abilities/ability_shushan_huankong012/ability_shushan_huankong012_vip.vpcf",
    },
    ["ability_shushan_huankong013"] = {
        [1] = "particles/avalon/abilities/ability_shushan_huankong013/ability_shushan_huankong013.vpcf",
        [2] = "particles/avalon/abilities/ability_shushan_huankong013/ability_shushan_huankong013_vip.vpcf",
    },
    ["ability_shushan_huankong013_end"] = {
        [1] = "particles/avalon/abilities/ability_shushan_huankong013/ability_shushan_huankong013_end.vpcf",
        [2] = "particles/avalon/abilities/ability_shushan_huankong013/ability_shushan_huankong013_end_vip.vpcf",
    },
    ["ability_shushan_huankong014_attack"] = {
        [1] = "particles/avalon/abilities/ability_shushan_huankong014/ability_shushan_huankong014_attack.vpcf",
        [2] = "particles/avalon/abilities/ability_shushan_huankong014/ability_shushan_huankong014_attack_vip.vpcf",
    },
    ["ability_shushan_huankong014"] = {
        [1] = "particles/avalon/abilities/ability_shushan_huankong014/ability_shushan_huankong014.vpcf",
        [2] = "particles/avalon/abilities/ability_shushan_huankong014/ability_shushan_huankong014_vip.vpcf",
    },
    ["ability_shushan_huankong014_end"] = {
        [1] = "particles/avalon/abilities/ability_shushan_huankong014/ability_shushan_huankong014_end.vpcf",
        [2] = "particles/avalon/abilities/ability_shushan_huankong014/ability_shushan_huankong014_end_vip.vpcf",
    },
    ["ability_shushan_juexin011"] = {
        [1] = "",
        [2] = "particles/heroes/juexin/ability_juexin_011_vip.vpcf",
    },
    ["ability_shushan_juexin011_step"] = {
        [1] = "",
        [2] = "particles/heroes/juexin/ability_juexin_011_step.vpcf",
    },
    ["ability_shushan_juexin012"] = {
        [1] = "particles/heroes/juexin/ability_juexin_012.vpcf",
        [2] = "particles/heroes/juexin/ability_juexin_012_vip.vpcf",
    },
    ["ability_shushan_juexin014"] = {
        [1] = "",
        [2] = "particles/heroes/juexin/ability_juexin_014_stun.vpcf",
    },
    ["ability_shushan_juexin014_smoke"] = {
        [1] = "particles/heroes/juexin/ability_juexin_012_b.vpcf",
        [2] = "particles/heroes/juexin/ability_juexin_014_smoke.vpcf",
    },
    ["ability_shushan_juexin014_sword"] = {
        [1] = "particles/heroes/juexin/ability_juexin_014_sword.vpcf",
        [2] = "particles/heroes/juexin/ability_juexin_014_sword_vip.vpcf",
    },
    ["ability_shushan_luxiao011"] = {
        [1] = "particles/heroes/luxiao/ability_luxiao_011_dash_vip.vpcf",
        [2] = "particles/heroes/luxiao/ability_luxiao_011_dash.vpcf",
    },
    ["ability_shushan_luxiao011_end"] = {
        [1] = "particles/heroes/luxiao/ability_luxiao_024_down.vpcf",
        [2] = "particles/heroes/luxiao/ability_luxiao_024_down_vip.vpcf",
    },
    ["ability_shushan_luxiao012"] = {
        [1] = "particles/heroes/luxiao/ability_luxiao_012.vpcf",
        [2] = "particles/heroes/luxiao/ability_luxiao_012_vip.vpcf",
    },
    ["ability_shushan_luxiao014"] = {
        [1] = "",
        [2] = "particles/heroes/luxiao/ability_luxiao_014_vip.vpcf",
    },
}

function shushan_GetCasterPurchaseNum(steamid, name)
    if shushan_caster_purchase_List[steamid] then
        return shushan_caster_purchase_List[steamid][name] or 1
    end
    return 1
end

function shushan_GetEffectName(caster,abilityname)
    local num = shushan_GetCasterPurchaseNum(caster:GetSteamID(), abilityname)
    if num~=nil then
        return shushan_EffectName_List[abilityname][num]
    else
        return nil
    end
end
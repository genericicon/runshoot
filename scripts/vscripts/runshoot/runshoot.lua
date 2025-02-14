
local magSize
local disableScript
if thisEntity:GetModelName() == "models/characters/combine_grunt/combine_grunt.vmdl" then
    magSize = 45
elseif thisEntity:GetModelName() == "models/characters/combine_soldier_captain/combine_captain.vmdl" then
    magSize = 30
else
    disableScript = true
end

if not disableScript then
    thisEntity.runShoot = {
        roundcounter = magSize or 30,
        moving = thisEntity:NpcNavGoalActive() or false,
        injured = thisEntity:GetGraphParameter("b_injured") or false,
    }


    function AnimTagListener(sTagName, nStatus)
        if sTagName == "Finished_Reload" and nStatus == 1 then
            EntFireByHandle(thisEntity,thisEntity,"speakresponseconcept", "COMBINESOLDIER_RELOAD")
        end 

        if sTagName == "Finished_Reload" and nStatus == 2 then
            thisEntity.runShoot.roundcounter = magSize 
        
        end 
        if sTagName == "weapon_fired" and nStatus == 0 then 
            thisEntity.runShoot.roundcounter = thisEntity.runShoot.roundcounter - 1
        end

    end

    thisEntity:RegisterAnimTagListener(AnimTagListener)



    thisEntity:SetThink(function() 
        -- Update movement/ injured vars
        thisEntity.runShoot.moving = thisEntity:NpcNavGoalActive()
        thisEntity.runShoot.injured = thisEntity:GetGraphParameter("b_injured")
        
        if thisEntity.runShoot.moving == true and thisEntity.runShoot.injured == false then 
            SoldierFoundEnemy()
        end

        if Convars:GetBool("runshoot_debug") then
           local displayRate = Convars:GetFloat("runshoot_rethink") or 0.1
           debugoverlay:Text(thisEntity:GetCenter() + thisEntity:GetRightVector() * 8,1,"RunShoot Enabled",0,0,255,255,255,displayRate)
        end


        return Convars:GetFloat("runshoot_rethink") or 0.1

    end,"runshoot_"..tostring(thisEntity:entindex()),0)

end


function SoldierFoundEnemy()
    
    
    thisEntity.runShoot.criteria = {}
    thisEntity:GatherCriteria(thisEntity.runShoot.criteria)
    local enemyClass = thisEntity.runShoot.criteria["enemy"]
    local enemyDist = thisEntity.runShoot.criteria["distancetoenemy"]

    if thisEntity.runShoot.roundcounter > 0 and enemyClass then


        --Try to assume who the enemy is

        local potentialEnts = Entities:FindAllByClassnameWithin(enemyClass,thisEntity:GetAbsOrigin(),enemyDist+64)
        
        for i,v in ipairs(potentialEnts) do
            local dist2 = (thisEntity:GetAbsOrigin()-v:GetAbsOrigin()):Length2D()
            if enemyDist == dist2 or abs(enemyDist-dist2) <= 8 then
                thisEntity.runShoot.enemy = v
            end
        end
        
        if thisEntity.runShoot.enemy and IsValidEntity(thisEntity.runShoot.enemy) and thisEntity.runShoot.enemy:IsAlive() and enemyDist ~= 16384 then
            thisEntity:SetGraphLookTarget(thisEntity.runShoot.enemy:GetCenter())
            if Convars:GetBool("runshoot_debug") then
                local displayRate = Convars:GetFloat("runshoot_rethink") or 0.1
                DebugDrawText(thisEntity:EyePosition(),tostring(thisEntity.runShoot.roundcounter),true,displayRate)
            end
            
            --Full auto burst while moving
            thisEntity:SetGraphParameterBool("b_firing",true)

            --TODO add burst firing, longer bursts while closer vs. further

            
        end

    elseif thisEntity.runShoot.roundcounter <= 0 then
        --Maybe Wait until the soldier's next reload scheduled reload

        thisEntity:SetGraphParameterBool("b_reload", true)
    end


end
function Start()
    print("Activated RunShootMod")
    --Runs on each soldier on the map

    thisEntity:SetThink(Think,"RunShootThink",0)
    Convars:RegisterConvar("runshoot_rethink_search","0.5","How often the script will search for new soldiers to apply script to",FCVAR_NONE)

    Convars:RegisterConvar("runshoot_rethink","0.1","How often the script will force the soldier to shoot (lower is more often, min 0)",FCVAR_NONE)
    Convars:RegisterConvar("runshoot_debug","0","Enable Debug, 1 on, zero off",FCVAR_NONE)

end


function Think()
    local combineSoldiers = Entities:FindAllByClassname("npc_combine_s")
    for k,v in pairs(combineSoldiers) do

        if IsValidEntity(v) and not v.runshootActive then
            EntFireByHandle(v, v,"RunScriptFile", 'runshoot/runshoot.lua')
            v.runshootActive = true
            print("\t runShoot: Activated runshoot on",v:GetName(), v:entindex())
        end
        
    end
    return 2
end